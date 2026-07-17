# Opérations de publication

Cette page est la référence technique des trois opérations FHIR système du serveur de publication MDM. Pour l'architecture d'ensemble, voir [Accueil](index.html) ; pour le contrat vu côté consommateur (typologie de lot, synchrone/asynchrone, erreurs), voir [API FHIR de récupération des lots publiés](api-publication-batch.html).

## Ce que les trois opérations ont en commun

`$publication-metadata`, `$publication-bundle` et `$publication-list` sont toutes déclarées comme opérations **système** (`kind = #operation`, `system = true`, `type = false`, `instance = false`) : elles s'invoquent sur la racine du serveur, jamais sur un type de ressource ni sur une instance —

```http
POST /fhir/$publication-metadata
POST /fhir/$publication-bundle
POST /fhir/$publication-list
Content-Type: application/fhir+json
```

— et aucune des trois ne modifie l'état du serveur (`affectsState = false`) : ce sont des lectures, pas des écritures.

---

## `$publication-metadata` {#op-publication-metadata}

**Objectif.** Étant donné un identifiant de lot, retourner ses métadonnées sans en récupérer le contenu. Un consommateur l'utilise pour décider s'il vaut la peine d'appeler `$publication-bundle` : le lot est-il prêt, quel est son périmètre, quelles ressources contient-il.

### Paramètres d'entrée

| Nom | Cardinalité | Type | Rôle |
|-----|:-----------:|------|------|
| `publicationBatchId` | 1..1 | `string` | Identifiant technique du lot publié à interroger |

### Paramètres de sortie

| Nom | Cardinalité | Type | Rôle |
|-----|:-----------:|------|------|
| `publicationBatchId` | 1..1 | `string` | Identifiant technique du lot (renvoyé en écho) |
| `scope` | 1..1 | `code` | `GLOBAL` ou `CLIENT` — required binding sur [ValueSet publication-scope](ValueSet-publication-scope.html) |
| `targetTenant` | 0..1 | `string` | Tenant cible ; présent uniquement si `scope = CLIENT` |
| `bundleType` | 1..1 | `code` | `transaction` ou `batch` — required binding sur [ValueSet bundle-type-publication](ValueSet-bundle-type-publication.html) |
| `publicationViewCode` | 0..1 | `string` | Code de la vue de publication utilisée pour fabriquer le lot |
| `sourceTransactionId` | 0..1 | `string` | Référence de la transaction métier interne qui a déclenché la production du lot |
| `sourceVersionNum` | 0..1 | `integer` | Version de l'objet source au moment de la fabrication du lot |
| `resourceType` | 0..* | `string` | Un type de ressource FHIR présent dans le lot ; un paramètre répété par type distinct |
| `status` | 1..1 | `code` | `READY` / `PROCESSING` / `FAILED` / `EXPIRED` — required binding sur [ValueSet publication-batch-status](ValueSet-publication-batch-status.html) |
| `createdAt` | 0..1 | `dateTime` | Date et heure de création du lot |

