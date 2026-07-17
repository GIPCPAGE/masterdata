# Mapping Legacy Oracle → FHIR — IG CPage

Ce document décrit, profil par profil, comment les extensions FHIR spécifiques à
`ig-md-fhir-cpage` se rattachent aux colonnes Oracle du système CPage historique
(schémas `ECO` et `STR`). Il s'adresse aux personnes qui doivent écrire ou relire un
mapping de migration ou d'interfaçage entre le legacy Oracle et FHIR.

**Hors périmètre de ce document** : `CPageParametresApplicatifProfile` n'a pas de
table Oracle source — sa terminologie vient de deux énumérations Java du code
applicatif (`master-data-api`), pas d'un schéma Oracle. Voir la page dédiée
[Paramètres techniques](https://gipcpage.github.io/masterdata/cpage/parametres-techniques.html)
plutôt qu'une section ici.

## Méthode et fiabilité des sources

Deux niveaux de vérification coexistent dans ce document, et sont indiqués
explicitement à chaque section :

- **DDL Oracle réel** — pour les profils **Fournisseur** et **Débiteur**, chaque
  colonne citée a été relue directement dans l'export `CREATE TABLE` de
  `ECO.ETIER`, `ECO.FOU` et `ECO.DBT` (fichier `Analyses/Tiers-Fournisseurs-Debiteurs.txt`
  à la racine de `mdm-igs`). Ce fichier contient aussi les deux triggers
  d'historisation et les contraintes `CHECK`, ce qui permet de vérifier non
  seulement le nom des colonnes mais leurs valeurs autorisées et leurs valeurs par
  défaut.
- **Commentaires FSH uniquement** — pour les profils **Entité Juridique**, **Entité
  Géographique** et **UF**, il n'existe dans ce dépôt aucun export `CREATE TABLE`
  pour les tables Oracle sources (`STR.CHO`, `STR.ETA`, `STR.UFO`). Le mapping
  provient donc uniquement des commentaires d'en-tête et d'extension déjà présents
  dans les fichiers `.fsh`. Ces commentaires sont internes et cohérents entre eux,
  mais n'ont pas pu être recoupés avec une source Oracle indépendante : cette partie
  du document documente l'**intention** du modèle, pas une vérification de second
  niveau.

Aucune colonne Oracle mentionnée ci-dessous n'est inventée : chaque ligne renvoie
soit à une entrée du DDL réel, soit à un commentaire présent dans un fichier `.fsh`
du dépôt `ig-md-fhir-cpage`.

## Contexte : le tiers pivot `ECO.ETIER`

`ECO.FOU` (Fournisseurs) et `ECO.DBT` (Débiteurs) sont deux tables filles d'une
table pivot **`ECO.ETIER`** ("Tiers"), reliées chacune par clé étrangère
(`FOU.ETIER_IDTITI`, `DBT.ETIER_IDTITI` → `ETIER.IDTITI`). `ETIER` porte un rôle
(`ROLETI`, contraint à `T`/`F`/`D`) et ses propres attributs génériques : validité
(`VALITI`), zone Europe (`EUROTI`, contrainte `EUROTI_CK` : `F`/`O`/`A`), identité
(SIRET/SIREN/FINESS/NIR/TVA), civilité, coordonnées, et quatre indicateurs booléens
de qualification du débiteur (`LABOTI`, `LOCATI`, `AGENTI`, `HOSPTI`).

`ECO.FOU` et `ECO.DBT` ont chacune, en plus, leurs **propres** colonnes de validité
(`FOU.VALIFO`, `DBT.INVADT`), et `ECO.FOU` a sa propre colonne de zone Europe
(`FOU.EUROFO`) — distincte de `ETIER.EUROTI`. C'est une source récurrente de
confusion dans les commentaires `^short` du FSH (voir les points de vigilance
ci-dessous) : les colonnes de niveau Tiers et les colonnes de niveau
Fournisseur/Débiteur ne portent pas toujours le même nom ni la même valeur.

`ECO.DBT` et `ECO.FOU` sont chacune couvertes par un trigger d'audit
(`ET_DBT_A_R_IUD_H`, `ET_FOU_A_R_IUD_H`) qui recopie l'état de la ligne à chaque
`INSERT`/`UPDATE`/`DELETE` dans une table d'historique (`DBT_H`, `FOU_H`), avec un
identifiant de révision (`IDRVN`) et un type de révision (`TYPERVN` : 0 création, 1
modification, 2 suppression). C'est le seul mécanisme d'historisation Oracle
disponible pour ces deux tables ; aucun trigger équivalent n'apparaît sur
`ECO.ETIER` dans le DDL disponible.

---

## 1. CPageFournisseurProfile

- **Parent** : `FournisseurProfile` (`ig-md-fhir-common`), lui-même dérivé de
  `TiersProfile`.
- **Table source** : `ECO.FOU` ("Fournisseurs"), liée à `ECO.ETIER` via
  `FOU.ETIER_IDTITI`.
- **Vérification** : DDL Oracle réel.

| Colonne `ECO.FOU` | Contrainte / défaut | Extension CPage | Élément FHIR |
|---|---|---|---|
| `VALIFO` | défaut `'V'` NOT NULL, `CHECK IN ('V','I')` | `CPageValidity` | `extension[cpageValidity]` |
| `EUROFO` | défaut `'A'` NOT NULL (« Fournisseur européen ») | `CPageEUZone` | `extension[cpageEUZone]` |
| `LBU6FO` | `VARCHAR2(1)` NOT NULL | `CPageSupplierAccountingClass6` | `extension[accountingClass6].extension[lbu]` |
| `CPT6FO` | `VARCHAR2(10)` NOT NULL, 1er car. dans `1..5` | `CPageSupplierAccountingClass6` | `extension[accountingClass6].extension[cpt]` |
| `LBU2FO` | `VARCHAR2(1)` NOT NULL | `CPageSupplierAccountingClass2` | `extension[accountingClass2].extension[lbu]` |
| `CPT2FO` | `VARCHAR2(10)` NOT NULL, 1er car. dans `1..5` | `CPageSupplierAccountingClass2` | `extension[accountingClass2].extension[cpt]` |
| `DEPAFO` | `NUMBER(3,0)`, `CHECK BETWEEN 0 AND 999` | `CPageSupplierPaymentTerms` | `extension[paymentTerms].extension[paymentDelayDays]` |
| `JOSPFO` | `NUMBER(2,0)` | `CPageSupplierPaymentTerms` | `extension[paymentTerms].extension[specificPaymentDay]` |
| `MTMIFO` | défaut `0`, `CHECK BETWEEN 0 AND 9999999999999.99` | `CPageSupplierPaymentTerms` | `extension[paymentTerms].extension[minimumOrderAmount]` |
| `TCMPFO` | défaut `'O'` NOT NULL, `CHECK IN ('O','N')` | `CPageSupplierPublicProcurement` | `extension[procurement].extension[publicProcurement]` |
| `GACHFO` | défaut `'N'` NOT NULL, `CHECK IN ('O','N')` | `CPageSupplierPublicProcurement` | `extension[procurement].extension[purchasingGroup]` |
| `ESCOFO` | défaut `'N'`, `CHECK IN ('O','N')` | `CPageSupplierPublicProcurement` | `extension[procurement].extension[discountable]` |
| `CHORFO` | défaut `'N'`, `CHECK IN ('O','N')` (« Assujetti à Chorus ») | `CPageSupplierChorus` | `extension[chorus].extension[subjectToChorus]` |
| `TIDCFO` | `VARCHAR2(2)` (« Type d'identifiant Chorus ») | `CPageSupplierChorus` | `extension[chorus].extension[chorusIdType]` |
| `IDCHFO` | `VARCHAR2(18)` (« Identifiant Chorus ») | `CPageSupplierChorus` | `extension[chorus].extension[chorusIdentifier]` |
| `EXTRFO` | défaut `'N'`, `CHECK IN ('O','N')` (« A extraire ») | `CPageSupplierInternalFlags` | `extension[internalFlags].extension[extractable]` |
| `MAJ_FO` | défaut `'N'`, `CHECK IN ('O','N')` | `CPageSupplierInternalFlags` | `extension[internalFlags].extension[changedSinceLastExtract]` |

### Points de vigilance (Fournisseur)

- **`EUROFO` vs `EUROTI`** : l'annotation `^short` de `extension[cpageEUZone]` dans
  `CPageFournisseurProfile.fsh` affiche `« Zone européenne (EUROTI) »`, alors que la
  colonne réellement portée par le rôle Fournisseur est `FOU.EUROFO`, pas
  `ETIER.EUROTI`. Les deux colonnes existent mais à des niveaux différents (Tiers vs
  Fournisseur) ; le libellé FSH est trompeur. Le domaine de valeurs (`F`/`O`/`A`)
  est identique dans les deux cas, seule la référence de colonne dans le commentaire
  est fausse.
- **Le lien retour Fournisseur→Débiteur n'a pas d'équivalent CPage.** Le DDL de
  `ECO.FOU` contient une colonne `NUDBFO` (« Débiteur associé »), symétrique de
  `DBT.NUFODT` (« Fournisseur associé »). Côté Débiteur, ce lien est modélisé
  **deux fois** : par `DebiteurParametresExtension.fournisseurAssocie` (commun,
  simple code string) et par `CPageDebtorAssociatedSupplier` (CPage, `Reference`
  FHIR vers l'`Organization` fournisseur). Côté Fournisseur, en revanche, `NUDBFO`
  n'est exposé que par l'extension commune `FournisseurAttributsExtension.debiteurAssocie`
  (toujours un simple code string) : **aucune extension CPage n'ajoute de
  `Reference` symétrique côté Fournisseur.** Ce n'est pas une erreur, seulement une
  asymétrie du modèle actuel, à connaître avant d'implémenter une résolution
  bidirectionnelle Fournisseur ↔ Débiteur.
- **Chevauchement avec l'IG commun** : la plupart des colonnes du tableau ci-dessus
  sont déjà exposées, sous un nom d'élément différent, par des extensions
  génériques portées par `FournisseurProfile` (le parent direct de ce profil) :
  `FournisseurComptabiliteExtension` (`LBU2FO`/`CPT2FO`/`LBU6FO`/`CPT6FO`),
  `FournisseurPaiementExtension` (`DEPAFO`/`JOSPFO`/`MTMIFO`/`ESCOFO`) et
  `FournisseurAttributsExtension` (`TCMPFO`/`GACHFO`/`CHORFO`/`TIDCFO`/`IDCHFO`/
  `EXTRFO`/`MAJ_FO`, entre autres). Les extensions CPage de ce profil dupliquent
  donc, sous une structure différente, des colonnes déjà lisibles une couche plus
  haut. Ce constat n'appelle pas de correction FSH dans le cadre de cette
  réécriture documentaire, mais toute personne qui écrit une valeur doit savoir sur
  quelle extension (commune ou CPage) la lire de façon fiable.

---

## 2. CPageDebiteurProfile

- **Parent** : `DebiteurProfile` (`ig-md-fhir-common`), lui-même dérivé de
  `TiersProfile`.
- **Table source** : `ECO.DBT` ("Debiteurs des Titres de Recettes"), liée à
  `ECO.ETIER` via `DBT.ETIER_IDTITI`, et fonctionnellement à `ECO.FOU` via
  `DBT.NUFODT` (relation documentée par un commentaire de colonne, sans contrainte
  `FOREIGN KEY` déclarée dans le DDL).
- **Vérification** : DDL Oracle réel.

| Colonne `ECO.DBT` | Contrainte / défaut | Extension CPage | Élément FHIR |
|---|---|---|---|
| `INVADT` | défaut `'V'` NOT NULL, `CHECK IN ('I','V')` (« Code Validite ») | `CPageValidity` | `extension[cpageValidity]` |
| `RESIDT` | défaut `'R'` NOT NULL, `CHECK IN ('R','N','E')` | `CPageDebtorResidency` | `extension[residency]` |
| `LBTIDT` | `VARCHAR2(1)` NOT NULL (« Lettre budgetaire ») | `CPageDebtorAccount` | `extension[debtorAccount].extension[budgetLetter]` |
| `CPTIDT` | `VARCHAR2(10)` NOT NULL (« No du compte de tiers ») | `CPageDebtorAccount` | `extension[debtorAccount].extension[thirdPartyAccount]` |
| `ASAPDT` | défaut `'N'` NOT NULL (« Ne pas générer d'ASAP dématérialisé O/N ») | `CPageDebtorAsap` | `extension[asap].extension[disableAsap]` |
| `FCENDT` | défaut `'N'` NOT NULL (« Forcer une impression au Centre d'Editique National ») | `CPageDebtorAsap` | `extension[asap].extension[forceCenPrint]` |
| `IDEXDT` | `VARCHAR2(20)` (« Identifiant Externe du débiteur ») | `CPageDebtorExternalId` | `extension[externalId]` |
| `NUFODT` | `VARCHAR2(6)` (« Fournisseur associé ») | `CPageDebtorAssociatedSupplier` | `extension[associatedSupplier]` (`Reference(Organization)`) |

### Points de vigilance (Débiteur)

- **Pas de zone Europe propre sur `ECO.DBT`.** Contrairement au Fournisseur, la
  table `DBT` ne comporte, dans le DDL vérifié, aucune colonne de type
  `EURODT`/équivalent. L'annotation `^short` de `extension[cpageEUZone]` sur
  `CPageDebiteurProfile.fsh` affiche pourtant `« Zone européenne (EUROTI) »`. La
  seule colonne candidate réelle est `ETIER.EUROTI` (accessible via la clé étrangère
  `DBT.ETIER_IDTITI`), qui est bien mentionnée dans la description narrative de
  l'extension commune `DebiteurParametresExtension` (« Correspond aux colonnes
  COMPTI, EUROTI, FACBTI, TRLSTI de la table ETIER ») **mais n'a pas de sous-élément
  dédié** : la liste réelle des sous-extensions de `DebiteurParametresExtension` est
  `compteLettre`/`typeResident`/`typeDebiteur`/`assuAutorise`/`forceImpressionCoh`/
  `facturationActesBiologie`/`liquidationSoupleAutorisee`/`asapDesactive`/
  `dateIntegration`/`fournisseurAssocie` — aucune n'est une zone Europe. **En
  l'état du FSH, `CPageEUZone` sur `CPageDebiteurProfile` ne correspond donc à
  aucune colonne concrètement câblée** ; seul le Fournisseur a un mapping réel et
  propre (`FOU.EUROFO`, section 1).
- **Nom de profil obsolète dans la description FSH.** `CPageDebtorAssociatedSupplierExtension.fsh`
  décrit sa cible comme « une Organization de profil `CPageSupplierOrganization` ».
  Ce profil n'existe pas dans ce dépôt ; le profil réel produit par cet IG est
  `CPageFournisseurProfile`. Ce texte est très probablement resté d'un renommage
  antérieur. Le mapping réel documenté ici est : `NUFODT` référence un
  `Organization` de profil `CPageFournisseurProfile`.
- **Chevauchement avec `DebiteurParametresExtension`** (commun, portée par
  `DebiteurProfile`) : `asapDesactive` (`ASAPDT`) et `fournisseurAssocie` (`NUFODT`)
  y sont déjà exposés — en plus, respectivement, de `CPageDebtorAsap.disableAsap`
  et `CPageDebtorAssociatedSupplier`. `DebiteurParametresExtension` couvre aussi
  `dateIntegration` (`DINTDT`), qu'aucune extension CPage ne reprend — c'est la
  seule voie d'accès FHIR à cette colonne.

---

## 3. CPageEntiteJuridiqueProfile

- **Parent** : `EntiteJuridiqueProfile` (`ig-md-fhir-common`), lui-même dérivé de
  `FRCoreOrganizationEtablissementProfile` (FR Core 2.2.0).
- **Table source** : `STR.CHO`.
- **Vérification** : **commentaires FSH uniquement**, aucun DDL indépendant
  disponible pour `STR.CHO` dans ce dépôt (voir « Méthode et fiabilité »
  ci-dessus).

Avant les champs CPage, `EntiteJuridiqueProfile` (IG commun) définit déjà
l'essentiel du profil générique : identifiants (UUID interne, code CPage
établissement, SIRET, FINESS, FINESS siège, TVA), nom/alias, adresse, télécoms,
extensions génériques (statut juridique, code APE, CPCM, catégorie PMSI, CEDEX,
DOM/TOM, numéros émetteur, arrondissement), un rattachement `partOf` vers un GHT
(`GHTProfile`), et — depuis la mise en conformité FR Core la plus récente — une
extension `extension[membres]` (`fr-core-organization-member`) qui liste les
Centres de Responsabilité directement rattachés à cette entité juridique. Cette
extension est portée par le parent (l'entité juridique), conformément à FR Core, et
non par les Centres de Responsabilité eux-mêmes. `CPageEntiteJuridiqueProfile` en
hérite automatiquement, sans qu'aucune modification CPage n'ait été nécessaire :
ce document ne détaille donc plus loin cette partie générique, qui est du ressort
de l'IG commun.

Les champs qui suivent sont les seuls ajoutés par le profil CPage lui-même.

### Receveur comptable — `CPageEJReceveurExtension`

| Colonne `STR.CHO` | Sous-élément de `extension[receveur]` |
|---|---|
| `RAISCH` (40 car.) | `extension[raisonSociale]` |
| `AD1RCH`/`AD2RCH`/`AD3RCH` | `extension[adresse].valueAddress.line[0..2]` |
| `BUDRCH` | `extension[adresse].valueAddress.city` |
| `COP_NCPOPO2` | `extension[adresse].valueAddress.postalCode` |
| `CBARCH` (5 car.) | `extension[rib].extension[codeBanque]` |
| `CGURCH` (5 car.) | `extension[rib].extension[codeGuichet]` |
| `CCBRCH` (11 car.) | `extension[rib].extension[numCompte]` |
| `CCIRCH` (2 car.) | `extension[rib].extension[cleRib]` |
| `CCPRCH` (15 car.) | `extension[rib].extension[centreCcp]` |
| `CBICCH` (11 car.) | `extension[bicIban].extension[bic]` |
| `CIBACH` (34 car.) | `extension[bicIban].extension[iban]` |
| `POSCCH` (6 car.) | `extension[posteComptable]` |
| `TELRCH` (20 car.) | `extension[telephone]` |
| `TELCCH` (20 car.) | `extension[telephoneCompl]` |

### Numéros d'organismes patronaux — `CPageEJOrganismesPatronauxExtension`

| Colonne `STR.CHO` | Sous-élément |
|---|---|
| `CACTCH` (7 car.) | `extension[accidentTravail]` |
| `CRECCH` (6 car.) | `extension[retraiteComplementaire]` |
| `CNAVCH` (10 car.) | `extension[cnavts]` |
| `IRCACH` (13 car.) | `extension[ircantec]` |
| `CAMACH` (12 car.) | `extension[camarca]` |
| `CNRACH` (6 car.) | `extension[cnracl]` |
| `URNOCH` (15 car.) | `extension[urssaf].extension[numero]` |
| `URCOCH` (4 car.) | `extension[urssaf].extension[code]` |
| `URLICH` (15 car.) | `extension[urssaf].extension[libelle]` |

### Paramètres de TVA — `CPageEJParametresTvaExtension`

| Colonne `STR.CHO` | Sous-élément |
|---|---|
| `TVARCH` | `extension[tauxRecuperableEnCours]` |
| `TVASCH` | `extension[tauxRecuperableSuivant]` |
| `LTVACH` (1 car.) | `extension[exploitationLettre]` |
| `CTVACH` (10 car.) | `extension[exploitationCompte]` |
| `LTVICH` (1 car.) | `extension[investissementLettre]` |
| `CTVICH` (10 car.) | `extension[investissementCompte]` |

### Indicateurs divers

| Colonne `STR.CHO` | Extension CPage |
|---|---|
| `TBICCH` (1 car.) | `CPageEJIndicateurBicExtension` → `extension[indicateurBic]` |
| `CM22CH` (O/N) | `CPageEJComptabiliteM22Extension` → `extension[comptabiliteM22]` (`boolean`) |
| `ITPGCH` (6 car.) | `CPageEJIdentifiantTpgExtension` → `extension[identifiantTpg]` |

`CATGCH`/`NATJCH` sont cités dans l'en-tête du profil CPage mais renvoient au
modèle FR Core générique (nature/catégorie juridique), pas à une extension CPage.

---

## 4. CPageEntiteGeographiqueProfile

- **Parent** : `EntiteGeographiqueProfile` (`ig-md-fhir-common`), lui-même dérivé
  de `FRCoreOrganizationEtablissementProfile` (FR Core 2.2.0).
- **Table source** : `STR.ETA`.
- **Vérification** : **commentaires FSH uniquement**, mêmes réserves que pour
  l'Entité Juridique.

Comme pour l'Entité Juridique, l'essentiel du profil générique (identifiants,
type `GEOGRAPHICAL-ENTITY`, nom/alias, adresse, télécoms, période de validité,
secteur sanitaire, code NAF, coefficients géographiques/transition T2A FR Core, et
`partOf` vers l'Entité Juridique) est défini par `EntiteGeographiqueProfile` dans
l'IG commun. `CPageEntiteGeographiqueProfile` n'ajoute que les champs suivants.

### Dates d'activation T2A — `CPageEGDatesActivationT2AExtension`

14 dates, regroupées par type d'activité (`DB**` = bases de remboursement
distinctes, `DF**` = facturation individuelle ; `*E` = externe, `*H` =
hospitalisation) :

| Colonne `STR.ETA` | Sous-élément |
|---|---|
| `DBMEET` / `DBMHET` | `extension[dbMcoHadExterne]` / `extension[dbMcoHadHospit]` |
| `DBSEET` / `DBSHET` | `extension[dbSsrExterne]` / `extension[dbSsrHospit]` |
| `DBPEET` / `DBPHET` | `extension[dbPsyExterne]` / `extension[dbPsyHospit]` |
| `DBLHET` | `extension[dbLongSejour]` |
| `DFMEET` / `DFMHET` | `extension[dfMcoHadExterne]` / `extension[dfMcoHadHospit]` |
| `DFSEET` / `DFSHET` | `extension[dfSsrExterne]` / `extension[dfSsrHospit]` |
| `DFPEET` / `DFPHET` | `extension[dfPsyExterne]` / `extension[dfPsyHospit]` |
| `DFLHET` | `extension[dfLongSejour]` |

### Coefficients tarifaires — `CPageEGCoefficientsTarifairesExtension`

| Colonne `STR.ETA` | Sous-élément |
|---|---|
| `CPRUET` | `extension[prudentiel]` |
| `CMCOET` | `extension[mco]` |
| `CFISCET` | `extension[cfisc]` |
| `CSEGURET` | `extension[segur]` |

### Paramètres de TVA — `CPageEGParametresTvaExtension`

| Colonne `STR.ETA` | Sous-élément |
|---|---|
| `TVARET` | `extension[tauxRecuperableEnCours]` |
| `TVASET` | `extension[tauxRecuperableSuivant]` |
| `LTVAET` | `extension[exploitationLettre]` |
| `CTVAET` | `extension[exploitationCompte]` |
| `LTVIET` | `extension[investissementLettre]` |
| `CTVIET` | `extension[investissementCompte]` |

**Point de vigilance** : l'en-tête de `CPageEntiteGeographiqueProfile.fsh` liste la
colonne `TVAIET` parmi les paramètres de TVA de ce profil, mais
`CPageEGParametresTvaExtension` n'a aucun sous-élément qui lui corresponde (la
liste réelle est celle des six lignes ci-dessus). C'est une incohérence interne au
commentaire du profil, pas une erreur de ce document — elle est signalée ici sans
être corrigée, la modification des `.fsh` étant hors périmètre.

---

## 5. CPageUFProfile

- **Parent** : `UFProfile` (`ig-md-fhir-common`), lui-même dérivé de
  `FRCoreOrganizationUFProfile` (FR Core 2.2.0).
- **Table source** : `STR.UFO`.
- **Vérification** : **commentaires FSH uniquement**, mêmes réserves que ci-dessus.

`UFProfile` (IG commun) porte déjà l'essentiel générique de l'UF : identifiants,
nom/alias, télécoms, période de validité, rattachement à un site géographique
(`siteLocalisation`, obligatoire), lettre budgétaire (obligatoire), et `partOf`
vers un Centre de Responsabilité. Les rattachements optionnels à un Service, un
Centre d'Activité ou un Pôle sont portés par ces profils eux-mêmes (extension
`membres`), pas par l'UF. `CPageUFProfile` ajoute trois modules métier CPage,
alignés sur les trois familles applicatives historiques (MAL/ECO/PER).

### Module MAL (patients / activité médicale) — `CPageUFModuleMalExtension`

| Colonne `STR.UFO` | Sous-élément |
|---|---|
| `UFM_NTLIUF` | `extension[nbLitsInstalles]` |
| `UFM_NTSEUF` | `extension[nbLitsSeances]` |
| `UFM_NBMNDH` | `extension[dureeMoyennePassage]` |
| `UFM_FMALUF` | `extension[utiliseCPagePatients]` |
| `UFM_SMMAUF` | `extension[majorationActes]` |
| `UFM_VNUIUF` | `extension[valeurDefautNuit]` |
| `UFM_ENAUUF` | `extension[genEnAtCreation]` |
| `UFM_REFOUF` | `extension[ufRefonctionnelle]` |
| `UFM_TSSRUF` | `extension[ufSSR]` |
| `UFM_CAFPUF` / `UFM_DUFPUF` | `extension[genAutoFinDP]` / `extension[dureeDP]` |
| `UFM_CAFSUF` / `UFM_DUFSUF` | `extension[genAutoFinSeance]` / `extension[dureeSeance]` |
| `UFM_CAFJUF` / `UFM_DUFJUF` | `extension[genAutoFinHJ]` / `extension[dureeHJ]` |
| `UFM_CAFNUF` / `UFM_DUFNUF` | `extension[genAutoFinHN]` / `extension[dureeHN]` |
| `UFM_DUSPUF` | `extension[dureeHabituellePerm]` |
| `UFM_NBJCUF` | `extension[nbJoursClotureE]` |
| `UFM_CODETHO` | `extension[typeHospitalisationDefaut]` |
| `UFM_CODEPSC` | `extension[codeParcoursSoin]` |
| `UFM_ETQHUF`/`UFM_NBEHUF`, `UFM_ETQEUF`/`UFM_NBEEUF`, `UFM_ETQUUF`/`UFM_NBEUUF`, `UFM_ETQBUF`/`UFM_NBEBUF` | `extension[etiquettes].extension[...]` (types/nombres hospitalisé, externe, urgence, bébé) |

### Module ECO (comptabilité / trésorerie) — `CPageUFModuleEcoExtension`

| Colonne `STR.UFO` | Sous-élément |
|---|---|
| `UFE_LIBCUE` / `UFE_LIBRUE` | `extension[libelleLong]` / `extension[libelleReduit]` |
| `UFE_FECOUF` | `extension[utiliseCPageEco]` |
| `UFE_AUTOUE` | `extension[autoriseeConsommer]` |
| `UFE_MAGAUE` | `extension[magasin]` |
| `UFE_PRESUE` | `extension[prestataire]` |
| `UFE_UFSBUF` | `extension[ufSubstitution]` |
| `UFE_PTVAUE`/`UFE_PTSAUE`/`UFE_LTVAUE`/`UFE_CTVAUE`/`UFE_PTVIUE`/`UFE_PTSIUE`/`UFE_LTVIUE`/`UFE_CTVIUE` | `extension[tva].extension[...]` (taux/lettre/compte exploitation et investissement) |
| `UFE_BONIUE` / `UFE_MALIUE` | `extension[ufBoni]` / `extension[ufMali]` |
| `UFE_ASMAUE` | `extension[magasinAutoRecep]` |

### Module PER (personnel / RH) — `CPageUFModulePerExtension`

| Colonne `STR.UFO` | Sous-élément |
|---|---|
| `UFP_LIBPUF` / `UFP_LBRPUF` | `extension[libelleLong]` / `extension[libelleReduit]` |
| `UFP_FPERUF` | `extension[utiliseCPageRH]` |
| `UFP_TINUUF` | `extension[travauxIntensifNuit]` |
| `UFP_SAGGUF` | `extension[indicateurSag]` |
| `UFP_BUVOUF` | `extension[bureauVote]` |
| `UFP_TSTPUF` | `extension[tauxTransportPatron]` |
| `UFP_PCIRUF` | `extension[pourcentIndResidence]` |

---

## Terminologies CPage

| CodeSystem / ValueSet | Codes | Utilisé par |
|---|---|---|
| `CPageValidityCodeSystem` / `CPageValidityValueSet` | `V` Valide / `I` Invalide | `CPageValidity` (Fournisseur : `FOU.VALIFO` ; Débiteur : `DBT.INVADT`) |
| `CPageEUZoneCodeSystem` / `CPageEUZoneValueSet` | `F` France / `O` Europe hors France / `A` Autre | `CPageEUZone` (Fournisseur : `FOU.EUROFO` réel ; Débiteur : non câblé, voir section 2) |
| `CPageResidencyCodeSystem` / `CPageResidencyValueSet` | `R` Résident / `N` Non-résident / `E` Étranger | `CPageDebtorResidency` (`DBT.RESIDT`) |

---

## Récapitulatif des points de vigilance documentaires

Ces points concernent des incohérences ou des zones d'ombre repérées en relisant le
FSH et le DDL en détail. Ils sont documentés pour information et **volontairement
non corrigés** dans les `.fsh` (hors périmètre de cette réécriture) :

1. `CPageFournisseurProfile.fsh` : `extension[cpageEUZone]` cite `(EUROTI)` alors
   que la colonne réelle de ce profil est `FOU.EUROFO`.
2. `CPageDebiteurProfile.fsh` : `extension[cpageEUZone]` cite `(EUROTI)` alors
   qu'aucune colonne de zone Europe n'existe sur `ECO.DBT`, et que `ETIER.EUROTI`
   (seule candidate) n'est câblée sur aucun élément FHIR concret pour le rôle
   Débiteur.
3. `CPageDebtorAssociatedSupplierExtension.fsh` : la description cite un profil
   cible `CPageSupplierOrganization`, qui n'existe pas ; le profil réel est
   `CPageFournisseurProfile`.
4. `CPageEntiteGeographiqueProfile.fsh` : l'en-tête cite `TVAIET` parmi les
   paramètres de TVA, sans sous-élément correspondant dans
   `CPageEGParametresTvaExtension`.
5. `ECO.FOU.NUDBFO` (débiteur associé, symétrique de `DBT.NUFODT`) n'a pas
   d'équivalent CPage sous forme de `Reference` : seul le sens Débiteur→Fournisseur
   bénéficie d'une extension CPage dédiée (`CPageDebtorAssociatedSupplier`).
6. Plusieurs extensions CPage du profil Fournisseur (comptabilité classe 2/6,
   conditions de paiement, marchés publics, Chorus, flags internes) dupliquent,
   sous une structure différente, des colonnes déjà exposées par des extensions
   génériques équivalentes de l'IG commun (`FournisseurComptabiliteExtension`,
   `FournisseurPaiementExtension`, `FournisseurAttributsExtension`).
