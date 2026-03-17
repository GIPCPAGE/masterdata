# Guide d'Intégration

## Vue d'ensemble

Cette page fournit des recommandations pratiques pour **intégrer le référentiel des organisations tierces** dans vos systèmes d'information hospitaliers ou vos logiciels de gestion.

Le référentiel expose une **API REST FHIR** standard permettant de créer, consulter, modifier et rechercher les organisations (fournisseurs, clients, organismes payeurs).

---

## Principes d'Intégration

### 1. Approche API REST

Le référentiel suit les standards **FHIR REST** :

| Opération | Méthode HTTP | URL | Description |
|-----------|-------------|-----|-------------|
| **Créer** | POST | `[base]/Organization` | Créer une nouvelle organisation |
| **Lire** | GET | `[base]/Organization/{id}` | Récupérer une organisation par son ID |
| **Modifier** | PUT | `[base]/Organization/{id}` | Mettre à jour une organisation existante |
| **Rechercher** | GET | `[base]/Organization?[critères]` | Rechercher des organisations |
| **Supprimer** | DELETE | `[base]/Organization/{id}` | Supprimer une organisation (logique) |

### 2. Format des Données

**Format** : JSON (FHIR R4)  
**Encodage** : UTF-8  
**Content-Type** : `application/fhir+json`

---

## Scénarios d'Intégration

### Scénario 1 : Import Depuis un Système Existant

**Contexte** : Vous avez un système de gestion existant avec des fournisseurs et clients. Vous souhaitez les importer dans le référentiel FHIR.

#### Étapes

**1. Analyser vos données sources**
- Liste des fournisseurs avec SIRET, raison sociale, adresse
- Liste des clients avec coordonnées bancaires
- Identifiants existants (codes fournisseur/client)

**2. Mapper vers les profils FHIR**
- Raison sociale → `Organization.name`
- SIRET → `Organization.identifier[siret].value`
- Adresse → `Organization.address`
- Code fournisseur → `Organization.extension[codeFournisseur].value`

**3. Créer les ressources FHIR**

```http
POST [base]/Organization
Content-Type: application/fhir+json

{
  "resourceType": "Organization",
  "identifier": [
    {
      "system": "urn:oid:1.2.250.1.24.3.2",
      "value": "12345678901234"
    }
  ],
  "name": "Laboratoires Pharmaceutiques Durand",
  "address": [{
    "line": ["10 Rue de la Santé"],
    "city": "Paris",
    "postalCode": "75014",
    "country": "FR"
  }],
  "extension": [{
    "url": "https://www.cpage.fr/ig/masterdata/tiers/StructureDefinition/tiers-role-extension",
    "valueCoding": {
      "system": "http://cpage.org/fhir/CodeSystem/tiers-role-cs",
      "code": "supplier"
    }
  }]
}
```

**4. Gérer les doublons**

Avant chaque import, vérifier si l'organisation existe déjà :

```http
GET [base]/Organization?identifier=urn:oid:1.2.250.1.24.3.2|12345678901234
```

Si résultat vide → Créer  
Si résultat trouvé → Mettre à jour ou ignorer

---

### Scénario 2 : Synchronisation Bidirectionnelle

**Contexte** : Votre système doit rester synchronisé avec le référentiel (modifications dans les deux sens).

#### Architecture Recommandée

```
┌─────────────────────────────┐
│   Votre Système Métier      │
│  (Comptabilité, Achats)     │
└──────────┬──────────────────┘
           │
           │ Synchronisation
           │ bidirectionnelle
           ↓
┌─────────────────────────────┐
│  Référentiel FHIR Tiers     │
│  (Source de vérité)         │
└─────────────────────────────┘
```

#### Mécanismes

**1. Push (de votre système vers le référentiel)**

Quand une organisation est créée/modifiée dans votre système :
- Appeler `POST` ou `PUT` sur le référentiel
- Stocker l'ID FHIR retourné dans votre base

**2. Pull (du référentiel vers votre système)**

Option A : **Polling périodique**
```http
GET [base]/Organization?_lastUpdated=gt2024-03-15T10:00:00Z
```

Option B : **Webhooks/Subscriptions** (si supporté)
- S'abonner aux événements de modification
- Recevoir notification push lors de changements

**3. Gestion des conflits**

Stratégie : **Référentiel = source de vérité**
- En cas de divergence, privilégier les données du référentiel
- Journaliser les écrasements pour audit

---

### Scénario 3 : Recherche et Affichage

**Contexte** : Votre application doit permettre de rechercher et afficher les organisations.

#### Interface Utilisateur

