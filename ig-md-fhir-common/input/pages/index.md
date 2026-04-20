# Guide d'Implémentation FHIR - Référentiel Commun CPage MasterData

**Version**: 0.1.0 | **Date**: 17 mars 2026 | **Statut**: Draft

## Bienvenue

Ce **Guide d'Implémentation FHIR** définit les ressources communes pour deux axes complémentaires :

1. **Tiers** — profiler et échanger les données sur les organisations tierces (fournisseurs, clients, organismes payeurs) dans le secteur hospitalier français, modélisés comme des ressources `Organization` enrichies d'extensions métier.
2. **Nomenclatures géographiques** — exposer les communes françaises du Code Officiel Géographique (COG/INSEE) via la terminologie nationale **TRE-R13** de l'ANS, sous forme de `CodeSystem`, `ValueSet` et `NamingSystem` FHIR standard.

Ce guide est **interopérable**, basé sur le **standard national FR Core 2.1.0** (HL7 France) et s'appuie sur les référentiels nationaux de l'ANS.

---

## Périmètre

### Axe 1 — Ressources : Tiers

Un **tiers** est toute organisation avec laquelle un établissement de santé est en relation commerciale ou administrative.

| Type d'organisation | Description | Exemples |
|---------------------|-------------|----------|
| **Fournisseurs** | Vendent des biens ou services à l'établissement | Laboratoires, équipementiers médicaux, prestataires |
| **Clients/Débiteurs** | Achètent des prestations à l'établissement | Autres hôpitaux, EHPAD, cabinets médicaux |
| **Organismes payeurs** | Remboursent les soins aux patients | CPAM, MSA, mutuelles, assurances complémentaires |
| **Succursales** | Sites secondaires rattachés à une organisation principale | Annexes, sites de livraison, adresses de facturation |

### Axe 2 — Nomenclatures

| Nomenclature | Type FHIR | Description |
|-------------|-----------|-------------|
| **Communes COG (TRE-R13)** | `CodeSystem` + `ValueSet` | Code Officiel Géographique INSEE — communes actives et historique complet |
| **NamingSystem COG** | `NamingSystem` | OID `1.2.250.1.213.2.12` et URI officiels ANS |
| **Classifications** | `CodeSystem` × 10 | Natures juridiques, catégories, civilités, rôles, moyens de paiement… |

> **Note** : Les autres référentiels (personnels soignants, patients, structures internes, produits, actes) seront ajoutés dans les prochaines versions.

## Objectifs

✅ **Modéliser** les tiers (fournisseurs, clients, payeurs) en FHIR R4, basé sur FR Core  
✅ **Identifier** un même tiers dans différents systèmes (SIRET, FINESS, TVA, RIDET…)  
✅ **Rechercher** rapidement via 10 critères REST  
✅ **Gérer les multi-rôles** : une même organisation peut être à la fois fournisseur ET client  
✅ **Exposer les communes françaises** via le COG INSEE / TRE-R13 en terminologies FHIR standard  
✅ **Garantir la conformité** avec FR Core 2.1.0 et les référentiels ANS

---

## Architecture

```
┌─────────────────────────────────────────────────────────────────┐
│           Référentiels Nationaux Français                       │
│   FR Core 2.1.0 (HL7 France) · ANS SMT TRE-R13 · COG INSEE     │
└──────────────────────────┬──────────────────────────────────────┘
                           │
           ┌───────────────┴───────────────┐
           │                               │
           ▼                               ▼
┌──────────────────────┐     ┌─────────────────────────────────┐
│   Axe 1 — Tiers      │     │   Axe 2 — Nomenclatures         │
│                      │     │                                 │
│  TiersProfile        │     │  TRE-R13 CommuneOM              │
│  FournisseurProfile  │     │  (CodeSystem COG, fragment)     │
│  DebiteurProfile     │     │                                 │
│  PayeurSanteProfile  │     │  fr-communes-actives (VS)       │
│                      │     │  fr-communes-cog-complet (VS)   │
│  19 extensions   │     │  insee-cog-commune (NS)         │
│  10 SearchParameters │     │                                 │
│                      │     │  10 CodeSystems             │
└──────────────────────┘     └─────────────────────────────────┘
```

---

## Contenu du guide

### Axe 1 — Profils Tiers

