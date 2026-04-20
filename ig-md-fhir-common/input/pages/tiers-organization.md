# Axe Concepts Métiers — Profils Tiers

## Vue d'ensemble

Cette page décrit l'**Axe Concepts Métiers** du guide d'implémentation : la modélisation des organisations tierces (fournisseurs, clients, organismes payeurs). Chaque tiers est représenté par une ressource FHIR **Organization** enrichie d'extensions métier.

Les nomenclatures géographiques (communes COG, TRE-R13) sont documentées dans les [Données Géographiques COG](geographie.html).

---

## Architecture des Profils

### Hiérarchie

```
Organization (Standard FHIR R4)
    ↓ hérite de
FR Core Organization (France officiel)
    ↓ hérite de
Organisation Tierce (profil de base)
    ↓ se spécialise en
    ├── Profil Fournisseur (suppliers)
    ├── Profil Client (debtors/buyers)
    └── Profil Payeur Santé (health insurance payers)
```

### Approche Multi-Rôles

**Une organisation = une seule fiche** avec plusieurs rôles possibles.

**Exemple** : Une clinique peut être à la fois :
- **Fournisseur** (vend des consultations)
- **Client** (achète des médicaments)

Au lieu de créer 2 fiches distinctes, on crée **1 fiche avec 2 rôles**.

---

## Extensions (19)

Les extensions métier enrichissent le profil de base `Organization` :

| Extension | Profil(s) | Description |
|-----------|-----------|-------------|
| `TiersRoleExtension` | Tiers | Rôle(s) de l'organisation (supplier / debtor / payer) |
| `TiersIdentifierTypeExtension` | Tiers | Type de l'identifiant principal (SIRET, FINESS, NIR…) |
| `TiersLegalNatureExtension` | Tiers | Nature juridique (SA, SARL, GCS, association…) |
| `TiersBankAccountExtension` | Tiers | Compte bancaire IBAN/BIC avec paramètres de paiement |
| `TiersPersonDetailsExtension` | Tiers | Civilité et prénom (personnes physiques) |
| `TiersAddressLocalizationExtension` | Tiers / Débiteur | Zone géographique (France, Europe, Autre) |
| `ChorusIdentifierTypeExtension` | Tiers | Type d'identifiant CHORUS (commande publique) |
| `TiersDebtorFlagsExtension` | Débiteur | Drapeaux débiteur (autorisations, centralisations…) |
| `TiersDebtorTypeExtension` | Débiteur | Type débiteur (Normal / Occasionnel) |
| `TiersCategoryExtension` | Tiers | Catégorie de l'organisation (codes 00-74 : personne physique, EPS, collectivité, organisme social…) |
| `TiersPublicAccountingCounterpartExtension` | Débiteur | Compte de contrepartie comptabilité publique |
| `TiersRegieCodeExtension` | Débiteur | Code régie (CHORUS, comptabilité publique) |
| `FournisseurCodeExtension` | Fournisseur | Code fournisseur CPage unique |
| `FournisseurComptabiliteExtension` | Fournisseur | Paramètres comptables (comptes classe 2/6) |
| `FournisseurPaiementExtension` | Fournisseur | Conditions de paiement (délai, escompte, EDI…) |
| `DebiteurCodeExtension` | Débiteur | Code débiteur CPage unique |
| `DebiteurParametresExtension` | Débiteur | Paramètres encaissement débiteur |
| `PayeurSanteExtension` | Payeur santé | Paramètres organisme payeur (code centre, régime…) |
| `SuccursaleUsageExtension` | Tiers | Usage de la succursale (livraison, facturation, siège) |

**[Voir tous les artifacts de conformité →](artifacts.html)**

---

## Profil de Base : Organisation Tierce

### Structure des Informations

#### 1. Identifiants Officiels

Plusieurs types d'identifiants selon la juridiction :

| Type | Exemple | Utilisation |
|------|---------|-------------|
| **SIRET** | 12345678901234 | Établissements en France (le plus courant) |
| **SIREN** | 123456789 | Entreprises françaises (9 chiffres) |
| **FINESS** | 750712184 | Établissements de santé et médico-sociaux |
| **NIR** | 123456789012345 | Personnes physiques (Sécurité Sociale) |
| **TVA UE** | DE123456789 | Fournisseurs Union Européenne |
| **Identifiant interne** | ETIER123456 | Référence interne au système |

