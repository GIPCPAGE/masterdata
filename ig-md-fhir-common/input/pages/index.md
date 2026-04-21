# Guide d'Implémentation FHIR - Référentiel Commun CPage MasterData

**Version**: 0.1.0 | **Date**: 17 mars 2026 | **Statut**: Draft

## Bienvenue

Ce **Guide d'Implémentation FHIR** définit les ressources communes pour deux axes complémentaires :

1. **Tiers** — profiler et échanger les données sur les organisations tierces (fournisseurs, débiteurs, organismes payeurs) dans le secteur hospitalier français, modélisés comme des ressources `Organization` enrichies d'extensions métier.
2. **Nomenclatures géographiques** — exposer les communes françaises du Code Officiel Géographique (COG/INSEE) via la terminologie nationale **TRE-R13** de l'ANS, sous forme de `CodeSystem`, `ValueSet` et `NamingSystem` FHIR standard.

Ce guide est **interopérable**, basé sur le **standard national FR Core 2.1.0** (HL7 France) et s'appuie sur les référentiels nationaux de l'ANS.

---

## Périmètre

### Axe Concepts Métiers

Un **tiers** est toute organisation avec laquelle un établissement de santé est en relation commerciale ou administrative.

| Type d'organisation | Description | Exemples |
|---------------------|-------------|----------|
| **Fournisseurs** | Vendent des biens ou services à l'établissement | Laboratoires, équipementiers médicaux, prestataires |
| **Clients/Débiteurs** | Achètent des prestations à l'établissement | Autres hôpitaux, EHPAD, cabinets médicaux |
| **Organismes payeurs** | Remboursent les soins aux patients | CPAM, MSA, mutuelles, assurances complémentaires |
| **Succursales** | Sites secondaires rattachés à une organisation principale | Annexes, sites de livraison, adresses de facturation |

### Axe Nomenclatures

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
│  Axe Concepts Métiers│     │   Axe Nomenclatures             │
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

### Axe Concepts Métiers — Profils Tiers

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

### Axe Nomenclatures

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

---

## Liens et ressources

- 📦 **Code source** : [github.com/GIPCPAGE/masterdata](https://github.com/GIPCPAGE/masterdata)
- 🇫🇷 **Standard national** : [FR Core 2.1.0](https://hl7.fr/ig/fhir/core)
- 📚 **Spécification FHIR** : [FHIR R4](https://www.hl7.org/fhir/R4/)