| Profil | Lien | Description |
|--------|------|-------------|
| TiersProfile | [→](StructureDefinition-tiers-profile.html) | Profil de base — identifiants, rôles, coordonnées bancaires |
| FournisseurProfile | [→](StructureDefinition-fournisseur-profile.html) | Fournisseur avec code CPage et paramètres comptables |
| DebiteurProfile | [→](StructureDefinition-debiteur-profile.html) | Client/débiteur avec codes et conditions d'encaissement |
| PayeurSanteProfile | [→](StructureDefinition-payeur-sante-profile.html) | Organisme payeur santé (CPAM, mutuelle…) |

**Extensions** (19) : rôle tiers, nature juridique, compte bancaire, code fournisseur/débiteur, type TG, paramètres comptables, usage succursale, informations personne physique…

**[Voir la documentation des profils →](tiers-organization.html)**

#### Identifiants supportés

| Type | Exemples | Juridiction |
|------|----------|-------------|
| SIRET | 12345678901234 | France |
| FINESS | 750712184 | Établissements de santé FR |
| NIR | 1 23 456 789 012 34 | Personnes physiques FR |
| TVA Ue | DE123456789 | Union Européenne |
| Tahiti | — | Polynésie française |
| RIDET | — | Nouvelle-Calédonie |

#### NamingSystems Territoires d'Outre-Mer

| NamingSystem | Identifiant | Territoire |
|-------------|-------------|------------|
| [TahitiIdentifierNamingSystem](NamingSystem-tahiti-identifier-ns.html) | URI CPage (OID à acquérir DGEN/ISPF) | Polynésie française |
| [RIDETIdentifierNamingSystem](NamingSystem-ridet-identifier-ns.html) | URI CPage (OID à acquérir ridet.nc) | Nouvelle-Calédonie |

#### Paramètres de recherche (10)

| Paramètre | Description |
|-----------|-------------|
| `tiers-role` | Rôle : fournisseur, client, payeur |
| `tiers-category` | Catégorie d'organisation |
| `tiers-legal-nature` | Nature juridique |
| `fournisseur-code` | Code fournisseur CPage |
| `debiteur-code` | Code débiteur CPage |
| `bank-account-iban` | IBAN du compte bancaire |
| `payeur-grand-regime` | Régime SS, MSA, mutuelle… |
| `payeur-type` | Obligatoire vs complémentaire |
| `succursale-usage` | Usage de la succursale |
| `debiteur-type-resident` | Résidence fiscale |

**[Voir les paramètres de recherche →](search-parameters.html)**

---

### Axe 2 — Nomenclatures

#### Communes françaises (COG / TRE-R13)

Les communes françaises sont exposées via le **Code Officiel Géographique INSEE**, modélisé selon la terminologie nationale **TRE-R13** de l'ANS.

| Ressource | Identifiant | Description |
|-----------|-------------|-------------|
| CodeSystem | `fr-commune-cog` | Fragment COG avec propriétés (dates création/suppression, successeur, type territoire…) |
| ValueSet | `fr-communes-actives` | Communes actives (filtre `inactive = false`) |
| ValueSet | `fr-communes-cog-complet` | Toutes les communes (actives + historique) |
| NamingSystem | `insee-cog-commune` | OID `1.2.250.1.213.2.12` + URI ANS SMT |

**[Voir la documentation géographique complète →](geographie.html)**

#### Classifications (Tiers)

| CodeSystem | Codes | Usage |
|------------|-------|-------|
| Rôles (`tiers-role-cs`) | 3 | supplier / debtor / payer |
| Catégories (`tiers-category-cs`) | 24 | Types d'organisations |
| Natures juridiques | 12 | SA, SARL, GCS, EPST… |
| Civilités | 5 | M, Mme, Dr… |
| Types d'identifiants | 9 | SIRET, FINESS, RIDET… |
| Moyens de paiement | 6 | Virement, chèque, numéraire… |
| Régimes | 5 | SS, MSA, CNAV, mutuelle… |
| Types TG (payeur) | 2 | Régime obligatoire / complémentaire |
| Usages succursale | 3 | Livraison, facturation, siège |
| Types résident | 2 | Résident / non-résident |

**[Voir les terminologies complètes →](terminologies.html)**

---

## Pour qui est ce guide ?

### Établissements de santé

- **Échanger** données fournisseurs/clients/payeurs au format standard FHIR interopérable
- **Rechercher** un tiers par rôle, IBAN, code, régime via l'API REST
- **Localiser** les patients et organisations avec les codes communes COG officiels
- **Garantir la conformité** avec FR Core et les référentiels ANS

### Éditeurs de logiciels

- **Profils FHIR prêts à l'emploi** pour les modules tiers (achats, facturation, RH)
- **Terminologies normalisées** réutilisables pour les adresses et communes
- **10 SearchParameters** définis et testés, compatibles serveurs HAPI/FHIR

