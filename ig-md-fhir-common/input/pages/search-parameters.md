# Axe Concepts Métiers — Paramètres de Recherche Tiers

## Introduction

**10 paramètres de recherche** FHIR pour interroger les organisations tierces (`Organization`) via l'API REST.
Pour les requêtes sur les CodeSystems géographiques (communes COG), voir la [documentation géographique](geographie.html).

**[Définitions FHIR des SearchParameters →](artifacts.html#behavior-search-parameters)**

---

## Tableau récapitulatif

| Paramètre | Type | Extension source | Valeurs / Usage |
|-----------|------|-----------------|-----------------|
| `tiers-role` | token | `TiersRoleExtension` | `supplier` / `debtor` / `payer` |
| `tiers-category` | token | `TiersCategoryExtension` | Code 00-74 (catégorie organisation) |
| `tiers-legal-nature` | token | `TiersLegalNatureExtension` | Code nature juridique |
| `fournisseur-code` | string | `FournisseurCodeExtension` | Code fournisseur CPage |
| `debiteur-code` | string | `DebiteurCodeExtension` | Code débiteur CPage |
| `bank-account-iban` | string | `TiersBankAccountExtension` | IBAN du compte bancaire |
| `payeur-grand-regime` | token | `PayeurSanteExtension` | `SS` / `MSA` / `RSI` / `CNAV` / `MUTUELLE` |
| `payeur-type` | token | `TiersCategoryExtension` | `RO` / `RC` |
| `succursale-usage` | token | `SuccursaleUsageExtension` | `POINT_LIVRAISON` / `FACTURATION` / `SIEGE_SOCIAL` |
| `debiteur-type-resident` | token | `TiersIdentifierTypeExtension` | `R` / `NR` |

---

## Syntaxe

```
GET [serveur]/Organization?[critère]=[valeur]
```

| Modificateur | Description | Exemple |
|---|---|---|
| _(aucun)_ | Correspondance exacte | `?fournisseur-code=FRSUP001` |
| `:contains` | Contient | `?fournisseur-code:contains=LPD` |
| `,` (virgule) | OU logique | `?tiers-role=supplier,debtor` |
| `&` répété | ET logique | `?tiers-role=supplier&tiers-role=debtor` |

---

## Exemples

### Par rôle

```http
# Tous les fournisseurs
GET [serveur]/Organization?tiers-role=supplier

# Fournisseurs OU clients
GET [serveur]/Organization?tiers-role=supplier,debtor

# Organisations multi-rôles (fournisseur ET client simultanément)
GET [serveur]/Organization?tiers-role=supplier&tiers-role=debtor
```

### Par type d'organisation

```http
# Tous les EPS (hôpitaux publics, catégorie 27)
GET [serveur]/Organization?tiers-category=27

# Toutes les mutuelles (catégorie 63)
GET [serveur]/Organization?tiers-category=63
```

### Par code ou identifiant

```http
# Code fournisseur exact
GET [serveur]/Organization?fournisseur-code=FRSUP00456

# Par IBAN (identification bénéficiaire paiement)
GET [serveur]/Organization?bank-account-iban=FR7630002005500000012345611
```

### Organismes payeurs

```http
# CPAM et caisses SS (régime obligatoire, grand régime SS)
GET [serveur]/Organization?tiers-role=payer&payeur-grand-regime=SS

# Toutes les mutuelles (régime complémentaire)
GET [serveur]/Organization?payeur-type=RC
```

### Succursales et résidence fiscale

```http
# Points de livraison
GET [serveur]/Organization?succursale-usage=POINT_LIVRAISON

# Non-résidents fiscaux
GET [serveur]/Organization?debiteur-type-resident=NR
```

---

## Voir aussi

- [Profils Tiers](tiers-organization.html) · [Exemples](examples.html) · [Artifacts](artifacts.html#behavior-search-parameters)