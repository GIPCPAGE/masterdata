# Guide d'implémentation FHIR — Opérations de publication MDM

**Version** : 0.1.0 | **Date** : 30 mars 2026 | **Statut** : Draft

## Pourquoi un IG dédié aux opérations

Cet IG ne définit aucun profil de ressource métier. Il définit un **contrat d'échange** : la façon dont un système consommateur retrouve, après coup, le contenu que le CPage MasterData a produit et rendu disponible.

La distinction est volontaire. Modéliser une ressource (quels champs, quelles extensions, quelles terminologies — c'est le rôle de `ig-md-fhir-common` et `ig-md-fhir-cpage`) et définir comment cette ressource est *remise* à un consommateur sont deux problèmes qui n'évoluent pas au même rythme et n'intéressent pas les mêmes équipes. Ajouter une opération de récupération ne devrait jamais obliger à republier un profil métier, et inversement. En les séparant, chaque IG peut vivre — et surtout être versionné — selon son propre calendrier.

Concrètement, cet IG ajoute trois choses, et rien d'autre :

- trois **opérations FHIR système** (`$publication-metadata`, `$publication-bundle`, `$publication-list`) ;
- deux **modèles logiques** qui documentent la structure des lots transportés (`PublicationBatch`, `PublicationBatchItem`) — ce ne sont pas des ressources FHIR exposées, seulement le vocabulaire commun aux paramètres des opérations ;
- les **terminologies** qui encadrent ces paramètres (statut de lot, périmètre de diffusion, type de bundle).

Il dépend de `hl7.fhir.fr.core` (pour l'écosystème FR Core dans lequel s'inscrit le MasterData) et de `ig.mdm.fhir.common` (le socle de modélisation métier), mais aucune ressource métier n'est profilée ici.

---

## Comment le contenu circule, en un coup d'œil

Le MasterData ne diffuse jamais une transaction interne telle quelle. Chaque transaction validée est transformée en un ou plusieurs **lots de publication**, puis sa disponibilité est annoncée séparément de son contenu :

```text
Transaction métier interne (validée côté MasterData)
        │
        ▼
Moteur de publication — découpe en lot(s) homogènes
        │
        ├─ lot GLOBAL   : nomenclatures, référentiels partagés (pas de tenant cible)
        └─ lot CLIENT   : ressources métier contextualisées pour un tenant précis
        │
        ▼
   ┌────────────────────────┬─────────────────────────────┐
   │  Notification NATS     │  API FHIR (3 opérations)     │
   │  disponibilité seule   │  seul point de récupération  │
   └────────────────────────┴─────────────────────────────┘
                              │
                              ▼
                        Consommateur
             1. $publication-metadata → métadonnées du lot
             2. $publication-bundle   → contenu (Bundle FHIR)
             3. applique localement (create / update / delete)
             (en cas de doute : $publication-list → rattrapage)
```

Deux principes structurent ce schéma :

**NATS ne porte jamais le contenu.** Le message publié sur le broker signale qu'un lot identifié par un `publicationBatchId` est prêt ; il ne remplace à aucun moment un appel aux opérations FHIR. Un consommateur qui recevrait un message NATS corrompu ou incomplet perdrait au pire une information de routage — jamais des données métier, puisque celles-ci ne transitent pas par ce canal. Le détail des sujets et des scénarios de notification est dans [Cas d'exemple NATS](nats-cases.html).

**Les opérations FHIR sont l'unique porte d'entrée du contenu.** Il n'existe pas de `read` ou de `search` standard qui exposerait un lot : la notion même de « lot prêt à consulter » n'a pas d'équivalent dans les interactions REST FHIR de base. D'où les trois opérations système décrites en détail dans [Opérations de publication](operations.html), et le contrat vu côté intégrateur dans [API FHIR de récupération des lots publiés](api-publication-batch.html).

### GLOBAL contre CLIENT

Un lot ([`PublicationBatch`](StructureDefinition-PublicationBatch.html)) porte un `scope`, bindé sur le [CodeSystem publication-scope](CodeSystem-publication-scope.html), qui ne peut prendre que deux valeurs :

- **`GLOBAL`** : le contenu est identique quel que soit le destinataire — typiquement des nomenclatures (`CodeSystem`, `ValueSet`) ou des référentiels partagés. Le champ `targetTenant` du lot reste vide.
- **`CLIENT`** : le contenu est contextualisé pour un tenant précis — des ressources métier (`Organization`, `Location`...) portant des identifiants propres à ce tenant. `targetTenant` identifie ce destinataire.

