# Critères de Recherche - SearchParameters

## Vue d'ensemble

Cette page documente les **critères de recherche (SearchParameters)** définis pour faciliter l'exploitation des ressources **Organization** conformes aux profils Tiers. Ces paramètres permettent de filtrer, rechercher et identifier rapidement les organisations selon leurs rôles, attributs métier, identifiants, et paramètres de gestion.

## Principes généraux

Les SearchParameters FHIR permettent de construire des requêtes REST pour interroger le serveur FHIR :

```
GET [base]/Organization?[parameter]=[value]
```

### Syntaxe des recherches

- **Token** : Pour codes et valeurs codées  
  `?tiers-role=supplier`
  
- **String** : Pour chaînes de caractères (supporte `:exact`, `:contains`)  
  `?fournisseur-code:contains=LPD`
  
- **MultipleOr** : Recherche avec OU logique  
  `?tiers-role=supplier,debtor` (supplier OU debtor)
  
- **MultipleAnd** : Recherche avec ET logique  
  `?tiers-role=supplier&tiers-role=debtor` (supplier ET debtor)

---

## Recherches par Rôle et Classification

### 1. Recherche par Rôle du Tiers

**Code** : `tiers-role`  
**Type** : token  
**Base** : Organization  
**Cardinalité** : Multiple OR/AND supportés  

Permet de rechercher un tiers par son ou ses rôles : fournisseur (supplier), débiteur (debtor), ou payeur santé (payer).

```http
GET [base]/Organization?tiers-role=supplier
GET [base]/Organization?tiers-role=debtor
GET [base]/Organization?tiers-role=payer
GET [base]/Organization?tiers-role=supplier,debtor (OU)
GET [base]/Organization?tiers-role=supplier&tiers-role=debtor (ET - multi-rôles)
```

**Cas d'usage** :
- Lister tous les fournisseurs actifs
- Identifier les tiers ayant un double rôle (supplier + debtor)
- Filtrer uniquement les payeurs santé (CPAM, mutuelles)

---

### 2. Recherche par Catégorie TG

**Code** : `tiers-category`  
**Type** : token  
**Base** : Organization  
**Cardinalité** : Multiple OR supporté  

Permet de rechercher un tiers par sa catégorie TG selon la nomenclature GEF (codes 00-74).

```http
GET [base]/Organization?tiers-category=01 (État)
GET [base]/Organization?tiers-category=02 (Collectivité territoriale)
GET [base]/Organization?tiers-category=16 (Établissement public de santé)
GET [base]/Organization?tiers-category=60 (Assurance maladie)
GET [base]/Organization?tiers-category=16,60 (EPS OU Assurance maladie)
```

**Cas d'usage** :
- Identifier tous les établissements publics de santé (TG 16)
- Lister les organismes sociaux (TG 60-65)
- Filtrer les collectivités territoriales pour mandats électroniques

---

### 3. Recherche par Nature Juridique

**Code** : `tiers-legal-nature`  
**Type** : token  
**Base** : Organization  
**Cardinalité** : Multiple OR supporté  

Permet de rechercher un tiers par sa nature juridique selon GEF (codes 00-11).

```http
GET [base]/Organization?tiers-legal-nature=00 (Particulier)
GET [base]/Organization?tiers-legal-nature=03 (Société)
GET [base]/Organization?tiers-legal-nature=04 (Association)
GET [base]/Organization?tiers-legal-nature=06 (Établissement public)
GET [base]/Organization?tiers-legal-nature=03,04 (Société OU Association)
```

**Cas d'usage** :
- Filtrer les personnes physiques (particuliers) pour gestion spécifique
- Identifier les sociétés commerciales vs associations
- Séparer les établissements publics des entités privées

---

## Recherches par Codes Métier

### 4. Recherche par Code Fournisseur

**Code** : `fournisseur-code`  
**Type** : string  
**Base** : Organization  
**Cardinalité** : Multiple OR supporté  

Permet de rechercher un fournisseur par son code fournisseur unique (numéro interne de gestion).

```http
GET [base]/Organization?fournisseur-code=FRSUP00456
GET [base]/Organization?fournisseur-code:exact=FRNSLPD001
GET [base]/Organization?fournisseur-code:contains=LPD
```

**Cas d'usage** :
- Validation d'existence d'un code fournisseur avant création
- Récupération fiche fournisseur par code EFOU
- Recherche approximative sur nom fournisseur intégré au code

---

### 5. Recherche par Code Débiteur

**Code** : `debiteur-code`  
**Type** : string  
**Base** : Organization  
**Cardinalité** : Multiple OR supporté  

