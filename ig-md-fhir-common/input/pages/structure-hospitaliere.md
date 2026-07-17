# Structure hospitalière

Cette page détaille le domaine **Structure hospitalière** de l'IG Commun CPage MasterData : la
hiérarchie organisationnelle et physique complète d'un établissement de santé, du groupement de
territoire jusqu'au lit.

## Note sur le niveau de vérification des mappings

Les mappings Oracle → FHIR de ce domaine sont documentés à partir des **commentaires d'en-tête des
fichiers FSH** (mapping colonne par colonne, souvent très détaillé). Contrairement au domaine
[Tiers financiers](tiers-financiers.html), pour lequel un export réel du DDL Oracle
(`ECO.ETIER`/`FOU`/`DBT`) a permis de vérifier chaque mapping, **aucun DDL équivalent n'était
disponible** pour les tables `STR.CHO`, `STR.ETA`, `STR.POA`, `STR.SER`, `STR.CRE`, `STR.UFO`,
`PAT.PIE` et `PAT.LLI`. Les informations ci-dessous sont donc présentées « d'après le FSH » et non
« vérifiées contre le DDL Oracle » — une nuance de fiabilité assumée plutôt que de faux garantir un
niveau de vérification identique aux deux domaines.

## La hiérarchie hospitalière : explication métier

```text
GHT (groupement de territoire)
 └─ Entité Juridique — l'établissement, personne morale (SIRET/FINESS de tête)
     └─ Entité Géographique — un site physique de cet établissement
         ├─ Service — hiérarchie historique parallèle au Pôle
         ├─ Secteur — psychiatrie (CSP art. R3221-1), aucun cas Oracle réel à ce jour
         └─ Pôle — macro-structure médicale (loi HPST 2009)
             └─ Centre de Responsabilité — unité budgétaire (M21/M22)
                 ├─ Centre d'Activité — regroupement analytique d'UF
                 └─ Unité Fonctionnelle (UF) — plus petite unité de production médicale (MOS/DGOS)
                     ├─ PAC/UAC — unité élémentaire de facturation PMSI
                     ├─ Salle d'examen
                     └─ Chambre
                         └─ Lit
Département / Unité Médicale — niveaux additionnels, absents d'Oracle, pour interopérabilité DPI/PMSI
```

