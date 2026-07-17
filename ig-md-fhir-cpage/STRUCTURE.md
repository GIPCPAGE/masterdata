# Structure du projet — ig-md-fhir-cpage

```text
ig-md-fhir-cpage/
├── sushi-config.yaml              # Config SUSHI : id, dépendances, pages, menu
├── README.md                      # Vue d'ensemble + quickstart
├── STRUCTURE.md                   # Ce fichier
├── LEGACY_SUPPORT.md              # Mapping détaillé Oracle → FHIR (par profil)
├── FSH-LIMITATIONS.md             # Limitation FSH/SUSHI (contraintes string)
└── input/
    ├── fsh/
    │   ├── profiles/              # 5 fichiers, 1 profil chacun
    │   │   ├── CPageFournisseurProfile.fsh        # Parent : FournisseurProfile (commun)
    │   │   ├── CPageDebiteurProfile.fsh           # Parent : DebiteurProfile (commun)
    │   │   ├── CPageEntiteJuridiqueProfile.fsh    # Parent : EntiteJuridiqueProfile (commun)
    │   │   ├── CPageEntiteGeographiqueProfile.fsh # Parent : EntiteGeographiqueProfile (commun)
    │   │   └── CPageUFProfile.fsh                 # Parent : UFProfile (commun)
    │   ├── extensions/            # 16 fichiers, 26 définitions d'extension
    │   │   ├── CPageValidityExtension.fsh
    │   │   ├── CPageEUZoneExtension.fsh
    │   │   ├── CPageSupplierAccountingClass6Extension.fsh
    │   │   ├── CPageSupplierAccountingClass2Extension.fsh
    │   │   ├── CPageSupplierPaymentTermsExtension.fsh
    │   │   ├── CPageSupplierPublicProcurementExtension.fsh
    │   │   ├── CPageSupplierChorusExtension.fsh
    │   │   ├── CPageSupplierInternalFlagsExtension.fsh
    │   │   ├── CPageDebtorAccountExtension.fsh
    │   │   ├── CPageDebtorAsapExtension.fsh
    │   │   ├── CPageDebtorAssociatedSupplierExtension.fsh
    │   │   ├── CPageDebtorExternalIdExtension.fsh
    │   │   ├── CPageDebtorResidencyExtension.fsh
    │   │   ├── CPageEntiteJuridiqueExtensions.fsh   # 6 extensions (receveur, TVA, ...)
    │   │   ├── CPageEntiteGeographiqueExtensions.fsh# 3 extensions (T2A, TVA, coefficients)
    │   │   └── CPageUFExtensions.fsh                # 3 extensions (modules MAL/ECO/PER)
    │   ├── codesystems/           # 3 fichiers
    │   │   ├── CPageValidityCodeSystem.fsh          # V / I
    │   │   ├── CPageEUZoneCodeSystem.fsh             # F / O / A
    │   │   └── CPageResidencyCodeSystem.fsh          # R / N / E
    │   └── valuesets/             # 3 fichiers, un par CodeSystem ci-dessus
    │       ├── CPageValidityValueSet.fsh
    │       ├── CPageEUZoneValueSet.fsh
    │       └── CPageResidencyValueSet.fsh
    └── pages/                     # Pages narratives publiées
        ├── index.md               # Accueil : architecture, profils, mapping Oracle → FHIR
        └── downloads.md           # Téléchargements (package, définitions, exemples)
```

## Profils et tables Oracle source

| Profil CPage | Parent (`ig-md-fhir-common`) | Table Oracle | Vérification du mapping |
|---|---|---|---|
| `CPageFournisseurProfile` | `FournisseurProfile` | `ECO.FOU` (+ `ECO.ETIER`) | DDL Oracle réel |
| `CPageDebiteurProfile` | `DebiteurProfile` | `ECO.DBT` (+ `ECO.ETIER`) | DDL Oracle réel |
| `CPageEntiteJuridiqueProfile` | `EntiteJuridiqueProfile` | `STR.CHO` | Commentaires FSH uniquement (pas de DDL indépendant) |
| `CPageEntiteGeographiqueProfile` | `EntiteGeographiqueProfile` | `STR.ETA` | Commentaires FSH uniquement (pas de DDL indépendant) |
| `CPageUFProfile` | `UFProfile` | `STR.UFO` | Commentaires FSH uniquement (pas de DDL indépendant) |

Détail complet colonne par colonne : voir [`LEGACY_SUPPORT.md`](LEGACY_SUPPORT.md).

## Configuration SUSHI (`sushi-config.yaml`)

- `id: ig.mdm.fhir.cpage`, canonical `https://www.cpage.fr/ig/masterdata/cpage`.
- `dependencies: ig.mdm.fhir.common: dev`.
- `pages:` déclare uniquement `index.md` et `downloads.md` (même convention que
  `ig-md-fhir-common`, qui ne publie pas non plus de pages détaillées par profil : le
  détail par profil est porté par `LEGACY_SUPPORT.md`, hors des pages publiées).
- `menu:` expose Accueil, un lien externe vers l'IG Socle Commun, les Ressources de
  conformité (`artifacts.html`, généré automatiquement par SUSHI/IG Publisher) et les
  Téléchargements.

## Répertoires générés (non versionnés / non modifiés par la documentation)

`input-cache/`, `output/`, `temp/`, `fsh-generated/` sont produits par la chaîne de
build SUSHI/IG Publisher et ne font pas partie du contenu source.
