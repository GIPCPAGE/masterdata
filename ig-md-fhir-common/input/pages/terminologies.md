# Axe Nomenclatures — Terminologies

## Vue d'ensemble

Cette page documente les **classifications et nomenclatures** utilisées pour qualifier les organisations tierces (fournisseurs, clients, organismes payeurs). Ces codes permettent de structurer les informations selon des critères métier standardisés.

Ce guide expose deux catégories de terminologies :

| Catégorie | Description | Lien |
|-----------|-------------|------|
| **Classifications** | 10 CodeSystems internes CPage — natures juridiques, catégories, civilités, rôles… | Cette page |
| **Nomenclatures géographiques** | Communes françaises COG via TRE-R13 (ANS SMT), NamingSystems INSEE | [Données Géographiques COG](geographie.html) |

Le référentiel utilise **10 classifications** regroupant **74+ codes** pour caractériser les fournisseurs, clients et organismes payeurs.

---

## Navigation

- [Types d'Identifiants](#types-didentifiants---9-codes)
- [Catégories d'Organisations](#catégories-dorganisations---24-codes)
- [Natures Juridiques](#natures-juridiques---12-codes)
- [Rôles](#rôles---3-codes)
- [Types de Clients](#types-de-clients---2-codes)
- [Civilités](#civilités---5-codes)
- [Localisations Géographiques](#localisations-géographiques---3-codes)
- [Usages des Succursales](#usages-des-succursales---3-codes)
- [Moyens de Paiement](#moyens-de-paiement---6-codes)
- [Régimes d'Assurance](#régimes-dassurance---5-codes)
- [Types d'Organismes Payeurs](#types-dorganismes-payeurs---2-codes)
- [Types de Résidents Fiscaux](#types-de-résidents-fiscaux---2-codes)

---

## Types d'Identifiants - 9 codes

### Description

Les différents **types d'identifiants** utilisés pour identifier officiellement les organisations selon leur juridiction.

### Codes

| Code | Type d'identifiant | Longueur | Juridiction | Description |
|------|-------------------|----------|-------------|-------------|
| **01** | SIRET | 14 chiffres | France | Identifiant établissement (9 SIREN + 5 NIC) |
| **02** | SIREN | 9 chiffres | France | Identifiant entreprise unique |
| **03** | FINESS | 9 caractères | France | Identifiant établissements de santé et médico-sociaux |
| **04** | NIR | 15 caractères | France | Numéro Sécurité Sociale (personnes physiques uniquement) |
| **05** | TVA Intracommunautaire | Variable | Union Européenne | Numéro TVA hors France (ex: DE123456789) |
| **06** | Hors UE | Variable | International | Identifiant fiscal pays hors Europe (ex: Swiss UID, US TIN) |
| **07** | Tahiti | Variable | Polynésie Française | Identifiant Tahiti (DGEN/ISPF) |
| **08** | RIDET | 7 caractères | Nouvelle-Calédonie | Répertoire d'Identification des Entreprises et des Établissements |
| **09** | En cours d'immatriculation | - | Provisoire | Organisme en attente d'immatriculation officielle |

### Utilisation pratique

**Recherche d'une organisation** : Utiliser le SIRET en priorité (le plus fiable)  
**Établissements de santé** : FINESS obligatoire  
**Fournisseurs européens** : TVA intracommunautaire  
**Personnes physiques** : NIR (médecins libéraux, patients)

---

## Catégories d'Organisations - 24 codes

### Description

Classification des organisations par **secteur d'activité** et **statut** : administration publique, santé, organismes sociaux, retraite, secteur privé.

### Codes par secteur

#### Inconnu / Générique

| Code | Catégorie | Exemples |
|------|-----------|----------|
| **00** | Catégorie inconnue | Non renseigné |
| **01** | Personne physique | Patient, médecin libéral, individu |
| **50** | Personne morale de droit privé | Entreprise, société commerciale, SARL, SA |

#### État et Collectivités Territoriales (20-29)

| Code | Catégorie | Exemples |
|------|-----------|----------|
| **20** | État | Ministère de la Santé, Préfecture |
| **21** | Région | Conseil Régional Île-de-France |
| **22** | Département | Conseil Départemental Val-de-Marne |
| **23** | Commune | Mairie de Paris, Commune de Lyon |
| **24** | CCAS | Centre Communal d'Action Sociale |
| **25** | Autre établissement public local | EPL hors santé |
| **26** | Centre de rééducation fonctionnelle | CRF spécialisé |
| **27** | Établissement public de santé (EPS) | CHU, Hôpital public |
| **28** | École nationale de santé publique | ENSP, école formation |
| **29** | Autre établissement public de l'État | EPA, EPIC |

#### Organismes Sociaux et Assurance Maladie (60-65)

| Code | Catégorie | Exemples |
|------|-----------|----------|
| **60** | Caisse Sécurité Sociale régime général | CPAM, CNAM |
| **61** | Caisse Sécurité Sociale régime agricole | MSA (Mutualité Sociale Agricole) |
| **62** | Caisse travailleurs non-salariés | TNS, RSI |
| **63** | Mutuelle | MGEN, Mutuelle d'Alsace |
| **64** | Tiers payant | Organisme tiers payant |
| **65** | Autres organismes sociaux | CAF, autres |

#### Organismes de Retraite et Emploi (70-74)

| Code | Catégorie | Exemples |
|------|-----------|----------|
| **70** | CNRACL | Caisse Nationale de Retraite des Agents des Collectivités Locales |
| **71** | IRCANTEC | Retraite Complémentaire Agents Non Titulaires |
| **72** | ASSEDIC | Pôle Emploi (ancien nom) |
| **73** | Caisses mutuelles retraite | Caisses mutuelles |
| **74** | Autres organismes de retraite | Autres régimes |

### Utilisation pratique

**Recherche par secteur** :
- Tous les hôpitaux publics : code **27**
- Toutes les mutuelles : code **63**
- Toutes les entreprises privées : code **50**

**Combinaison avec nature juridique** : Certaines combinaisons sont obligatoires (voir section [Règles de Cohérence](#règles-de-cohérence))

---

## Natures Juridiques - 12 codes

### Description

Classification selon le **statut juridique** de l'organisation : société, association, établissement public, etc.

### Codes

| Code | Nature juridique | Description | Exemples |
|------|-----------------|-------------|----------|
| **00** | Inconnue | Non renseignée | - |
| **01** | Particulier | Personne physique | Patient individuel |
| **02** | Artisan-Commerçant-Agriculteur | Personne physique professionnelle | Médecin libéral, auto-entrepreneur |
| **03** | Société | Personne morale de droit privé | SA, SARL, SAS, EURL, SCI |
| **04** | Caisse Assurance Maladie | Organisme Sécurité Sociale | CPAM locale |
| **05** | Caisse complémentaire | Organisme complémentaire santé | Mutuelle, surcomplémentaire |
| **06** | Association | Association loi 1901 | Association humanitaire, sportive |
| **07** | État | Services de l'État | Ministères, services centraux |
| **08** | EPA ou EPIC | Établissement Public Administratif ou Industriel | France Télévisions, SNCF |
| **09** | Collectivité territoriale - Établissement public local ou de santé | Collectivités et EPS | Région, Département, Hôpital public |
| **10** | État étranger - Ambassade | Représentations diplomatiques | Ambassade, Consulat |
| **11** | CAF | Caisse d'Allocations Familiales | CAF départementale |

### Utilisation pratique

**Hôpital public** : Nature juridique **09** (Collectivité - EPS)  
**Entreprise privée** : Nature juridique **03** (Société)  
**Mutuelle** : Nature juridique **05** (Caisse complémentaire)  
**Association** : Nature juridique **06** (Association loi 1901)

---

## Rôles - 3 codes

### Description

Les **rôles métier** d'une organisation dans le référentiel. Une organisation peut avoir plusieurs rôles simultanément.

### Codes

| Code | Rôle | Description |
|------|------|-------------|
| **supplier** | Fournisseur | Fournit des biens ou services (pharmaceutiques, équipements, prestations) |
| **debtor** | Client | Achète des biens ou services |
| **payer** | Organisme payeur | Rembourse les prestations de soins (CPAM, mutuelles) |

### Utilisation pratique

**Multi-rôle** : Une organisation peut être à la fois fournisseur ET client (ex: clinique qui vend et achète)  
**Recherche** : Trouver toutes les organisations fournisseurs : `?tiers-role=supplier`  
**Organismes payeurs** : Uniquement rôle "payer", pas fournisseur ni client

---

## Types de Clients - 2 codes

### Description

Classification de la **fréquence des transactions** avec un client.

### Codes

| Code | Type | Description | Utilisation |
|------|------|-------------|-------------|
| **O** | Occasionnel | Client ponctuel, transaction unique ou rare | Patient externe unique, prestation exceptionnelle |
| **N** | Normal | Client régulier, transactions récurrentes | Organisme social, entreprise partenaire permanent |

### Utilisation pratique

**Client occasionnel** : Compte temporaire, un seul achat  
**Client normal** : Compte permanent, achats réguliers, conventions établies

---

## Civilités - 5 codes

### Description

Civilités pour les **personnes physiques uniquement** (catégorie 01).

### Codes

| Code | Civilité | Utilisation |
|------|----------|-------------|
| **M** | Monsieur | Personne de sexe masculin |
| **MME** | Madame | Personne de sexe féminin |
| **MLLE** | Mademoiselle | Jeune femme non mariée (usage traditionnel) |
| **METMME** | Monsieur et Madame | Couple (compte joint, courrier commun) |
| **MOUMME** | Monsieur ou Madame | Indéterminé ou neutre |

### Règle

**Obligatoire** si Catégorie = 01 (Personne physique)  
**Omis** si organisation (catégories 20-29, 50, 60-74)

---

## Localisations Géographiques - 3 codes

### Description

Zone géographique de l'adresse d'une organisation.

### Codes

| Code | Localisation | Description | Pays ISO 3166 |
|------|-------------|-------------|---------------|
| **FRANCE** | France | Métropole et DROM | FR |
| **EUROPE** | Europe | Union Européenne hors France | AT, BE, DE, ES, IT, etc. |
| **AUTRE** | Autre | Hors Union Européenne | Suisse, USA, Japon, etc. |

### Utilisation pratique

**Fiscalité** : Impacte la TVA et les obligations déclaratives  
**France** : TVA française standard  
**Europe** : TVA intracommunautaire, autoliquidation  
**Autre** : Réglementations internationales, retenue à la source possible

---

## Usages des Succursales - 3 codes

### Description

Qualification de l'**usage métier** d'un site secondaire (succursale).

### Codes

| Code | Usage | Description |
|------|-------|-------------|
| **POINT_LIVRAISON** | Point de livraison | Adresse de réception des marchandises |
| **FACTURATION** | Facturation | Adresse d'envoi des factures |
| **SIEGE_SOCIAL** | Siège social | Succursale correspondant au siège social |

### Utilisation pratique

**Multisite** : Un hôpital avec plusieurs campus définit l'usage de chaque site  
**Exemple** : Campus principal = Facturation + Siège social, Campus annexe = Point de livraison

---

## Moyens de Paiement - 6 codes

### Description

Moyens de paiement acceptés par un fournisseur ou utilisés pour les paiements sortants.

### Codes

| Code | Moyen | Description |
|------|-------|-------------|
| **NUMERAIRE** | Numéraire | Paiement en espèces (rare, montants limités) |
| **CHEQUE** | Chèque | Paiement par chèque bancaire |
| **VIREMENT** | Virement bancaire | Virement bancaire standard (SEPA) |
| **VIREMENT_APPLI_EXT** | Virement application externe | Virement via une application de paiement externe |
| **VIREMENT_GROS_MONTANT** | Virement gros montant | Virement pour montants importants nécessitant validation spéciale |
| **VIREMENT_INTERNE** | Virement interne | Virement entre comptes internes de l'organisation |

### Utilisation pratique

**Standard France/UE** : Virement bancaire SEPA (code **VIREMENT**)  
**Gros montants** : Validation spécifique requise (code **VIREMENT_GROS_MONTANT**)  
**Applications tierces** : Paiement via outil externe (code **VIREMENT_APPLI_EXT**)

---

## Régimes d'Assurance - 5 codes

### Description

Classification des **régimes de protection sociale** pour les organismes payeurs.

### Codes

| Code | Régime | Description | Exemples |
|------|--------|-------------|----------|
| **SS** | Sécurité Sociale générale | Régime général obligatoire | CPAM, CNAM |
| **MSA** | Mutualité Sociale Agricole | Régime agricole | MSA départementale |
| **RSI** | Régime Social des Indépendants | Travailleurs indépendants | RSI (devenu SSI) |
| **CNAV** | Caisse Nationale d'Assurance Vieillesse | Régime retraite | CNAV |
| **MUTUELLE** | Mutuelle complémentaire | Organisme complémentaire mutualiste | MGEN, Mutuelle d'Alsace |

### Utilisation pratique

**Ordre de remboursement** :
1. Régime obligatoire (**SS**, **MSA**, **RSI**) en premier
2. Régime complémentaire (**MUTUELLE**) ensuite

**Tiers-payant intégral** : Cumul régime obligatoire + complémentaire = 0 € reste à charge patient

---

## Types d'Organismes Payeurs - 2 codes

### Description

Classification des organismes payeurs selon qu'ils sont **obligatoires** ou **complémentaires**.

### Codes

| Code | Type | Description | Exemples |
|------|------|-------------|----------|
| **RO** | Régime Obligatoire | Assurance maladie de base (obligatoire pour tous) | CPAM, MSA, RSI |
| **RC** | Régime Complémentaire | Assurance complémentaire (volontaire) | Mutuelles, prévoyances |

### Utilisation pratique

**Facturation** : Envoyer d'abord au RO, puis au RC  
**Tiers-payant** : RO rembourse en premier, RC complète  
**Recherche** : Lister tous les régimes obligatoires : `?payeur-type=RO`

---

## Types de Résidents Fiscaux - 2 codes

### Description

Statut de **résidence fiscale** d'une organisation pour les obligations déclaratives.

### Codes

| Code | Type | Description | Obligations |
|------|------|-------------|-------------|
| **R** | Résident | Résidence fiscale en France | Déclaration fiscale française standard |
| **NR** | Non-Résident | Résidence fiscale hors France | Retenue à la source possible |

### Utilisation pratique

**Fiscalité** :  
- **Résident** : TVA et impôts selon régime français  
- **Non-résident** : Obligation de retenue à la source sur certains paiements

**Recherche** : Identifier tous les non-résidents : `?debiteur-type-resident=NR`

---

## Règles de Cohérence

### Combinaisons Catégorie + Nature Juridique

Certaines combinaisons de **Catégorie d'organisation** et **Nature juridique** sont obligatoires pour maintenir la cohérence des données.

| Catégorie | Nature juridique autorisée |
|-----------|---------------------------|
| **01** (Personne physique) | **00** (Inconnue), **01** (Particulier), **02** (Artisan-Commerçant-Agriculteur) |
| **20** (État) | **07** (État) |
| **21-23** (Région, Département, Commune) | **09** (Collectivité territoriale) |
| **27** (EPS - Hôpital public) | **09** (Collectivité - EPS) |
| **50** (Personne morale privé) | **03** (Société), **06** (Association) |
| **60-62** (Caisses Sécurité Sociale) | **04** (CAM), **05** (Caisse complémentaire) |
| **63** (Mutuelle) | **05** (Caisse complémentaire), **06** (Association) |
| **65** ou **11** (CAF) | **11** (CAF) |
| **70-71** (CNRACL, IRCANTEC) | **08** (EPA ou EPIC) |

### Règle Civilité

**Si Catégorie = 01** (Personne physique) :
- ✅ **Civilité OBLIGATOIRE** (M, MME, MLLE, etc.)
- ✅ **Prénom OBLIGATOIRE**

**Sinon** (Organisation) :
- ❌ **Civilité et Prénom OMIS**

---

## Exemples d'Utilisation

### Exemple 1 : Hôpital Public

```
Catégorie : 27 (EPS)
Nature juridique : 09 (Collectivité - EPS)
Rôle : supplier + debtor (fournit et achète)
Identifiant : FINESS (03)
```

### Exemple 2 : Mutuelle Complémentaire

```
Catégorie : 63 (Mutuelle)
Nature juridique : 05 (Caisse complémentaire)
Rôle : payer (uniquement)
Régime : MUTUELLE
Type payeur : RC (Régime Complémentaire)
```

### Exemple 3 : Entreprise Pharmaceutique

```
Catégorie : 50 (Personne morale privé)
Nature juridique : 03 (Société)
Rôle : supplier (fournisseur)
Identifiant : SIRET (01)
```

### Exemple 4 : Médecin Libéral

```
Catégorie : 01 (Personne physique)
Nature juridique : 02 (Artisan-Commerçant-Agriculteur)
Rôle : supplier (prestations médicales)
Identifiant : NIR (04)
Civilité : M (Monsieur)
Prénom : Jean
```

---

## Liens vers Ressources Techniques

### CodeSystems (définitions)

- [Types d'identifiants](CodeSystem-tiers-identifier-type-cs.html)
- [Catégories d'organisations](CodeSystem-tiers-category-cs.html)
- [Natures juridiques](CodeSystem-tiers-legal-nature-cs.html)
- [Rôles](CodeSystem-tiers-role-cs.html)
- [Types de clients](CodeSystem-tiers-debtor-type-cs.html)
- [Civilités](CodeSystem-tiers-civility-cs.html)
- [Localisations géographiques](CodeSystem-tiers-address-localization-cs.html)
- [Usages des succursales](CodeSystem-succursale-usage-cs.html)
- [Moyens de paiement](CodeSystem-moyen-paiement-cs.html)
- [Régimes d'assurance](CodeSystem-grand-regime-cs.html)
- [Types de résidents fiscaux](CodeSystem-type-resident-cs.html)

### ValueSets (ensembles de valeurs)

- [Types d'identifiants VS](ValueSet-tiers-identifier-type-vs.html)
- [Catégories d'organisations VS](ValueSet-tiers-category-vs.html)
- [Natures juridiques VS](ValueSet-tiers-legal-nature-vs.html)
- [Rôles VS](ValueSet-tiers-role-valueset.html)
- [Types de clients VS](ValueSet-tiers-debtor-type-vs.html)
- [Civilités VS](ValueSet-tiers-civility-vs.html)
- [Localisations géographiques VS](ValueSet-tiers-address-localization-vs.html)
- [Usages des succursales VS](ValueSet-succursale-usage-vs.html)
- [Moyens de paiement VS](ValueSet-moyen-paiement-vs.html)
- [Régimes d'assurance VS](ValueSet-grand-regime-vs.html)
- [Types de résidents fiscaux VS](ValueSet-type-resident-vs.html)

---

## Voir Aussi

- [Données Géographiques COG](geographie.html) - Communes françaises TRE-R13 (Axe Nomenclatures géographiques)
- [Profils Tiers](tiers-organization.html) - Profils Organization utilisant ces classifications
- [Paramètres de Recherche](search-parameters.html) - Recherches par catégorie, rôle, régime…
- [Exemples](examples.html) - Instances concrètes avec les classifications
