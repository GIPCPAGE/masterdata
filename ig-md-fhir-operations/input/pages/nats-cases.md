# Cas d'exemple NATS

Cette page décrit le rôle de NATS dans l'architecture de publication et détaille la convention de sujets ainsi que plusieurs scénarios concrets de notification.

NATS ne sert ici que de **canal de signalement** : il annonce qu'un lot est disponible, il n'embarque jamais son contenu. Le contenu se récupère toujours séparément via les opérations FHIR — voir [Opérations de publication](operations.html) et [API FHIR de récupération des lots publiés](api-publication-batch.html).

---

## Principe général

Dès qu'un lot passe au statut `READY`, le serveur publie un message NATS. Le consommateur qui le reçoit ne dispose encore d'aucune donnée métier : il sait seulement qu'un `publicationBatchId` donné est désormais consultable, et de quoi décider s'il le concerne. La suite du traitement — `$publication-metadata` puis `$publication-bundle` — est strictement identique quel que soit le sujet NATS ayant déclenché l'appel.

---

## Convention de nommage des sujets

### Lots `GLOBAL`

```text
publication.global.<artefact>.available
```

Exemples : `publication.global.codesystem.available`, `publication.global.valueset.available`, `publication.global.nomenclature.available`.

### Lots `CLIENT`

```text
publication.<tenant>.<resource>.available
```

Exemples : `publication.ght21.organization.available`, `publication.ght21.transaction.available`, `publication.chu_dijon.location.available`.

