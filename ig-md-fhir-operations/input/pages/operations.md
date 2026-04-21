# Opérations de publication

## 1. Périmètre

Cette spécification décrit les opérations FHIR exposées pour la consultation des publications produites par le MDM.

Elle couvre :

- `$publication-metadata`
- `$publication-bundle`

Elle ne couvre pas :

- la fabrication interne des lots ;
- les règles métier internes de versionnement ;
- les traitements hors interface FHIR.

---

## 2. Articulation avec NATS

Les opérations FHIR de cet IG constituent le point d'accès de consultation des lots publiés.

NATS est utilisé comme canal de notification de disponibilité à destination des consommateurs.
Le message NATS annonce qu'un lot publié est disponible. Le consommateur récupère ensuite ses métadonnées et son contenu via les opérations FHIR.

Pour le détail des scénarios de notification, voir : [Cas d'exemple NATS](nats-cases.html).

---

## 3. Modèle de publication

Le modèle est structuré en trois niveaux.

### 3.1 Transaction métier interne

La transaction métier interne regroupe les validations applicatives dans Master Data.
Elle peut impacter dans un même commit :

- une nomenclature ;
- une ou plusieurs ressources métier.

### 3.2 Lots de publication dérivés

La transaction interne n'est pas diffusée telle quelle.
Elle est transformée en lots de publication homogènes :

- lot `GLOBAL` pour les contenus globaux (ex. nomenclatures) ;
- lot(s) `CLIENT` pour les contenus contextualisés par tenant.

### 3.3 Notification broker

Le broker NATS transporte une notification de disponibilité de lot — et non la transaction métier brute.
La notification contient au minimum :

- `publicationBatchId`
- `scope`
- le type de contenu ou les types de ressources concernés
- le client cible si applicable

Le consommateur récupère ensuite le lot via les opérations FHIR.

---

## 4. Principe de découpage des publications

Une transaction métier interne peut impacter plusieurs objets simultanément.

Le principe retenu est le suivant :

- une transaction interne peut produire plusieurs lots de publication ;
- chaque lot publié doit rester homogène en termes de périmètre de diffusion ;
- les lots globaux et les lots client-spécifiques doivent être séparés ;
- un lot `GLOBAL` est identique pour tous les consommateurs concernés ;
- un lot `CLIENT` est calculé pour un client cible et peut contenir des identifiants locaux propres à ce client.

---

## 5. Opération `$publication-metadata`

### 5.1 Objectif

Cette opération permet de récupérer les métadonnées d'un lot publié.

Elle permet au consommateur de comprendre :

- la nature du lot ;
- son scope ;
- le type de bundle attendu ;
- les ressources concernées ;
- le client cible éventuel ;
- la version source ;
- le statut du lot.

### 5.2 Endpoint

```http
POST /fhir/$publication-metadata
Content-Type: application/fhir+json
```

### 5.3 Paramètres d'entrée

L'entrée est portée par une ressource `Parameters`.

| Paramètre | Cardinalité | Type | Description |
|-----------|------------|------|-------------|
| `publicationBatchId` | 1..1 | string | Identifiant technique du lot publié |

Exemple :

```json
{
  "resourceType": "Parameters",
  "parameter": [
    {
      "name": "publicationBatchId",
      "valueString": "PB-2026-000145"
    }
  ]
}
```

### 5.4 Paramètres de sortie

| Paramètre | Cardinalité | Type | Description |
|-----------|------------|------|-------------|
| `publicationBatchId` | 1..1 | string | Identifiant technique du lot |
| `scope` | 1..1 | code | `GLOBAL` ou `CLIENT` |
| `targetTenant` | 0..1 | string | Client destinataire si applicable |
| `bundleType` | 1..1 | code | `transaction` ou `batch` |
| `publicationViewCode` | 0..1 | string | Vue de publication utilisée |
| `sourceTransactionId` | 0..1 | string | Transaction métier source |
| `sourceVersionNum` | 0..1 | integer | Version source |
| `resourceType` | 0..* | string | Type(s) de ressource présents dans le lot |
| `status` | 1..1 | code | État du lot (`READY`, `PROCESSING`, `FAILED`) |
| `createdAt` | 1..1 | dateTime | Date de création du lot |

Exemple de réponse pour un lot `CLIENT` :

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

Exemple de réponse pour un lot `GLOBAL` :

```json
{
  "resourceType": "Parameters",
  "parameter": [
    { "name": "publicationBatchId", "valueString": "PB-GLOBAL-001" },
    { "name": "scope", "valueCode": "GLOBAL" },
    { "name": "bundleType", "valueCode": "batch" },
    { "name": "publicationViewCode", "valueString": "NOMENCLATURES_GLOBAL" },
    { "name": "sourceTransactionId", "valueString": "TX-2026-000654" },
    { "name": "sourceVersionNum", "valueInteger": 12 },
    { "name": "resourceType", "valueString": "CodeSystem" },
    { "name": "resourceType", "valueString": "ValueSet" },
    { "name": "status", "valueCode": "READY" },
    { "name": "createdAt", "valueDateTime": "2026-03-30T08:30:00Z" }
  ]
}
```

### 5.5 Règles de comportement

- `publicationBatchId` est obligatoire ;
- si le lot est inconnu, le serveur retourne un `OperationOutcome` avec `issue.code = not-found` ;
- si le lot est de scope `CLIENT`, le champ `targetTenant` est renseigné dans la réponse ;
- plusieurs occurrences de `resourceType` peuvent être retournées ;
- un lot `GLOBAL` ne doit pas annoncer de contenu client-spécifique.

---

## 6. Opération `$publication-bundle`

### 6.1 Objectif

Cette opération permet de récupérer le contenu publié sous forme de `Bundle` FHIR.

### 6.2 Endpoint

```http
POST /fhir/$publication-bundle
Content-Type: application/fhir+json
```

### 6.3 Paramètres d'entrée

| Paramètre | Cardinalité | Type | Description |
|-----------|------------|------|-------------|
| `publicationBatchId` | 1..1 | string | Identifiant technique du lot |
| `targetTenant` | 0..1 | string | Tenant cible (obligatoire pour lot `CLIENT` si non déterminé par le contexte de sécurité) |
| `publicationViewCode` | 0..1 | string | Vue de publication attendue (optionnelle) |

Exemple pour un lot `CLIENT` :

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

Exemple pour un lot `GLOBAL` :

```json
{
  "resourceType": "Parameters",
  "parameter": [
    { "name": "publicationBatchId", "valueString": "PB-GLOBAL-001" }
  ]
}
```

### 6.4 Réponse synchrone

Si le lot est disponible immédiatement et de volumétrie raisonnable, l'API retourne directement un `Bundle`.

Exemple pour un lot `CLIENT` :

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

Exemple pour un lot `GLOBAL` :

```json
{
  "resourceType": "Bundle",
  "type": "batch",
  "timestamp": "2026-03-30T08:30:02Z",
  "entry": [
    {
      "resource": {
        "resourceType": "CodeSystem",
        "id": "codes-postaux-fr",
        "url": "https://www.cpage.fr/fhir/CodeSystem/codes-postaux-fr",
        "version": "2026-03",
        "status": "active"
      },
      "request": { "method": "PUT", "url": "CodeSystem/codes-postaux-fr" }
    },
    {
      "resource": {
        "resourceType": "ValueSet",
        "id": "codes-postaux-fr-vs",
        "url": "https://www.cpage.fr/fhir/ValueSet/codes-postaux-fr-vs",
        "version": "2026-03",
        "status": "active"
      },
      "request": { "method": "PUT", "url": "ValueSet/codes-postaux-fr-vs" }
    }
  ]
}
```

### 6.5 Réponse asynchrone

Pour les lots volumineux ou les traitements différés, l'opération peut suivre le pattern FHIR asynchrone standard :

```http
POST /fhir/$publication-bundle
Prefer: respond-async
Content-Type: application/fhir+json
```

Réponse immédiate :

```http
HTTP/1.1 202 Accepted
Content-Location: /fhir/async-jobs/12345
```

Polling :

```http
GET /fhir/async-jobs/12345
```

- `202 Accepted` tant que le traitement est en cours ;
- `200 OK` avec le `Bundle` lorsque le lot est prêt ;
- `OperationOutcome` en cas d'erreur.

### 6.6 Règles de comportement

- `publicationBatchId` est obligatoire ;
- si le lot n'existe pas, le serveur retourne une erreur FHIR ;
- si le lot n'est pas prêt, le serveur retourne une erreur applicative documentée ;
- pour un lot `CLIENT`, le serveur doit vérifier la cohérence entre le lot demandé, le `targetTenant` fourni et le contexte de sécurité ;
- si `publicationViewCode` est transmis, il doit être cohérent avec le lot demandé ;
- le serveur ne doit jamais retourner un lot `CLIENT` pour un tenant différent de celui autorisé.

---

## 7. Type de Bundle retourné

### 7.1 `Bundle.type = transaction`

Le lot publié doit être interprété comme une unité cohérente.

- soit le bundle peut être rejoué tel quel contre un serveur FHIR ;
- soit il peut être traité localement comme un lot logique cohérent.

### 7.2 `Bundle.type = batch`

Les entrées peuvent être traitées indépendamment.

### 7.3 Règle de choix

Le type de bundle est déterminé par :

- la vue de publication ;
- la nature du contenu publié ;
- le besoin de cohérence du lot.

---

## 8. Gestion des périmètres et projections

### 8.1 Nomenclatures (lots GLOBAL)

- contenu identique pour tous les consommateurs concernés ;
- pas d'identifiant local client à injecter ;
- pas de contextualisation par client.

### 8.2 Ressources métier (lots CLIENT)

- contenu contextualisé par client ;
- identifiants locaux potentiellement différents selon le client ;
- filtrage selon les règles de visibilité de la vue de publication.

### 8.3 Transaction interne mixte

Si une transaction interne impacte à la fois une nomenclature et une ressource métier, il faut produire :

- un lot `GLOBAL` pour le contenu global ;
- un ou plusieurs lots `CLIENT` pour le contenu contextualisé.

---

## 9. Modèle logique de lot de publication

### 9.1 PublicationBatch

| Champ | Cardinalité | Type | Description |
|-------|------------|------|-------------|
| `publicationBatchId` | 1..1 | string | Identifiant unique du lot |
| `scope` | 1..1 | code | `GLOBAL` ou `CLIENT` |
| `targetTenant` | 0..1 | string | Identifiant du tenant cible pour les lots CLIENT |
| `publicationViewId` | 0..1 | string | Vue de publication appliquée lors de la fabrication du lot |
| `bundleType` | 1..1 | code | `transaction` ou `batch` |
| `resourceTypes` | 1..* | string | Types de ressources présents dans le lot |
| `sourceTransactionId` | 0..1 | string | Identifiant de la transaction métier source |
| `sourceVersionNum` | 0..1 | integer | Numéro de version de la transaction source |
| `status` | 1..1 | code | `READY`, `PROCESSING` ou `FAILED` |
| `createdAt` | 1..1 | dateTime | Date de création du lot |

---

## 10. Gestion des erreurs

En cas d'erreur, le serveur retourne une ressource FHIR `OperationOutcome`.

```json
{
  "resourceType": "OperationOutcome",
  "issue": [
    {
      "severity": "error",
      "code": "not-found",
      "details": { "text": "Lot de publication PB-2026-000999 inconnu." },
      "diagnostics": "publicationBatchId PB-2026-000999 not found"
    }
  ]
}
```

Codes d'erreur fonctionnels :

| Situation | HTTP | `issue.code` | Description |
|-----------|------|-------------|-------------|
| Lot inconnu | 404 | `not-found` | `publicationBatchId` ne correspond à aucun lot connu |
| Paramètres invalides | 400 | `required` / `value` | Paramètre obligatoire manquant ou valeur incohérente |
| Accès interdit | 403 | `forbidden` | Le jeton de l'appelant n'autorise pas l'accès à ce lot |
| Lot non prêt | 409 | `conflict` | Le lot existe mais son statut n'est pas READY |
| Incohérence tenant | 422 | `business-rule` | Le `targetTenant` transmis ne correspond pas au lot demandé |
| Incohérence vue | 422 | `business-rule` | Le `publicationViewCode` transmis ne correspond pas au lot demandé |
| Erreur interne | 500 | `exception` | Erreur inattendue côté serveur |