Permet de rechercher un débiteur par son code débiteur unique (numéro interne de gestion).

```http
GET [base]/Organization?debiteur-code=DEB000789
GET [base]/Organization?debiteur-code:exact=DEBNECKER01
GET [base]/Organization?debiteur-code:contains=NECKER
```

**Cas d'usage** :
- Validation d'existence d'un code débiteur avant création
- Récupération fiche débiteur par code KERD
- Recherche approximative sur nom établissement intégré au code

---

## Recherches Financières

### 6. Recherche par IBAN

**Code** : `bank-account-iban`  
**Type** : string  
**Base** : Organization  
**Cardinalité** : Multiple OR supporté  

Permet de rechercher un tiers par son IBAN (International Bank Account Number).

```http
GET [base]/Organization?bank-account-iban=FR7630004000020000012345678
GET [base]/Organization?bank-account-iban:exact=DE89370400440532013000
GET [base]/Organization?bank-account-iban:contains=30004 (recherche par code banque)
```

**Cas d'usage** :
- Identification du bénéficiaire d'un virement pour rapprochement comptable
- Validation de compte bancaire avant ordre de paiement
- Contrôle anti-doublons sur RIB/IBAN
- Détection de comptes bancaires partagés entre plusieurs tiers

---

## Recherches Payeurs Santé

### 7. Recherche par Grand Régime

**Code** : `payeur-grand-regime`  
**Type** : token  
**Base** : Organization  
**Cardinalité** : Multiple OR supporté  

Permet de rechercher un payeur santé par son grand régime de protection sociale.

```http
GET [base]/Organization?payeur-grand-regime=SS (Sécurité Sociale)
GET [base]/Organization?payeur-grand-regime=MSA (Mutualité Sociale Agricole)
GET [base]/Organization?payeur-grand-regime=MUTUELLE (Mutuelles complémentaires)
GET [base]/Organization?payeur-grand-regime=SS,MSA (SS OU MSA)
```

**Valeurs** : `SS`, `MSA`, `RSI`, `CNAV`, `MUTUELLE`

**Cas d'usage** :
- Filtrer les caisses primaires Sécurité Sociale pour télétransmission FSE
- Identifier les mutuelles pour facturation complémentaire
- Lister tous les organismes régime obligatoire (SS+MSA+RSI)

---

### 8. Recherche par Type Payeur

**Code** : `payeur-type`  
**Type** : string  
**Base** : Organization  
**Cardinalité** : Multiple OR supporté  

Permet de rechercher un payeur santé par son type : Régime Obligatoire (RO) ou Régime Complémentaire (RC).

```http
GET [base]/Organization?payeur-type=RO (Régime Obligatoire)
GET [base]/Organization?payeur-type=RC (Régime Complémentaire)
```

**Cas d'usage** :
- Séparer payeurs RO (CPAM/MSA/RSI) des RC (mutuelles)
- Appliquer règles de gestion différenciées (délais, taux remboursement)
- Générer états financiers par type de payeur

---

## Recherches Organisationnelles

### 9. Recherche par Usage Succursale

**Code** : `succursale-usage`  
**Type** : token  
**Base** : Organization  
**Cardinalité** : Multiple OR/AND supportés  

Permet de rechercher une succursale par son usage : point de livraison, siège de facturation, ou siège social secondaire.

```http
GET [base]/Organization?succursale-usage=POINT_LIVRAISON
GET [base]/Organization?succursale-usage=FACTURATION
GET [base]/Organization?succursale-usage=SIEGE_SOCIAL
GET [base]/Organization?succursale-usage=POINT_LIVRAISON,FACTURATION (OU)
GET [base]/Organization?succursale-usage=POINT_LIVRAISON&succursale-usage=FACTURATION (ET)
```

**Valeurs** : `POINT_LIVRAISON`, `FACTURATION`, `SIEGE_SOCIAL`

**Cas d'usage** :
- Identifier toutes les adresses de livraison d'un groupe hospitalier
- Lister les sièges de facturation pour envoi factures
- Distinction sites secondaires vs établissements principaux

---

### 10. Recherche par Type Résident Fiscal

**Code** : `debiteur-type-resident`  
**Type** : token  
**Base** : Organization  
**Cardinalité** : Multiple OR supporté  

Permet de rechercher un débiteur par son type de résidence fiscale : Résident (R) ou Non-résident (NR).

```http
GET [base]/Organization?debiteur-type-resident=R (Résident)
GET [base]/Organization?debiteur-type-resident=NR (Non-résident)
```

**Valeurs** : `R` (Résident français), `NR` (Non-résident)