---

## Statut et conformité

✅ **Compilation Sushi** : 0 erreurs, 0 warnings  
✅ **Standard FHIR** : R4 4.0.1 conforme  
✅ **Standard national** : FR Core 2.1.0 conforme  
✅ **Multi-rôles** : Support complet (plusieurs rôles par organisation)  
✅ **Terminologie nationale** : TRE-R13 (ANS SMT) intégrée

---

## Feuille de route

### Version actuelle (0.1.0)
✅ Profils Tiers (Fournisseur, Client/Débiteur, Organisme payeur, base)  
✅ 19 extensions + 10 SearchParameters  
✅ Nomenclatures geographiques COG (TRE-R13, ValueSets, NamingSystem)  
✅ 10 CodeSystems

### Prochaines versions
- **v0.2** : Référentiel des **personnes** (Professionnels de santé, patients, contacts)
- **v0.3** : Référentiel des **structures internes** (Services, unités de soins, pôles)

---

## Contact

**Équipe Référentiels CPage**  
📧 contact@cpage.fr  
🌐 https://www.cpage.fr

```
┌──────────────────────────────────────────────┐
│  Standard National FR Core 2.1.0             │
│  (HL7 France)                                │
│  • Identifiants français: SIRET, FINESS     │
│  • Adresses françaises                       │
└────────┬─────────────────────────────────────┘
         │
         ├─▶ ┌───────────────────────────────────────────────┐
         │   │ Ce Guide - Référentiel Tiers                 │
         │   │ (Interopérable et réutilisable)              │
         │   │                                              │
         │   │ • Profil de base: Organisation Tiers         │
         │   │ • Profils spécialisés: Fournisseur, Client,  │
         │   │   Organisme Payeur, Succursale               │
         │   │ • 10 critères de recherche REST              │
         │   │ • Support multi-rôles                        │
         │   └────────┬──────────────────────────────────────┘
         │            │
         └────────────┴─▶ ┌──────────────────────────────────┐
                          │ Guides spécialisés établissements│
                          │ (Extensions métier spécifiques)   │
                          │                                  │
                          │ • Gestion interne                │
                          │ • Processus métier               │
                          │ • Échanges sectoriels            │
                          └──────────────────────────────────┘
```

**Principe** : Ce guide définit le **socle commun** réutilisable par tous les établissements. Les spécificités locales sont ajoutées dans des guides dérivés.

## Contenu du guide

### Profils d'organisations

#### [Profil de base Organisation](StructureDefinition-tiers-profile.html)
Profil commun à tous les types de tiers. Inclut les identifiants nationaux (SIRET, FINESS, TVA), les coordonnées bancaires, et la classification de l'organisation.

**Caractéristiques** :
- **Multi-rôles** : Une même organisation peut être à la fois fournisseur, client ET organisme payeur
- **9 types d'identifiants** : SIRET, SIREN, FINESS, Numéro de sécurité sociale, TVA intracommunautaire, identifiants DOM-TOM, etc.
- **Coordonnées bancaires** : RIB/IBAN avec paramètres de paiement (virements, chèques, EDI, affacturage)

#### [Profil Fournisseur](StructureDefinition-fournisseur-profile.html)
Pour les organisations qui **vendent des biens ou services** à l'établissement.

**Informations spécifiques** :
- Code fournisseur unique
- Paramètres comptables (comptes de charges et dettes)
- Conditions de paiement : délais, montants minimums, taux, possibilité d'escompte

**Exemples** : Laboratoires pharmaceutiques, fournisseurs d'équipements médicaux, prestataires de services d'entretien

#### [Profil Client/Débiteur](StructureDefinition-debiteur-profile.html)
Pour les organisations qui **achètent des prestations** à l'établissement.

**Informations spécifiques** :
- Code client unique
- Paramètres de facturation et encaissement
- Statut fiscal (résident/non-résident)
- Autorisations (paiement par assurances, etc.)
- Coordonnées bancaires **obligatoires** pour encaissement

**Exemples** : Autres hôpitaux, EHPAD, cliniques, maisons de retraite, cabinets médicaux

#### [Profil Organisme Payeur](StructureDefinition-payeur-sante-profile.html)
Pour les **organismes d'assurance maladie** qui remboursent les soins.

