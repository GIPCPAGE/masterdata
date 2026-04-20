# Axe Nomenclatures — Terminologies

## Vue d'ensemble

**10 CodeSystems**, **74+ codes** pour qualifier les organisations tierces.

| Catégorie | Contenu |
|-----------|---------|
| **Classifications Tiers** | 10 CodeSystems CPage — natures juridiques, catégories, civilités, rôles, moyens de paiement… |
| **Nomenclatures géographiques** | Communes COG via TRE-R13 (ANS SMT) → [Données Géographiques COG](geographie.html) |

---

## Types d'Identifiants — 9 codes

| Code | Type | Juridiction |
|------|------|-------------|
| **01** | SIRET | France |
| **02** | SIREN | France |
| **03** | FINESS | Établissements de santé FR |
| **04** | NIR | Personnes physiques FR |
| **05** | TVA Intracommunautaire | Union Européenne |
| **06** | Identifiant interne CPage | — |
| **07** | RIDET | Nouvelle-Calédonie |
| **08** | Identifiant Tahiti | Polynésie française |
| **09** | Autre | Hors UE |

---

## Catégories d'Organisations — 24 codes

| Code | Catégorie | Exemples |
|------|-----------|----------|
| **00** | Catégorie inconnue | — |
| **01** | Personne physique | Médecin libéral, patient |
| **02** | Groupement de personnes physiques | Cabinet médical groupé |
| **10** | Établissement public médico-social | EHPAD public |
| **11** | Établissement privé médico-social | EHPAD privé |
| **20** | État | Ministère |
| **21** | Région | Conseil régional |
| **22** | Département | Conseil départemental |
| **23** | Commune | Mairie |
| **24** | Groupement de collectivités | Communauté de communes |
| **25** | Établissement public national | ANSM, HAS |
| **26** | Établissement public local (hors EPS) | SDIS, lycée public |
| **27** | Établissement Public de Santé (EPS) | CHU, hôpital public |
| **28** | Groupement de coopération sanitaire | GCS |
| **29** | Groupement de coopération sociale | GCSMS |
| **30** | Personne morale étrangère | Société hors France |
| **50** | Personne morale de droit privé | SA, SARL, SAS |
| **60** | Caisse SS régime général | CPAM |
| **61** | Caisse SS régime agricole | MSA |
| **62** | Caisse SS autre régime | CARSAT… |
| **63** | Mutuelle | MGEN, Mutuelle d'Alsace |
| **64** | Institution de prévoyance | Malakoff Humanis |
| **70** | Régime retraite complémentaire | AGIRC-ARRCO |
| **74** | Autre organisme | — |

---

## Natures Juridiques — 12 codes

| Code | Nature juridique | Exemples |
|------|-----------------|----------|
| **00** | Inconnue | — |
| **01** | Particulier | Médecin, patient |
| **02** | Artisan-Commerçant-Agriculteur | Professionnel libéral |
| **03** | Société | SA, SARL, SAS, GIE |
| **04** | CAM | Caisse Assurance Maladie |
| **05** | Caisse complémentaire | Mutuelle, prévoyance |
| **06** | Association | Association loi 1901 |
| **07** | État | Ministère, administration centrale |
| **08** | EPA ou EPIC | SNCF, EDF, CEA |
| **09** | Collectivité - EPS | Hôpital public, région, département |
| **10** | GCS | Groupement de coopération sanitaire |
| **11** | CAF | Caisse d'Allocations Familiales |

---

## Rôles — 3 codes

| Code | Rôle | Description |
|------|------|-------------|
| **supplier** | Fournisseur | Vend des biens ou services |
| **debtor** | Client | Achète des prestations |
| **payer** | Organisme payeur | Rembourse les soins |

---

## Types de Clients — 2 codes

| Code | Type |
|------|------|
| **N** | Normal — client régulier, compte permanent |
| **O** | Occasionnel — client ponctuel, transaction unique |

---

## Civilités — 5 codes

| Code | Civilité |
|------|----------|
| **M** | Monsieur |
| **MME** | Madame |
| **MLLE** | Mademoiselle |
| **DR** | Docteur |
| **PR** | Professeur |

---

## Localisations Géographiques — 3 codes

