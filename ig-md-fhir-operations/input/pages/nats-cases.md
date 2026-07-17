# Cas d'exemple NATS

## Objectif

Cette page décrit le rôle de NATS dans l'architecture de publication du MasterData et détaille la convention de nommage des sujets ainsi que plusieurs scénarios de notification.

NATS n'est utilisé ici que comme **canal de notification de disponibilité**. Il n'embarque jamais le contenu métier détaillé du lot : celui-ci est récupéré séparément via les opérations FHIR décrites dans [Opérations de publication](operations.html) et [API FHIR de récupération des lots publiés](api-publication-batch.html).

---

## 1. Principe général

Lorsqu'un lot passe au statut `READY` :

1. le serveur publie une notification NATS ;
2. le consommateur reçoit cette notification ;
3. le consommateur appelle `$publication-metadata` avec le `publicationBatchId` annoncé ;
4. le consommateur appelle `$publication-bundle` pour récupérer le contenu.

Le message NATS ne transporte pas la transaction métier brute : il annonce uniquement qu'un lot de publication est disponible, avec de quoi le router et décider s'il concerne le consommateur.

---

## 2. Convention de nommage des sujets

### 2.1 Lots globaux

```text
publication.global.<artefact>.available
```

Exemples :

- `publication.global.codesystem.available`
- `publication.global.valueset.available`
- `publication.global.nomenclature.available`

### 2.2 Lots client-spécifiques

```text
publication.<tenant>.<resource>.available
```

Exemples :

- `publication.ght21.organization.available`
- `publication.ght21.transaction.available`
- `publication.chu_dijon.organization.available`
- `publication.chu_dijon.location.available`

