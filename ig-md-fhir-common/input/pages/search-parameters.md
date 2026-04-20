# Axe Concepts Métiers — Paramètres de Recherche Tiers

## Introduction

Cette page documente les **10 paramètres de recherche** FHIR pour requêter les organisations tierces (ressource `Organization`) via l'API REST.

Ces SearchParameters sont spécifiques à l'**Axe Concepts Métiers** de ce guide. Pour les requêtes sur les CodeSystems et ValueSets géographiques (communes COG), voir la [documentation géographique](geographie.html).

| Paramètre | Extension source | Cible |
|-----------|-----------------|-------|
| `tiers-role` | `TiersRoleExtension` | Rôle : supplier / debtor / payer |
| `tiers-category` | `TiersCategoryExtension` | Catégorie d'organisation |
| `tiers-legal-nature` | `TiersLegalNatureExtension` | Nature juridique |
| `fournisseur-code` | `FournisseurCodeExtension` | Code fournisseur CPage |
| `debiteur-code` | `DebiteurCodeExtension` | Code débiteur CPage |
| `bank-account-iban` | `TiersBankAccountExtension` | IBAN du compte bancaire |
| `payeur-grand-regime` | `PayeurSanteExtension` | Grand régime (SS, MSA…) |
| `payeur-type` | `TiersCategoryExtension` | Type payeur (RO / RC) |
| `succursale-usage` | `SuccursaleUsageExtension` | Usage succursale |
| `debiteur-type-resident` | `TiersIdentifierTypeExtension` | Résidence fiscale |

