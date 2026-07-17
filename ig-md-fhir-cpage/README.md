# ig-md-fhir-cpage

IG FHIR R4 spécifique à CPage pour le Master Data Management (MDM) hospitalier.

| | |
|---|---|
| **Id** | `ig.mdm.fhir.cpage` |
| **Version** | 0.1.0 |
| **Statut** | Draft |
| **FHIR** | 4.0.1 |
| **Juridiction** | France |

## Rôle de ce dépôt

Cet IG **hérite** de l'[IG Socle Commun](../ig-md-fhir-common) (`ig.mdm.fhir.common`,
dépendance `dev` dans `sushi-config.yaml`) et n'ajoute que ce qui est spécifique au
système CPage : 5 profils et 25 extensions câblés sur les tables Oracle historiques
`ECO.FOU`, `ECO.DBT`, `ECO.ETIER`, `STR.CHO`, `STR.ETA` et `STR.UFO`. Il ne
redéfinit jamais ce que son IG parent porte déjà.

Ce dépôt fait partie du monorepo [GIPCPAGE/masterdata](https://github.com/GIPCPAGE/masterdata),
publié sur <https://gipcpage.github.io/masterdata/>.

## Contenu

- `input/fsh/profiles/` — 5 profils : `CPageFournisseurProfile`,
  `CPageDebiteurProfile`, `CPageEntiteJuridiqueProfile`,
  `CPageEntiteGeographiqueProfile`, `CPageUFProfile`.
- `input/fsh/extensions/` — 16 fichiers portant 25 définitions d'`Extension`
  (certains fichiers en regroupent plusieurs, un par table/module Oracle : voir
  [`STRUCTURE.md`](STRUCTURE.md)).
- `input/fsh/codesystems/` et `input/fsh/valuesets/` — 3 terminologies CPage
  (validité, zone Europe, résidence).
- `input/pages/` — pages narratives publiées (`index.md`, `downloads.md`).

## Mapping Oracle → FHIR

Le détail complet, colonne Oracle par élément FHIR, pour chaque profil, est
maintenu dans [`LEGACY_SUPPORT.md`](LEGACY_SUPPORT.md). Ce document précise, pour
chaque profil, si le mapping a pu être vérifié contre un export DDL Oracle réel
(Fournisseur, Débiteur — via `Analyses/Tiers-Fournisseurs-Debiteurs.txt`) ou
seulement contre les commentaires embarqués dans le FSH (Entité Juridique, Entité
Géographique, UF), ainsi que les points de vigilance identifiés lors de la
relecture (annotations imprécises, chevauchements avec l'IG commun, colonnes
mentionnées mais non câblées).

## Limitations connues

Voir [`FSH-LIMITATIONS.md`](FSH-LIMITATIONS.md) : l'état actuel des contraintes
`maxLength`/motif sur les champs `string` de cet IG (documentées en `^short`, pas
appliquées comme contrainte FHIR), et les options FSH disponibles si elles doivent
un jour être ajoutées.

## Construire l'IG

```powershell
npm install -g fsh-sushi
sushi build .
```

Cet IG dépend de `ig.mdm.fhir.common` (`dev`) : sa résolution nécessite que le
paquet de l'IG commun soit présent dans le cache local FHIR (`~/.fhir/packages`).
En son absence, le build échoue uniquement sur la résolution des profils parents
(`Parent not found`) — c'est une limitation de l'environnement local, pas un défaut
de ce dépôt.

## Documentation publiée

La documentation narrative de cet IG (accueil, téléchargements, ressources de
conformité) est générée depuis `input/pages/` et publiée sur
<https://gipcpage.github.io/masterdata/>. La configuration des pages et du menu se
trouve dans `sushi-config.yaml`.

## Contact

- **Éditeur** : CPage
- **Email** : <contact@cpage.fr>
- **Web** : <https://www.cpage.fr>