**Relations multi-parents (`partOf` vs `member`)** : le schéma ci-dessus montre le rattachement
budgétaire/structurel principal de chaque entité (`partOf`, cardinalité unique). Conformément à FR
Core (`structure_relations.html`, règles STRU-1/STRU-6 : *"une entité peut être rattachée à
plusieurs entités père"*), une UF peut être **simultanément** membre d'un Service, d'un Secteur, d'un
Centre d'Activité et d'un Pôle, en plus de son `partOf` budgétaire vers le Centre de Responsabilité.
FR Core résout ce cas via l'extension `member`, portée par le **parent** qui liste ses membres
(l'inverse de `partOf`, porté par l'enfant) — c'est donc `PoleProfile`, `ServiceProfile`,
`CentreActiviteProfile` et `SecteurProfile` qui déclarent chacun `extension[membres]` pointant vers
leurs UF membres, sur le même modèle que `GHTProfile` qui liste ses Entités Juridiques membres.

- **GHT (Groupement Hospitalier de Territoire)** : dispositif créé par la loi de modernisation du
  système de santé (2016) regroupant plusieurs établissements publics d'un même territoire, qui
  mutualisent certaines fonctions (système d'information, achats...). Dans le contexte CPage, **une
  instance du Master Data est déployée pour un GHT** : `GHTProfile` permet d'exposer explicitement ce
  niveau racine dans les Bundles FHIR. C'est le seul profil de ce domaine à portée **GLOBAL** (visible
  par tous les établissements membres) ; tous les autres sont à portée **TENANT**.
- **Entité Juridique (EJ)** : l'établissement en tant que personne morale — celle qui porte le SIRET
  et le FINESS de tête, le statut juridique, la catégorie PMSI. Un GHT regroupe plusieurs EJ.
- **Entité Géographique (EG)** : un site physique de cette entité juridique (un EJ peut avoir
  plusieurs sites géographiques distincts, chacun avec sa propre adresse, son propre FINESS de site,
  ses propres coefficients tarifaires T2A).
- **Pôle** : macro-structure médicale introduite par les réformes de gouvernance hospitalière
  (ordonnance de 2005, loi HPST de 2009), regroupant plusieurs services/UF autour d'une même
  discipline, pilotée par un chef de pôle avec une délégation de gestion budgétaire.
- **Service** : hiérarchie historique, parallèle au Pôle. Certains établissements l'utilisent encore
  comme structure de rattachement opérationnelle des UF, en plus ou à la place du Pôle — le Service
  liste ses UF membres via l'extension multi-parent FR Core (`member`, voir ci-dessous).
- **Secteur** : zone géographique et démographique définie pour l'organisation des soins
  psychiatriques (Code de la santé publique, art. R3221-1, R3221-4, R3221-5). Ajouté au modèle bien
  qu'**aucun établissement psychiatrique sectorisé ne soit géré à ce jour** par CPage — pour couvrir
  le type FR Core `SECTEUR` sans attendre un premier cas d'usage réel. Comme le Pôle et le Service, un
  Secteur liste ses UF membres via `member`.
- **Centre de Responsabilité (CR)** : unité budgétaire — un centre de coût au sens de la comptabilité
  publique hospitalière (cadres M21/M22), identifié par une lettre budgétaire obligatoire. Rattaché
  soit à un Pôle, soit directement à l'Entité Juridique si aucun pôle n'est renseigné. Conforme FR
  Core (`member` porté par le parent) : le rattachement à l'Entité Juridique, y compris quand
  `partOf` référence un Pôle, est exprimé côté EJ (`EntiteJuridiqueProfile.extension[membres]`) plutôt
  que par une extension portée par le CR lui-même.
- **Centre d'Activité (CAC)** : regroupement **analytique** des UF — un troisième axe de
  classification, distinct de l'axe organisationnel (Pôle) et de l'axe budgétaire (CR), utilisé pour
  la comptabilité analytique et les statistiques d'activité.
- **Unité Fonctionnelle (UF)** : historiquement l'entité centrale de CPage et du dispositif national
  MOS/DGOS — la plus petite unité de production médicale homogène. La quasi-totalité de l'activité
  clinique, administrative et budgétaire (lits, personnel, facturation) est rattachée à ce niveau.
  Une UF est budgétairement rattachée à un CR (`partOf`), physiquement localisée sur une Entité
  Géographique (qui peut différer du site de son CR), et peut être listée comme membre d'un Service,
  d'un Secteur, d'un Centre d'Activité et/ou d'un Pôle simultanément — ces relations multi-parents
  sont portées par l'extension FR Core `member`, déclarée du côté de ces quatre entités parentes (pas
  sur l'UF elle-même, conformément à la sémantique FR Core — voir la note sur `partOf` vs `member`
  ci-dessus).
