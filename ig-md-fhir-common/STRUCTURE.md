# Structure du dépôt — ig-md-fhir-common

Ce document décrit l'organisation technique du dépôt, pour les contributeurs. Pour le narratif
métier (ce que modélise cet IG et pourquoi), voir [`README.md`](README.md) et le guide publié
lui-même (`input/pages/index.md` et ses deux pages de détail).

## Arborescence

```text
ig-md-fhir-common/
├── sushi-config.yaml          Configuration SUSHI/IG Publisher : id, canonical, dépendances,
│                              pages et menu de navigation.
├── ig.ini                     Configuration IG Publisher (template, options).
├── package.json               Script npm "build" (sushi build).
├── _genonce.bat / .sh         Construction complète (SUSHI + IG Publisher) en une passe.
├── _build.bat / .sh           Lancement direct du IG Publisher (jar déjà présent).
├── _gencontinuous.bat / .sh   Construction en mode watch.
├── _updatePublisher.bat / .sh Téléchargement/mise à jour du IG Publisher.
│
├── input/
│   ├── fsh/
│   │   ├── aliases.fsh          Alias FSH partagés (FR Core, terminologies HL7, OID internes).
│   │   ├── profiles/            21 profils Organization/Location.
│   │   ├── extensions/          ~80 extensions FHIR (certains fichiers en définissent plusieurs).
│   │   ├── codesystems/         CodeSystems (nomenclatures PESv2, communes COG INSEE, internes CPage).
│   │   ├── valuesets/           ValueSets associés (un par CodeSystem, généralement).
│   │   ├── searchparameters/    10 SearchParameter personnalisés (domaine Tiers uniquement).
│   │   ├── operations/          OperationDefinition $hierarchy (structure hospitalière).
│   │   └── examples/            Instances d'exemple + NamingSystem (RIDET, Tahiti, COG INSEE).
│   │
│   └── pages/
│       ├── index.md                    Page d'accueil : architecture, vue d'ensemble des deux
│       │                              domaines, méthodologie et gouvernance.
│       ├── tiers-financiers.md         Catalogue détaillé du domaine Tiers financiers.
│       ├── structure-hospitaliere.md   Catalogue détaillé du domaine Structure hospitalière.
│       └── downloads.md                Page de téléchargement des artefacts publiés.
│
├── fsh-generated/    Sortie SUSHI (régénérée à chaque build, non versionnée en pratique).
├── input-cache/      Cache local du IG Publisher (jar, packages FHIR téléchargés).
├── output/           Site HTML généré par le IG Publisher (dont qa.html).
└── temp/             Fichiers de travail du IG Publisher.
```

## Conventions de nommage observées dans ce dépôt

- **Profils** : `<Concept>Profile.fsh` dans `input/fsh/profiles/`. Attention, une exception existe :
  le profil `TiersProfile` est défini dans le fichier `CPageTiersProfile.fsh` (nom de fichier
  historique non aligné avec le nom du profil qu'il contient) — se fier au contenu du fichier
  (`Profile: TiersProfile`), pas à son nom.
- **Extensions** : `<Concept>Extension.fsh` ou `<Concept>Extensions.fsh` (au pluriel quand le fichier
  regroupe plusieurs extensions liées, ex. `EntiteJuridiqueExtensions.fsh`,
  `CentreResponsabiliteExtensions.fsh`, `UFExtensions.fsh`).
- **CodeSystems / ValueSets** : `<Concept>CodeSystem.fsh` / `<Concept>ValueSet.fsh`, mais certains
  CodeSystems/ValueSets liés à une extension métier sont déclarés directement dans le fichier de
  l'extension plutôt que dans `codesystems/`/`valuesets/` (ex. `EJCategoriePmsiCS`/`EJCategoriePmsiVS`
  dans `EntiteJuridiqueExtensions.fsh`).
- **Profils socles (non instanciés directement)** : `StructureHospitaliereOrganizationProfile`
  (parent de Pôle, Service, Centre de Responsabilité, Centre d'Activité, Département, Unité
  Médicale) et `StructureHospitaliereSiteProfile` (parent de Chambre et Lit) — ne pas les confondre
  avec des profils métier terminaux.

## Ce que ce dépôt ne contient PAS

- Aucune ressource clinique (`Patient`, `Practitioner`, `PractitionerRole`, etc.) — voir
  `input/pages/index.md` pour la justification de ce choix architectural.
- Aucun profil ou extension propre à CPage (comptabilité M21/M22 détaillée, URSSAF/CNRACL/IRCANTEC,
  TVA/coefficients T2A détaillés, etc.) : ces éléments vivent dans `ig-md-fhir-cpage`, un dépôt
  frère, pas dans celui-ci.
- Aucune opération de publication/synchronisation (`PublicationBatch`, `PublicationBatchItem`,
  `$publication-bundle`, etc.) : ces éléments vivent dans `ig-md-fhir-operations`.

## Ne pas modifier

- Les fichiers `.fsh` doivent être modifiés avec la même rigueur que le reste du code — vérifier
  systématiquement contre la source Oracle documentée en commentaire d'en-tête avant tout changement
  de mapping.
- `input-cache/`, `output/`, `temp/`, `fsh-generated/` sont des artefacts de build : ne jamais les
  modifier à la main, ils sont régénérés par SUSHI/IG Publisher.
