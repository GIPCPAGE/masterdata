# Opérations de publication

## 1. Périmètre

Cette page est la référence technique des trois opérations FHIR système exposées par le serveur de publication MDM :

- [`$publication-metadata`](#op-publication-metadata)
- [`$publication-bundle`](#op-publication-bundle)
- [`$publication-list`](#op-publication-list)

Les trois sont des opérations **système** (`system = true`, `type = false`, `instance = false`) invoquées sur la racine du serveur (`POST /fhir/$nom-operation`), et aucune ne modifie l'état du serveur (`affectsState = false`).

Pour l'architecture d'ensemble (production, notification NATS, récupération), voir [Accueil](index.html). Pour le contrat vu côté consommateur (typologie de lot, synchrone/asynchrone, erreurs), voir [API FHIR de récupération des lots publiés](api-publication-batch.html).

---

## 2. Opération `$publication-metadata` {#op-publication-metadata}

### 2.1 Objectif

Retourne les métadonnées d'un lot de publication identifié par `publicationBatchId`, sans en récupérer le contenu. Permet à un consommateur de décider s'il doit appeler `$publication-bundle` (le lot est-il prêt ? quel est son scope ? quelles ressources contient-il ?) avant de le faire.

### 2.2 Endpoint

```http
POST /fhir/$publication-metadata
Content-Type: application/fhir+json
```

### 2.3 Paramètres d'entrée

| Paramètre | Cardinalité | Type | Description |
|-----------|:-----------:|------|-------------|
| `publicationBatchId` | 1..1 | `string` | Identifiant technique du lot publié |

### 2.4 Paramètres de sortie

| Paramètre | Cardinalité | Type | Description |
|-----------|:-----------:|------|-------------|
| `publicationBatchId` | 1..1 | `string` | Identifiant technique du lot |
| `scope` | 1..1 | `code` | `GLOBAL` ou `CLIENT` — bindé (required) sur [ValueSet publication-scope](ValueSet-publication-scope.html) |
| `targetTenant` | 0..1 | `string` | Tenant cible lorsque le lot est client-spécifique |
| `bundleType` | 1..1 | `code` | `transaction` ou `batch` — bindé (required) sur [ValueSet bundle-type-publication](ValueSet-bundle-type-publication.html) |
| `publicationViewCode` | 0..1 | `string` | Code de la vue de publication utilisée pour fabriquer le lot |
| `sourceTransactionId` | 0..1 | `string` | Identifiant de la transaction métier interne source |
| `sourceVersionNum` | 0..1 | `integer` | Numéro de version de l'objet source au moment de la fabrication du lot |
| `resourceType` | 0..* | `string` | Un type de ressource FHIR présent dans le lot (répété une fois par type distinct) |
| `status` | 1..1 | `code` | `READY`, `PROCESSING`, `FAILED` ou `EXPIRED` — bindé (required) sur [ValueSet publication-batch-status](ValueSet-publication-batch-status.html) |
| `createdAt` | 0..1 | `dateTime` | Date de création du lot |

> Le nom de paramètre `publicationViewCode` désigne, côté opération, la même notion que le champ `publicationViewId` du modèle logique `PublicationBatch` (voir [§5](#modele-logique)). Les deux noms coexistent délibérément : l'un est le nom du champ dans le modèle de transport interne, l'autre celui du paramètre exposé publiquement.

### 2.5 Exemple

Requête :

```json
{
  "resourceType": "Parameters",
  "parameter": [
    { "name": "publicationBatchId", "valueString": "PB-2026-000145" }
  ]
}
```

Réponse (lot `CLIENT`) :

```json
{
  "resourceType": "Parameters",
  "parameter": [
    { "name": "publicationBatchId", "valueString": "PB-2026-000145" },
    { "name": "scope", "valueCode": "CLIENT" },
    { "name": "targetTenant", "valueString": "ght21" },
    { "name": "bundleType", "valueCode": "transaction" },
    { "name": "publicationViewCode", "valueString": "ORG_GHT21" },
    { "name": "sourceTransactionId", "valueString": "TX-2026-000987" },
    { "name": "sourceVersionNum", "valueInteger": 54 },
    { "name": "resourceType", "valueString": "Organization" },
    { "name": "resourceType", "valueString": "Location" },
    { "name": "status", "valueCode": "READY" },
    { "name": "createdAt", "valueDateTime": "2026-03-30T09:15:00Z" }
  ]
}
```

### 2.6 Règles de comportement

- `publicationBatchId` est obligatoire ; son absence entraîne une erreur `400`.
- Si l'identifiant ne correspond à aucun lot connu, le serveur retourne un `OperationOutcome` (`404` / `issue.code = not-found`) — voir [Gestion des erreurs](api-publication-batch.html#gestion-des-erreurs).
- `targetTenant` n'est renseigné en sortie que pour un lot `CLIENT`.
- `resourceType` peut apparaître zéro, une ou plusieurs fois : c'est l'ensemble des types de ressources distincts portés par les items du lot (voir modèle `PublicationBatchItem`, [§5.2](#publicationbatchitem)).
- `status` peut valoir `EXPIRED` : un lot `READY` peut être retiré de la consultation après une politique de rétention, sans que son identifiant soit réutilisé.

---

## 3. Opération `$publication-bundle` {#op-publication-bundle}

### 3.1 Objectif

Retourne le contenu publié d'un lot sous la forme d'un `Bundle` FHIR (`transaction` ou `batch`, selon la valeur de `bundleType` du lot).

### 3.2 Endpoint

```http
POST /fhir/$publication-bundle
Content-Type: application/fhir+json
```

### 3.3 Paramètres d'entrée

| Paramètre | Cardinalité | Type | Description |
|-----------|:-----------:|------|-------------|
| `publicationBatchId` | 1..1 | `string` | Identifiant technique du lot publié |
| `targetTenant` | 0..1 | `string` | Tenant cible, transmis pour **contrôle de cohérence** avec le lot demandé |
| `publicationViewCode` | 0..1 | `string` | Vue de publication attendue, transmise pour **contrôle de cohérence** avec le lot demandé |

`targetTenant` et `publicationViewCode` ne sélectionnent pas de contenu : ils permettent au serveur de vérifier que l'appelant demande bien le lot qu'il croit demander, et de renvoyer une erreur si ce n'est pas le cas (voir [§3.6](#op-publication-bundle-comportement) et le tableau d'erreurs de [API FHIR de récupération des lots publiés](api-publication-batch.html#gestion-des-erreurs)).

### 3.4 Paramètre de sortie

| Paramètre | Cardinalité | Type | Description |
|-----------|:-----------:|------|-------------|
| `return` | 1..1 | `Bundle` | Bundle FHIR correspondant au lot publié |

### 3.5 Exemple

Requête :

```json
{
  "resourceType": "Parameters",
  "parameter": [
    { "name": "publicationBatchId", "valueString": "PB-2026-000145" },
    { "name": "targetTenant", "valueString": "ght21" },
    { "name": "publicationViewCode", "valueString": "ORG_GHT21" }
  ]
}
```

Réponse (`Bundle` de type `transaction`) :

```json
{
  "resourceType": "Bundle",
  "type": "transaction",
  "timestamp": "2026-03-30T09:15:02Z",
  "entry": [
    {
      "resource": {
        "resourceType": "Organization",
        "id": "ORG-GHT21-4589",
        "identifier": [{ "system": "urn:ght21:tiers", "value": "4589" }],
        "name": "Clinique Exemple"
      },
      "request": { "method": "PUT", "url": "Organization/ORG-GHT21-4589" }
    },
    {
      "resource": {
        "resourceType": "Location",
        "id": "LOC-GHT21-775",
        "name": "Site principal"
      },
      "request": { "method": "PUT", "url": "Location/LOC-GHT21-775" }
    }
  ]
}
```

Les entrées apparaissent dans l'ordre `sortOrder` défini par les items du lot (voir [§5.2](#publicationbatchitem)) : dans un `Bundle` de type `transaction`, le consommateur doit les appliquer dans cet ordre.

### 3.6 Règles de comportement {#op-publication-bundle-comportement}

- `publicationBatchId` est obligatoire.
- Le mode de réponse peut être synchrone ou asynchrone (`Prefer: respond-async`) — détaillé dans [API FHIR de récupération des lots publiés](api-publication-batch.html#synchrone-asynchrone).
- Si `targetTenant` ou `publicationViewCode` sont transmis et ne correspondent pas au lot réellement désigné par `publicationBatchId`, le serveur retourne une erreur (incohérence tenant / incohérence vue).
- Le serveur ne doit jamais retourner le contenu d'un lot `CLIENT` pour un tenant différent de celui autorisé par le contexte de sécurité de l'appelant.

---

## 4. Opération `$publication-list` {#op-publication-list}

### 4.1 Objectif

Retourne la liste des identifiants de lots publiés compris dans un intervalle donné. Cette opération est le mécanisme de **rattrapage (gap detection)** de cet IG : un consommateur qui a pu manquer une ou plusieurs notifications NATS (redémarrage, indisponibilité, perte de message) peut, à partir du dernier lot qu'il sait avoir traité, demander la liste de tout ce qui a été publié depuis.

### 4.2 Endpoint

```http
POST /fhir/$publication-list
Content-Type: application/fhir+json
```

### 4.3 Paramètres d'entrée

| Paramètre | Cardinalité | Type | Description |
|-----------|:-----------:|------|-------------|
| `fromExclusiveBatchId` | 1..1 | `string` | Borne basse **exclusive** (format `PB-{id}`). Seuls les lots dont l'identifiant est strictement supérieur à cette valeur sont retournés. |
| `toInclusiveBatchId` | 0..1 | `string` | Borne haute **inclusive** (format `PB-{id}`). Si absente, tous les lots publiés au-delà de `fromExclusiveBatchId` sont retournés. |

### 4.4 Paramètre de sortie

| Paramètre | Cardinalité | Type | Description |
|-----------|:-----------:|------|-------------|
| `batchId` | 0..* | `string` | Identifiant d'un lot publié compris dans l'intervalle (format `PB-{id}`), un paramètre par lot trouvé. Les résultats sont triés par identifiant croissant. |

### 4.5 Exemple — détection d'un trou de publication

Requête (« qu'est-ce qui a été publié entre le lot 140, exclu, et le lot 145, inclus ? ») :

```json
{
  "resourceType": "Parameters",
  "parameter": [
    { "name": "fromExclusiveBatchId", "valueString": "PB-2026-000140" },
    { "name": "toInclusiveBatchId",   "valueString": "PB-2026-000145" }
  ]
}
```

Réponse :

```json
{
  "resourceType": "Parameters",
  "parameter": [
    { "name": "batchId", "valueString": "PB-2026-000141" },
    { "name": "batchId", "valueString": "PB-2026-000142" },
    { "name": "batchId", "valueString": "PB-2026-000145" }
  ]
}
```

Le consommateur connaissait déjà `PB-2026-000140`. La réponse lui apprend que trois lots ont depuis été publiés, mais que **`PB-2026-000143` et `PB-2026-000144` n'y figurent pas** : soit ils n'ont jamais existé, soit ils ont expiré ou échoué entre-temps. Dans tous les cas, la liste retournée est faisant foi — c'est elle, et non une simple différence arithmétique d'identifiants, qui indique ce qui reste réellement à récupérer. Le consommateur enchaîne alors un appel `$publication-metadata` puis `$publication-bundle` pour chaque `batchId` reçu, dans l'ordre croissant renvoyé.

Requête en rattrapage ouvert (pas de borne haute — « tout ce qui est paru depuis ») :

```json
{
  "resourceType": "Parameters",
  "parameter": [
    { "name": "fromExclusiveBatchId", "valueString": "PB-2026-000140" }
  ]
}
```

Si aucun lot n'est trouvé dans l'intervalle, la réponse est une ressource `Parameters` sans occurrence de `batchId`.

### 4.6 Règles de comportement

- `fromExclusiveBatchId` est obligatoire ; son absence entraîne une erreur `400`.
- `toInclusiveBatchId` est optionnel ; en son absence, l'intervalle est ouvert vers le haut.
- Les résultats sont triés par identifiant de lot croissant.
- L'opération ne filtre pas par scope ni par tenant : elle retourne tous les lots publiés dans l'intervalle, quel que soit leur destinataire. Le filtrage par droits d'accès s'opère ensuite, lot par lot, lors des appels à `$publication-metadata` / `$publication-bundle`.
- L'opération ne modifie aucune donnée (`affectsState = false`).

---

## 5. Modèle logique {#modele-logique}

Les paramètres des trois opérations dérivent de deux modèles logiques, qui ne sont pas eux-mêmes des ressources FHIR exposées : ce sont des structures de transport internes documentées pour expliciter d'où viennent les champs manipulés par les opérations.

### 5.1 `PublicationBatch`

Un lot de publication ([`PublicationBatch`](StructureDefinition-PublicationBatch.html)) est l'unité de diffusion homogène produite à partir d'une ou plusieurs transactions métier internes. Il devient consultable dès qu'il passe au statut `READY`.

| Champ | Cardinalité | Type | Description |
|-------|:-----------:|------|-------------|
| `publicationBatchId` | 1..1 | `string` | Identifiant technique unique du lot, généré par la plateforme MDM |
| `scope` | 1..1 | `code` | `GLOBAL` (nomenclatures partagées) ou `CLIENT` (ressources métier contextualisées par tenant) |
| `targetTenant` | 0..1 | `string` | Tenant destinataire ; renseigné uniquement pour les lots `CLIENT` |
| `publicationViewId` | 0..1 | `string` | Identifiant de la vue de publication appliquée lors de la fabrication du lot |
| `sourceTransactionId` | 0..1 | `string` | Référence de la transaction métier interne qui a déclenché la production du lot |
| `sourceVersionNum` | 0..1 | `integer` | Version de l'objet métier au moment de la création du lot |
| `bundleType` | 1..1 | `code` | `transaction` (unité cohérente) ou `batch` (entrées indépendantes) |
| `status` | 1..1 | `code` | `PROCESSING`, `READY`, `FAILED` ou `EXPIRED` |
| `createdAt` | 0..1 | `dateTime` | Date et heure de création du lot |

### 5.2 `PublicationBatchItem` {#publicationbatchitem}

Un item ([`PublicationBatchItem`](StructureDefinition-PublicationBatchItem.html)) représente une ressource individuelle appartenant à un lot — un item par entrée du `Bundle` retourné par `$publication-bundle`.

| Champ | Cardinalité | Type | Description |
|-------|:-----------:|------|-------------|
| `publicationBatchId` | 1..1 | `string` | Lot de publication auquel appartient l'item |
| `resourceType` | 1..1 | `string` | Type de ressource FHIR (ex. `Organization`, `Location`, `CodeSystem`, `ValueSet`, `Practitioner`) |
| `logicalId` | 1..1 | `string` | Identifiant logique de la ressource FHIR — correspond au champ `id` dans le lot |
| `rootInstanceId` | 0..1 | `string` | Identifiant de l'instance racine dans le référentiel métier, lorsqu'il diffère de `logicalId` |
| `eventType` | 1..1 | `code` | Nature de la modification, bindée (required) sur [`http://hl7.org/fhir/ValueSet/audit-event-action`](http://hl7.org/fhir/ValueSet/audit-event-action) |
| `sortOrder` | 1..1 | `integer` | Ordre d'application dans le lot (entier positif, croissant) |

`eventType` est bindé sur le ValueSet FHIR standard `audit-event-action`, qui compte cinq codes (`C` Create, `R` Read, `U` Update, `D` Delete, `E` Execute). Dans le contexte de la publication MDM, seuls **`C`, `U` et `D`** ont un sens fonctionnel (création, mise à jour, suppression logique) ; `R` et `E` sont hérités du binding standard mais ne sont pas produits par le moteur de publication.

---

## 6. Traçabilité des publications {#tracabilite}

`PublicationBatchItem` (via `eventType`, `logicalId`, `rootInstanceId`, `sortOrder`) et `PublicationBatch` (via `sourceTransactionId`, `sourceVersionNum`) permettent ensemble de répondre, pour une ressource donnée d'un lot donné, aux questions suivantes :

- **quel type d'événement** a produit cet item (`eventType` : création, mise à jour, suppression) ;
- **dans quel lot** il a été publié, et **à quelle position** il doit être appliqué par rapport aux autres items du même lot (`sortOrder`) ;
- **à partir de quelle transaction métier interne** et **quelle version source** il a été généré (`sourceTransactionId`, `sourceVersionNum`, portés par le lot parent) ;
- **quel est son identifiant métier racine** lorsqu'il diffère de l'identifiant FHIR exposé (`rootInstanceId`).

Combinée à `$publication-list` (§4), cette traçabilité permet à un consommateur de détecter un lot manqué, de le récupérer, et de rejouer ses items dans le bon ordre sans dupliquer ni perdre une modification : c'est un mécanisme de **lignage de publication**, pensé pour la fiabilité de la réplication.

**Ce que ce mécanisme ne fournit pas :** il ne s'agit pas d'un audit de gouvernance au sens FHIR `Provenance`. Aucun champ ne capture *qui* a réalisé la modification (agent, utilisateur, système appelant), *pourquoi* elle a été faite (motif métier, activité), ni ne fournit de preuve d'intégrité de type signature. `PublicationBatchItem` répond à « quoi a changé, dans quel lot, dans quel ordre » — un besoin d'intégration technique — pas à « qui a changé quoi et pour quelle raison » — un besoin d'audit métier ou réglementaire. Si un tel audit est nécessaire en aval, il relève d'un mécanisme distinct (par exemple des ressources `Provenance` produites par les systèmes métier eux-mêmes), hors périmètre de cet IG.

---

## 7. Ressources de conformité liées

- [CapabilityStatement `mdm-publication-server`](CapabilityStatement-mdm-publication-server.html) — déclaration des 3 opérations, sécurité (Bearer token OAuth2 / SMART-on-FHIR), formats supportés
- [CodeSystem `publication-scope`](CodeSystem-publication-scope.html) / [ValueSet `publication-scope`](ValueSet-publication-scope.html)
- [CodeSystem `publication-batch-status`](CodeSystem-publication-batch-status.html) / [ValueSet `publication-batch-status`](ValueSet-publication-batch-status.html)
- [ValueSet `bundle-type-publication`](ValueSet-bundle-type-publication.html)
