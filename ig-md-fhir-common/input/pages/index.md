# Guide d'Implémentation FHIR — Socle Commun CPage MasterData

**Version** : 0.1.0 | **Date** : 2026-02-11 | **Statut** : Draft

Ce guide d'implémentation définit les **profils, extensions et terminologies FHIR génériques** du CPage MasterData.  
Il constitue le socle partagé, vendor-neutral, basé sur [FR Core 2.2.0](https://hl7.fr/ig/fhir/core/), réutilisable par les IG spécifiques (ex. : IG CPage).

---

## Positionnement dans l'architecture

```
┌─────────────────────────────────────────────────┐
│  FHIR R4 + FR Core 2.2.0 (HL7 France)          │
│  • FRCoreOrganizationProfile                    │
│  • Slices SIREN, SIRET, FINESS                  │
└────────────────────┬────────────────────────────┘
                     │
          ┌──────────▼───────────────┐
          │  IG Socle Commun (CE GUIDE)         │
          │  • TiersProfile                     │
          │  • FournisseurProfile               │
          │  • DebiteurProfile                  │
          │  • PayeurSanteProfile               │
          │  • Extensions, CodeSystems          │
          └──────────┬───────────────┘
                     │
          ┌──────────▼───────────────┐
          │  IG CPage (ig-md-fhir-cpage)        │
          │  • CPageFournisseurOrganization     │
          │  • CPageDebiteurOrganization        │
          └────────────────────────────┘
```

---

## Contenu de ce guide

### Profils Organization

Profils basés sur `FRCoreOrganizationProfile` pour les structures tierces :

| Profil | Description |
|--------|-------------|
| **TiersProfile** | Profil de base — identifiants (ETIER, SIRET, SIREN, FINESS, TVA, NIR, hors UE, Tahiti, RIDET), adresses, comptes bancaires, rôles, nature juridique, catégorie |
| **FournisseurProfile** | Spécialisation fournisseur — conditions de paiement, comptabilité, marchés publics, Chorus |
| **DebiteurProfile** | Spécialisation débiteur — type, résidence, paramètres ASAP, comptes |
| **PayeurSanteProfile** | Payeur santé — grand régime, codes organismes |
| **SuccursaleProfile** | Succursale / établissement secondaire d'un tiers |

### Extensions

Extensions génériques portées par les profils :

| Extension | Description |
|-----------|-------------|
| **TiersRoleExtension** | Rôle(s) d'un tiers (débiteur, fournisseur, payeur) |
| **TiersLegalNameExtension** | Raison sociale / dénomination légale |
| **TiersCategoryExtension** | Catégorie TG (codes 00–74) |
| **TiersAddressExtension** | Adresse avec localisation géographique (France, Europe, Hors UE) |
| **TiersBankAccountExtension** | Coordonnées bancaires (IBAN, BIC) |
| **TiersIdentifierExtension** | Type d'identifiant (interfaces EFOU, KERD) |
| **TiersPublicMarketExtension** | Indicateur marché public |
| **TiersRegieExtension** | Indicateur régie |
| **TiersPersonnalExtension** | Données personnelles complémentaires |
| **FournisseurComptabiliteExtension** | Classes comptables (classe 6 et classe 2) |
| **FournisseurChorusExtension** | Paramètres CHORUS (type service, code service, N° EJ) |
| **FournisseurCondPaiementExtension** | Conditions de paiement fournisseur |
| **DebiteurComptesExtension** | Compte tiers débiteur |
| **DebiteurParamsExtension** | Paramètres ASAP débiteur |
| **PayeurSanteRegimeExtension** | Grand régime et code organisme payeur |
| **SuccursaleAddressExtension** | Adresse de la succursale |
| **ChorusIdentifierTypeExtension** | Type d'identifiant CHORUS |

### Terminologies

#### CodeSystems

| CodeSystem | Description |
|------------|-------------|
| **TiersRoleCodeSystem** | Rôles génériques d'un tiers (débiteur, fournisseur, payeur) |
| **TiersCategoryCS** | Catégories de tiers — codes 00–74 (interfaces KERD, EFOU) |
| **TiersCivilityCS** | Codes de civilité (personnes physiques, catégorie TG = 01) |
| **TiersLegalNatureCS** | Nature juridique — codes 00–11 |
| **TiersIdentifierTypeCS** | Types d'identifiants (interfaces EFOU, KERD) |
| **TiersDebtorTypeCS** | Type de débiteur (occasionnel / normal) |
| **TiersAddressLocalizationCS** | Localisation géographique d'adresse (France, DOM-TOM, Europe, Hors UE) |
| **MoyenPaiementCS** | Types de moyens de paiement |
| **GrandRegimeCS** | Grands régimes de Sécurité sociale et organismes payeurs |
| **TypeResidentCS** | Type de résident fiscal (Résident / Non-résident / Étranger) |
| **SuccursaleUsageCS** | Types d'usage de succursale |
| **ChorusIdentifierTypeCS** | Types d'identifiants reconnus par CHORUS |
| **CommunesFrancaisesCodeSystem** | ~36 000 communes françaises COG INSEE avec historique et codes postaux |

#### ValueSets

Chaque CodeSystem est accompagné d'un ValueSet correspondant (`TiersRoleVS`, `TiersCategoryVS`, `MoyenPaiementVS`, `GrandRegimeVS`, `CommunesActivesVS`, etc.).

### Paramètres de recherche

Paramètres de recherche FHIR personnalisés permettant de requêter les instances par extension :

- Recherche par rôle (`tiers-role`)
- Recherche par IBAN / BIC (`tiers-iban`, `tiers-bic`)
- Recherche par type débiteur, résidence fiscale
- Recherche par identifiant CHORUS, grand régime payeur
- Recherche sur les succursales

### Référentiel COG — Données Géographiques

| Ressource | Description |
|-----------|-------------|
| **CommunesFrancaisesCodeSystem** | CodeSystem — ~36 000 communes avec historique, fusions et codes postaux |
| **CommunesActivesVS** | ValueSet des communes en vigueur (`inactive = false`) |
| **NamingSystem INSEE COG** | OID officiel `1.2.250.1.213.2.12` + URI CPage |

---

## Dépendances

| Package | Version |
|---------|---------|
| `hl7.fhir.fr.core` | 2.2.0 |
| FHIR R4 | 4.0.1 |

---

## Ressources de conformité

L'ensemble des profils, extensions, CodeSystems, ValueSets, paramètres de recherche et exemples est disponible sur la page [Ressources de conformité](artifacts.html).