**Règle** : Toujours renseigner au minimum un identifiant officiel (SIRET, FINESS, ou autre).

---

#### 2. Informations Générales

| Information | Obligatoire | Description | Exemple |
|-------------|-------------|-------------|---------|
| **Nom** | Oui | Raison sociale officielle | "Centre Hospitalier Universitaire de Paris" |
| **Alias** | Non | Nom commercial ou abrégé | "CHU Paris" |
| **Actif** | Non | Organisation active ou fermée | true / false |
| **Adresse** | Recommandé | Adresse du siège social | "1 Avenue de l'Hôpital, 75001 Paris" |
| **Téléphone** | Recommandé | Numéro principal | "01 40 12 34 56" |
| **Email** | Recommandé | Email de contact | "contact@chu-paris.fr" |
| **Site web** | Optionnel | URL du site | "https://www.chu-paris.fr" |

---

#### 3. Catégorisation

Chaque organisation doit être qualifiée par :

**a) Rôle(s) métier** - Obligatoire, peut être multiple

| Rôle | Signification |
|------|--------------|
| **Fournisseur** (supplier) | Fournit des biens ou services |
| **Client** (debtor) | Achète des biens ou services |
| **Payeur** (payer) | Rembourse les soins (CPAM, mutuelles) |

**b) Catégorie d'organisation** - Optionnelle mais recommandée

| Catégorie | Exemples |
|-----------|----------|
| Personne physique | Médecin libéral, patient |
| Établissement Public de Santé (EPS) | CHU, hôpital public |
| Personne morale de droit privé | Société, entreprise |
| Caisse Sécurité Sociale | CPAM, MSA |
| Mutuelle | MGEN, Mutuelle d'Alsace |

**c) Nature juridique** - Optionnelle

| Nature juridique | Exemples |
|-----------------|----------|
| Société | SA, SARL, SAS |
| Association | Association loi 1901 |
| Collectivité - EPS | Hôpital public, région, département |
| CAM | Caisse Assurance Maladie |

Voir [Classifications et nomenclatures](terminologies.html) pour la liste complète.

---

#### 4. Coordonnées Bancaires

**Information critique** pour les paiements et règlements.

##### Formats acceptés

**Format français (RIB)** : 4 informations requises ensemble
- Code banque (5 chiffres)
- Code guichet (5 chiffres)
- Numéro de compte (11 caractères)
- Clé RIB (2 chiffres)

**Format international (IBAN + BIC)** :
- IBAN : FR7630002005500000012345611 (34 caractères max)
- BIC/SWIFT : SOGEFRPPXXX (11 caractères max)

##### Règles métier

- **Fournisseurs** : Coordonnées bancaires recommandées (pour virements)
- **Clients** : Coordonnées bancaires **obligatoires** (pour recevoir paiements)
- **Payeurs** : Pas de coordonnées bancaires (ne communiquent pas leur RIB)

##### Multi-comptes

Une organisation peut avoir **plusieurs comptes bancaires** :
- Compte principal (virements standards)
- Compte secondaire (gros montants, opérations spécifiques)

**Exemple** : Un hôpital avec un compte pour les règlements fournisseurs et un autre pour les recettes patients.

---

## Profils Spécialisés

### 1. Profil Fournisseur (Supplier)

**Utilisation** : Entreprises et établissements qui fournissent des biens ou services.

#### Informations supplémentaires

**Code fournisseur** : Référence unique dans le système (ex: "FRSUP123456")

**Paramètres comptables** :
- Compte de gestion (comptabilité analytique)
- Compte classe 2 (immobilisations)
- Compte classe 6 (charges)

**Conditions de paiement** :
- Délai de règlement (ex: 60 jours)
- Jour de paiement (ex: le 10 du mois)
- Montant minimum (ex: factures ≥ 1000 €)