Une même transaction métier interne peut donc donner naissance à *plusieurs* lots distincts : le moteur de publication n'a pas le droit de mélanger dans un même lot un contenu GLOBAL et un contenu CLIENT, même s'ils proviennent d'un seul événement source (le champ `sourceTransactionId`, commun à ces lots, garde la trace du lien).

### Synchrone et asynchrone

`$publication-bundle` peut répondre immédiatement ou, si l'appelant envoie `Prefer: respond-async`, différer sa réponse derrière un `202 Accepted` suivi d'un polling — utile pour les lots dont la reconstruction est coûteuse. Ce comportement est déclaré dans le [CapabilityStatement `mdm-publication-server`](CapabilityStatement-mdm-publication-server.html) et détaillé dans [API FHIR de récupération des lots publiés](api-publication-batch.html).

### Cycle de vie d'un lot

Un lot n'est consultable par les opérations de récupération que dans un état précis. Le [CodeSystem publication-batch-status](CodeSystem-publication-batch-status.html) définit quatre états : `PROCESSING` (en cours de fabrication, pas encore visible), `READY` (seul état consultable — c'est à ce moment que la notification NATS part), `FAILED` (la fabrication a échoué ; un nouveau lot de reprise portera un nouvel identifiant) et `EXPIRED` (retiré de la consultation après rétention, sans réutilisation de l'identifiant).

---

## Traçabilité : ce que ce guide couvre, et ce qu'il ne couvre pas

Le modèle logique `PublicationBatchItem` porte, pour chaque ressource incluse dans un lot, un `eventType` (création, mise à jour, suppression), un `sortOrder` qui fixe l'ordre d'application, et éventuellement un `rootInstanceId` lorsque l'identifiant métier racine diffère de l'identifiant FHIR exposé. Combinés au `sourceTransactionId` et au `sourceVersionNum` portés par le lot parent, ces champs répondent à une seule question : *qu'est-ce qui a changé, dans quel lot, dans quel ordre*.

Cette information n'a pas vocation à servir d'audit de gouvernance au sens FHIR `Provenance` : elle ne dit rien de *qui* a déclenché la modification ni *pourquoi*. C'est un choix de conception délibéré, pas un oubli — le détail et sa justification sont donnés dans [Opérations de publication — Traçabilité des publications](operations.html#tracabilite).

---

## Ce que ce guide couvre — et ce qu'il ne couvre pas

Couvert par cet IG :

- les opérations [`$publication-metadata`](OperationDefinition-publication-metadata.html), [`$publication-bundle`](OperationDefinition-publication-bundle.html) et [`$publication-list`](OperationDefinition-publication-list.html) ;
- les modèles logiques `PublicationBatch` et `PublicationBatchItem` ;
- les terminologies `publication-scope`, `publication-batch-status` et `bundle-type-publication` ;
- le `CapabilityStatement` du serveur de publication.

Hors périmètre :

- la fabrication interne des lots (règles de découpage, moteur de projection, versionnement des objets sources) ;
- l'administration du broker NATS au-delà de la convention de notification ;
- la logique de consommation propre à chaque application cliente ;
- la modélisation des ressources métier elles-mêmes, qui relève de `ig-md-fhir-common` / `ig-md-fhir-cpage`.

---

## Pour aller plus loin

- [Opérations de publication](operations.html) — référence paramètre par paramètre des trois opérations, modèles logiques, traçabilité
- [API FHIR de récupération des lots publiés](api-publication-batch.html) — le contrat vu côté consommateur : typologie de lot, synchrone/asynchrone, sécurité, erreurs
- [Cas d'exemple NATS](nats-cases.html) — convention de sujets et scénarios de notification concrets
- [Téléchargements](downloads.html) — artefacts du guide

---

## Dépendances

| Package | Version |
|---------|---------|
| `hl7.fhir.fr.core` | 2.2.0 |
| `ig.mdm.fhir.common` | dev |
| FHIR | R4 (4.0.1) |

---

## Contact

**CPage** — [contact@cpage.fr](mailto:contact@cpage.fr) — [https://www.cpage.fr](https://www.cpage.fr)
