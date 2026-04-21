# Guide d'Implémentation FHIR — Opérations de publication MDM

**Version** : 0.1.0 | **Date** : 30 mars 2026 | **Statut** : Draft

Ce guide d'implémentation FHIR décrit les opérations exposées pour consulter les publications produites par le CPage MasterData.

Il s'appuie sur le socle commun **ig-md-fhir-common** et définit un contrat d'échange basé sur :

- les opérations FHIR système (`$operation`) ;
- la ressource `Parameters` pour les entrées/sorties descriptives ;
- la ressource `Bundle` pour la restitution du contenu publié.

---

## Cycle de publication

Le Master Data produit des **lots de publication** à destination des consommateurs.

Lorsqu'un lot est prêt, le serveur publie sur **NATS** une notification de disponibilité.
Cette notification n'embarque pas la transaction métier brute. Elle annonce uniquement qu'un lot est disponible et qu'il peut être récupéré via l'API FHIR.

Le consommateur suit le cycle suivant :

1. il reçoit une notification NATS ;
2. il appelle `$publication-metadata` pour obtenir les métadonnées du lot ;
3. il appelle `$publication-bundle` pour récupérer le contenu sous forme de `Bundle` FHIR ;
4. il applique localement les créations, mises à jour ou suppressions.

---

## Périmètre de ce guide

Ce guide couvre exclusivement :

- l'opération [`$publication-metadata`](OperationDefinition-publication-metadata.html)
- l'opération [`$publication-bundle`](OperationDefinition-publication-bundle.html)

Ce guide ne couvre pas :

- les traitements internes de fabrication des lots ;
- les règles métier internes de versionnement ;
- l'orchestration technique hors interface FHIR ;
- la logique interne de consommation des messages par les applications clientes.

---

## Types de lots

| Type | Scope | Description |
|------|-------|-------------|
| **GLOBAL** | Tous consommateurs | Nomenclatures, CodeSystems, ValueSets partagés |
| **CLIENT** | Tenant cible | Ressources métier contextualisées (Organization, Location…) avec identifiants locaux |

Règles de découpage :

- une transaction interne peut produire plusieurs lots de publication ;
- chaque lot doit rester homogène en termes de périmètre de diffusion ;
- les lots GLOBAL et les lots CLIENT doivent toujours être séparés.

---

## Opérations exposées

### `$publication-metadata`

Récupère les métadonnées d'un lot publié.

```http
POST /fhir/$publication-metadata
Content-Type: application/fhir+json
```

Retourne : `publicationBatchId`, `scope`, `targetTenant`, `bundleType`, `publicationViewCode`, `resourceTypes`, `status`, `createdAt`.

### `$publication-bundle`

Récupère le contenu publié d'un lot sous forme de `Bundle` FHIR.

```http
POST /fhir/$publication-bundle
Content-Type: application/fhir+json
```

Mode de réponse :

- **synchrone** pour les lots de faible volumétrie ;
- **asynchrone** via `Prefer: respond-async` → `202 Accepted` + `Content-Location` pour les lots volumineux.

---

## Type de Bundle retourné

| Type | Sémantique |
|------|-----------|
| `transaction` | Le lot doit être interprété comme une unité cohérente |
| `batch` | Les entrées peuvent être traitées indépendamment |

Le type est déterminé par la vue de publication et la nature du contenu.

---

## Documentation détaillée

- [Opérations de publication](operations.html) — spécification complète des paramètres, exemples et règles
- [API FHIR de récupération des lots](api-publication-batch.html) — contrat d'API et gestion des erreurs
- [Cas d'exemple NATS](nats-cases.html) — scénarios de notification et de récupération

---

## Dépendances

| Package | Version |
|---------|---------|
| `hl7.fhir.fr.core` | 2.2.0 |
| `ig.mdm.fhir.common` | dev |
| FHIR R4 | 4.0.1 |

---

## Contact

**Équipe Référentiels CPage** — contact@cpage.fr — [https://www.cpage.fr](https://www.cpage.fr)