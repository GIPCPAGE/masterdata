# Guide d'Implémentation FHIR — CPage MasterData

**Version** : 0.1.0 | **Date** : 2026-02-11 | **Statut** : Draft

Cet Implementation Guide FHIR définit les profils et extensions **spécifiques à CPage** pour la gestion des Tiers dans le contexte du Master Data Management (MDM).

Il hérite du [IG Socle Commun](https://www.cpage.fr/ig/masterdata/common/) et y ajoute les extensions métier issues des tables Oracle ECO (`FOU`, `DBT`).

---

## Architecture Multi-IG

```
┌───────────────────────────────────────────┐
│  FR Core 2.2.0 (HL7 France)              │
│  • FRCoreOrganizationProfile             │
│  • Slices SIREN, SIRET, FINESS           │
└──────────────────┬────────────────────────┘
                   │
          ┌────────▼──────────────────┐
          │  IG Socle Commun          │
          │  (ig-md-fhir-common)      │
          │  • TiersProfile           │
          │  • FournisseurProfile     │
          │  • DebiteurProfile        │
          │  • Extensions génériques  │
          └────────┬──────────────────┘
                   │
          ┌────────▼──────────────────────────┐
          │  IG CPage (CE GUIDE)              │
          │  • CPageFournisseurOrganization   │
          │  • CPageDebiteurOrganization      │
          │  • Extensions métier CPage        │
          │  • Terminologies CPage ECO        │
          └───────────────────────────────────┘
```

---

## Contenu de ce guide

### Profils

#### CPageFournisseurOrganization

Profil fournisseur CPage, héritant de `FournisseurProfile` (IG commun).  
Ajoute les extensions issues de la table Oracle **ECO.FOU** :

| Extension | Champ Oracle | Description |
|-----------|-------------|-------------|
| **CPageValidityExtension** | `VALIDI`/`VALIDF` | Période de validité (dates début/fin) |
| **CPageEUZoneExtension** | `ZONEUE_FOU` | Zone Europe (F = France, O = Europe, A = Hors UE) |
| **CPageSupplierAccountingExtension** | `CLASSIMP6`, `CLASSIMP2` | Classes comptables (classe 6 et classe 2) |
| **CPageSupplierPaymentConditionsExtension** | `CONDPAI` | Conditions de paiement |
| **CPageSupplierPublicMarketExtension** | `MARCHE_FOU` | Indicateur marché public |
| **CPageSupplierChorusExtension** | `CHORUSTYPSER`, `CHORUSCODSER`, `CHORUSNEJ` | Paramètres CHORUS |
| **CPageSupplierValidityExtension** | `VALIDF` | Flag validité fournisseur (V/I) |

#### CPageDebiteurOrganization

Profil débiteur CPage, héritant de `DebiteurProfile` (IG commun).  
Ajoute les extensions issues de la table Oracle **ECO.DBT** :

| Extension | Champ Oracle | Description |
|-----------|-------------|-------------|
| **CPageValidityExtension** | `VALIDI`/`VALIDF` | Période de validité (dates début/fin) |
| **CPageEUZoneExtension** | `ZONEUE_DBT` | Zone Europe (F / O / A) |
| **CPageDebtorResidenceExtension** | `RESIDFIS` | Type de résidence fiscale (R / N / E) |
| **CPageDebtorTiersAccountExtension** | `CPTIERS` | Compte tiers débiteur |
| **CPageDebtorAsapExtension** | `ASAP_*` | Paramètres ASAP débiteur |
| **CPageDebtorExternalIdExtension** | `IDEXT` | Identifiant externe |
| **CPageDebtorLinkedSupplierExtension** | `IDFOU` | Fournisseur associé au débiteur |

---

### Terminologies CPage

#### CodeSystems

| CodeSystem | Valeurs | Description |
|------------|---------|-------------|
| **CPageValidityCS** | `V` / `I` | Validité active (Valide) ou inactive (Invalide) |
| **CPageResidencyCS** | `R` / `N` / `E` | Résidence : Résident / Non-résident / Étranger |
| **CPageEUZoneCS** | `F` / `O` / `A` | Zone géographique : France / Europe / Reste du monde |

#### ValueSets

- **CPageValidityVS** — codes `V` et `I`
- **CPageResidencyVS** — codes `R`, `N` et `E`
- **CPageEUZoneVS** — codes `F`, `O` et `A`

---

### Mapping Oracle → FHIR

Correspondence entre les champs des tables Oracle ECO (`FOU`, `DBT`) et les éléments FHIR des profils CPage. Disponible dans les définitions des extensions et des profils listés ci-dessus.

---

## Dépendances

| Package | Version | Rôle |
|---------|---------|------|
| `ig.mdm.fhir.common` | dev | IG Socle Commun CPage MasterData |
| `hl7.fhir.fr.core` | 2.2.0 | Via IG commun |
| FHIR R4 | 4.0.1 | Standard de base |

---

## Ressources de conformité

L'ensemble des profils, extensions, terminologies et exemples est disponible sur la page [Ressources de conformité](artifacts.html).

---

## Liens

- **IG Socle Commun** : [ig-md-fhir-common](https://www.cpage.fr/ig/masterdata/common/)
- **FR Core** : [hl7.fr/ig/fhir/core](https://hl7.fr/ig/fhir/core/)
- **FHIR R4** : [hl7.org/fhir/R4](https://www.hl7.org/fhir/R4/)
- **Contact** : contact@cpage.fr