- **PAC/UAC (Poste / Unité d'Activité Complémentaire)** : l'unité élémentaire de **facturation** des
  activités de soins PMSI — associe une discipline de prestation à un tarif de nuit/jour de
  prestation (TNJP). À ne pas confondre avec le Centre d'Activité (CAC), qui est un concept analytique
  Oracle : le PAC/UAC est absent d'Oracle CPage et a été ajouté au Master Data pour l'interopérabilité
  DPI/PMSI.
- **Chambre** et **Lit** : l'inventaire physique (ressources `Location`) — une chambre est gérée par
  une UF, un lit appartient à une chambre. Point notable : dans Oracle CPage, la gestion des chambres
  et des lits vit dans le schéma **patients** (`PAT.PIE`, `PAT.LLI`), pas dans le schéma **structure**
  (`STR`), bien qu'il s'agisse conceptuellement d'éléments de la structure hospitalière.
- **Salle d'examen** : une salle de consultation/examen, gérée par une UF. Absente d'Oracle CPage,
  ajoutée pour l'interopérabilité DPI/PMSI (type `SL_EXM`).
- **Département** et **Unité Médicale (UM)** : deux niveaux **absents d'Oracle CPage**, sans table
  source dédiée dans les modules STR ou PAT. Ils ont été créés et sont gérés directement dans le
  Master Data pour assurer la compatibilité avec les DPI et le PMSI, qui référencent ces concepts
  nationaux (notamment le « département médical », utilisé comme niveau intermédiaire dans certains
  CHU). Important : selon la doctrine MOS/DGOS, l'UF est la plus petite unité de production médicale
  homogène — l'UM **n'est pas** un simple sous-niveau de l'UF ; la relation entre UM et UF dépend du
  référentiel de chaque établissement. C'est pourquoi ces deux profils ne contraignent pas strictement
  leur `partOf` à une seule autre entité de la hiérarchie.

## Catalogue des profils

| Profil | Parent FHIR | Table Oracle source | Rôle métier |
|---|---|---|---|
| `GHTProfile` | `FRCoreOrganizationProfile` | *(aucune — le GHT est l'instance MDM elle-même)* | Groupement hospitalier de territoire ; niveau racine, portée GLOBAL |
| `EntiteJuridiqueProfile` | `FRCoreOrganizationEtablissementProfile` (FR Core) | `STR.CHO` | Établissement, personne morale (SIRET/FINESS de tête, statut juridique) |
| `EntiteGeographiqueProfile` | `FRCoreOrganizationEtablissementProfile` (FR Core) | `STR.ETA` | Site géographique d'un établissement |
| `StructureHospitaliereOrganizationProfile` | `FRCoreOrganizationProfile` | *(socle, non instancié directement)* | Profil de base commun à Pôle, Service, CR, CAC, Département, UM |
| `PoleProfile` | `StructureHospitaliereOrganizationProfile` | `STR.POA` | Macro-structure médicale (loi HPST) |
| `ServiceProfile` | `StructureHospitaliereOrganizationProfile` | `STR.SER` | Hiérarchie historique parallèle au Pôle |
| `SecteurProfile` | `StructureHospitaliereOrganizationProfile` | absent d'Oracle, aucun cas réel à ce jour | Secteur psychiatrique (CSP art. R3221-1) — couverture du type FR Core `SECTEUR` |
| `CentreResponsabiliteProfile` | `StructureHospitaliereOrganizationProfile` | `STR.CRE` | Unité budgétaire (M21/M22) |
| `CentreActiviteProfile` | `FRCoreOrganizationProfile` | attribut `CAC_NUACAC` de `STR.UFO` | Regroupement analytique d'UF |
| `DepartementProfile` | `StructureHospitaliereOrganizationProfile` | absent d'Oracle, ajouté pour PMSI/DPI | Niveau intermédiaire optionnel pôle ↔ services (certains CHU) |
| `UniteMedicaleProfile` | `StructureHospitaliereOrganizationProfile` | absent d'Oracle, ajouté pour PMSI/DPI | Unité médicale au sens MOS/DGOS, référencée par les DPI |
| `UFProfile` | `FRCoreOrganizationUFProfile` (FR Core) | `STR.UFO` | Unité Fonctionnelle — plus petite unité de production médicale |
| `PacUacProfile` | `FRCoreOrganizationUACProfile` (FR Core) | absent d'Oracle, ajouté pour PMSI/DPI | Unité élémentaire de facturation PMSI (discipline + tarif TNJP) |
| `StructureHospitaliereSiteProfile` | `FRCoreLocationProfile` (FR Core) | *(socle, non instancié directement)* | Profil de base commun à Chambre et Lit |
| `ChambreProfile` | `StructureHospitaliereSiteProfile` | `PAT.PIE` | Chambre d'hospitalisation, gérée par une UF |
| `LitProfile` | `StructureHospitaliereSiteProfile` | `PAT.LLI` | Lit, rattaché à une chambre |
| `SalleExamenProfile` | `StructureHospitaliereSiteProfile` | absent d'Oracle, ajouté pour PMSI/DPI | Salle de consultation/examen, gérée par une UF |

## Modèle temporel récurrent

La plupart des tables Oracle sources de ce domaine ont une **clé primaire composite incluant une date
de début de période** (ex. `STR.UFO` : `NUUFUF + DATDUF`). Chaque profil concerné (EG, Pôle, Service,
CR, UF, Chambre, Lit) reproduit donc systématiquement la même paire d'extensions :

- une extension **`*PeriodeValidite`** (`dateDebut` 1..1, `dateFin` 0..1) portant la période de
  validité de cette version de l'enregistrement ;
- une extension **`*CodeValidite`**, valeur `F` (Fermé) / `I` (Invalide) / `V` (Valide), qui vient en
  complément du champ standard FHIR `active`/`status`.

Ce doublement (extension de code de validité **et** élément FHIR standard `active`) reflète une
volonté de conserver le code métier Oracle d'origine (utile pour la traçabilité et pour les
consommateurs legacy) tout en exposant la sémantique FHIR standard attendue par les nouveaux
consommateurs.

## Extensions par entité

| Entité | Extensions propres (hors paire période/validité) |
|---|---|
| Entité Juridique | Statut juridique, code APE/NAF, numéro CPCM, catégorie PMSI (10/20/21/22/30/40), code CEDEX, localisation DOM/TOM, numéros émetteur EH, indicateur arrondissement, Centres de Responsabilité membres (`member`) |
| Entité Géographique | Secteur sanitaire, code NAF, libellé de localisation, indicateur SAE, horaires d'ouverture, coefficients géographique et de transition T2A |
| Pôle | UF membres (`member`) |
| Service | Sigle, type de service (Direction/Service), UF membres (`member`) |
| Secteur | Responsable du secteur (contact), UF membres (`member`) |
| Centre d'Activité | UF membres (`member`) |
| Centre de Responsabilité | Lettre budgétaire (obligatoire), code secteur budgétaire, code direction transversale |
| Unité Fonctionnelle | Site de localisation géographique (obligatoire), pôle optionnel, type d'UF médicale, indicateur séances, classe dominante, lits urgence, activité libérale, maternité, confidentialité, UF de responsabilité, lettre budgétaire (obligatoire), domaine d'activité, libellé très long, type d'autorisation UM, type d'autorisation urgence, catégorie d'UF, regroupements analytiques (RU1/RU2/urgence, centre d'activité, département, section de prix de revient...) |
| Chambre | Indicateur chambre individuelle |
| Lit | Type de lit (9 valeurs : standard, bébé, hospitalisation, isolement, pédiatrie, soins, urgences, chirurgie, rééducation), indicateur lit de séances, date d'indisponibilité, type d'autorisation |
| Toutes (Organization et Location) | `StrHCodeInterneExtension` — code interne SIH source, générique |

