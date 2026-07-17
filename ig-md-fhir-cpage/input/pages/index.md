# Guide d'Implémentation FHIR — CPage MasterData

**Version** : 0.1.0 | **Date** : 2026-02-11 | **Statut** : Draft

Cet Implementation Guide FHIR définit les profils et extensions **spécifiques à CPage**
pour la gestion des Tiers (Fournisseurs, Débiteurs) et des structures hospitalières
(Entité Juridique, Entité Géographique, Unité Fonctionnelle) dans le contexte du
Master Data Management (MDM).

Il hérite du [IG Socle Commun](https://www.cpage.fr/ig/masterdata/common/) et y ajoute
les extensions métier issues des tables Oracle historiques CPage (schémas `ECO` et
`STR`).

---

## Architecture Multi-IG

```text
┌───────────────────────────────────────────┐
│  FR Core 2.2.0 (HL7 France)               │
│  • FRCoreOrganizationEtablissementProfile │
│  • FRCoreOrganizationUFProfile            │
└──────────────────┬────────────────────────┘
                    │
          ┌─────────▼──────────────────┐
          │  IG Socle Commun           │
          │  (ig-md-fhir-common)       │
          │  • TiersProfile            │
          │  • FournisseurProfile      │
          │  • DebiteurProfile         │
          │  • EntiteJuridiqueProfile  │
          │  • EntiteGeographiqueProfile│
          │  • UFProfile               │
          │  • Extensions génériques   │
          └─────────┬───────────────────┘
                    │
          ┌─────────▼──────────────────────────┐
          │  IG CPage (CE GUIDE)               │
          │  • CPageFournisseurProfile         │
          │  • CPageDebiteurProfile            │
          │  • CPageEntiteJuridiqueProfile     │
          │  • CPageEntiteGeographiqueProfile  │
          │  • CPageUFProfile                  │
          │  • Terminologies CPage             │
          └─────────────────────────────────────┘
```

---

## Contenu de ce guide

### Profils

#### CPageFournisseurProfile

Profil fournisseur CPage, héritant de `FournisseurProfile` (IG commun).
Ajoute les extensions issues de la table Oracle **`ECO.FOU`** :

| Extension CPage | Champ(s) Oracle | Description |
|---|---|---|
| `CPageValidity` | `FOU.VALIFO` | Validité du fournisseur (V/I) |
| `CPageEUZone` | `FOU.EUROFO` | Zone Europe (F = France, O = Europe, A = Autre) |
| `CPageSupplierAccountingClass6` | `FOU.LBU6FO`, `FOU.CPT6FO` | Comptabilité classe 6 (charges) |
| `CPageSupplierAccountingClass2` | `FOU.LBU2FO`, `FOU.CPT2FO` | Comptabilité classe 2 (immobilisations) |
| `CPageSupplierPaymentTerms` | `FOU.DEPAFO`, `FOU.JOSPFO`, `FOU.MTMIFO` | Délai de paiement, jour spécifique, montant minimum |
| `CPageSupplierPublicProcurement` | `FOU.TCMPFO`, `FOU.GACHFO`, `FOU.ESCOFO` | Marchés publics, groupement d'achat, escomptable |
| `CPageSupplierChorus` | `FOU.CHORFO`, `FOU.TIDCFO`, `FOU.IDCHFO` | Assujettissement et identifiants Chorus |
| `CPageSupplierInternalFlags` | `FOU.EXTRFO`, `FOU.MAJ_FO` | Indicateurs internes d'extraction |

#### CPageDebiteurProfile

Profil débiteur CPage, héritant de `DebiteurProfile` (IG commun).
Ajoute les extensions issues de la table Oracle **`ECO.DBT`** :

| Extension CPage | Champ(s) Oracle | Description |
|---|---|---|
| `CPageValidity` | `DBT.INVADT` | Validité du débiteur (V/I) |
| `CPageDebtorResidency` | `DBT.RESIDT` | Résidence (R = résident, N = non-résident, E = étranger) |
| `CPageDebtorAccount` | `DBT.LBTIDT`, `DBT.CPTIDT` | Lettre budgétaire et compte de tiers débiteur |
| `CPageDebtorAsap` | `DBT.ASAPDT`, `DBT.FCENDT` | Désactivation ASAP dématérialisé / impression CEN forcée |
| `CPageDebtorExternalId` | `DBT.IDEXDT` | Identifiant externe du débiteur |
| `CPageDebtorAssociatedSupplier` | `DBT.NUFODT` | Fournisseur associé (référence `CPageFournisseurProfile`) |

`CPageEUZone` existe aussi sur ce profil mais ne correspond, en l'état du modèle, à
aucune colonne propre à `ECO.DBT` — voir le détail et les réserves dans
[`LEGACY_SUPPORT.md`](https://github.com/GIPCPAGE/masterdata/blob/master/ig-md-fhir-cpage/LEGACY_SUPPORT.md).

#### CPageEntiteJuridiqueProfile

Profil de l'entité légale d'un établissement hospitalier, héritant de
`EntiteJuridiqueProfile` (IG commun). Ajoute, depuis la table Oracle **`STR.CHO`**, le
receveur comptable (coordonnées, RIB/IBAN, poste comptable), les numéros d'organismes
patronaux (URSSAF, CNRACL, IRCANTEC, CAMARCA, CNAVTS), les paramètres de TVA et les
indicateurs M22/TPG/BIC.

#### CPageEntiteGeographiqueProfile

Profil du site géographique d'un établissement, héritant de
`EntiteGeographiqueProfile` (IG commun). Ajoute, depuis la table Oracle **`STR.ETA`**,
les 14 dates d'activation T2A par type de séjour et voie d'entrée, les paramètres de
TVA et les coefficients tarifaires (prudentiel, MCO, CFISC, SEGUR).

#### CPageUFProfile

Profil de l'unité fonctionnelle hospitalière, héritant de `UFProfile` (IG commun).
Ajoute, depuis la table Oracle **`STR.UFO`**, les trois modules métier CPage : MAL
(lits, étiquettes, options patients), ECO (TVA, magasin, comptabilité) et PER
(personnel/RH).

> Les mappings des profils Entité Juridique / Entité Géographique / UF sont sourcés
> depuis les commentaires embarqués dans le FSH lui-même : il n'existe pas, pour
> `STR.CHO`/`STR.ETA`/`STR.UFO`, d'export DDL Oracle indépendant permettant de les
> vérifier de la même façon que pour Fournisseur/Débiteur. Voir
> [`LEGACY_SUPPORT.md`](https://github.com/GIPCPAGE/masterdata/blob/master/ig-md-fhir-cpage/LEGACY_SUPPORT.md)
> pour le détail complet colonne par colonne et les niveaux de vérification.

---

## Terminologies CPage

### CodeSystems

| CodeSystem | Valeurs | Description |
|---|---|---|
| `CPageValidityCodeSystem` | `V` / `I` | Validité : Valide / Invalide |
| `CPageResidencyCodeSystem` | `R` / `N` / `E` | Résidence : Résident / Non-résident / Étranger |
| `CPageEUZoneCodeSystem` | `F` / `O` / `A` | Zone géographique : France / Europe (hors France) / Autre |

### ValueSets

- `CPageValidityValueSet` — codes `V` et `I`
- `CPageResidencyValueSet` — codes `R`, `N` et `E`
- `CPageEUZoneValueSet` — codes `F`, `O` et `A`

---

## Mapping Oracle → FHIR

Le détail complet, colonne par colonne, du mapping entre les tables Oracle legacy
(`ECO.ETIER`, `ECO.FOU`, `ECO.DBT`, `STR.CHO`, `STR.ETA`, `STR.UFO`) et les extensions
FHIR de cet IG est maintenu dans un document dédié à la racine du dépôt source :

**[`LEGACY_SUPPORT.md`](https://github.com/GIPCPAGE/masterdata/blob/master/ig-md-fhir-cpage/LEGACY_SUPPORT.md)**

Ce document précise, pour chaque profil :

- la table Oracle source et, le cas échéant, les tables liées (`ECO.ETIER` pour
  Fournisseur/Débiteur) ;
- le niveau de vérification du mapping (DDL Oracle réel pour Fournisseur/Débiteur ;
  commentaires FSH uniquement pour Entité Juridique/Entité Géographique/UF, en
  l'absence d'export DDL indépendant pour `STR.*`) ;
- les points de vigilance identifiés (colonnes mentionnées dans un commentaire mais non
  câblées sur un élément FHIR, chevauchements avec des extensions génériques de l'IG
  commun, etc.).

Les tables ci-dessus (sections Profils) donnent un résumé de premier niveau ; s'y
référer directement pour toute décision d'implémentation ou de migration.

---

## Dépendances

| Package | Version | Rôle |
|---------|---------|------|
| `ig.mdm.fhir.common` | dev | IG Socle Commun CPage MasterData |
| `hl7.fhir.fr.core` | 2.2.0 | Via IG commun |
| FHIR R4 | 4.0.1 | Standard de base |

---

## Ressources de conformité

L'ensemble des profils, extensions, terminologies et exemples est disponible sur la
page [Ressources de conformité](artifacts.html).

---

## Liens

- **IG Socle Commun** : [ig-md-fhir-common](https://www.cpage.fr/ig/masterdata/common/)
- **Dépôt source** : [GIPCPAGE/masterdata](https://github.com/GIPCPAGE/masterdata)
- **FR Core** : [hl7.fr/ig/fhir/core](https://hl7.fr/ig/fhir/core/)
- **FHIR R4** : [hl7.org/fhir/R4](https://www.hl7.org/fhir/R4/)
- **Contact** : <contact@cpage.fr>