**Informations spécifiques** :
- Type de régime : Obligatoire (CPAM, MSA, RSI) ou Complémentaire (mutuelles)
- Grand régime de rattachement : Sécurité Sociale, MSA, RSI, CNAV, Mutuelle
- Paramètres de gestion : code centre, numéro de caisse, délais de prise en charge
- Éclatement des factures par acte (oui/non)

**Exemples** : CPAM, MSA, mutuelles, assurances complémentaires

### Classifications et nomenclatures

#### Types d'organisations
- **Catégories** : État, collectivités territoriales, établissements publics de santé, organismes sociaux, entreprises privées, personnes physiques
- **Natures juridiques** : Particulier, société commerciale, association, établissement public, collectivité territoriale, etc.

#### Rôles des organisations (multi-rôles supportés)
- **Fournisseur** (supplier) : Vend des biens ou services
- **Client** (debtor) : Achète des prestations
- **Organisme payeur** (payer) : Rembourse les soins aux patients

> Une même organisation peut avoir **plusieurs rôles simultanément**. Exemple : une clinique peut être à la fois fournisseur de consultations spécialisées ET cliente d'équipements médicaux.

#### Moyens de paiement
- Numéraire, Chèque, Virement bancaire standard
- Virement application externe, Virement gros montant, Virement interne

#### Régimes de protection sociale
- **Sécurité Sociale** (SS) : CPAM, régime général
- **Mutualité Sociale Agricole** (MSA) : Secteur agricole
- **RSI** : Régime Social des Indépendants
- **CNAV** : Caisse Nationale d'Assurance Vieillesse
- **MUTUELLE** : Organismes complémentaires

#### Usages des succursales
- **Point de livraison** : Adresse de réception des marchandises
- **Facturation** : Adresse d'envoi des factures
- **Siège social secondaire** : Établissement autonome rattaché

📊 **Total** : 12 CodeSystems, 74 codes, 19 extensions, 12 ValueSets, 10 SearchParameters

### NamingSystems Territoires d'Outre-Mer

#### [TahitiIdentifierNamingSystem](NamingSystem-tahiti-identifier-ns.html)
Système d'identification pour Polynésie française (PF).
- URI temporaire : `https://www.cpage.fr/ig/masterdata/common/NamingSystem/tahiti-identifier`
- ⚠️ OID officiel à acquérir auprès de DGEN/ISPF

#### [RIDETIdentifierNamingSystem](NamingSystem-ridet-identifier-ns.html)
RIDET - Répertoire d'IDEntification des Entreprises et des Établissements (Nouvelle-Calédonie NC).
- URI temporaire : `https://www.cpage.fr/ig/masterdata/common/NamingSystem/ridet-identifier`
- ⚠️ OID officiel à acquérir auprès de https://www.ridet.nc/

### [Critères de recherche](search-parameters.html)

10 critères pour interroger le référentiel via l'API REST :

| Critère | Description | Exemple d'usage |
|---------|-------------|-----------------|
| **tiers-role** | Recherche par rôle | Tous les fournisseurs |
| **tiers-category** | Recherche par type d'organisation | Toutes les cliniques, tous les CHU |
| **tiers-legal-nature** | Recherche par forme juridique | Sociétés commerciales, associations |
| **fournisseur-code** | Recherche un fournisseur par son code | Recherche par code fournisseur |
| **debiteur-code** | Recherche un client par son code | Recherche par code client |
| **bank-account-iban** | Recherche par compte bancaire | Identification bénéficiaire d'un virement |
| **payeur-grand-regime** | Recherche organisme par régime | Toutes les CPAM, toutes les mutuelles |
| **payeur-type** | Recherche par type de régime | Régimes obligatoires vs complémentaires |
| **succursale-usage** | Recherche succursale par usage | Points de livraison, adresses de facturation |
| **debiteur-type-resident** | Recherche par résidence fiscale | Résidents vs non-résidents |

**Voir** : [Documentation complète des critères de recherche](search-parameters.html)

### [Exemples pratiques](examples.html)

7 exemples d'organisations avec leurs données complètes :

#### Cas multi-rôles
- **Organisation multi-rôles** : Une entreprise qui est à la fois fournisseur, client ET organisme payeur pour ses employés
- **Clinique bi-rôle** : Un établissement qui vend des consultations ET achète des médicaments

#### Organisation hiérarchique
- **Succursale** : Un site secondaire rattaché à son établissement principal (point de livraison + facturation)

#### Profils spécialisés
- **Fournisseur** : Laboratoire pharmaceutique avec conditions de paiement complètes
- **Client** : CHU acheteur avec coordonnées bancaires pour encaissement
- **CPAM** : Organisme payeur régime obligatoire Sécurité Sociale
- **Mutuelle** : Organisme payeur régime complémentaire