> `publicationViewCode` (paramètre exposé) et `publicationViewId` (champ du modèle logique `PublicationBatch`, voir [§ Modèle logique](#modele-logique)) désignent la même notion. La différence de nom entre les deux est volontaire : l'un appartient au vocabulaire public de l'opération, l'autre au modèle de transport interne.

### Exemple

Requête :

```json
{
  "resourceType": "Parameters",
  "parameter": [
    { "name": "publicationBatchId", "valueString": "PB-2026-000145" }
  ]
}
```

Réponse — lot `CLIENT`, `READY` :

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

### Comportement attendu

- `publicationBatchId` absent → erreur `400`.
- Identifiant inconnu → `OperationOutcome` `404` (`issue.code = not-found`, voir [table des erreurs](api-publication-batch.html#gestion-des-erreurs)).
- `targetTenant` n'apparaît en sortie que pour un lot `CLIENT` ; pour un lot `GLOBAL`, il est absent.
- `resourceType` apparaît autant de fois qu'il y a de types de ressources distincts dans le lot — c'est un résumé, pas la liste des ressources elles-mêmes (celle-ci n'arrive qu'avec `$publication-bundle`).
- `status = EXPIRED` est un cas normal : un lot déjà `READY` peut être retiré de la consultation par politique de rétention sans que son identifiant soit réattribué.

---

## `$publication-bundle` {#op-publication-bundle}

**Objectif.** Retourner le contenu réel d'un lot, sous forme de `Bundle` FHIR — c'est la seule des trois opérations qui livre de la donnée métier.

### Paramètres d'entrée

| Nom | Cardinalité | Type | Rôle |
|-----|:-----------:|------|------|
| `publicationBatchId` | 1..1 | `string` | Identifiant technique du lot publié à récupérer |
| `targetTenant` | 0..1 | `string` | Tenant attendu — sert de **contrôle de cohérence**, pas de filtre |
| `publicationViewCode` | 0..1 | `string` | Vue de publication attendue — même rôle de contrôle de cohérence |

`targetTenant` et `publicationViewCode` ne sélectionnent aucun contenu : le lot est déjà entièrement déterminé par `publicationBatchId`. Leur seul rôle est de permettre au serveur de vérifier que l'appelant demande bien le lot qu'il croit demander, et de rejeter la requête sinon (voir [§ Comportement](#op-publication-bundle-comportement)).

### Paramètre de sortie

| Nom | Cardinalité | Type | Rôle |
|-----|:-----------:|------|------|
| `return` | 1..1 | `Bundle` | Le contenu publié, sous forme de `Bundle` `transaction` ou `batch` |

### Exemple

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

Réponse — `Bundle` de type `transaction` contenant deux ressources liées :

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

L'ordre des entrées du `Bundle` reflète le `sortOrder` des items du lot (voir [`PublicationBatchItem`](#publicationbatchitem)) : pour un `Bundle` `transaction`, le consommateur doit les appliquer dans cet ordre exact, pas dans un ordre de son choix.

### Comportement attendu {#op-publication-bundle-comportement}

- `publicationBatchId` est obligatoire.
- La réponse peut être synchrone ou différée via `Prefer: respond-async` — détaillé dans [API FHIR de récupération des lots publiés](api-publication-batch.html#synchrone-asynchrone).
- Si `targetTenant` ou `publicationViewCode` sont fournis et ne correspondent pas au lot réellement identifié par `publicationBatchId`, le serveur renvoie une erreur d'incohérence plutôt que de retourner silencieusement un contenu différent de celui attendu.
- Le serveur ne doit jamais laisser un appelant récupérer le contenu d'un lot `CLIENT` destiné à un autre tenant que celui autorisé par son contexte de sécurité — cette règle prime sur les paramètres d'entrée eux-mêmes.

---

## `$publication-list` {#op-publication-list}

**Objectif.** Là où les deux opérations précédentes portent sur *un* lot connu, `$publication-list` répond à une question différente : « qu'est-ce qui a été publié entre deux bornes ? ». C'est le mécanisme de **rattrapage (gap detection)** de cet IG — celui qui permet à un consommateur de vérifier qu'il n'a manqué aucune notification, sans dépendre du broker NATS pour le savoir.

### Paramètres d'entrée

| Nom | Cardinalité | Type | Rôle |
|-----|:-----------:|------|------|
| `fromExclusiveBatchId` | 1..1 | `string` | Borne basse **exclusive** (format `PB-{id}`) : seuls les lots strictement postérieurs sont retournés |
| `toInclusiveBatchId` | 0..1 | `string` | Borne haute **inclusive** (format `PB-{id}`) ; absente, l'intervalle reste ouvert vers le haut |

### Paramètre de sortie

| Nom | Cardinalité | Type | Rôle |
|-----|:-----------:|------|------|
| `batchId` | 0..* | `string` | Un identifiant de lot par occurrence, trié par ordre croissant ; répété une fois par lot trouvé dans l'intervalle |

### Exemple — un trou entre deux lots connus

Un consommateur sait avoir traité `PB-2026-000140` et veut savoir ce qui a été publié jusqu'à `PB-2026-000145` inclus :

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

`PB-2026-000143` et `PB-2026-000144` n'apparaissent pas : soit ils n'ont jamais existé, soit ils sont passés en `FAILED` ou `EXPIRED` depuis. La liste retournée fait foi — un consommateur ne doit pas déduire ce qu'il lui manque par simple arithmétique sur les identifiants, mais se fier à la liste explicite reçue. Il enchaîne ensuite `$publication-metadata` puis `$publication-bundle` pour chaque `batchId`, dans l'ordre reçu.

Sans borne haute, l'appel devient un rattrapage ouvert (« tout ce qui est paru depuis `PB-2026-000140` ») :

```json
{
  "resourceType": "Parameters",
  "parameter": [
    { "name": "fromExclusiveBatchId", "valueString": "PB-2026-000140" }
  ]
}
```

Si l'intervalle ne contient aucun lot, la réponse est une ressource `Parameters` sans occurrence de `batchId`.

### Comportement attendu

- `fromExclusiveBatchId` absent → erreur `400`.
- `toInclusiveBatchId` est optionnel ; son absence signifie « jusqu'à maintenant ».
- Les résultats sont triés par identifiant de lot croissant.
- Aucun filtrage par scope ou par tenant n'est appliqué à ce stade : `$publication-list` retourne tous les lots publiés dans l'intervalle, quel que soit leur destinataire. Le contrôle d'accès s'exerce ensuite, lot par lot, lors des appels ultérieurs à `$publication-metadata` / `$publication-bundle`.
- Comme les deux autres opérations, elle ne modifie aucune donnée (`affectsState = false`).

---

## Modèle logique sous-jacent {#modele-logique}

Les paramètres ci-dessus ne sortent pas de nulle part : ils proviennent de deux modèles logiques qui documentent la structure interne d'un lot. Ce ne sont pas des ressources FHIR consultables — seulement le vocabulaire de référence pour les champs manipulés par les opérations.

### `PublicationBatch`

Unité de diffusion homogène produite à partir d'une ou plusieurs transactions métier internes ; devient consultable dès qu'elle passe au statut `READY`.

| Champ | Cardinalité | Type | Rôle |
|-------|:-----------:|------|------|
| `publicationBatchId` | 1..1 | `string` | Identifiant technique unique, généré par la plateforme MDM |
| `scope` | 1..1 | `code` | `GLOBAL` ou `CLIENT` |
| `targetTenant` | 0..1 | `string` | Tenant destinataire, renseigné uniquement pour un lot `CLIENT` |
| `publicationViewId` | 0..1 | `string` | Vue de publication appliquée lors de la fabrication du lot |
| `sourceTransactionId` | 0..1 | `string` | Transaction métier interne à l'origine du lot |
| `sourceVersionNum` | 0..1 | `integer` | Version de l'objet métier au moment de la création du lot |
| `bundleType` | 1..1 | `code` | `transaction` (unité cohérente) ou `batch` (entrées indépendantes) |
| `status` | 1..1 | `code` | `PROCESSING` / `READY` / `FAILED` / `EXPIRED` |
| `createdAt` | 0..1 | `dateTime` | Date et heure de création |

### `PublicationBatchItem` {#publicationbatchitem}

Une ressource individuelle appartenant à un lot — un item par entrée du `Bundle` que `$publication-bundle` finit par renvoyer.

| Champ | Cardinalité | Type | Rôle |
|-------|:-----------:|------|------|
| `publicationBatchId` | 1..1 | `string` | Lot de publication auquel l'item appartient |
| `resourceType` | 1..1 | `string` | Type de ressource FHIR (ex. `Organization`, `Location`, `CodeSystem`, `ValueSet`, `Practitioner`) |
| `logicalId` | 1..1 | `string` | Identifiant logique de la ressource — correspond au champ `id` dans le lot |
| `rootInstanceId` | 0..1 | `string` | Identifiant de l'instance racine côté référentiel métier, quand il diffère du `logicalId` FHIR |
| `eventType` | 1..1 | `code` | Nature de la modification — required binding sur [`audit-event-action`](http://hl7.org/fhir/ValueSet/audit-event-action) |
| `sortOrder` | 1..1 | `integer` | Position d'application dans le lot, entier positif croissant |

Le ValueSet `audit-event-action` compte cinq codes (`C` Create, `R` Read, `U` Update, `D` Delete, `E` Execute) : c'est un binding standard FHIR, pas un vocabulaire propre à cet IG. Dans le contexte de la publication MDM, seuls `C`, `U` et `D` ont un sens — un item publié correspond toujours à une création, une mise à jour ou une suppression logique. `R` et `E` restent autorisés par le binding mais ne sont jamais produits par le moteur de publication.

---

## Traçabilité des publications {#tracabilite}

Mis côte à côte, `PublicationBatchItem` (`eventType`, `logicalId`, `rootInstanceId`, `sortOrder`) et son lot parent `PublicationBatch` (`sourceTransactionId`, `sourceVersionNum`) permettent de répondre, pour une ressource publiée donnée, à quatre questions :

- **quel événement** l'a produite (création, mise à jour, suppression) ;
- **dans quel lot**, et **à quelle position relative** elle doit être appliquée par rapport aux autres items du même lot ;
- **depuis quelle transaction métier interne**, et **quelle version source**, elle a été générée ;
- **quel est son identifiant métier racine**, quand celui-ci n'est pas l'identifiant FHIR exposé.

C'est suffisant pour qu'un consommateur, combiné à `$publication-list`, détecte un lot manqué, le récupère, et rejoue ses items dans le bon ordre sans dupliquer ni perdre une modification. C'est un mécanisme de **lignage de publication**, taillé pour la fiabilité d'une réplication technique — pas un audit.

**Ce qui n'est délibérément pas fourni.** Rien dans `PublicationBatchItem` ni `PublicationBatch` n'indique *qui* a réalisé la modification (utilisateur, agent, système appelant), ni *pour quel motif métier*, ni ne fournit une preuve d'intégrité de type signature. Cette absence n'est pas une omission mais un choix de périmètre : cet IG répond à « quoi a changé, dans quel lot, dans quel ordre » — une question d'intégration technique — et non à « qui a changé quoi et pourquoi » — une question d'audit réglementaire ou de gouvernance, qui relèverait d'un mécanisme distinct (par exemple des ressources `Provenance` produites en amont par les systèmes métier eux-mêmes), hors périmètre de cet IG.

---

## Ressources de conformité liées

- [CapabilityStatement `mdm-publication-server`](CapabilityStatement-mdm-publication-server.html) — déclaration des trois opérations, sécurité, formats
- [CodeSystem `publication-scope`](CodeSystem-publication-scope.html) / [ValueSet `publication-scope`](ValueSet-publication-scope.html)
- [CodeSystem `publication-batch-status`](CodeSystem-publication-batch-status.html) / [ValueSet `publication-batch-status`](ValueSet-publication-batch-status.html)
- [ValueSet `bundle-type-publication`](ValueSet-bundle-type-publication.html)
