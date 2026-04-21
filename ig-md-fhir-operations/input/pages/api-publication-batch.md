# API FHIR de récupération des lots publiés

## Objectif

Cette page décrit le contrat d'API FHIR permettant aux systèmes consommateurs de récupérer les lots publiés par le Master Data, après réception d'une notification de disponibilité sur NATS.

Les objectifs sont de :

- notifier de manière asynchrone qu'un lot est disponible ;
- permettre au consommateur de récupérer les métadonnées du lot ;
- permettre au consommateur de récupérer le contenu publiable sous forme de `Bundle` FHIR ;
- gérer à la fois les publications globales et les publications contextualisées par client ;
- rester cohérent avec le modèle de publication exposé dans cet IG.

---

## 1. Principe général

Le broker ne transporte pas directement le contenu complet des données publiées.
Il transporte une notification de disponibilité d'un lot de publication.

Le consommateur suit ensuite le cycle suivant :

1. il reçoit une notification sur NATS ;
2. il récupère les métadonnées du lot via `$publication-metadata` ;
3. il récupère le contenu du lot via `$publication-bundle` ;
4. il applique localement les créations, mises à jour, suppressions ou fusions concernées.

---

## 2. Pourquoi une API FHIR dédiée

Le standard FHIR permet :

- de soumettre un `Bundle` de type `transaction` ou `batch` ;
- d'exposer des opérations personnalisées via le mécanisme `$operation` ;
- d'exécuter certaines opérations en mode asynchrone.

En revanche, FHIR ne définit pas nativement une API du type "récupère-moi le lot publié numéro X".
Il est donc nécessaire d'exposer des opérations FHIR custom au niveau système.

---

## 3. Positionnement dans l'architecture

```
┌───────────────────────────────────────────────────────┐
│   Master Data                                         │
│   Transaction métier validée                          │
│         │                                             │
│         ▼                                             │
│   Moteur de publication                               │
│   Lot(s) produit(s)                                   │
│         │                                             │
│         ├──► Notification NATS (disponibilité)        │
│         │                                             │
│         └──► API FHIR (récupération)                  │
└───────────────────────────────────────────────────────┘
          │
          ▼
┌───────────────────────────────────────────────────────┐
│   Consommateur                                        │
│   1. Reçoit notification NATS                         │
│   2. Appelle $publication-metadata                    │
│   3. Appelle $publication-bundle                      │
│   4. Applique le lot localement                       │
└───────────────────────────────────────────────────────┘
```

---

## 4. Typologie des lots publiés

### 4.1 Lot global

Un lot global correspond à un contenu identique pour tous les destinataires.

Cas typiques :

- nomenclatures (`CodeSystem`, `ValueSet`) ;
- jeux de référence partagés.

Caractéristiques :

- pas de contexte client spécifique ;
- pas d'identifiant local client à injecter ;
- même contenu pour tous les consommateurs.

### 4.2 Lot contextualisé par client

Un lot contextualisé correspond à un contenu dépendant du client destinataire.

Cas typiques :

- `Organization`, `Practitioner`, `Location` ;
- ressources métier publiées avec des identifiants ou une visibilité spécifiques.

Caractéristiques :

- un client cible explicite (`targetTenant`) ;
- des identifiants locaux spécifiques au client ;
- un contenu potentiellement différent selon le destinataire.

---

## 5. Principe de découpage des publications

Une transaction métier interne peut impacter plusieurs objets en même temps.

Le principe retenu :

- une transaction interne peut produire plusieurs lots de publication ;
- chaque lot publié doit rester homogène en termes de périmètre de diffusion ;
- les lots globaux et les lots client-spécifiques doivent être séparés ;
- un lot `GLOBAL` est identique pour tous les consommateurs ;
- un lot `CLIENT` est calculé pour un client cible.

---

## 6. Opérations FHIR exposées

Deux opérations sont exposées :

- [`$publication-metadata`](OperationDefinition-publication-metadata.html) — récupère les métadonnées d'un lot
- [`$publication-bundle`](OperationDefinition-publication-bundle.html) — récupère le contenu d'un lot sous forme de `Bundle`

Pour la spécification complète des paramètres et des exemples, voir [Opérations de publication](operations.html).

---

## 7. Opération `$publication-metadata`

### 7.1 Endpoint

```http
POST /fhir/$publication-metadata
Content-Type: application/fhir+json
```

### 7.2 Entrée

```json
{
  "resourceType": "Parameters",
  "parameter": [
    { "name": "publicationBatchId", "valueString": "PB-2026-000145" }
  ]
}
```

### 7.3 Sortie (exemple lot `CLIENT`)