**Options bancaires** :
- **EDI** (Échange de Données Informatisé) : automatisation virements
- **Affacturage** : cession de créances à un organisme financier
- **Moyens de paiement acceptés** : virement, chèque, espèces

#### Cas d'usage

**Laboratoire pharmaceutique** : Fournit des médicaments, délai de paiement 60 jours, virement SEPA uniquement.

---

### 2. Profil Client (Debtor)

**Utilisation** : Organisations qui achètent des biens ou services.

#### Informations supplémentaires

**Code client** : Référence unique (ex: "DEBCHU0001")

**Type de client** :
- **Normal** : Client régulier, compte permanent
- **Occasionnel** : Client ponctuel, transaction unique

**Résidence fiscale** :
- **Résident** (France) : TVA et fiscalité française standard
- **Non-résident** : Obligation de retenue à la source possible

**Paramètres** :
- Compte de gestion comptable
- Autorisation assurances (paiement direct mutuelles)
- Centralisation des commandes (achats groupés)

**Localisation géographique** :
- **France** : Métropole et DROM
- **Europe** : Union Européenne hors France
- **Autre** : Hors UE

⚠️ **Coordonnées bancaires OBLIGATOIRES** (pour recevoir les paiements)

#### Cas d'usage

**CHU acheteur** : Achète des équipements, compte permanent (Normal), résident fiscal français, autorise paiements directs mutuelles.

---

### 3. Profil Payeur Santé (Health Insurance Payer)

**Utilisation** : Organismes qui remboursent les prestations de soins (CPAM, mutuelles).

#### Informations supplémentaires

**Type de payeur** :
- **RO** (Régime Obligatoire) : Sécurité Sociale, MSA, RSI
- **RC** (Régime Complémentaire) : Mutuelles, prévoyances

**Identification organisme** :
- Code centre (ex: 750 = Paris)
- Numéro caisse (ex: 75001)
- Numéro organisme national (ex: 007501)

**Régime d'assurance** :
- Sécurité Sociale (SS)
- Mutualité Sociale Agricole (MSA)
- Régime Social des Indépendants (RSI)
- Caisse Nationale d'Assurance Vieillesse (CNAV)
- Mutuelle complémentaire (MUTUELLE)

**Paramètres** :
- **Délai de prise en charge** : 90 jours (CPAM), 60 jours (mutuelles)
- **Éclatement des factures** : oui/non (facturation détaillée par acte)

⚠️ **Pas de coordonnées bancaires** (les payeurs ne communiquent pas leur RIB)

#### Cas d'usage

**CPAM** : Régime Obligatoire, Sécurité Sociale, délai 90 jours, pas d'éclatement factures.  
**MGEN** : Régime Complémentaire, Mutuelle, délai 60 jours, éclatement factures activé.

---

## Cas Particuliers

### Organisations Multi-Rôles

**Problème** : Une clinique vend des consultations (fournisseur) ET achète des médicaments (client). Faut-il créer 2 fiches ?

**Réponse** : NON. Créer **une seule fiche** avec **2 rôles** : supplier + debtor.

**Avantages** :
- Pas de duplication d'informations (adresse, contacts, identifiants)
- Historique unique de toutes les transactions
- Gestion simplifiée des relations commerciales

**Exemple concret** :

```
Clinique du Parc
├── Rôle 1 : Fournisseur
│   ├── Code fournisseur : FRSUP999
│   └── Conditions paiement : 60 jours
└── Rôle 2 : Client
    ├── Code client : DEBCLP001
    └── Type : Normal (compte permanent)
```

---

### Succursales et Sites Secondaires

**Principe** : Chaque site est une ressource `Organization` distincte. La succursale référence son siège via `partOf`. Le siège n'a pas à lister ses succursales.

#### Pourquoi deux ressources séparées ?

