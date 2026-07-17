# Paramètres techniques (CPageParametresApplicatifProfile)

Ce profil est d'une nature différente des autres profils de cet IG. Les profils
`CPageFournisseurProfile`, `CPageDebiteurProfile`, `CPageEntiteJuridiqueProfile`,
`CPageEntiteGeographiqueProfile` et `CPageUFProfile` **spécialisent** un profil
générique du [socle commun](https://www.cpage.fr/ig/masterdata/common/) pour
exposer des colonnes issues de tables Oracle legacy (`ECO.*`, `STR.*`). Ce n'est
pas le cas de `CPageParametresApplicatifProfile` : il ne dérive d'aucun profil
Organization/Location du socle commun, et sa terminologie ne vient pas d'Oracle
mais de deux énumérations Java du code applicatif (`TypeParametreEnum` et
`TypeDonneeEnum`, `master-data-api`) — voir « Sourcing » ci-dessous. C'est
pourquoi il fait l'objet de cette page dédiée plutôt que d'une section dans
[`LEGACY_SUPPORT.md`](https://github.com/GIPCPAGE/masterdata/blob/master/ig-md-fhir-cpage/LEGACY_SUPPORT.md),
qui reste réservé au mapping legacy Oracle → FHIR.

## Ce que ce profil représente

Un « paramètre applicatif » est une valeur de configuration fonctionnelle d'un
module — CPage (délai de session, taux de TVA, timeout d'un connecteur...) ou
**application legacy** — centralisée dans le Master Data. L'objectif n'est pas
limité aux nouveaux modules CPage : le Master Data a vocation à devenir le point
de centralisation unique des paramètres de configuration de l'ensemble des
applicatifs du GHT, y compris legacy, pour garantir leur cohérence entre tous les
établissements plutôt que de laisser chaque application maintenir sa propre copie
locale. Dans la typologie de ressources du Master Data, ce concept correspond au
type **Paramétrage** (configuration technique/fonctionnelle, modifiable par les
administrateurs, traçabilité des modifications — cf. le Knowledge Graph du
projet). Le champ `module` (ex. `CORE`, `GAP`, `GEF`) et l'exemple `connecteur`
(ex. `HL7`, `DMP`, `CARDIO`) illustrent déjà cette portée volontairement large —
pas seulement CPage.

Le profil hérite directement de la ressource FHIR standard `Parameters` (pas
d'`Organization` ni de `Location`) : chaque instance encode **un seul**
paramètre, sous forme d'une liste de `parameter` nommés.

## Structure

| `parameter.name` | Cardinalité | Rôle |
|---|---|---|
| `identifiant` | 1..1 | Clé fonctionnelle stable du paramètre (ex. `TI_TIMEOUT_448495`), max 20 caractères |
| `libelle` | 1..1 | Libellé affiché dans l'IHM, max 255 caractères |
| `valeur` | 1..1 | Valeur sérialisée en `string` — le type réel est indiqué par `typeDonnee`, max 255 caractères |
| `typeDonnee` | 1..1 | Code du type de la valeur (`B`/`D`/`I`/`S`/`F`/`C`, `CPageParametresApplicatifTypeDonneeCodeSystem`), nécessaire au module consommateur pour désérialiser `valeur` correctement |
| `actif` | 1..1 | `"true"`/`"false"` — désactivation logique du paramètre |
| `typeParametre` | 1..1 | Catégorie fonctionnelle et gouvernance du paramètre (`A`/`S`/`U`/`C`/`D`/`P`, `CPageParametresApplicatifTypeCodeSystem`) |
| `module` | 0..1 | Module CPage propriétaire (ex. `CORE`, `GAP`, `GEF`), max 3 caractères |
| `connecteur` | 0..1 | Identifiant du connecteur concerné (ex. `HL7`, `DMP`, `CARDIO`) — requis si `typeParametre = C` |
| `commentaire` | 1..1 | Description libre du paramètre, max 4000 caractères |
| `controle_parametre` | 0..1 | Règle de contrôle de la valeur (ex. expression régulière, plage), max 255 caractères |
| `utilisateur` | 0..1 | Dernier modificateur (login ou UUID Keycloak), max 255 caractères |
| `mots_cle` | 0..* | Mots-clés de recherche/classification, répétable |
| `periodes` | 0..* | Périodes de validité d'une valeur — uniquement pour `typeParametre = D` ou `P` (voir ci-dessous) |

### Terminologies

**`CPageParametresApplicatifTypeCodeSystem`** (type fonctionnel — gouvernance) :

| Code | Libellé | Signification |
|---|---|---|
| `A` | Administrateur | Géré par un administrateur |
| `S` | Système | Interne à CPage |
| `U` | Utilisateur | Préférence modifiable par l'utilisateur final |
| `C` | Connecteur | Configuration d'un connecteur — `connecteur` devient pertinent |
| `D` | Administrateur - Périodique | Révision périodique, gérée par un administrateur — active `periodes` |
| `P` | Système - Périodique | Révision périodique, interne à CPage — active `periodes` |

**`CPageParametresApplicatifTypeDonneeCodeSystem`** (type de la valeur sérialisée) :
`B` (Boolean), `D` (Date, ISO-8601), `I` (Integer), `S` (String), `F` (Float),
`C` (Character).

### Sourcing des CodeSystems

Contrairement au reste du guide, ces deux CodeSystems ne dérivent pas d'une
table Oracle : leur en-tête FSH indique explicitement `TypeParametreEnum` et
`TypeDonneeEnum`, deux énumérations Java du code applicatif `master-data-api`.
Toute évolution de ces énumérations côté code doit se répercuter ici.

### Périodes de validité (`periodes`)

Pour un paramètre à révision périodique (`typeParametre = D` ou `P`), `periodes`
porte une ou plusieurs périodes, chacune avec :

| `part.name` | Cardinalité | Rôle |
|---|---|---|
| `date_debut` | 1..1 | Date de début de validité de cette valeur |
| `date_fin` | 0..1 | Date de fin — absente pour la période actuellement en vigueur |
| `valeur` | 1..1 | Valeur applicable sur cette période, max 255 caractères |

## Portée : GLOBAL vs TENANT

Rien dans la structure FHIR ne porte explicitement un `tenantId` — la portée
d'un paramètre (partagé à tout le GHT, ou propre à un établissement) se déduit
du contexte de publication (cf. `ig-md-fhir-operations`, scopes `GLOBAL`/`CLIENT`
des lots de publication), pas d'un champ de ce profil.

## Exemples

Trois instances illustrent les trois cas d'usage principaux (`input/fsh/examples/`) :

- **`ExempleParametresApplicatifGlobal`** — `CORE_SESSION_EXPIRATION_480` :
  durée d'expiration de session (480 minutes), `typeParametre = S` (Système),
  `typeDonnee = I` (Integer), partagée à l'ensemble du GHT (golden record, sans
  `periodes`).
- **`ExempleParametresApplicatifPeriodique`** — `GEF_TAUX_TVA` : taux de TVA du
  module GEF, `typeParametre = D` (Administrateur - Périodique), deux périodes
  successives (20 % jusqu'au 31/12/2024, 21 % à partir du 01/01/2025) — illustre
  `periodes` avec une période close (`date_fin` renseignée) et une période
  ouverte (`date_fin` absente).
- **`ExempleParametresApplicatifTenant`** — `TI_TIMEOUT_448495` : timeout du
  connecteur `HL7` pour le module `CORE`, `typeParametre = C` (Connecteur),
  propre à un établissement, avec `controle_parametre` renseigné.

## Retour

[Accueil](index.html) · [Ressources de conformité](artifacts.html)