Le dernier segment peut désigner le type de ressource principal du lot, ou le mot `transaction` lorsque le lot regroupe plusieurs types de ressources appliqués comme un tout cohérent (voir [Cas 4](#cas-4)). Ce qui compte n'est pas tel ou tel nom de segment mais la stabilité de la convention dans le temps : un consommateur construit ses abonnements sur cette structure, elle ne doit pas changer de forme d'un déploiement à l'autre.

---

## Structure du message

Le message reste minimal — juste assez pour router la notification et savoir quel appel FHIR déclencher.

```json
{
  "messageId": "msg-001",
  "correlationId": "evt-001",
  "publicationBatchId": "PB-2026-000145",
  "scope": "CLIENT",
  "targetTenant": "ght21",
  "bundleType": "transaction",
  "resourceTypes": ["Organization", "Location"],
  "occurredAt": "2026-03-30T09:15:00Z"
}
```

| Champ | Rôle |
|-------|------|
| `messageId` | Identifiant unique du message NATS lui-même |
| `correlationId` | Identifiant de corrélation avec la transaction/l'événement source ; peut être partagé par plusieurs messages issus d'une même transaction mixte (voir [Cas 3](#cas-3)) |
| `publicationBatchId` | Le lot à interroger via `$publication-metadata` / `$publication-bundle` |
| `scope` | `GLOBAL` ou `CLIENT` — reflète le `scope` du lot ([CodeSystem publication-scope](CodeSystem-publication-scope.html)) |
| `targetTenant` | Présent si `scope = CLIENT` |
| `bundleType` | `transaction` ou `batch` — reflète le `bundleType` du lot |
| `resourceTypes` | Les types de ressources distincts présents dans le lot, agrégés depuis les items (`PublicationBatchItem`) |
| `occurredAt` | Horodatage de mise à disposition |

Ce format de message est une convention documentée par cet IG — il n'est adossé à aucun artefact FSH formel — mais son vocabulaire (`scope`, `bundleType`) reprend volontairement les codes exacts des terminologies de cet IG, pour qu'un consommateur n'ait pas à faire de correspondance entre deux jeux de valeurs.

---

## Cas 1 — Nomenclature globale

Une transaction interne met à jour une nomenclature partagée : le moteur produit un lot `GLOBAL`.

Sujet : `publication.global.codesystem.available`

```json
{
  "messageId": "msg-1001",
  "correlationId": "evt-1001",
  "publicationBatchId": "PB-GLOBAL-001",
  "scope": "GLOBAL",
  "bundleType": "batch",
  "resourceTypes": ["CodeSystem", "ValueSet"],
  "occurredAt": "2026-03-30T08:30:00Z"
}
```

Traitement : réception → `$publication-metadata(PB-GLOBAL-001)` → `$publication-bundle(PB-GLOBAL-001)` → application.

---

## Cas 2 — Ressource client-spécifique

Une ressource métier est mise à jour pour un tenant donné : le moteur produit un lot `CLIENT`.

Sujet : `publication.ght21.organization.available`

```json
{
  "messageId": "msg-2001",
  "correlationId": "evt-2001",
  "publicationBatchId": "PB-CLIENT-0456",
  "scope": "CLIENT",
  "targetTenant": "ght21",
  "bundleType": "transaction",
  "resourceTypes": ["Organization"],
  "occurredAt": "2026-03-30T09:15:00Z"
}
```

Traitement : réception → `$publication-metadata(PB-CLIENT-0456)` → `$publication-bundle(PB-CLIENT-0456)` → application de la projection propre au tenant.

---

## Cas 3 — Transaction mixte, deux lots {#cas-3}

Une transaction interne touche simultanément une nomenclature et une ressource métier. La règle de découpage homogène (voir [API FHIR de récupération des lots publiés](api-publication-batch.html)) interdit un lot mixte : deux lots sont produits, partageant un `correlationId` commun mais chacun son propre `publicationBatchId`.

Sujets : `publication.global.codesystem.available` et `publication.ght21.organization.available`

```json
{
  "messageId": "msg-3001",
  "correlationId": "evt-3001",
  "publicationBatchId": "PB-GLOBAL-010",
  "scope": "GLOBAL",
  "bundleType": "batch",
  "resourceTypes": ["CodeSystem"],
  "occurredAt": "2026-03-30T10:00:00Z"
}
```

```json
{
  "messageId": "msg-3002",
  "correlationId": "evt-3001",
  "publicationBatchId": "PB-CLIENT-010",
  "scope": "CLIENT",
  "targetTenant": "ght21",
  "bundleType": "transaction",
  "resourceTypes": ["Organization", "Location"],
  "occurredAt": "2026-03-30T10:00:00Z"
}
```

`correlationId = evt-3001` est identique dans les deux messages : c'est le même événement source. Les deux lots restent néanmoins entièrement indépendants à récupérer et à appliquer.

---

## Cas 4 — Lot client à plusieurs ressources cohérentes {#cas-4}

Une mise à jour métier implique plusieurs ressources liées (`Organization` + `Location`) qui doivent être appliquées comme un tout : un seul lot `CLIENT` de type `transaction` est produit.

Sujet : `publication.ght21.transaction.available`

```json
{
  "messageId": "msg-4001",
  "correlationId": "evt-4001",
  "publicationBatchId": "PB-CLIENT-020",
  "scope": "CLIENT",
  "targetTenant": "ght21",
  "bundleType": "transaction",
  "resourceTypes": ["Organization", "Location"],
  "occurredAt": "2026-03-30T11:00:00Z"
}
```

Le `Bundle` renvoyé par `$publication-bundle` sera de type `transaction` : le consommateur applique ses entrées dans l'ordre `sortOrder` des items, comme un tout indivisible.

---

## Cas 5 — Lot volumineux, récupération asynchrone

La notification ne change pas de forme selon la volumétrie du lot annoncé :

Sujet : `publication.global.nomenclature.available`

```json
{
  "messageId": "msg-5001",
  "correlationId": "evt-5001",
  "publicationBatchId": "PB-GLOBAL-999",
  "scope": "GLOBAL",
  "bundleType": "batch",
  "resourceTypes": ["CodeSystem", "ValueSet"],
  "occurredAt": "2026-03-30T12:00:00Z"
}
```

C'est au moment de l'appel à `$publication-bundle` que le consommateur décide du mode de récupération : `Prefer: respond-async` reçoit `202 Accepted` + `Content-Location`, puis interroge cette URL jusqu'à `200 OK` (contenu prêt) ou `OperationOutcome` (échec). Voir [API FHIR de récupération des lots publiés — synchrone et asynchrone](api-publication-batch.html#synchrone-asynchrone).

---

## Cas 6 — Rattrapage après une notification manquée

Un consommateur a été indisponible (redémarrage, incident réseau) et soupçonne avoir manqué une ou plusieurs notifications entre le dernier lot traité (`PB-2026-000140`) et aujourd'hui.

NATS ne peut rien garantir seul ici : il notifie en temps réel, sans mécanisme de relecture des messages passés dans le cadre de cet IG. C'est le rôle de `$publication-list` (voir [Opérations de publication — `$publication-list`](operations.html#op-publication-list)), qui interroge directement l'état des lots côté serveur, indépendamment du broker.

Séquence :

1. `$publication-list(fromExclusiveBatchId = PB-2026-000140)`, sans borne haute ;
2. réception de la liste ordonnée des `batchId` publiés depuis ;
3. pour chacun, dans l'ordre reçu : `$publication-metadata` puis `$publication-bundle`, puis application locale.

Ce cas ne génère aucun nouveau message NATS : il montre comment l'API FHIR comble, après coup, un manque que le canal de notification n'a pas comblé de lui-même.
