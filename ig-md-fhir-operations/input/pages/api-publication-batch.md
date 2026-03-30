# API FHIR de recuperation des lots publies

## 1. Objectif

Cette page decrit le contrat API pour recuperer :

- les metadonnees d'un lot publie ;
- le contenu d'un lot publie.

Le design cible est base sur des operations FHIR custom :

- `POST /fhir/$publication-metadata`
- `POST /fhir/$publication-bundle`

## 2. Principes de diffusion

- La transaction metier interne n'est pas exposee directement.
- La notification broker annonce la disponibilite d'un `PublicationBatch`.
- Le consommateur recupere ensuite les informations du lot via API FHIR.
- Si une transaction interne melange des contenus heterogenes, plusieurs lots homogenes sont produits (GLOBAL et CLIENT separes).

## 3. Operation `$publication-metadata`

### 3.1 Endpoint

- Methode : `POST`
- URL : `/fhir/$publication-metadata`
- Content-Type : `application/fhir+json`

### 3.2 Entree

Ressource FHIR `Parameters`.

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

### 3.3 Sortie

Ressource FHIR `Parameters`.

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
      "valueCode": "GLOBAL"
    },
    {
      "name": "bundleType",
      "valueCode": "transaction"
    },
    {
      "name": "resourceType",
      "valueString": "Organization"
    },
    {
      "name": "resourceType",
      "valueString": "CodeSystem"
    },
    {
      "name": "sourceVersionNum",
      "valueInteger": 54
    }
  ]
}
```

### 3.4 Regles de validation

- `publicationBatchId` obligatoire.
- Si batch inconnu : erreur FHIR `OperationOutcome`.
- Si lot `CLIENT` : `targetTenant` retourne si applicable.

## 4. Operation `$publication-bundle`

### 4.1 Endpoint

- Methode : `POST`
- URL : `/fhir/$publication-bundle`
- Content-Type : `application/fhir+json`

### 4.2 Entree

Ressource FHIR `Parameters` contenant :

- `publicationBatchId` obligatoire ;
- `targetTenant` optionnel ;
- `publicationViewCode` optionnel.

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

### 4.3 Sortie synchrone

Si lot disponible et volumetrie raisonnable : retour direct d'un `Bundle` FHIR.

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
        "name": "Clinique Exemple"
      },
      "request": {
        "method": "PUT",
        "url": "Organization/ORG-GHT21-4589"
      }
    }
  ]
}
```

### 4.4 Sortie asynchrone

Pour lot volumineux / traitement differe :

- requete avec `Prefer: respond-async` ;
- reponse `202 Accepted` ;
- en-tete `Content-Location` pour polling.

Exemple reponse initiale :

```http
HTTP/1.1 202 Accepted
Content-Location: /fhir/Task/publication-bundle-job-001
```

Puis polling :

- `GET /fhir/Task/publication-bundle-job-001`
- retour etat intermediaire puis resultat final.

## 5. Codes retour recommandes

### 5.1 `$publication-metadata`

- `200 OK` : metadonnees retournees.
- `400 Bad Request` : parametres invalides.
- `404 Not Found` : batch inexistant.
- `403 Forbidden` : acces interdit au batch.

### 5.2 `$publication-bundle`

- `200 OK` : bundle retourne en synchrone.
- `202 Accepted` : traitement asynchrone demarre.
- `400 Bad Request` : parametres invalides.
- `404 Not Found` : batch inexistant.
- `409 Conflict` : batch non pret.

## 6. Cas d'usage de diffusion

### 6.1 Cas A - Nomenclatures globales

Sujet NATS (exemple) :

`publication.global.codesystem.available`

Payload :

```json
{
  "messageId": "msg-001",
  "publicationBatchId": "PB-GLOBAL-001",
  "scope": "GLOBAL",
  "artifactType": "CodeSystem",
  "version": "2026-03"
}
```

Le consommateur recupere ensuite le lot via :

- `$publication-metadata` ;
- `$publication-bundle`.

### 6.2 Cas B - Ressources metier client

Sujet NATS (exemple) :

`publication.clientA.organization.available`

Payload :

```json
{
  "messageId": "msg-002",
  "publicationBatchId": "PB-CLIENTA-0456",
  "scope": "CLIENT",
  "targetTenant": "clientA",
  "resourceType": "Organization"
}
```

Le bundle retourne est tenant-aware.

## 7. Regle de decoupage lors d'une transaction mixte

Si la transaction interne melange nomenclature + ressource metier, il faut publier plusieurs batches homogenes :

- `PB-GLOBAL-001` pour `CodeSystem` ;
- `PB-CLIENTA-0456` pour `Organization` client A ;
- `PB-CLIENTB-0457` pour `Organization` client B.

## 8. Rattachement des artefacts IG

- OperationDefinition metadata : [OperationDefinition-publication-metadata.html](OperationDefinition-publication-metadata.html)
- OperationDefinition bundle : [OperationDefinition-publication-bundle.html](OperationDefinition-publication-bundle.html)
- CapabilityStatement serveur : [CapabilityStatement-mdm-publication-server.html](CapabilityStatement-mdm-publication-server.html)
- Cas NATS : [nats-cases.html](nats-cases.html)