**Voir** : [Tous les exemples détaillés](examples.html)
- **ExempleDebiteurPersonnePhysique** : Particulier avec NIR + Civilité M + Prénom (obligatoire TG 01)
- **ExempleDebiteurEPSPublic** : Hôpital avec FINESS + compte contrepartie + code régie (CHORUS)
- **ExempleFournisseurRIDET** : Société calédonienne avec RIDET (overseas NC)

### [Mapping](mapping.html)

Tables complètes de correspondance :
- interface fournisseurs positions 1-262 → FournisseurProfile
- interface debiteurs colonnes CSV → DebiteurProfile
- Règles métier (combinaisons Catégorie TG × Nature juridique)

## Implémentation

## Pour qui est ce guide ?

### Établissements de santé

Ce guide vous permet de :
- **Échanger** vos données fournisseurs et clients avec d'autres établissements au format standard
- **Synchroniser** vos référentiels tiers entre vos différents systèmes (comptabilité, achats, facturation)
- **Rechercher** rapidement un fournisseur, client ou organisme payeur dans votre base
- **Maîtriser** la qualité de vos données grâce aux contrôles de conformité

### Éditeurs de logiciels

Ce guide vous fournit :
1. **Des profils FHIR prêts à l'emploi** pour gérer les organisations tierces
2. **Une API REST standardisée** avec 10 critères de recherche
3. **Des exemples concrets** pour valider vos implémentations
4. **La compatibilité** avec le standard national FR Core
5. **Le support du multi-rôle** : une organisation = plusieurs fonctions

### Cas d'usage pratiques

#### Gestion des multi-rôles

Une même organisation peut avoir **plusieurs rôles simultanés** :

```json
{
  "resourceType": "Organization",
  "id": "clinique-dupont",
  "name": "Clinique Dupont",
  "extension": [
    {"url": "tiersRole", "valueCoding": {"code": "supplier"}},
    {"url": "tiersRole", "valueCoding": {"code": "debtor"}}
  ]
}
```

**Avantages** :
- ✅ Une seule fiche pour tous les échanges commerciaux
- ✅ Pas de duplication de données (adresse, contacts, RIB uniques)
- ✅ Historique centralisé des relations
- ✅ Recherche flexible par rôle

**Exemple réel** : Une clinique partenaire vous vend des consultations spécialisées (rôle fournisseur) ET vous achète des médicaments (rôle client).

**Voir** : [Exemples multi-rôles détaillés](examples.html)

## Statut et conformité

✅ **Compilation** : 0 erreurs, 0 warnings  
✅ **Standard FHIR** : R4 4.0.1 conforme  
✅ **Standard national** : FR Core 2.1.0 conforme  
✅ **Multi-rôles** : Support complet (plusieurs rôles par organisation)  
✅ **Recherches** : 10 critères REST définis et testés

### Ressources produites

- **4 profils** : Organisation de base, Fournisseur, Client, Organisme payeur
- **19 extensions** : Informations métier spécifiques (codes, comptabilité, paiement, coordonnées bancaires)
- **12 nomenclatures** : Types d'organisations, rôles, moyens de paiement, régimes sociaux
- **24 exemples** : Cas réels d'organisations avec données complètes
- **10 critères de recherche** : API REST pour interroger le référentiel

## Liens et ressources

- 📦 **Code source** : [github.com/GIPCPAGE/masterdata](https://github.com/GIPCPAGE/masterdata)
- 🇫🇷 **Standard national** : [FR Core 2.1.0](https://hl7.fr/ig/fhir/core)
- 📚 **Spécification FHIR** : [FHIR R4](https://www.hl7.org/fhir/R4/)

## Feuille de route

### Version actuelle (Mars 2026)
✅ **Référentiel des organisations tierces**
- Profils de base et spécialisés (Fournisseur, Client, Organisme payeur)
- Support du multi-rôle
- 10 critères de recherche REST
- 19 extensions métier
- 24 exemples d'utilisation

### Prochaines versions

**Version 0.2** (À venir)
- Référentiel des **personnes** : Professionnels de santé, patients, contacts
- Référentiel des **structures internes** : Services, unités de soins, pôles

**Version 0.3** (À venir)  
- Référentiel des **produits** : Médicaments, dispositifs médicaux, consommables
- Référentiel des **actes et prestations** : Nomenclature des actes

## Contact

**Équipe Référentiels**  
📧 contact@cpage.fr  
🌐 https://www.cpage.fr
