# ig-md-fhir-common

IG FHIR — Socle commun du Master Data CPage

| | |
|---|---|
| **Version** | 0.1.0 |
| **Statut** | Draft |
| **FHIR** | 4.0.1 |
| **Dépendance** | `hl7.fhir.fr.core` 2.2.0 |
| **Jurisdiction** | France |

## Vue d'ensemble

Cet Implementation Guide définit le socle FHIR générique, vendor-neutral, du Master Data CPage : les
profils, extensions et terminologies communs à deux domaines métier — les **tiers financiers**
(fournisseurs, débiteurs, payeurs santé) et la **structure hospitalière** (GHT, entité juridique,
entité géographique, pôles, unités fonctionnelles, chambres, lits...). Il est construit directement
sur `hl7.fhir.fr.core` 2.2.0 et sert de socle aux IG spécialisés `ig-md-fhir-cpage` (extensions
propriétaires CPage) et `ig-md-fhir-operations` (opérations de publication/synchronisation).

Le narratif complet — architecture, catalogue de profils, extensions, terminologies, méthodologie et
gouvernance — est publié dans le guide lui-même : voir **[`input/pages/index.md`](input/pages/index.md)**
(page « Accueil » une fois l'IG construit), ainsi que ses deux pages de détail
[`tiers-financiers.md`](input/pages/tiers-financiers.md) et
[`structure-hospitaliere.md`](input/pages/structure-hospitaliere.md). Ce README ne duplique pas ce
contenu : il se limite au strict nécessaire pour construire et naviguer dans le dépôt.

Pour la disposition des fichiers du projet, voir [`STRUCTURE.md`](STRUCTURE.md).

## Prérequis

- [Node.js](https://nodejs.org/) (pour SUSHI, le compilateur FHIR Shorthand)
- Java (pour le IG Publisher HL7, téléchargé automatiquement par les scripts `_updatePublisher.*`)
- [SUSHI](https://fshschool.org/) : `npm install -g fsh-sushi` (ou via `npx fsh-sushi`)

## Construire l'IG

```bash
# Compiler uniquement les FSH (rapide, pour vérifier les erreurs de profils)
npx fsh-sushi build .

# Construction complète avec le IG Publisher (génère le site HTML, qa.html, etc.)
# Sous Windows :
_genonce.bat
# Sous Linux/macOS :
./_genonce.sh

# Mettre à jour le IG Publisher local
_updatePublisher.bat   # ou _updatePublisher.sh
```

La sortie SUSHI se trouve dans `fsh-generated/`, la sortie du IG Publisher dans `output/`
(non versionnés, voir `.gitignore`).

## Où trouver quoi

- `input/fsh/profiles/` — 21 profils (Organization / Location), voir le catalogue complet dans
  `input/pages/tiers-financiers.md` et `input/pages/structure-hospitaliere.md`.
- `input/fsh/extensions/` — environ 80 extensions FHIR.
- `input/fsh/codesystems/`, `input/fsh/valuesets/` — terminologies (nomenclatures PESv2, référentiel
  communes COG INSEE, nomenclatures internes CPage).
- `input/fsh/searchparameters/` — 10 SearchParameter personnalisés (domaine Tiers).
- `input/fsh/operations/` — l'opération personnalisée `$hierarchy` (reconstruction de la hiérarchie
  hospitalière en un seul Bundle).
- `input/fsh/examples/` — instances d'exemple et NamingSystem (RIDET, Tahiti, COG INSEE).
- `input/pages/` — narratif publié de l'IG.

## Dépôts liés

Ce dépôt fait partie d'un ensemble de trois IG publiés ensemble sous
<https://gipcpage.github.io/masterdata/> :

- `ig-md-fhir-common` (ce dépôt) — socle générique.
- `ig-md-fhir-cpage` — extensions et profils propriétaires CPage.
- `ig-md-fhir-operations` — opérations de publication/synchronisation du Master Data
  (`PublicationBatch`/`PublicationBatchItem`, etc.).

Ces deux autres dépôts ont leur propre documentation ; ce README ne les décrit pas en détail.
