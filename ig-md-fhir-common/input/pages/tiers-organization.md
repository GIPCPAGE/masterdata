# Axe Concepts Métiers — Profils Tiers

## Vue d'ensemble

Modélisation des organisations tierces (fournisseurs, clients, organismes payeurs) via la ressource FHIR **Organization** enrichie d'extensions métier.

### Hiérarchie des profils

```
Organization (FHIR R4)
  └── FR Core Organization
        └── TiersProfile (base)
              ├── FournisseurProfile
              ├── DebiteurProfile
              └── PayeurSanteProfile
```

Les données géographiques (communes COG, TRE-R13) sont documentées dans les [Données Géographiques COG](geographie.html).

---

## Extensions (19)

| Extension | Profil(s) | Description |
|-----------|-----------|-------------|
| `TiersRoleExtension` | Tiers | Rôle(s) — supplier / debtor / payer |
| `TiersIdentifierTypeExtension` | Tiers | Type identifiant principal |
| `TiersLegalNatureExtension` | Tiers | Nature juridique |
| `TiersBankAccountExtension` | Tiers | IBAN/BIC + paramètres paiement |
| `TiersPersonDetailsExtension` | Tiers | Civilité + prénom (personnes physiques) |
| `TiersAddressLocalizationExtension` | Tiers / Débiteur | Zone géographique (FR / EU / HU) |
| `ChorusIdentifierTypeExtension` | Tiers | Type identifiant CHORUS |
| `TiersCategoryExtension` | Tiers | Catégorie d'organisation (codes 00-74) |
| `TiersDebtorFlagsExtension` | Débiteur | Drapeaux débiteur (autorisations, centralisations…) |
| `TiersDebtorTypeExtension` | Débiteur | Normal / Occasionnel |
| `TiersPublicAccountingCounterpartExtension` | Débiteur | Compte contrepartie comptabilité publique |
| `TiersRegieCodeExtension` | Débiteur | Code régie CHORUS |
| `FournisseurCodeExtension` | Fournisseur | Code fournisseur CPage |
| `FournisseurComptabiliteExtension` | Fournisseur | Paramètres comptables (comptes classe 2/6) |
| `FournisseurPaiementExtension` | Fournisseur | Conditions de paiement (délai, escompte, EDI…) |
| `DebiteurCodeExtension` | Débiteur | Code débiteur CPage |
| `DebiteurParametresExtension` | Débiteur | Paramètres encaissement |
| `PayeurSanteExtension` | Payeur santé | Code centre, régime, délai prise en charge… |
| `SuccursaleUsageExtension` | Tiers | Usage de la succursale |

**[Voir tous les artifacts →](artifacts.html)**

---

## Profil de Base : Organisation Tierce

### Identifiants supportés

| Type | Juridiction |
|------|-------------|
| SIRET / SIREN | France |
| FINESS | Établissements de santé FR |
| NIR | Personnes physiques FR |
| TVA Intracommunautaire | Union Européenne |
| Identifiant Tahiti | Polynésie française |
| RIDET | Nouvelle-Calédonie |
| Identifiant interne | CPage |

**Règle** : Au minimum un identifiant officiel (SIRET, FINESS ou autre).

### Informations principales

- **Nom** (obligatoire), alias, statut actif/inactif
- **Adresse** : code postal, commune, extension COG INSEE
- **Coordonnées bancaires** : RIB (banque/guichet/compte/clé) ou IBAN+BIC ; plusieurs comptes possibles
- **Catégorie + Nature juridique** : combinaisons contraintes — voir [Terminologies](terminologies.html#règles-de-cohérence)

---

## Profils Spécialisés

### Fournisseur

Extensions spécifiques : code fournisseur CPage unique, paramètres comptables (comptes classe 2/6), conditions de paiement (délai, jour de règlement, montant minimum), EDI/affacturage.

### Client (Débiteur)

Extensions spécifiques : code client CPage unique, type Normal/Occasionnel, résidence fiscale (R/NR), compte contrepartie comptabilité publique, drapeaux autorisations, centralisation commandes.

⚠️ **Coordonnées bancaires obligatoires** (pour recevoir les paiements).

### Organisme Payeur Santé

Extensions spécifiques : type RO/RC, grand régime (SS/MSA/RSI/CNAV/MUTUELLE), code centre, numéro caisse, numéro organisme national, délai prise en charge, éclatement factures (oui/non).

⚠️ **Pas de coordonnées bancaires** (les payeurs ne communiquent pas leur RIB).

---

## Cas Particuliers

### Multi-rôles

Une organisation peut avoir **plusieurs rôles simultanés** (supplier + debtor + payer). Créer **une seule fiche** avec toutes les extensions applicables. Avantage : pas de duplication, historique centralisé, recherche flexible.

### Succursales

Chaque site est une ressource `Organization` distincte avec son propre SIRET. La succursale référence son siège via `partOf` (référence résolvable par l'API). Le siège n'a pas à lister ses succursales.

### Personnes Physiques

Catégorie **01**. Civilité + prénom **obligatoires**. Identifiant : NIR (15 caractères). Nature juridique : **01** (Particulier) ou **02** (Artisan-Commerçant-Agriculteur).

### Organisations Étrangères

- **UE** : TVA intracommunautaire, IBAN SEPA, autoliquidation TVA
- **Hors UE** : identifiant selon pays
- **Polynésie française** : identifiant Tahiti (DGEN/ISPF)
- **Nouvelle-Calédonie** : RIDET (7 caractères)

---

## Liens

- Profils : [TiersProfile](StructureDefinition-tiers-profile.html) · [FournisseurProfile](StructureDefinition-fournisseur-profile.html) · [DebiteurProfile](StructureDefinition-debiteur-profile.html) · [PayeurSanteProfile](StructureDefinition-payeur-sante-profile.html)
- [Classifications](terminologies.html) · [Exemples](examples.html) · [Paramètres de recherche](search-parameters.html)