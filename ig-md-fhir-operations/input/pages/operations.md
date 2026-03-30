# Operations de publication

## 1. Perimetre

Cette specification decrit les operations FHIR exposees pour la consultation des publications produites par le MDM.

Elle couvre :

- `$publication-metadata`
- `$publication-bundle`

Elle ne couvre pas :

- la fabrication interne des lots ;
- les regles metier internes de versionnement ;
- les traitements hors interface FHIR.

## 1.1 Articulation avec NATS

Les operations FHIR de cette IG sont le point d'acces de consultation des lots publies.
La production de ces lots est alimentee en amont par des evenements NATS.

Le detail des cas de transformation evenement -> lot(s) -> operations FHIR est documente dans :

- [Cas d'exemple NATS](nats-cases.html)

## 2. Modele cible de publication

Le modele est structure en 3 niveaux.

### 2.1 Transaction metier interne

La transaction metier interne regroupe les validations applicatives dans Master Data.
Elle peut impacter dans un meme commit :

- une nomenclature ;
- une ou plusieurs ressources metier.

### 2.2 Lots de publication derives

La transaction interne n'est pas diffusee telle quelle.
Elle est transformee en lots de publication homogenes :

- lot GLOBAL pour les contenus globaux (ex. nomenclatures) ;
- lot(s) CLIENT pour les contenus contextualises par tenant.

### 2.3 Notification broker

Le broker NATS transporte une notification de disponibilite de lot, et non la transaction metier brute.
La notification contient au minimum :

- publicationBatchId ;
- scope ;
- type de contenu.

Le consommateur recupere ensuite le lot via les operations FHIR.

## 3. Principe de decoupage des publications

Une transaction metier interne peut impacter plusieurs objets en meme temps.

Exemples :

- mise a jour d'une nomenclature ;
- mise a jour d'une ressource metier.

Dans ce cas, la diffusion ne doit pas necessairement reprendre la transaction interne telle quelle.

Le principe retenu est le suivant :

- une transaction interne peut produire plusieurs lots de publication ;
- chaque lot publie doit rester homogene en termes de perimetre de diffusion ;
- les lots globaux et les lots client-specifiques doivent etre separes.

## 4. Operations FHIR exposees

Deux operations sont exposees :

- [`$publication-metadata`](OperationDefinition-publication-metadata.html)
- [`$publication-bundle`](OperationDefinition-publication-bundle.html)

---

## 5. Operation `$publication-metadata`

### 5.1 Objectif

Cette operation permet de recuperer les metadonnees d'un lot publie.

Elle permet au consommateur de comprendre :

- la nature du lot ;
- son scope ;
- le type de bundle attendu ;
- les ressources concernees ;
- le client cible eventuel ;
- la version source ;
- le statut du lot.

### 5.2 Endpoint

`POST /fhir/$publication-metadata`

### 5.3 Parametres d'entree

L'entree est portee par une ressource `Parameters`.

Parametre attendu :

- `publicationBatchId` : identifiant technique du lot publie.

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

### 5.4 Parametres de sortie

La sortie est portee par une ressource `Parameters`.

Parametres retournes :

- `publicationBatchId` : identifiant technique du lot ;
- `scope` : `GLOBAL` ou `CLIENT` ;
- `targetTenant` : client destinataire si applicable ;
- `bundleType` : `transaction` ou `batch` ;
- `publicationViewCode` : vue de publication utilisee ;
- `sourceTransactionId` : transaction metier source ;
- `sourceVersionNum` : version source ;
- `resourceType` : type de ressource present dans le lot ;
- `status` : etat du lot ;
- `createdAt` : date de creation du lot.

Exemple :

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

### 5.5 Regles de comportement

- `publicationBatchId` est obligatoire ;
- si le lot est inconnu, le serveur retourne une erreur FHIR ;
- si le lot est de scope `CLIENT`, `targetTenant` est renseigne ;
- plusieurs occurrences de `resourceType` peuvent etre retournees.

---

## 6. Operation `$publication-bundle`

### 6.1 Objectif

Cette operation permet de recuperer le contenu publie sous forme de `Bundle` FHIR.

### 6.2 Endpoint

`POST /fhir/$publication-bundle`

### 6.3 Parametres d'entree

L'entree est portee par une ressource `Parameters`.

Parametres attendus :

- `publicationBatchId` : identifiant technique du lot ;
- `targetTenant` : client attendu, optionnel ;
- `publicationViewCode` : vue attendue, optionnelle.

Exemple :

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

### 6.4 Reponse synchrone

Si le lot est disponible immediatement et de volumetrie raisonnable, l'API retourne directement un `Bundle`.

Exemple :

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

### 6.5 Reponse asynchrone

Pour les lots volumineux ou les traitements differes, l'operation peut suivre le pattern FHIR asynchrone standard :

- requete `POST /fhir/$publication-bundle` ;
- en-tete `Prefer: respond-async` ;
- reponse `202 Accepted` avec `Content-Location` ;
- polling de l'URL de suivi jusqu'au resultat final.

### 6.6 Regles de comportement

- `publicationBatchId` est obligatoire ;
- si le lot n'existe pas, le serveur retourne une erreur FHIR ;
- si le lot n'est pas pret, le serveur retourne une erreur applicative documentee ;
- si `targetTenant` est transmis, il doit etre coherent avec le lot demande ;
- si `publicationViewCode` est transmis, il doit etre coherent avec le lot demande.

---

## 7. Type de bundle retourne

### 7.1 `Bundle.type = transaction`

A utiliser lorsque le lot doit etre applique comme une unite coherente.

Cas typiques :

- plusieurs ressources liees ;
- besoin de coherence de traitement ;
- logique de mise a jour atomique cote consommateur.

### 7.2 `Bundle.type = batch`

A utiliser lorsque les entrees peuvent etre traitees independamment.

Cas typiques :

- chargements moins couples ;
- traitement unitaire par ressource ;
- plus grande souplesse cote consommateur.

### 7.3 Regle de choix

Le type de bundle est determine par :

- la vue de publication ;
- le besoin de coherence du lot expose.

Le consommateur doit s'appuyer :

- soit sur les metadonnees retournees par `$publication-metadata` ;
- soit sur la valeur reelle de `Bundle.type` retournee par `$publication-bundle`.

## 8. Gestion des perimetres et projections

### 8.1 Cas nomenclatures

Les nomenclatures partagables sont diffusees dans des lots `GLOBAL`.
La notification NATS expose un batch global disponible.

### 8.2 Cas ressources metier

Les ressources metier contextualisees sont diffusees dans des lots `CLIENT`.
Le lot est tenant-aware et peut etre filtre par `targetTenant` et `publicationViewCode`.

### 8.3 Transaction interne mixte

Si la transaction interne melange nomenclature et ressources metier, la diffusion doit produire plusieurs batches homogenes, par exemple :

- `PB-GLOBAL-001` pour `CodeSystem` ;
- `PB-CLIENTA-0456` pour `Organization` client A ;
- `PB-CLIENTB-0457` pour `Organization` client B.

## 9. Modele logique de lot de publication

La Zone E de publication peut s'appuyer sur les entites logiques suivantes.

### 9.1 PublicationBatch

- publicationBatchId ;
- scope (`GLOBAL` ou `CLIENT`) ;
- targetTenant (nullable) ;
- publicationViewId ;
- sourceTransactionId ;
- bundleType ;
- status ;
- createdAt.

### 9.2 PublicationBatchItem

- publicationBatchId ;
- resourceType ;
- logicalId ;
- rootInstanceId ;
- eventType ;
- sortOrder.

## 10. CapabilityStatement serveur

La declaration de capacites du serveur est publiee dans l'artefact :

- [CapabilityStatement serveur](CapabilityStatement-mdm-publication-server.html)

Ce CapabilityStatement reference explicitement les deux operations systeme exposees :

- `$publication-metadata`
- `$publication-bundle`