Le segment final peut désigner soit le type de ressource principal, soit `transaction` lorsque le lot regroupe plusieurs types cohérents (voir [Cas 4](#cas-4)). Le point important est que la convention retenue reste stable dans tout le système, pour que les consommateurs puissent s'abonner de façon fiable.

---

## 3. Structure minimale du message NATS

Le message reste volontairement léger : juste assez d'informations pour permettre au consommateur de décider s'il est concerné et de récupérer le lot via l'API FHIR.

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

| Champ | Description |
|-------|-------------|
| `messageId` | Identifiant unique du message NATS |
| `correlationId` | Identifiant de corrélation avec la transaction ou l'événement source (peut être partagé par plusieurs messages issus de la même transaction, voir [Cas 3](#cas-3)) |
| `publicationBatchId` | Identifiant du lot à récupérer via `$publication-metadata` / `$publication-bundle` |
| `scope` | `GLOBAL` ou `CLIENT` — reflète le champ `scope` du lot ([CodeSystem publication-scope](CodeSystem-publication-scope.html)) |
| `targetTenant` | Tenant cible, présent si `scope = CLIENT` |
| `bundleType` | `transaction` ou `batch` — reflète le champ `bundleType` du lot |
| `resourceTypes` | Types de ressources présents dans le lot ; agrège les valeurs `resourceType` distinctes des items du lot (`PublicationBatchItem`) |
| `occurredAt` | Date de mise à disposition du lot |

Ce payload est une convention documentée par cet IG (il n'est pas porté par un artefact FSH), construite pour rester cohérente avec le vocabulaire des opérations : les valeurs de `scope` et `bundleType` correspondent exactement aux codes des CodeSystems/ValueSets de cet IG.

---

## 4. Cas 1 — Publication d'une nomenclature globale

**Contexte** : une transaction métier interne met à jour une nomenclature partagée.

**Résultat** : le moteur de publication produit un lot `GLOBAL`.

**Sujet NATS** :

```text
publication.global.codesystem.available
```

**Payload** :

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

**Comportement du consommateur** : reçoit la notification → appelle `$publication-metadata` avec `PB-GLOBAL-001` → appelle `$publication-bundle` avec le même identifiant → applique le contenu.

---

## 5. Cas 2 — Publication d'une ressource client-spécifique

**Contexte** : une ressource métier est mise à jour et doit être publiée avec les identifiants visibles pour un tenant donné.

**Résultat** : le moteur de publication produit un lot `CLIENT`.

**Sujet NATS** :

```text
publication.ght21.organization.available
```

**Payload** :

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

**Comportement du consommateur** : reçoit la notification → appelle `$publication-metadata` avec `PB-CLIENT-0456` → appelle `$publication-bundle` avec le même identifiant → applique la projection tenant-aware.

---

## 6. Cas 3 — Transaction métier interne mixte {#cas-3}

**Contexte** : une transaction métier interne met à jour simultanément une nomenclature et une ressource métier.

**Règle** : la notification ne doit jamais annoncer un lot mixte lorsque les périmètres de diffusion diffèrent ; la transaction interne produit alors plusieurs lots publiés (un `GLOBAL`, un ou plusieurs `CLIENT`), reliés par un `correlationId` commun mais des `publicationBatchId` distincts.

**Sujets NATS** :

```text
publication.global.codesystem.available
publication.ght21.organization.available
```

**Payloads** :

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

Les deux messages partagent `correlationId = evt-3001` (même transaction source) mais pointent vers deux lots distincts, à récupérer et appliquer indépendamment.

---

## 7. Cas 4 — Lot client avec plusieurs ressources cohérentes {#cas-4}

**Contexte** : une mise à jour métier implique plusieurs ressources FHIR liées (`Organization`, `Location`) qui doivent être appliquées ensemble.

**Résultat** : le moteur produit un lot `CLIENT` unique de type `transaction`.

**Sujet NATS** :

```text
publication.ght21.transaction.available
```

**Payload** :

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

Le `Bundle` retourné par `$publication-bundle` sera de type `transaction` : le consommateur doit appliquer ses entrées dans l'ordre `sortOrder` des items, comme une unité cohérente.

---

## 8. Cas 5 — Lot volumineux récupéré en asynchrone

**Contexte** : le lot publié est volumineux ou sa reconstruction prend du temps.

**Notification NATS** : identique dans son principe — la volumétrie du lot n'affecte pas le format du message.

```text
publication.global.nomenclature.available
```

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

**Comportement du consommateur** : appelle `$publication-bundle` avec `Prefer: respond-async`, reçoit `202 Accepted` + `Content-Location`, puis interroge cette URL jusqu'à `200 OK` (Bundle prêt) ou `OperationOutcome` (erreur). Voir [API FHIR de récupération des lots publiés — synchrone et asynchrone](api-publication-batch.html#synchrone-asynchrone).

---

## 9. Cas 6 — Rattrapage après une notification manquée

**Contexte** : un consommateur a été indisponible (redémarrage, incident réseau) et soupçonne avoir manqué une ou plusieurs notifications NATS entre le dernier lot qu'il a traité (`PB-2026-000140`) et maintenant.

**Ce que NATS ne peut pas garantir seul** : NATS notifie en temps réel, mais ne fournit pas nativement de mécanisme de relecture des messages passés dans le cadre de cet IG. C'est précisément le rôle de l'opération FHIR `$publication-list` (voir [Opérations de publication — `$publication-list`](operations.html#op-publication-list)) : elle ne dépend pas du broker et interroge directement l'état des lots publiés côté serveur.

**Séquence de rattrapage** :

1. appel de `$publication-list` avec `fromExclusiveBatchId = PB-2026-000140` (pas de borne haute) ;
2. réception de la liste ordonnée des `batchId` publiés depuis ;
3. pour chaque `batchId` reçu, dans l'ordre : appel `$publication-metadata` puis `$publication-bundle`, application locale.

Ce cas ne produit pas de nouveau message NATS : il documente comment un consommateur comble, via l'API FHIR, un manque que le canal de notification n'a pas comblé lui-même.