## L'opération `$hierarchy`

`GET /Organization/$hierarchy` est une **opération FHIR personnalisée**, sans équivalent natif dans
FHIR R4 (`OperationDefinition` : `strh-hierarchy-operation`). Elle retourne, en un seul appel,
l'intégralité de la hiérarchie organisationnelle d'un établissement sous forme d'un `Bundle` FHIR
`type=collection` :

```text
GHT → EJ → EG → (Service | Pôle → CR → Centre d'Activité) → UF → Chambre → Lit
```

Elle est exposée à l'identique sur les trois endpoints du Master Data — Common, CPage et FR Core —
afin qu'un consommateur puisse obtenir la même hiérarchie exprimée dans le vocabulaire de profils
qu'il préfère :

- `GET /fhir/strh/Organization/$hierarchy`
- `GET /fhir/cpage/strh/Organization/$hierarchy`
- `GET /fhir/frcore/strh/Organization/$hierarchy`

### Paramètres

| Paramètre | Type | Rôle |
|---|---|---|
| `_since` | `instant` (standard FHIR) | Ne retourne que les entités dont au moins une version a été créée après cet instant — permet un delta sync |
| `includeInactive` | `boolean` (custom MDM) | Inclut les entités fermées/désactivées ; `false` par défaut |
| `search` | `string` (custom MDM) | Filtre texte libre sur les attributs des entités |

Le cloisonnement tenant est appliqué automatiquement à partir du claim JWT `tenant_id` ; un
administrateur sans `tenant_id` obtient tous les établissements.

### Pourquoi une opération personnalisée plutôt que `_include`/`_revinclude` ?