**Champ de recherche libre** :
```http
GET [base]/Organization?name:contains=hopital
```

**Filtres avancés** :

- Par rôle (fournisseur, client, payeur)
```http
GET [base]/Organization?tiers-role=supplier
```

- Par catégorie (hôpital public, mutuelle, entreprise)
```http
GET [base]/Organization?tiers-category=27
```

- Par identifiant (SIRET, FINESS)
```http
GET [base]/Organization?identifier=urn:oid:1.2.250.1.24.3.2|12345678901234
```

#### Affichage des Résultats

Informations minimales à afficher :
- Nom (+ alias si disponible)
- Identifiant principal (SIRET, FINESS)
- Adresse
- Rôle(s) métier
- Statut actif/inactif

---

### Scénario 4 : Validation des Paiements

**Contexte** : Avant de régler un fournisseur, vérifier ses coordonnées bancaires et conditions.

#### Workflow

**1. Récupérer le fournisseur**
```http
GET [base]/Organization?fournisseur-code:exact=FRSUP123456
```

**2. Extraire les informations de paiement**

```json
{
  "extension": [{
    "url": ".../gef-bank-account",
    "extension": [
      {"url": "iban", "valueString": "FR7630002..."},
      {"url": "bic", "valueString": "SOGEFRPPXXX"}
    ]
  }, {
    "url": ".../fournisseur-paiement",
    "extension": [
      {"url": "delaiPaiement", "valueInteger": 60},
      {"url": "jourPaiement", "valueInteger": 10},
      {"url": "montantMin", "valueDecimal": 1000.0}
    ]
  }]
}
```

**3. Valider avant paiement**

- Délai respecté ? (60 jours depuis facture)
- Montant ≥ minimum ? (1000 €)
- IBAN valide ?
- Affacturage activé ? (si oui, payer le factor, pas le fournisseur)

---

### Scénario 5 : Transmission FSE aux Organismes Payeurs

**Contexte** : Envoyer les feuilles de soins électroniques aux bons organismes (CPAM, mutuelles).

#### Workflow

**1. Identifier l'organisme payeur**

Trouver la CPAM du patient selon son département :

```http
GET [base]/Organization?tiers-role=payer
  &payeur-type=RO
  &payeur-grand-regime=SS
  &_filter=extension('numeroCaisse').value eq '75001'
```

**2. Récupérer les paramètres de transmission**

```json
{
  "extension": [{
    "url": ".../payeur-sante",
    "extension": [
      {"url": "typePayeur", "valueCode": "RO"},
      {"url": "codeCentre", "valueString": "750"},
      {"url": "numeroCaisse", "valueString": "75001"},
      {"url": "numeroOrganisme", "valueString": "007501"},
      {"url": "delaiPec", "valueInteger": 90}
    ]
  }]
}
```

**3. Transmettre la FSE**

- Utiliser le `numeroOrganisme` pour identifier le destinataire
- Surveiller le délai de prise en charge (90 jours)
- Relancer si dépassement

---

## Bonnes Pratiques

### 1. Gestion des Identifiants

**Privilégier les identifiants officiels** :
1. SIRET (entreprises françaises)
2. FINESS (établissements de santé)
3. TVA UE (fournisseurs européens)
4. Identifiant interne (en dernier recours)

**Rechercher par identifiant avant création** pour éviter doublons :

```http
GET [base]/Organization?identifier=[system]|[value]
```

---

### 2. Multi-Rôle

**Une organisation = une seule ressource**, même si elle a plusieurs rôles.

❌ **Mauvaise pratique** :
- Créer 3 ressources distinctes pour la même clinique (fournisseur, client, payeur)

✅ **Bonne pratique** :
- Créer 1 ressource avec 3 rôles différents

**Avantages** :
- Pas de duplication
- Historique unifié
- Recherche simplifiée

---

### 3. Gestion des Erreurs

**Codes HTTP standards** :

| Code | Signification | Action |
|------|--------------|--------|
| **200 OK** | Succès | Continuer |
| **201 Created** | Ressource créée | Stocker l'ID retourné |
| **400 Bad Request** | Données invalides | Corriger la requête |
| **404 Not Found** | Ressource inexistante | Vérifier l'ID |
| **409 Conflict** | Conflit (doublon) | Utiliser ressource existante |
| **500 Server Error** | Erreur serveur | Réessayer plus tard |

**Validation FHIR** :

Le serveur peut retourner un `OperationOutcome` en cas d'erreur :

```json
{
  "resourceType": "OperationOutcome",
  "issue": [{
    "severity": "error",
    "code": "invalid",
    "diagnostics": "SIRET invalide : doit faire 14 chiffres"
  }]
}
```

