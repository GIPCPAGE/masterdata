# ig-md-fhir-cpage

IG FHIR spécialisé CPage pour le Master Data Management (MDM) hospitalier.

| | |
|---|---|
| **Version** | 0.1.0 |
| **Statut** | Draft |
| **FHIR** | 4.0.1 |
| **Juridiction** | France |

## Vue d'ensemble

Cet Implementation Guide (IG) hérite du [IG Socle Commun](../ig-md-fhir-common)
(`ig.mdm.fhir.common`, dépendance `dev` déclarée dans `sushi-config.yaml`) et ajoute les
extensions et profils propres au système CPage, câblés sur les tables Oracle historiques
(`ECO.FOU`, `ECO.DBT`, `ECO.ETIER`, `STR.CHO`, `STR.ETA`, `STR.UFO`).

Ce dépôt fait partie du monorepo [GIPCPAGE/masterdata](https://github.com/GIPCPAGE/masterdata),
publié sur <https://gipcpage.github.io/masterdata/>.

## Contenu

- `input/fsh/profiles/` — 5 profils : `CPageFournisseurProfile`, `CPageDebiteurProfile`,
  `CPageEntiteJuridiqueProfile`, `CPageEntiteGeographiqueProfile`, `CPageUFProfile`.
- `input/fsh/extensions/` — 16 fichiers, 26 définitions d'extension CPage.
- `input/fsh/codesystems/` et `input/fsh/valuesets/` — terminologies CPage (validité,
  résidence, zone Europe).
- `input/pages/` — pages narratives publiées (`index.md`, `downloads.md`).

Voir [`STRUCTURE.md`](STRUCTURE.md) pour le détail de l'arborescence.

## Mapping Oracle → FHIR

Le mapping complet, colonne Oracle par élément FHIR, pour chaque profil, est documenté
dans [`LEGACY_SUPPORT.md`](LEGACY_SUPPORT.md). Ce document précise aussi, pour chaque
profil, si le mapping a pu être vérifié contre un export DDL Oracle réel (Fournisseur,
Débiteur) ou seulement contre les commentaires embarqués dans le FSH (Entité Juridique,
Entité Géographique, UF — aucun DDL indépendant n'est disponible pour `STR.CHO`/
`STR.ETA`/`STR.UFO` dans ce dépôt).

## Limitations connues

Voir [`FSH-LIMITATIONS.md`](FSH-LIMITATIONS.md) pour la limitation FSH/SUSHI actuelle
sur les contraintes de longueur/motif appliquées aux champs `string`.

## Construire l'IG

```powershell
npm install -g fsh-sushi
sushi build .
```

Cet IG dépend de `ig.mdm.fhir.common` (`dev`) : sa résolution nécessite que le paquet du
IG commun soit disponible dans le cache local FHIR (`~/.fhir/packages`), sans quoi le
build échoue uniquement sur la résolution des profils parents — c'est une limitation
connue de l'environnement local, pas un défaut de ce dépôt.

## Documentation publiée

La documentation narrative de cet IG (page d'accueil, téléchargements, ressources de
conformité) est générée depuis `input/pages/` et publiée sur
<https://gipcpage.github.io/masterdata/>. Consulter `sushi-config.yaml` pour la
configuration des pages et du menu.

## Contact

- **Éditeur** : CPage
- **Email** : <contact@cpage.fr>
- **Web** : <https://www.cpage.fr>