```json
{
  "resourceType": "Parameters",
  "parameter": [
    { "name": "publicationBatchId", "valueString": "PB-2026-000145" },
    { "name": "scope", "valueCode": "CLIENT" },
    { "name": "targetTenant", "valueString": "ght21" },
    { "name": "bundleType", "valueCode": "transaction" },
    { "name": "publicationViewCode", "valueString": "ORG_GHT21" },
    { "name": "resourceType", "valueString": "Organization" },
    { "name": "resourceType", "valueString": "Location" },
    { "name": "status", "valueCode": "READY" },
    { "name": "createdAt", "valueDateTime": "2026-03-30T09:15:00Z" }
  ]
}
```

### 7.4 Règles de validation

- `publicationBatchId` est obligatoire ;
- si le lot est inconnu, le serveur retourne un `OperationOutcome` (`not-found`) ;
- si le lot est de scope `CLIENT`, `targetTenant` est renseigné dans la réponse.

---

## 8. Opération `$publication-bundle`

### 8.1 Endpoint

```http
POST /fhir/$publication-bundle
Content-Type: application/fhir+json
```

### 8.2 Entrée

Exemple minimal :

```json
{
  "resourceType": "Parameters",
  "parameter": [
    { "name": "publicationBatchId", "valueString": "PB-2026-000145" }
  ]
}
```

Exemple explicite pour un lot `CLIENT` :

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

### 8.3 Réponse synchrone

Si le lot est disponible immédiatement et de volumétrie raisonnable, l'API retourne directement un `Bundle`.

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
      "request": { "method": "PUT", "url": "Organization/ORG-GHT21-4589" }
    }
  ]
}
```

### 8.4 Réponse asynchrone

Le mode asynchrone est recommandé lorsque :

- le lot est volumineux ;
- la reconstruction prend du temps ;
- la génération du bundle ne doit pas bloquer le client.

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
- `200 OK` avec le `Bundle` quand il est prêt ;
- `OperationOutcome` en cas d'erreur.

### 8.5 Règles de comportement

- `publicationBatchId` est obligatoire ;
- si le lot n'existe pas, retour d'un `OperationOutcome` ;
- si le lot est de scope `CLIENT`, le serveur vérifie la cohérence entre le lot, le `targetTenant` fourni et le contexte de sécurité ;
- le serveur ne doit jamais retourner un lot `CLIENT` pour un tenant différent de celui autorisé.

---

## 9. Gestion des erreurs

| Situation | HTTP | `issue.code` | Description |
|-----------|------|-------------|-------------|
| Lot inconnu | 404 | `not-found` | `publicationBatchId` ne correspond à aucun lot connu |
| Paramètres invalides | 400 | `required` / `value` | Paramètre obligatoire manquant ou valeur incohérente |
| Accès interdit | 403 | `forbidden` | Le jeton de l'appelant n'autorise pas l'accès à ce lot |
| Lot non prêt | 409 | `conflict` | Le lot existe mais son statut n'est pas READY |
| Incohérence tenant | 422 | `business-rule` | Le `targetTenant` transmis ne correspond pas au lot demandé |
| Incohérence vue | 422 | `business-rule` | Le `publicationViewCode` ne correspond pas au lot demandé |
| Erreur interne | 500 | `exception` | Erreur inattendue côté serveur |

---

## 10. Gestion des abonnements partiels

Le lot retourné par l'API est une projection de publication adaptée au destinataire.

- si un consommateur n'est abonné qu'à une partie du contenu, il ne reçoit que le périmètre qui lui est destiné ;
- les ressources non visibles ne sont pas incluses ;
- les dépendances minimales nécessaires doivent être définies par la vue de publication.

---

## 11. Cas des nomenclatures

Pour les nomenclatures, le lot est généralement de scope `GLOBAL`.

Deux possibilités de récupération :

- via `$publication-bundle` après notification NATS ;
- via API FHIR standard si l'artefact est exposé nativement comme `CodeSystem` ou `ValueSet`.

---

## 12. Contrat de notification broker

Le broker transporte uniquement la notification de disponibilité.

Payload minimal recommandé :

```json
{
  "messageId": "msg-002",
  "correlationId": "evt-001",
  "publicationBatchId": "PB-CLIENTA-0456",
  "scope": "CLIENT",
  "targetTenant": "clientA",
  "bundleType": "transaction",
  "resourceTypes": ["Organization", "Location"],
  "occurredAt": "2026-03-30T09:15:00Z"
}
```

---

## 13. Liens

- [Opérations de publication](operations.html) — spécification complète
- [Cas d'exemple NATS](nats-cases.html) — scénarios de notification
- [OperationDefinition $publication-metadata](OperationDefinition-publication-metadata.html)
- [OperationDefinition $publication-bundle](OperationDefinition-publication-bundle.html)
- [CapabilityStatement serveur](CapabilityStatement-mdm-publication-server.html)