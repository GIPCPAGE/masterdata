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
    │   ├── profiles/                       # 5 fichiers, 1 profil chacun
    │   │   ├── CPageFournisseurProfile.fsh        # Parent : FournisseurProfile (commun)
    │   │   ├── CPageDebiteurProfile.fsh           # Parent : DebiteurProfile (commun)
    │   │   ├── CPageEntiteJuridiqueProfile.fsh    # Parent : EntiteJuridiqueProfile (commun)
    │   │   ├── CPageEntiteGeographiqueProfile.fsh # Parent : EntiteGeographiqueProfile (commun)
    │   │   └── CPageUFProfile.fsh                 # Parent : UFProfile (commun)
    │   ├── extensions/                     # 16 fichiers, 25 définitions Extension
    │   │   ├── CPageValidityExtension.fsh          # 1 extension  — Fournisseur + Débiteur
    │   │   ├── CPageEUZoneExtension.fsh             # 1 extension  — Fournisseur (+ Débiteur, non câblé)
    │   │   ├── CPageSupplierAccountingClass6Extension.fsh  # 1 extension
    │   │   ├── CPageSupplierAccountingClass2Extension.fsh  # 1 extension
    │   │   ├── CPageSupplierPaymentTermsExtension.fsh      # 1 extension
    │   │   ├── CPageSupplierPublicProcurementExtension.fsh # 1 extension
    │   │   ├── CPageSupplierChorusExtension.fsh             # 1 extension
    │   │   ├── CPageSupplierInternalFlagsExtension.fsh      # 1 extension
    │   │   ├── CPageDebtorAccountExtension.fsh               # 1 extension
    │   │   ├── CPageDebtorAsapExtension.fsh                  # 1 extension
    │   │   ├── CPageDebtorAssociatedSupplierExtension.fsh    # 1 extension
    │   │   ├── CPageDebtorExternalIdExtension.fsh            # 1 extension
    │   │   ├── CPageDebtorResidencyExtension.fsh             # 1 extension
    │   │   ├── CPageEntiteJuridiqueExtensions.fsh    # 6 extensions (receveur, organismes patronaux, TVA, BIC, M22, TPG)
    │   │   ├── CPageEntiteGeographiqueExtensions.fsh # 3 extensions (dates T2A, coefficients, TVA)
    │   │   └── CPageUFExtensions.fsh                 # 3 extensions (modules MAL / ECO / PER)
    │   ├── codesystems/                    # 3 fichiers
    │   │   ├── CPageValidityCodeSystem.fsh          # V / I
    │   │   ├── CPageEUZoneCodeSystem.fsh             # F / O / A
    │   │   └── CPageResidencyCodeSystem.fsh          # R / N / E
    │   ├── valuesets/                      # 3 fichiers, un par CodeSystem ci-dessus
    │   │   ├── CPageValidityValueSet.fsh
    │   │   ├── CPageEUZoneValueSet.fsh
    │   │   └── CPageResidencyValueSet.fsh
    │   ├── examples/                       # vide à ce jour — aucun exemple FSH publié
    │   └── aliases.fsh                     # alias FHIR/HL7 + alias legacy vers l'IG commun
    └── pages/                              # Pages narratives publiées
        ├── index.md               # Accueil : architecture, catalogue des profils, mapping
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

Détail complet colonne par colonne, y compris les points de vigilance identifiés
(annotations FSH imprécises, colonnes non câblées, chevauchements avec l'IG
commun) : voir [`LEGACY_SUPPORT.md`](LEGACY_SUPPORT.md).

## Configuration SUSHI (`sushi-config.yaml`)

- `id: ig.mdm.fhir.cpage`, canonical `https://www.cpage.fr/ig/masterdata/cpage`.
- `dependencies: ig.mdm.fhir.common: dev`.
- `pages:` déclare uniquement `index.md` et `downloads.md` — même convention que
  `ig-md-fhir-common`, qui ne publie pas non plus de page détaillée par profil : le
  détail colonne par colonne est porté par `LEGACY_SUPPORT.md`, hors des pages
  publiées par l'IG Publisher.
- `menu:` expose Accueil, un lien externe vers l'IG Socle Commun, les Ressources de
  conformité (`artifacts.html`, générées automatiquement par SUSHI/IG Publisher) et
  les Téléchargements.

## Répertoires générés (non versionnés, non modifiés par la documentation)

`input-cache/`, `output/`, `temp/`, `fsh-generated/` sont produits par la chaîne de
build SUSHI/IG Publisher et ne font pas partie du contenu source.
