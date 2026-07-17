# Guide d'implémentation FHIR — Opérations de publication MDM

**Version** : 0.1.0 | **Date** : 30 mars 2026 | **Statut** : Draft

## Pourquoi un IG séparé

Ce guide d'implémentation ne modélise aucune ressource métier. Il décrit uniquement le **contrat de diffusion** par lequel un système consommateur récupère le contenu produit par le CPage MasterData.

Ce choix est délibéré : la façon dont un contenu est modélisé (profils, extensions, terminologies — voir les IG `ig-md-fhir-common` et `ig-md-fhir-cpage`) et la façon dont ce contenu est **publié et retrouvé** par un consommateur sont deux préoccupations orthogonales. La première relève de la donnée ; la seconde relève de l'intégration. Fusionner les deux dans un même IG lierait le cycle de vie du contrat d'échange à celui du modèle métier, alors que les deux évoluent à des rythmes différents et intéressent des publics différents (équipes d'intégration côté consommateur pour ce guide, équipes de modélisation FHIR pour les guides communs).

Cet IG dépend de `hl7.fhir.fr.core` (profils FR Core) et de `ig.mdm.fhir.common` (socle commun MDM), mais n'ajoute aucun profil de ressource métier : il ajoute des **opérations**, des **modèles logiques de transport** (lot de publication, item de lot) et les **terminologies** associées.

---

## Architecture pub/sub en un coup d'œil

Le MasterData ne diffuse pas ses transactions internes telles quelles. Il les transforme en **lots de publication** (*publication batches*), unités de diffusion homogènes, puis notifie leur disponibilité avant de les rendre récupérables via trois opérations FHIR.

```text
Master Data
  │
  │  transaction métier interne validée
  ▼
Moteur de publication
  │  découpe la transaction en lot(s) homogènes :
  │   - un lot GLOBAL pour les nomenclatures partagées
  │   - un ou plusieurs lots CLIENT pour les ressources métier d'un tenant
  ▼
  ├──► Notification NATS (disponibilité uniquement, pas de contenu métier)
  │
  └──► API FHIR (les 3 opérations $publication-*)
          │
          ▼
      Consommateur
        1. reçoit la notification NATS
        2. appelle $publication-metadata → métadonnées du lot
        3. appelle $publication-bundle   → contenu du lot (Bundle FHIR)
        4. applique localement créations / mises à jour / suppressions
        (5. en cas de doute sur un lot manqué : $publication-list → rattrapage)
```

### 1. Production — le lot de publication

Un lot de publication (modèle logique [`PublicationBatch`](StructureDefinition-PublicationBatch.html)) est soit :

- **`GLOBAL`** — contenu identique pour tous les consommateurs (nomenclatures, `CodeSystem`, `ValueSet`, référentiels partagés) ; le champ `targetTenant` n'est pas renseigné ;
- **`CLIENT`** — contenu contextualisé pour un tenant donné (`Organization`, `Location`, etc., avec des identifiants locaux propres au tenant) ; `targetTenant` identifie ce tenant.

Une même transaction métier interne peut donner naissance à plusieurs lots : le principe de découpage impose qu'un lot reste homogène en périmètre de diffusion — un lot GLOBAL et un lot CLIENT ne sont jamais mélangés, même s'ils proviennent de la même transaction source (`sourceTransactionId` commun).

Chaque lot passe par un cycle de statuts (`PROCESSING` → `READY`, ou `FAILED`, ou `EXPIRED` une fois retiré de la consultation — voir le [CodeSystem publication-batch-status](CodeSystem-publication-batch-status.html)). Seul un lot au statut `READY` est consultable par les opérations de récupération.

Le lot est composé d'items (modèle logique [`PublicationBatchItem`](StructureDefinition-PublicationBatchItem.html)), chacun correspondant à une ressource FHIR du `Bundle` final, ordonné par `sortOrder`.

### 2. Notification — un signal, pas un contenu

Lorsqu'un lot passe au statut `READY`, le serveur publie un message sur **NATS**. Ce message n'est **pas** un vecteur de contenu métier : il annonce uniquement qu'un lot identifié par `publicationBatchId` est désormais disponible, avec de quoi router l'information (scope, tenant cible éventuel, types de ressources concernés).

Le détail de la convention de nommage des sujets et des scénarios de notification est décrit dans [Cas d'exemple NATS](nats-cases.html).

### 3. Récupération — les 3 opérations FHIR

Le contenu ne se récupère qu'à travers trois opérations système, seul point d'entrée contractuel de cet IG :

| Opération | Rôle |
|-----------|------|
| [`$publication-metadata`](OperationDefinition-publication-metadata.html) | Retourne les métadonnées d'un lot (scope, tenant, statut, type de bundle, types de ressources, traçabilité de la transaction source) |
| [`$publication-bundle`](OperationDefinition-publication-bundle.html) | Retourne le contenu du lot sous forme de `Bundle` FHIR (`transaction` ou `batch`), en mode synchrone ou asynchrone (`Prefer: respond-async`) |
| [`$publication-list`](OperationDefinition-publication-list.html) | Retourne les identifiants de lots publiés dans un intervalle donné — permet à un consommateur de détecter et rattraper les lots qu'il aurait manqués |

Le détail complet des paramètres d'entrée/sortie, avec exemples, est donné dans [Opérations de publication](operations.html). Le contrat d'API vu côté consommateur (typologie des lots, synchrone/asynchrone, gestion des erreurs) est décrit dans [API FHIR de récupération des lots publiés](api-publication-batch.html).

---

## Traçabilité : ce que ce guide couvre, et ce qu'il ne couvre pas

Le modèle logique `PublicationBatchItem` porte des champs de traçabilité — `eventType`, `rootInstanceId`, et par héritage du lot parent `sourceTransactionId` / `sourceVersionNum`. Ces champs répondent à un besoin précis et volontairement limité : permettre à un consommateur de savoir **quelle ressource a changé, dans quel lot, dans quel ordre, et selon quel type d'événement**, afin de détecter un lot manqué et de le rejouer sans dupliquer ni perdre une modification.

Ce n'est **pas** un audit de gouvernance au sens FHIR `Provenance` (qui a fait la modification, pour quelle raison métier, avec quelle signature). Il s'agit d'une traçabilité de **lignage de publication**, au niveau item, suffisante pour l'intégration technique mais pas pour la conformité réglementaire ou l'audit métier. C'est un choix de conception assumé : le détail complet est donné dans [Opérations de publication — Traçabilité](operations.html#tracabilite).

---

## Périmètre de ce guide

Ce guide couvre exclusivement le contrat de récupération :

- l'opération [`$publication-metadata`](OperationDefinition-publication-metadata.html) ;
- l'opération [`$publication-bundle`](OperationDefinition-publication-bundle.html) ;
- l'opération [`$publication-list`](OperationDefinition-publication-list.html) ;
- les modèles logiques `PublicationBatch` et `PublicationBatchItem` ;
- les terminologies associées (scope, statut, type de bundle) ;
- le `CapabilityStatement` du serveur de publication.

Ce guide ne couvre pas :

- les traitements internes de fabrication des lots (règles de découpage détaillées, moteur de projection) ;
- les règles métier internes de versionnement des objets sources ;
- l'orchestration technique du broker NATS hors convention de notification ;
- la logique de consommation interne aux applications clientes ;
- la modélisation des ressources métier elles-mêmes (voir `ig-md-fhir-common` / `ig-md-fhir-cpage`).

---

## Documentation détaillée

- [Opérations de publication](operations.html) — référence complète des 3 opérations : paramètres, cardinalités, exemples, traçabilité, rattrapage
- [API FHIR de récupération des lots publiés](api-publication-batch.html) — contrat côté consommateur : typologie des lots, synchrone/asynchrone, gestion des erreurs
- [Cas d'exemple NATS](nats-cases.html) — convention de nommage des sujets et scénarios de notification
- [Téléchargements](downloads.html) — artefacts du guide (définitions, exemples, package NPM)

---

## Dépendances

| Package | Version |
|---------|---------|
| `hl7.fhir.fr.core` | 2.2.0 |
| `ig.mdm.fhir.common` | dev |
| FHIR R4 | 4.0.1 |

---

## Contact

**Équipe Référentiels CPage** — [contact@cpage.fr](mailto:contact@cpage.fr) — [https://www.cpage.fr](https://www.cpage.fr)