| Code | Localisation |
|------|-------------|
| **FR** | France (métropole + DROM) |
| **EU** | Union Européenne (hors France) |
| **HU** | Hors Union Européenne |

---

## Usages des Succursales — 3 codes

| Code | Usage |
|------|-------|
| **POINT_LIVRAISON** | Adresse de réception des marchandises |
| **FACTURATION** | Adresse d'envoi des factures |
| **SIEGE_SOCIAL** | Établissement secondaire autonome |

---

## Moyens de Paiement — 6 codes

| Code | Moyen |
|------|-------|
| **01** | Numéraire |
| **02** | Chèque |
| **03** | Virement bancaire standard |
| **04** | Virement application externe |
| **05** | Virement gros montant |
| **06** | Virement interne |

---

## Régimes d'Assurance — 5 codes

| Code | Régime | Description |
|------|--------|-------------|
| **SS** | Sécurité Sociale | Régime général obligatoire (CPAM, CNAM) |
| **MSA** | Mutualité Sociale Agricole | Régime agricole |
| **RSI** | Régime Social des Indépendants | Travailleurs indépendants (devenu SSI) |
| **CNAV** | Caisse Nationale d'Assurance Vieillesse | Retraite |
| **MUTUELLE** | Mutuelle complémentaire | Organisme mutualiste |

---

## Types d'Organismes Payeurs — 2 codes

| Code | Type |
|------|------|
| **RO** | Régime Obligatoire (CPAM, MSA, RSI) |
| **RC** | Régime Complémentaire (mutuelles, prévoyances) |

---

## Types de Résidents Fiscaux — 2 codes

| Code | Type |
|------|------|
| **R** | Résident (fiscalité française standard) |
| **NR** | Non-Résident (retenue à la source possible) |

---

## Règles de Cohérence

### Combinaisons Catégorie + Nature Juridique

| Catégorie | Nature juridique autorisée |
|-----------|---------------------------|
| **01** (Personne physique) | **00**, **01**, **02** |
| **20** (État) | **07** |
| **21-23** (Collectivités territoriales) | **09** |
| **27** (EPS) | **09** |
| **50** (Personne morale privé) | **03**, **06** |
| **60-62** (Caisses SS) | **04**, **05** |
| **63** (Mutuelle) | **05**, **06** |
| **65** ou **11** (CAF) | **11** |
| **70-71** (CNRACL, IRCANTEC) | **08** |

### Règle Civilité

Si **Catégorie = 01** (Personne physique) : Civilité + Prénom **OBLIGATOIRES**.

---

## Ressources FHIR

**CodeSystems** : [Identifiants](CodeSystem-tiers-identifier-type-cs.html) · [Catégories](CodeSystem-tiers-category-cs.html) · [Natures juridiques](CodeSystem-tiers-legal-nature-cs.html) · [Rôles](CodeSystem-tiers-role-cs.html) · [Types clients](CodeSystem-tiers-debtor-type-cs.html) · [Civilités](CodeSystem-tiers-civility-cs.html) · [Localisations](CodeSystem-tiers-address-localization-cs.html) · [Usages succursales](CodeSystem-succursale-usage-cs.html) · [Moyens paiement](CodeSystem-moyen-paiement-cs.html) · [Régimes](CodeSystem-grand-regime-cs.html) · [Types TG](CodeSystem-type-resident-cs.html)

**ValueSets** : [Identifiants](ValueSet-tiers-identifier-type-vs.html) · [Catégories](ValueSet-tiers-category-vs.html) · [Natures juridiques](ValueSet-tiers-legal-nature-vs.html) · [Rôles](ValueSet-tiers-role-valueset.html) · [Types clients](ValueSet-tiers-debtor-type-vs.html) · [Civilités](ValueSet-tiers-civility-vs.html) · [Localisations](ValueSet-tiers-address-localization-vs.html) · [Usages succursales](ValueSet-succursale-usage-vs.html) · [Moyens paiement](ValueSet-moyen-paiement-vs.html) · [Régimes](ValueSet-grand-regime-vs.html) · [Types TG](ValueSet-type-resident-vs.html)

---

## Voir aussi

- [Données Géographiques COG](geographie.html) — communes TRE-R13
- [Profils Tiers](tiers-organization.html) — profils utilisant ces classifications
- [Paramètres de Recherche](search-parameters.html) — recherche par catégorie, rôle…