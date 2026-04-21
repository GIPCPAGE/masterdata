# Cas d'exemple NATS

## Objectif

Cette page décrit le rôle de NATS dans l'architecture de publication du Master Data et précise les différents cas de notification de disponibilité de lots publiés.

Dans cette architecture, NATS est utilisé uniquement comme canal de notification exposé aux consommateurs.

Les messages publiés sur NATS annoncent la disponibilité d'un lot de publication homogène.
Le contenu détaillé du lot n'est pas transporté dans le message NATS ; il est récupéré ensuite via les opérations FHIR de cet IG.

Cette page complète :

- [Opérations de publication](operations.html)
- [API FHIR de récupération des lots publiés](api-publication-batch.html)

---

## 1. Principe général

Le moteur de publication produit des lots de publication.

Lorsqu'un lot est prêt :

1. le serveur publie une notification NATS ;
2. le consommateur reçoit cette notification ;
3. le consommateur récupère les métadonnées du lot via `$publication-metadata` ;
4. le consommateur récupère le contenu du lot via `$publication-bundle`.

Le message NATS ne transporte pas la transaction métier brute.
Il annonce uniquement qu'un lot de publication est disponible.

---

## 2. Convention de nommage des sujets

La convention recommandée est la suivante.

### 2.1 Lots globaux

```
publication.global.<artifact>.available
```

Exemples :

- `publication.global.codesystem.available`
- `publication.global.valueset.available`
- `publication.global.nomenclature.available`

### 2.2 Lots client-spécifiques

```
publication.<tenant>.<resource>.available
```

Exemples :

- `publication.ght21.organization.available`
- `publication.ght21.transaction.available`
- `publication.chu_dijon.organization.available`
- `publication.chu_dijon.location.available`

---

## 3. Structure minimale du message NATS

Le message NATS doit rester léger.
Il doit contenir uniquement les informations nécessaires pour permettre au consommateur de récupérer le lot via l'API FHIR.

Payload minimal recommandé :

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

Champs recommandés :

| Champ | Description |
|-------|-------------|
| `messageId` | Identifiant unique du message NATS |
| `correlationId` | Identifiant de corrélation avec la transaction ou l'événement source |
| `publicationBatchId` | Identifiant du lot à récupérer via l'API FHIR |
| `scope` | `GLOBAL` ou `CLIENT` |
| `targetTenant` | Client cible si applicable |
| `bundleType` | `transaction` ou `batch` |
| `resourceTypes` | Types de ressources présents dans le lot |
| `occurredAt` | Date de mise à disposition du lot |

---

## 4. Cas 1 — Publication d'une nomenclature globale

### Contexte

Une transaction métier interne met à jour une nomenclature partagée.

### Résultat attendu

Le moteur de publication produit un lot `GLOBAL`.

### Sujet NATS

```
publication.global.codesystem.available
```

### Payload d'exemple

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

### Comportement du consommateur

1. reçoit la notification ;
2. appelle `$publication-metadata` avec `PB-GLOBAL-001` ;
3. appelle `$publication-bundle` avec `PB-GLOBAL-001` ;
4. applique le contenu du lot.

---

## 5. Cas 2 — Publication d'une ressource client-spécifique

### Contexte

Une ressource métier est mise à jour et doit être publiée avec les identifiants visibles pour un client donné.

### Résultat attendu

Le moteur de publication produit un lot `CLIENT`.

### Sujet NATS

```
publication.ght21.organization.available
```

### Payload d'exemple

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

### Comportement du consommateur

1. reçoit la notification ;
2. appelle `$publication-metadata` avec `PB-CLIENT-0456` ;
3. appelle `$publication-bundle` avec le même identifiant ;
4. applique la projection tenant-aware.

---

## 6. Cas 3 — Transaction métier interne mixte

### Contexte

Une transaction métier interne met à jour simultanément :

- une nomenclature ;
- une ressource métier.

### Règle

La notification ne doit pas annoncer un lot mixte si les périmètres de diffusion sont différents.

### Résultat attendu

La transaction interne produit plusieurs lots publiés.

- un lot `GLOBAL` pour la nomenclature ;
- un lot `CLIENT` pour la ressource du client `ght21`.

### Sujets NATS

```
publication.global.codesystem.available
publication.ght21.organization.available
```

### Payloads d'exemple

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

Les deux messages peuvent partager le même `correlationId`, tout en pointant vers deux lots différents.

---

## 7. Cas 4 — Lot client avec plusieurs ressources cohérentes

### Contexte

Une mise à jour de ressource métier implique plusieurs ressources FHIR liées (`Organization`, `Location`).

### Résultat attendu

Le moteur produit un lot `CLIENT` unique de type `transaction`.

### Sujet NATS

```
publication.ght21.transaction.available
```

### Payload d'exemple

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

Le sujet peut être nommé par `resourceType` principal ou par `transaction` selon la convention retenue.
L'important est de conserver une convention stable dans tout le système.

---

## 8. Cas 5 — Lot volumineux récupéré en asynchrone

### Contexte

Le lot publié est volumineux ou sa reconstruction prend du temps.

### Notification NATS

Le message NATS reste identique dans son principe.

```
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

### Comportement du consommateur

Le consommateur appelle `$publication-bundle` avec l'en-tête `Prefer: respond-async` :

```http
POST /fhir/$publication-bundle
Prefer: respond-async
Content-Type: application/fhir+json
```

Il reçoit une réponse `202 Accepted` avec un `Content-Location`.  
Il interroge ensuite cette URL jusqu'à obtenir le `Bundle` final (`200 OK`) ou un `OperationOutcome` en cas d'erreur.