Reconstituer cette hiérarchie par une succession de requêtes `_include`/`_revinclude` récursives sur
`partOf` serait possible en théorie, mais coûteux (autant d'aller-retours que de niveaux) et fragile
en présence de relations multi-parents (une UF pouvant être listée comme membre d'un Service, d'un
Secteur, d'un Centre d'Activité et d'un Pôle simultanément via l'extension FR Core `member`, en plus
de son `partOf` budgétaire vers le Centre de Responsabilité). L'opération `$hierarchy` résout ce
graphe côté serveur et le restitue en un seul Bundle ordonné.

À noter : sur ce même point d'accès, l'historique complet est disponible via l'opération **standard**
FHIR R4 `GET /Organization/_history` (avec le paramètre standard `_since`) — `$hierarchy` ne
duplique pas cette fonctionnalité, elle la complète en ajoutant la reconstruction de l'arbre
hiérarchique, que `_history` ne fournit pas.

## Référentiel Communes françaises (COG INSEE)

Bien que rattaché aux deux domaines de cet IG (une adresse de tiers comme une adresse de site
hospitalier peut référencer une commune), le référentiel des communes françaises est décrit ici car
il repose, comme la structure hospitalière, sur la ressource `Location`.

Le profil `CommuneFrancaiseProfile` (parent : `Location` FHIR standard) représente une commune
française selon le **Code Officiel Géographique (COG)** maintenu par l'INSEE, mis à jour chaque
1ᵉʳ janvier. Chaque instance porte :

- un **code INSEE** à 5 caractères (`identifier[codeInsee]`) ;
- le **nom officiel** de la commune ;
- un ou plusieurs **codes postaux**, chacun accompagné du libellé postal La Poste (extension
  répétable `CommuneCodePostalExt`) ;
- le **type de territoire** (`type`, liaison requise sur `CommuneTypeTerritoireVS`) : commune
  ordinaire, commune nouvelle, ou commune déléguée ;
- les **codes département et région** INSEE (extensions) ;
- pour une commune déléguée : une référence `partOf` vers la commune nouvelle qui l'englobe.

Trois patrons d'usage, illustrés dans `ExemplesCommunesCOG.fsh` sur l'exemple réel de la fusion de
2019 dans le Rhône :

| Patron | Exemple | `status` | `type` |
|---|---|---|---|
| A — Commune historique inactive | Saint-Jean-d'Ardières (69282), fusionnée dans Belleville-en-Beaujolais au 01/01/2019 | `inactive` | `commune` |
| B — Commune nouvelle active | Belleville-en-Beaujolais (69264), créée le 01/01/2019 | `active` | `commune-nouvelle` |
| B' — Commune déléguée | Belleville-sur-Saône (69019), déléguée sous 69264 | `active` (conserve une existence administrative) | `commune-deleguee`, `partOf` renseigné |

### Deux CodeSystems, deux usages différents

Ce référentiel s'appuie sur **deux CodeSystems distincts**, à ne pas confondre :

- **`CommunesFrancaisesCodeSystem`** (`communes-fr-cs`, `content = #fragment`) : le CodeSystem
  effectivement référencé par `CommuneFrancaiseProfile`. Il énumère un **fragment représentatif** de
  concepts (les trois patrons ci-dessus, pris comme exemple réel) avec leurs propriétés
  (`inactive`, `dateCreation`, `dateSuppression`, `successeur`, `predecesseur`, `codePostal`,
  `typeTerritoire`, `codeDepartement`, `codeRegion`, `communeNouvelle`).
- **`CommunesINSEECodeSystem`** (`communes-insee-cs`, `content = #not-present`) : une déclaration de
  **terminologie de référence externe** — elle ne contient aucun concept énuméré et indique
  explicitement que les quelque 35 000 communes actives doivent être validées contre le COG INSEE
  officiel, pas contre une liste embarquée dans l'IG.

Le `NamingSystem` `insee-cog-commune` relie l'URI canonique CPage à l'**OID officiel INSEE**
(`1.2.250.1.213.2.12`), utilisé dans les échanges CDA et HL7 v2 historiques.

Le ValueSet `CommunesFrancaisesActivesValueSet` (`communes-fr-actives-vs`) filtre les communes dont
la propriété `inactive = false`, pour l'usage courant (saisie/validation d'adresse).

## Retour

[Accueil](index.html) · [Tiers financiers](tiers-financiers.html) ·
[Ressources de conformité](artifacts.html)