Analyser le champ `diagnostics` pour afficher un message utilisateur clair.

---

### 4. Performance et Pagination

**Limiter les résultats** :
```http
GET [base]/Organization?_count=50
```

**Pagination** :
```http
GET [base]/Organization?_count=50&_offset=100
```

**Optimiser les recherches** :
- Utiliser des critères précis (`identifier`, `fournisseur-code:exact`)
- Éviter les recherches `name:contains` trop larges
- Indexer sur les identifiants dans votre base locale

---

### 5. Sécurité

**Authentification** : Utiliser OAuth 2.0 ou API Key selon configuration serveur

**Autorisation** : Respecter les rôles métier
- Lecture : Tous utilisateurs
- Création/Modification : Administrateurs référentiel
- Suppression : Super-administrateurs uniquement

**Confidentialité** :
- Ne pas logger les coordonnées bancaires (IBAN, BIC)
- Chiffrer les communications (HTTPS obligatoire)
- Respecter RGPD pour données personnelles (NIR, civilité, prénom)

---

### 6. Maintenance et Evolution

**Versionnement** :
- Le référentiel suit FHIR R4
- Les extensions peuvent évoluer (nouvelles versions)
- Tester régulièrement la compatibilité

**Monitoring** :
- Surveiller les temps de réponse API
- Journaliser les erreurs 4xx/5xx
- Alerter si taux d'échec > seuil

**Documentation** :
- Maintenir la correspondance entre vos codes internes et IDs FHIR
- Documenter les mappings de données
- Former les utilisateurs aux nouveaux processus

---

## Exemples de Code

### Création d'un Fournisseur (Python)

```python
import requests
import json

url = "https://api.example.com/fhir/Organization"
headers = {
    "Content-Type": "application/fhir+json",
    "Authorization": "Bearer YOUR_TOKEN"
}

data = {
    "resourceType": "Organization",
    "identifier": [{
        "system": "urn:oid:1.2.250.1.24.3.2",
        "value": "12345678901234"
    }],
    "name": "Laboratoires Durand",
    "extension": [{
        "url": "https://www.cpage.fr/ig/masterdata/tiers/StructureDefinition/tiers-role-extension",
        "valueCoding": {
            "system": "http://cpage.org/fhir/CodeSystem/tiers-role-cs",
            "code": "supplier"
        }
    }]
}

response = requests.post(url, headers=headers, data=json.dumps(data))

if response.status_code == 201:
    org_id = response.json()["id"]
    print(f"Organisation créée avec ID : {org_id}")
else:
    print(f"Erreur {response.status_code} : {response.text}")
```

---

### Recherche par SIRET (JavaScript)

```javascript
const axios = require('axios');

const baseUrl = 'https://api.example.com/fhir';
const siret = '12345678901234';

async function findBySiret(siret) {
    const url = `${baseUrl}/Organization?identifier=urn:oid:1.2.250.1.24.3.2|${siret}`;
    
    try {
        const response = await axios.get(url, {
            headers: { 'Authorization': 'Bearer YOUR_TOKEN' }
        });
        
        const bundle = response.data;
        if (bundle.total > 0) {
            return bundle.entry[0].resource;
        } else {
            console.log('Organisation non trouvée');
            return null;
        }
    } catch (error) {
        console.error('Erreur:', error.message);
    }
}

findBySiret(siret).then(org => {
    if (org) {
        console.log('Nom:', org.name);
        console.log('Adresse:', org.address[0].city);
    }
});
```

---

## Ressources Complémentaires

### Documentation Technique

- [Spécification FHIR R4](https://www.hl7.org/fhir/R4/) - Standard international
- [FR Core](https://hl7.fr/ig/fhir/core/) - Profils français de base
- [API REST FHIR](https://www.hl7.org/fhir/R4/http.html) - Actions HTTP

### Pages du Guide

- [Guide d'implémentation](index.html) - Vue d'ensemble du référentiel
- [Structure des organisations](tiers-organization.html) - Profils et extensions
- [Rechercher dans le référentiel](search-parameters.html) - Critères de recherche
- [Exemples d'utilisation](examples.html) - Cas concrets
- [Classifications et nomenclatures](terminologies.html) - Codes et catégories

---

## Support

Pour toute question sur l'intégration :
- Consultez la [documentation des profils](StructureDefinition-tiers-profile.html)
- Utilisez les [exemples fournis](examples.html) comme modèles
- Testez avec des données fictives avant production
- Contactez l'équipe du référentiel pour support technique