**[Voir les définitions FHIR des SearchParameters →](artifacts.html#behavior-search-parameters)**

---

## Comment rechercher ?

### Syntaxe de base

```
GET [serveur]/Organization?[critère]=[valeur]
```

### Types de recherches

**Recherche exacte**
```
GET [serveur]/Organization?fournisseur-code=FRSUP00456
```

**Recherche partielle** (contient)
```
GET [serveur]/Organization?fournisseur-code:contains=LPD
```

**Recherche avec OU logique**
```
GET [serveur]/Organization?tiers-role=supplier,debtor
→ Renvoie les fournisseurs OU les clients
```

**Recherche avec ET logique**
```
GET [serveur]/Organization?tiers-role=supplier&tiers-role=debtor  
→ Renvoie uniquement les organisations qui sont À LA FOIS fournisseurs ET clients
```

---

## Recherches par rôle et type

### 1. Recherche par rôle de l'organisation

**Critère** : `tiers-role`  
**Type** : Valeurs codées  
**Utilité** : Trouver toutes les organisations ayant un rôle spécifique

**Valeurs possibles** :
- `supplier` = Fournisseur
- `debtor` = Client  
- `payer` = Organisme payeur

**Exemples** :
```http
# Tous les fournisseurs
GET [serveur]/Organization?tiers-role=supplier

# Tous les organismes payeurs (CPAM, mutuelles)
GET [serveur]/Organization?tiers-role=payer

# Fournisseurs OU clients (OU logique)
GET [serveur]/Organization?tiers-role=supplier,debtor

# Organisations multi-rôles (fournisseur ET client simultanément)
GET [serveur]/Organization?tiers-role=supplier&tiers-role=debtor
```

**Cas d'usage** :
- Générer la liste de tous mes fournisseurs actifs
- Envoyer une campagne d'information à tous mes clients
- Synchroniser les organismes payeurs avec l'outil de facturation

---

### 2. Recherche par type d'organisation

**Critère** : `tiers-category`  
**Type** : Valeurs codées  
**Utilité** : Filtrer par secteur d'activité ou statut juridique

**Exemples de valeurs** :
- `01` = État
- `02` = Collectivité territoriale
- `16` = Établissement public de santé  
- `03` = Clinique
- `60` = Assurance maladie (générique)
- `61` = CPAM
- `63` = Mutuelle

**Exemples** :
```http
# Tous les établissements publics de santé
GET [serveur]/Organization?tiers-category=16

# Toutes les CPAM
GET [serveur]/Organization?tiers-category=61

# Assurance maladie OU mutuelles
GET [serveur]/Organization?tiers-category=60,63
```

**Cas d'usage** :
- Identifier tous les établissements de santé partenaires
- Créer une liste de diffusion des organismes d'assurance maladie
- Filtrer les collectivités territoriales pour les mandats administratifs

---

### 3. Recherche par forme juridique

**Critère** : `tiers-legal-nature`  
**Type** : Valeurs codées  
**Utilité** : Filtrer par statut légal de l'organisation

**Exemples de valeurs** :
- `00` = Particulier (personne physique)
- `03` = Société commerciale
- `04` = Association  
- `06` = Établissement public

**Exemples** :
```http
# Toutes les sociétés commerciales
GET [serveur]/Organization?tiers-legal-nature=03

# Associations uniquement
GET [serveur]/Organization?tiers-legal-nature=04

# Sociétés OU associations (secteur privé)
GET [serveur]/Organization?tiers-legal-nature=03,04
```

**Cas d'usage** :
- Distinguer les entités publiques des privées
- Filtrer les associations pour des appels d'offres spécifiques
- Reporting juridique et fiscal

---

## Recherches par identifiants métier

### 4. Recherche par code fournisseur

**Critère** : `fournisseur-code`  
**Type** : Texte libre  
**Utilité** : Retrouver un fournisseur par son code interne

**Exemples** :
```http
# Recherche exacte par code
GET [serveur]/Organization?fournisseur-code:exact=FRSUP00456

# Recherche partielle (contient "LPD")
GET [serveur]/Organization?fournisseur-code:contains=LPD
```

**Cas d'usage** :
- Vérifier si un code fournisseur existe déjà avant création
- Retrouver une fiche fournisseur depuis un bon de commande
- Import/synchronisation depuis un système externe

---

### 5. Recherche par code client

**Critère** : `debiteur-code`  
**Type** : Texte libre  
**Utilité** : Retrouver un client par son code interne

**Exemples** :
```http
# Recherche exacte par code
GET [serveur]/Organization?debiteur-code:exact=DEBNECKER01

# Recherche partielle (contient "NECKER")
GET [serveur]/Organization?debiteur-code:contains=NECKER
```

**Cas d'usage** :
- Validation d'existence avant création client
- Récupération fiche client depuis une facture
- Rapprochement comptable

---

## Recherches financières

### 6. Recherche par compte bancaire (IBAN)

**Critère** : `bank-account-iban`  
**Type** : Texte libre  
**Utilité** : Identifier le titulaire d'un compte bancaire

**Exemples** :
```http
# Recherche exacte par IBAN complet
GET [serveur]/Organization?bank-account-iban=FR7630004000020000012345678

# Recherche par code banque (commence par FR76...)
GET [serveur]/Organization?bank-account-iban:contains=30004
```

**Cas d'usage** :
- **Rapprochement bancaire** : Qui a émis ce virement reçu ?
- **Contrôle avant paiement** : Vérifier le bénéficiaire avant ordre de virement
- **Détection de doublons** : Plusieurs organisations partageant le même RIB
- **Audit comptable** : Lister toutes les organisations ayant un compte chez une banque donnée

---

## Recherches spécifiques organismes payeurs

### 7. Recherche par régime de protection sociale

**Critère** : `payeur-grand-regime`  
**Type** : Valeurs codées  
**Utilité** : Filtrer les organismes payeurs par régime

**Valeurs possibles** :
- `SS` = Sécurité Sociale (CPAM)
- `MSA` = Mutualité Sociale Agricole
- `RSI` = Régime Social des Indépendants
- `CNAV` = Caisse Nationale d'Assurance Vieillesse
- `MUTUELLE` = Organismes complémentaires

**Exemples** :
```http
# Toutes les CPAM (Sécurité Sociale)
GET [serveur]/Organization?payeur-grand-regime=SS

# Toutes les mutuelles
GET [serveur]/Organization?payeur-grand-regime=MUTUELLE

# Sécurité Sociale OU MSA (régimes obligatoires agricoles et généraux)
GET [serveur]/Organization?payeur-grand-regime=SS,MSA
```

**Cas d'usage** :
- Préparer une télétransmission FSE vers les CPAM uniquement
- Lister les mutuelles pour facturation complémentaire
- Reporting par régime social

---

### 8. Recherche par type de régime

**Critère** : `payeur-type`  
**Type** : Texte libre  
**Utilité** : Distinguer régimes obligatoires et complémentaires

**Valeurs possibles** :
- `RO` = Régime Obligatoire (CPAM, MSA, RSI)
- `RC` = Régime Complémentaire (mutuelles, assurances)

**Exemples** :
```http
# Tous les régimes obligatoires
GET [serveur]/Organization?payeur-type=RO

# Tous les régimes complémentaires
GET [serveur]/Organization?payeur-type=RC
```

**Cas d'usage** :
- Facturation différenciée obligatoire vs complémentaire
- Télétransmission en deux temps (RO puis RC)
- Reporting financier par type de payeur

---

## Recherches organisationnelles

### 9. Recherche par usage de succursale

**Critère** : `succursale-usage`  
**Type** : Valeurs codées  
**Utilité** : Identifier les sites selon leur fonction

**Valeurs possibles** :
- `POINT_LIVRAISON` = Adresse de réception des marchandises
- `FACTURATION` = Adresse d'envoi des factures
- `SIEGE_SOCIAL` = Siège social secondaire

**Exemples** :
```http
# Tous les points de livraison
GET [serveur]/Organization?succursale-usage=POINT_LIVRAISON

# Adresses de facturation uniquement
GET [serveur]/Organization?succursale-usage=FACTURATION

# Sites qui sont À LA FOIS point de livraison ET facturation
GET [serveur]/Organization?succursale-usage=POINT_LIVRAISON&succursale-usage=FACTURATION
```

**Cas d'usage** :
- Préparer les bons de livraison (adresses POINT_LIVRAISON)
- Routage des factures (adresses FACTURATION)
- Gestion multi-sites d'un groupe hospitalier

---

### 10. Recherche par résidence fiscale

**Critère** : `debiteur-type-resident`  
**Type** : Valeurs codées  
**Utilité** : Identifier les clients selon leur statut fiscal

**Valeurs possibles** :
- `R` = Résident français
- `NR` = Non-résident (étranger)

**Exemples** :
```http
# Tous les clients résidents
GET [serveur]/Organization?debiteur-type-resident=R

# Tous les clients non-résidents
GET [serveur]/Organization?debiteur-type-resident=NR
```

**Cas d'usage** :
- Application de la retenue à la source (obligatoire pour non-résidents)
- Reporting fiscal différencié résidents/non-résidents
- Contrôles douaniers et TVA intracommunautaire

---

## Recherches combinées

### Exemples avancés

**Tous les fournisseurs établissements publics de santé actifs**
```http
GET [serveur]/Organization?tiers-role=supplier&tiers-category=16&active=true
```

**Clients non-résidents de forme société commerciale**
```http
GET [serveur]/Organization?tiers-role=debtor&debiteur-type-resident=NR&tiers-legal-nature=03
```

**Organismes payeurs Sécurité Sociale régime obligatoire uniquement**
```http
GET [serveur]/Organization?tiers-role=payer&payeur-type=RO&payeur-grand-regime=SS
```

**Organisations multi-rôles (fournisseur ET client)**
```http
GET [serveur]/Organization?tiers-role=supplier&tiers-role=debtor
```

---

## Critères de recherche standard FHIR

En plus des critères spécifiques ci-dessus, vous pouvez utiliser les **critères standards** de la ressource Organization :

**Recherche par nom**
```http
GET [serveur]/Organization?name:contains=Clinique
```

**Recherche par ville**
```http
GET [serveur]/Organization?address-city=Paris
```

**Recherche par SIRET**
```http
GET [serveur]/Organization?identifier=https://sirene.fr|85211234500018
```

**Recherche par FINESS**
```http
GET [serveur]/Organization?identifier=https://finess.esante.gouv.fr|750012345
```

---

## Pagination et performance

### Limiter le nombre de résultats

```http
# 50 résultats maximum par page
GET [serveur]/Organization?tiers-role=supplier&_count=50

# Page suivante (résultats 51-100)
GET [serveur]/Organization?tiers-role=supplier&_count=50&_offset=50
```

### Optimisation

Pour de meilleures performances :
- ✅ Combinez plusieurs critères pour affiner la recherche
- ✅ Utilisez la pagination explicite (`_count`)
- ✅ Évitez les recherches trop larges sans filtre

---

## Sécurité et confidentialité

### Contrôle d'accès

Certains critères donnent accès à des données sensibles :
- **IBAN** : Informations bancaires confidentielles
- **Codes métier** : Identifiants internes sensibles

Le serveur **doit** :
- Implémenter l'authentification (OAuth2 ou équivalent)
- Filtrer les résultats selon les droits de l'utilisateur
- Tracer les recherches sur données sensibles (audit)

---

## Tableau récapitulatif

| Critère | Type | OU logique | ET logique | Usage principal |
|---------|------|------------|------------|-----------------|
| **tiers-role** | Code | ✅ | ✅ | Filtrer par fonction (fournisseur/client/payeur) |
| **tiers-category** | Code | ✅ | ❌ | Filtrer par type d'organisation |
| **tiers-legal-nature** | Code | ✅ | ❌ | Filtrer par forme juridique |
| **fournisseur-code** | Texte | ✅ | ❌ | Retrouver un fournisseur par code |
| **debiteur-code** | Texte | ✅ | ❌ | Retrouver un client par code |
| **bank-account-iban** | Texte | ✅ | ❌ | Identifier titulaire d'un compte |
| **payeur-grand-regime** | Code | ✅ | ❌ | Filtrer organismes payeurs par régime |
| **payeur-type** | Texte | ✅ | ❌ | Distinguer RO (obligatoire) vs RC (complémentaire) |
| **succursale-usage** | Code | ✅ | ✅ | Trouver sites par fonction |
| **debiteur-type-resident** | Code | ✅ | ❌ | Filtrer par résidence fiscale |

---

## Voir aussi

- [Profils Tiers](tiers-organization.html) - Extensions qui exposent les données recherchables
- [Données Géographiques COG](geographie.html) - Requêtes sur les terminologies COG ($lookup, $expand)
- [Exemples](examples.html) - Instances concrètes avec exemples de recherche
- [Profils](StructureDefinition-tiers-profile.html) - Documentation technique des profils
