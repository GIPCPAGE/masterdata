# Operations de publication

## 1. Périmètre

Cette spécification décrit les opérations FHIR exposées pour la consultation des publications produites par le MDM.

Elle couvre :

- `$publication-metadata`
- `$publication-bundle`

Elle ne couvre pas :

- la fabrication interne des lots ;
- les règles metier internes de versionnement ;
- les traitements hors interface FHIR.

## 1.1 Articulation avec NATS

Les opérations FHIR de cette IG sont le point d’accès de consultation des lots publiés.

NATS est utilisé comme canal de notification de disponibilité à destination des consommateurs.
Le message NATS annonce qu’un lot publié est disponible. Le consommateur récupère ensuite ses métadonnées et son contenu via les opérations FHIR de cette IG.

Le détail des scénarios de notification et de récupération est documenté dans :

- [Cas d'exemple NATS](nats-cases.html)

## 2. Modèle cible de publication

Le modele est structuré en 3 niveaux.

### 2.1 Transaction métier interne

La transaction métier interne regroupe les validations applicatives dans Master Data.
Elle peut impacter dans un même commit :

- une nomenclature ;
- une ou plusieurs ressources métier.

### 2.2 Lots de publication dérivés

La transaction interne n'est pas diffusée telle quelle.
Elle est transformée en lots de publication homogènes :

- lot `GLOBAL` pour les contenus globaux (ex. nomenclatures) ;
- lot(s) `CLIENT` pour les contenus contextualisés par tenant.

### 2.3 Notification broker

Le broker NATS transporte une notification de disponibilite de lot, et non la transaction metier brute.
La notification contient au minimum :

- `publicationBatchId ;
- `scope` ;
- `type de contenu` ;
- le type de contenu ou les types de ressources concernés ;
- le client cible si applicable.

Le consommateur récupère ensuite le lot via les opérations FHIR.

## 3. Principe de découpage des publications

Une transaction métier interne peut impacter plusieurs objets en même temps.

Exemples :

- mise a jour d'une nomenclature ;
- mise a jour d'une ressource métier.

Dans ce cas, la diffusion ne doit pas nécessairement reprendre la transaction interne telle quelle.

Le principe retenu est le suivant :

- une transaction interne peut produire plusieurs lots de publication ;
- chaque lot publié doit rester homogène en termes de périmetre de diffusion ;
- les lots globaux et les lots client-spécifiques doivent etre séparés ;
- un lot `GLOBAL`est identique pour tous les consommateurs concernés ;
- un lot `CLIENT` est calculé pour un client cible et peut contenir des identifiants locaux propres à ce client.

## 4. Opérations FHIR exposées

Deux opérations sont exposées :

- [`$publication-metadata`](OperationDefinition-publication-metadata.html)
- [`$publication-bundle`](OperationDefinition-publication-bundle.html)

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

`POST /fhir/$publication-metadata`

### 5.3 Paramètres d'entrée

L'entrée est portée par une ressource `Parameters`.

Paramètre attendu :

- `publicationBatchId` : identifiant technique du lot publié.

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

La sortie est portée par une ressource `Parameters`.

Paramètres retournés :

- `publicationBatchId` : identifiant technique du lot ;
- `scope` : `GLOBAL` ou `CLIENT` ;
- `targetTenant` : client destinataire si applicable ;
- `bundleType` : `transaction` ou `batch` ;
- `publicationViewCode` : vue de publication utilisée ;
- `sourceTransactionId` : transaction métier source ;
- `sourceVersionNum` : version source ;
- `resourceType` : type de ressource présent dans le lot ;
- `status` : état du lot ;
- `createdAt` : date de création du lot.

Exemple pour un lot `CLIENT` :

```json
{
  "resourceType": "Parameters",
  "parameter": [
    {
      "name": "publicationBatchId",
      "valueString": "PB-2026-000145"
    },
    {
      "name": "scope",
      "valueCode": "CLIENT"
    },
    {
      "name": "targetTenant",
      "valueString": "ght21"
    },
    {
      "name": "bundleType",
      "valueCode": "transaction"
    },
    {
      "name": "publicationViewCode",
      "valueString": "ORG_GHT21"
    },
    {
      "name": "sourceTransactionId",
      "valueString": "TX-2026-000987"
    },
    {
      "name": "sourceVersionNum",
      "valueInteger": 54
    },
    {
      "name": "resourceType",
      "valueString": "Organization"
    },
    {
      "name": "resourceType",
      "valueString": "Location"
    },
    {
      "name": "status",
      "valueCode": "READY"
    },
    {
      "name": "createdAt",
      "valueDateTime": "2026-03-30T09:15:00Z"
    }
  ]
}
```

Exemple pour un lot `GLOBAL` : 
```json
{
  "resourceType": "Parameters",
  "parameter": [
    {
      "name": "publicationBatchId",
      "valueString": "PB-GLOBAL-001"
    },
    {
      "name": "scope",
      "valueCode": "GLOBAL"
    },
    {
      "name": "bundleType",
      "valueCode": "batch"
    },
    {
      "name": "publicationViewCode",
      "valueString": "NOMENCLATURES_GLOBAL"
    },
    {
      "name": "sourceTransactionId",
      "valueString": "TX-2026-000654"
    },
    {
      "name": "sourceVersionNum",
      "valueInteger": 12
    },
    {
      "name": "resourceType",
      "valueString": "CodeSystem"
    },
    {
      "name": "resourceType",
      "valueString": "ValueSet"
    },
    {
      "name": "status",
      "valueCode": "READY"
    },
    {
      "name": "createdAt",
      "valueDateTime": "2026-03-30T08:30:00Z"
    }
  ]
}
```

### 5.5 Règles de comportement

- `publicationBatchId` est obligatoire ;
- si le lot est inconnu, le serveur retourne une erreur FHIR ;
- si le lot est de scope `CLIENT`, `targetTenant` est renseigné dans la réponse ;
- plusieurs occurrences de `resourceType` peuvent être retournées ;
- un lot `GLOBAL` ne doit pas annoncer de contenu client-spécifique.

---

## 6. Opération `$publication-bundle`

### 6.1 Objectif

Cette opération permet de récupérer le contenu publié sous forme de `Bundle` FHIR.

### 6.2 Endpoint

`POST /fhir/$publication-bundle`

### 6.3 Paramètres d'entrée

L'entrée est portée par une ressource `Parameters`.

Paramètres attendus :

- `publicationBatchId` : identifiant technique du lot ;
- `targetTenant` : identifiant du tenant cible.
  - obligatoire pour un lot de scope `CLIENT` si le client n’est pas déjà déterminé par le contexte de sécurité ;
  - ignoré ou interdit pour un lot `GLOBAL` ;
- `publicationViewCode` : vue attendue, optionnelle si elle est deja déterminée par le lot.

Exemple pour un lot `CLIENT` :

```json
{
  "resourceType": "Parameters",
  "parameter": [
    {
      "name": "publicationBatchId",
      "valueString": "PB-2026-000145"
    },
    {
      "name": "targetTenant",
      "valueString": "ght21"
    },
    {
      "name": "publicationViewCode",
      "valueString": "ORG_GHT21"
    }
  ]
}
```

Exemple pour un lot `GLOBAL` :

```json
{
  "resourceType": "Parameters",
  "parameter": [
    {
      "name": "publicationBatchId",
      "valueString": "PB-GLOBAL-001"
    }
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
        "identifier": [
          {
            "system": "urn:ght21:tiers",
            "value": "4589"
          }
        ],
        "name": "Clinique Exemple"
      },
      "request": {
        "method": "PUT",
        "url": "Organization/ORG-GHT21-4589"
      }
    },
    {
      "resource": {
        "resourceType": "Location",
        "id": "LOC-GHT21-775",
        "name": "Site principal"
      },
      "request": {
        "method": "PUT",
        "url": "Location/LOC-GHT21-775"
      }
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
      "request": {
        "method": "PUT",
        "url": "CodeSystem/codes-postaux-fr"
      }
    },
    {
      "resource": {
        "resourceType": "ValueSet",
        "id": "codes-postaux-fr-vs",
        "url": "https://www.cpage.fr/fhir/ValueSet/codes-postaux-fr-vs",
        "version": "2026-03",
        "status": "active"
      },
      "request": {
        "method": "PUT",
        "url": "ValueSet/codes-postaux-fr-vs"
      }
    }
  ]
}
```



### 6.5 Réponse asynchrone

Pour les lots volumineux ou les traitements différés, l'opération peut suivre le pattern FHIR asynchrone standard :

- requête `POST /fhir/$publication-bundle` ;
- en-tête `Prefer: respond-async` ;
- réponse `202 Accepted` avec `Content-Location` ;
- polling de l'URL de suivi jusqu'au résultat final.

Lorsque le mode asynchrone est utilisé :
- le serveur retourne `202 Accepted` et un `Content-Location` ;
- le client effectue des `GET` sur cette URL ;
- tant que le traitement est en cours, le serveur peut retourner `202 Accepted` ;
- lorsque le lot est prêt, le serveur retourne `200 OK` avec `Bundle` FHIR demandé ;
- en cas d’échec, le serveur retourne un `OperationOutcome`.

### 6.6 Regles de comportement

- `publicationBatchId` est obligatoire ;
- si le lot n'existe pas, le serveur retourne une erreur FHIR ;
- si le lot n'est pas pret, le serveur retourne une erreur applicative documentee ;
- pour un lot `CLIENT`, le serveur doit vérifier la cohérence entre le lot demandé, le `targetTenant` fourni le cas échéant, et le contexte de sécurité;
- si `publicationViewCode` est transmis, il doit etre coherent avec le lot demandé ;
- le serveur ne doit jamais retourner un lot `CLIENT` pour un tenant différent de celui autorisé.

---

## 7. Type de bundle retourné

### 7.1 `Bundle.type = transaction`

Un `Bundle.type = transaction` signifie que le lot publié doit etre interprété comme une unité cohérente de publication.

Selon l’architecture du consommateur :

- soit le bundle peut etre rejoué tel quel contre un serveur FHIR ;
- soit il peut être traité localement comme un lot logique cohérent, sans nécessairement être soumis comme transaction HTTP FHIR.

### 7.2 `Bundle.type = batch`

Un `Bundle.type = batch` signifie que les entrées peuvent être traitées indépendamment.

### 7.3 Règle de choix

Le type de bundle est determine par :

- la vue de publication ;
- la nature du conteun publié ;
- le besoin de cohérence du lot.

## 8. Gestion des périmètres et projections

### 8.1 Cas nomenclatures

Les nomenclatures sont generalement publiees sous forme de lots `GLOBAL`.

Caractéristiques :

- contenu identique pour tous les consommateurs concernés ;
- pas d’identifiant local client à injecter ;
- pas de contextualisation par client.

### 8.2 Cas ressources metier

Les ressources métier sont généralement publiées sous forme de lots `CLIENT`.

Caractéristiques :

- contenu contextualisé par client ;
- identifiants locaux potentiellement differents selon le client ;
- filtrage selon les règles de visibilité de la vue de publication.

### 8.3 Transaction interne mixte

Une transaction métier interne peut impacter a la fois :

- une nomenclature ;
- une ressource métier.

Dans ce cas, il ne faut pas produire un lot unique mixte si les périmètres de diffusion sont différents.

Il faut produire :

- un lot GLOBAL pour le contenu global ;
- un ou plusieurs lots CLIENT pour le contenu contextualisé.

## 9. Modèle logique de lot de publication

### 9.1 PublicationBatch

Représente un lot de publication : unité de diffusion homogène produite a partir d'une ou plusieurs transactions métier internes.

| Champ | Cardinalite | Type | Description |
|---|---|---|---|
| publicationBatchId | 1..1 | string | Identifiant unique du lot, utilise dans tous les appels FHIR. |
| scope | 1..1 | code | `GLOBAL` ou `CLIENT` (voir [ValueSet publication-scope](ValueSet-publication-scope.html)). |
| targetTenant | 0..1 | string | Identifiant du tenant cible pour les lots CLIENT. |
| publicationViewId | 0..1 | string | Vue de publication appliquee lors de la fabrication du lot. |
| sourceTransactionId | 0..1 | string | Identifiant de la transaction metier interne source. |
| sourceVersionNum | 0..1 | integer | Version de l'objet metier au moment de la creation du lot. |
| bundleType | 1..1 | code | `transaction` ou `batch` (voir [ValueSet bundle-type-publication](ValueSet-bundle-type-publication.html)). |
| status | 1..1 | code | `READY`, `PROCESSING`, `FAILED`, `EXPIRED` (voir [ValueSet publication-batch-status](ValueSet-publication-batch-status.html)). |
| createdAt | 0..1 | dateTime | Date et heure de creation du lot. |

### 9.2 PublicationBatchItem

Représente une ressource individuelle appartenant a un lot. Correspond a une entrée (`entry`) du Bundle retourne par `$publication-bundle`.

| Champ | Cardinalite | Type | Description |
|---|---|---|---|
| publicationBatchId | 1..1 | string | Cle de rattachement au lot. |
| resourceType | 1..1 | string | Type FHIR de la ressource (ex. Organization, CodeSystem). |
| logicalId | 1..1 | string | Identifiant logique de la ressource FHIR. |
| rootInstanceId | 0..1 | string | Identifiant dans le referentiel metier source (peut differ de logicalId). |
| eventType | 1..1 | code | Nature de la modification : C (Creation), U (Mise a jour), D (Suppression logique). |
| sortOrder | 1..1 | integer | Ordre d'application dans le lot pour les bundles de type transaction. |

## 10. CapabilityStatement serveur

La declaration de capacites du serveur est publiee dans l'artefact :

- [CapabilityStatement serveur](CapabilityStatement-mdm-publication-server.html)

Ce CapabilityStatement serveur doit exposer :

- l’operation systeme `$publication-metadata` ;
- l’operation systeme `$publication-bundle` ;
- les usages synchrones et asynchrones documentés pour `$publication-bundle`.