**Cas d'usage** :
- Identifier débiteurs non-résidents pour application retenue à la source
- Filtrer résidents fiscaux pour obligations déclaratives nationales
- Reporting fiscal différencié résidents/non-résidents

---

## Recherches Combinées (Exemples Avancés)

### Multi-critères

```http
# Fournisseurs EPS actifs avec IBAN français
GET [base]/Organization?tiers-role=supplier
  &tiers-category=16
  &bank-account-iban:contains=FR76
  &active=true

# Débiteurs non-résidents de type société
GET [base]/Organization?tiers-role=debtor
  &debiteur-type-resident=NR
  &tiers-legal-nature=03

# Payeurs santé régime obligatoire Sécurité Sociale
GET [base]/Organization?tiers-role=payer
  &payeur-type=RO
  &payeur-grand-regime=SS

# Tiers multi-rôles (fournisseur ET débiteur)
GET [base]/Organization?tiers-role=supplier
  &tiers-role=debtor
```

### Recherches par identifiants standards FHIR

Les identifiants standards Organization sont également disponibles :

```http
# Recherche par SIRET
GET [base]/Organization?identifier=urn:oid:1.2.250.1.24.3.2|85211234500018

# Recherche par FINESS
GET [base]/Organization?identifier=https://finess.esante.gouv.fr|750012345

# Recherche par nom (substring)
GET [base]/Organization?name:contains=Clinique

# Recherche par ville
GET [base]/Organization?address-city=Paris
```

---

## Tableau Récapitulatif

| SearchParameter | Type | Multi OR | Multi AND | Extension Source |
|-----------------|------|----------|-----------|------------------|
| **tiers-role** | token | ✅ | ✅ | TiersRoleExtension |
| **tiers-category** | token | ✅ | ❌ | GEFTGCategory |
| **tiers-legal-nature** | token | ✅ | ❌ | GEFLegalNature |
| **fournisseur-code** | string | ✅ | ❌ | FournisseurCodeExtension |
| **debiteur-code** | string | ✅ | ❌ | DebiteurCodeExtension |
| **bank-account-iban** | string | ✅ | ❌ | GEFBankAccount.iban |
| **payeur-grand-regime** | token | ✅ | ❌ | PayeurSanteExtension.grandRegime |
| **payeur-type** | string | ✅ | ❌ | PayeurSanteExtension.typePayeur |
| **succursale-usage** | token | ✅ | ✅ | SuccursaleUsageExtension |
| **debiteur-type-resident** | token | ✅ | ❌ | DebiteurParametresExtension.typeResident |

---

## Implémentation Serveur

Les serveurs FHIR implémentant ce guide **DOIVENT** :

1. ✅ Supporter tous les SearchParameters token/string définis
2. ✅ Implémenter les modificateurs `:exact` et `:contains` pour string
3. ✅ Gérer les recherches MultipleOr (valeurs séparées par virgules)
4. ✅ Gérer les recherches MultipleAnd (paramètres répétés) quand supporté
5. ✅ Retourner des résultats conformes aux profils Tiers

Les serveurs **PEUVENT** :
- Ajouter des SearchParameters supplémentaires non définis ici
- Supporter d'autres modificateurs FHIR (`:above`, `:below`, etc.)
- Implémenter des recherches composites (Composite SearchParameters)

---

## Sécurité et Performance

### Contrôle d'accès

Les SearchParameters peuvent exposer des données sensibles :
- **IBAN** : Données bancaires confidentielles
- **NIR** : Données personnelles protégées
- **Codes métier** : Identifiants internes sensibles

Les serveurs **DOIVENT** :
- Implémenter OAuth2 ou autre mécanisme d'authentification
- Appliquer des filtres selon les droits de l'utilisateur
- Logger les recherches sur données sensibles

### Optimisation

Pour de meilleures performances :
- Indexer les extensions fréquemment recherchées (tiers-role, codes métier)
- Limiter les recherches par défaut (`:count`)
- Utiliser la pagination pour grands résultats
- Implémenter le cache pour recherches fréquentes

```http
# Pagination explicite
GET [base]/Organization?tiers-role=supplier&_count=50&_offset=100
```

---

## Voir aussi

- [Index](index.html) - Vue d'ensemble de l'Implementation Guide
- [TiersProfile](StructureDefinition-tiers-profile.html) - Profil de base Tiers
- [FournisseurProfile](StructureDefinition-fournisseur-profile.html) - Profil Fournisseur
- [DebiteurProfile](StructureDefinition-debiteur-profile.html) - Profil Débiteur
- [PayeurSanteProfile](StructureDefinition-payeur-sante-profile.html) - Profil Payeur Santé
- [Exemples](examples.html) - Exemples d'utilisation des recherches