- Chaque établissement au sens INSEE a son propre **SIRET** (même SIREN, NIC différent)
- La succursale peut avoir sa propre adresse, ses propres contacts, son propre RIB
- La relation `partOf` est une **référence entre ressources** (résolvable via l'API), pas un héritage de profil

#### Structure pour un fournisseur avec dépôt de livraison

```
Laboratoires Durand SA (siège — Toulouse)
│   SIREN : 425123456
│   codeFournisseur : FRNSLPD000
│
└── Dépôt Paris Nord (succursale)
    SIRET : 42512345600026  (même SIREN, NIC différent)
    codeFournisseur : FRNSLPDPN1
    succursaleUsage : POINT_LIVRAISON + FACTURATION
    partOf → Laboratoires Durand SA
```

#### Ressource siège (simplifié)

```json
{
  "resourceType": "Organization",
  "id": "fournisseur-siege",
  "identifier": [
    { "system": "https://sirene.fr", "value": "425123456" }
  ],
  "name": "Laboratoires Durand SA",
  "extension": [
    { "url": ".../tiers-role-extension", "valueCoding": { "code": "supplier" } }
  ]
}
```

#### Ressource succursale (simplifié)

```json
{
  "resourceType": "Organization",
  "id": "fournisseur-succursale-paris",
  "identifier": [
    { "system": "https://sirene.fr", "value": "42512345600026" }
  ],
  "name": "Laboratoires Durand SA — Dépôt Paris Nord",
  "address": [{
    "line": ["55 Avenue du Président Wilson", "Entrepôt B2"],
    "city": "La Plaine Saint-Denis",
    "postalCode": "93210",
    "country": "FR"
  }],
  "partOf": {
    "reference": "Organization/fournisseur-siege",
    "display": "Laboratoires Durand SA (Siège — Toulouse)"
  },
  "extension": [
    { "url": ".../tiers-role-extension", "valueCoding": { "code": "supplier" } },
    { "url": ".../succursale-usage-extension", "valueCode": "POINT_LIVRAISON" },
    { "url": ".../succursale-usage-extension", "valueCode": "FACTURATION" },
    { "url": ".../fournisseur-code", "valueString": "FRNSLPDPN1" }
  ]
}
```

**Usages possibles** (`succursaleUsage`) :
- **POINT_LIVRAISON** : Adresse de réception des marchandises
- **FACTURATION** : Adresse d'envoi des factures / facturation locale
- **SIEGE_SOCIAL** : Siège social secondaire

**[Voir l'exemple complet FSH →](Organization-ExempleFournisseurSuccursale.html)**

> **Important** : `partOf` est résolvable par l'API (`GET Organization/[id-siege]`). Il suffit d'une référence depuis la succursale vers le siège ; il n'est pas nécessaire de lister les succursales dans la ressource siège.

---

### Personnes Physiques

**Utilisation** : Médecins libéraux, patients, artisans.

**Spécificités** :
- **Civilité OBLIGATOIRE** : M, MME, MLLE, etc.
- **Prénom OBLIGATOIRE** : "Jean", "Marie", etc.
- **Catégorie** : Personne physique (01)
- **Nature juridique** : Particulier (01) ou Artisan-Commerçant-Agriculteur (02)
- **Identifiant** : NIR (Numéro Sécurité Sociale, 15 caractères)

**Exemple** : Dr Jean Dupont, médecin libéral
```
Nom : Monsieur Jean Dupont
Civilité : M
Prénom : Jean
Catégorie : Personne physique (01)
Nature juridique : Artisan-Commerçant-Agriculteur (02)
NIR : 123456789012345
```

---

### Organisations Étrangères

#### Union Européenne

**Identifiant** : TVA intracommunautaire (ex: DE123456789 pour Allemagne)  
**IBAN** : Format pays UE (ex: DE89...)  
**Fiscalité** : Autoliquidation TVA par l'acheteur français

**Exemple** : MedTech Solutions GmbH (Allemagne)
```
TVA UE : DE123456789
Pays : DE (Allemagne)
IBAN : DE89370400440532013000
```

#### Hors Union Européenne

**Identifiant** : Selon pays (Swiss UID, US TIN, etc.)  
**Fiscalité** : Réglementations internationales spécifiques

**Pays spécifiques gérés** :
- **Polynésie Française** : Identifiant Tahiti (DGEN/ISPF)
- **Nouvelle-Calédonie** : RIDET (7 caractères)

---

## Règles de Cohérence

### 1. Combinaisons Catégorie + Nature Juridique

Certaines combinaisons sont **obligatoires** pour maintenir la cohérence :

| Catégorie | Nature juridique autorisée |
|-----------|---------------------------|
| Personne physique | Particulier, Artisan-Commerçant-Agriculteur |
| EPS (Hôpital public) | Collectivité - EPS |
| Personne morale privé | Société, Association |
| Caisse Sécurité Sociale | CAM, Caisse complémentaire |
| Mutuelle | Caisse complémentaire, Association |

Voir [Classifications - Règles de cohérence](terminologies.html#règles-de-cohérence) pour la liste complète.

---

### 2. Identifiants Selon Type d'Organisation

| Type d'organisation | Identifiant obligatoire |
|---------------------|------------------------|
| Personne physique | NIR (15 caractères) |
| Établissement de santé | FINESS (9 caractères) |
| Entreprise française | SIRET (14 chiffres) ou SIREN (9 chiffres) |
| Fournisseur UE | TVA intracommunautaire |

---

### 3. Civilité et Prénom

**SI** Catégorie = Personne physique  
**ALORS** Civilité + Prénom **OBLIGATOIRES**

**SINON** (organisation)  
**ALORS** Civilité + Prénom **OMIS**

---

## Exemples Complets

### Exemple 1 : Hôpital Public Fournisseur

```
Nom : Centre Hospitalier Universitaire de Paris
Alias : CHU Paris
Identifiant SIRET : 12345678901234
Identifiant FINESS : 750712184

Rôle : Fournisseur (supplier)
Catégorie : Établissement Public de Santé (27)
Nature juridique : Collectivité - EPS (09)

Adresse : 1 Avenue de l'Hôpital, 75001 Paris, France
Téléphone : 01 40 12 34 56
Email : contact@chu-paris.fr

Coordonnées bancaires :
- IBAN : FR7630002005500000012345611
- BIC : SOGEFRPPXXX
```

---

### Exemple 2 : Entreprise Pharmaceutique Multi-Rôles

```
Nom : Laboratoires Pharmaceutiques Durand
Alias : LPD SA
Identifiant SIRET : 42512345600018

Rôles : Fournisseur (supplier) + Client (debtor)
Catégorie : Personne morale de droit privé (50)
Nature juridique : Société (03)

Code fournisseur : FRSUP123456
Délai paiement : 60 jours
Moyens paiement : Virement, Virement externe

Code client : DEBLPD001
Type client : Normal (régulier)
Résidence fiscale : Résident (France)

Coordonnées bancaires : (multiples)
Compte 1 (principal) : FR7612345678901234567890123
Compte 2 (numéraire) : FR7698765432109876543210987
```

---

### Exemple 3 : CPAM (Organisme Payeur)

```
Nom : Caisse Primaire d'Assurance Maladie de Paris
Alias : CPAM Paris
Identifiant FINESS : 750000001

Rôle : Payeur (payer) uniquement
Catégorie : Caisse Sécurité Sociale régime général (60)
Nature juridique : CAM (04)

Type payeur : RO (Régime Obligatoire)
Régime : Sécurité Sociale (SS)
Code centre : 750
Numéro caisse : 75001
Numéro organisme : 007501

Délai prise en charge : 90 jours
Éclatement factures : Non

⚠️ Pas de coordonnées bancaires (non communiquées)
```

---

## Liens Utiles

### Documentation des Profils

- [Profil Organisation Tierce](StructureDefinition-tiers-profile.html) - Profil de base
- [Profil Fournisseur](StructureDefinition-fournisseur-profile.html) - Spécialisation supplier
- [Profil Client](StructureDefinition-debiteur-profile.html) - Spécialisation debtor
- [Profil Payeur Santé](StructureDefinition-payeur-sante-profile.html) - Spécialisation payer

### Voir Aussi

- [Guide d'implémentation](index.html) - Vue d'ensemble du référentiel
- [Classifications et nomenclatures](terminologies.html) - Tous les codes et catégories
- [Exemples d'utilisation](examples.html) - Cas concrets détaillés
- [Rechercher dans le référentiel](search-parameters.html) - Critères de recherche
