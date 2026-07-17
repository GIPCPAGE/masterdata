# Mapping Legacy Oracle → FHIR — IG CPage

Ce document explique, profil par profil, comment les extensions FHIR spécifiques CPage
(`ig-md-fhir-cpage`) se rattachent aux colonnes des tables Oracle historiques du système
CPage (schémas `ECO` et `STR`). Il sert de référence aux développeurs qui doivent écrire
ou relire les mappings de migration/interfaçage entre le legacy Oracle et FHIR.

**Ce document remplace intégralement une version précédente** qui décrivait un format
d'enregistrement à largeur fixe (positions 1-261) pour un profil `CPageSupplierProfile`.
Ce format et ce profil n'ont jamais existé dans le code source de cet IG : la version
précédente avait été écrite une fois au commit initial du dépôt et n'avait plus jamais
été synchronisée avec les FSH réels, qui ont pourtant été entièrement refondus depuis
(passage aux tables Oracle réelles `ECO.FOU`/`ECO.DBT`/`ECO.ETIER`, ajout des profils
Entité Juridique/Entité Géographique/UF). Le contenu ci-dessous est reconstruit depuis
zéro à partir des seules sources vérifiables : le FSH réel du dépôt et le DDL Oracle
réel disponible.

## Méthode et niveau de vérification

Deux catégories de sources sont utilisées, avec un niveau de confiance différent :

- **Fournisseur et Débiteur** : le mapping est vérifié contre un export DDL réel
  (`Analyses/Tiers-Fournisseurs-Debiteurs.txt`, à la racine de `mdm-igs`) contenant les
  `CREATE TABLE` complets de `ECO.ETIER`, `ECO.DBT` et `ECO.FOU` — colonnes, types,
  valeurs par défaut, contraintes `CHECK`, commentaires de colonnes, et les deux triggers
  d'historisation. Chaque colonne citée ci-dessous a été relue dans ce DDL.
- **Entité Juridique, Entité Géographique, UF** : il n'existe pas d'export DDL équivalent
  pour `STR.CHO`, `STR.ETA` et `STR.UFO` dans ce dépôt. Le mapping provient uniquement
  des commentaires embarqués dans les fichiers FSH eux-mêmes (en-tête des profils et
  commentaires des extensions). Cette documentation est donc fiable quant à l'intention
  du modèle FHIR, mais **n'a pas pu être vérifiée contre un schéma Oracle indépendant**.
  C'est signalé explicitement dans chaque section concernée.

Aucun nom de colonne ci-dessous n'est inventé : chaque mapping renvoie soit à une ligne
du DDL réel, soit à un commentaire présent dans un fichier `.fsh` du dépôt.

## Contexte Oracle : rôle du Tiers et historisation

Les trois profils Fournisseur/Débiteur/Tiers partagent une table pivot **`ECO.ETIER`**
("Tiers"), qui porte un identifiant unique (`IDTITI`), un rôle (`ROLETI`, contraint à
`T`/`F`/`D`) et ses propres attributs de validité (`VALITI`) et de zone Europe (`EUROTI`).
`ECO.FOU` (Fournisseurs) et `ECO.DBT` (Débiteurs) référencent chacune `ECO.ETIER` via une
clé étrangère (`FOU.ETIER_IDTITI`, `DBT.ETIER_IDTITI`) et possèdent **leurs propres**
colonnes de validité (`FOU.VALIFO`, `DBT.INVADT`) et, pour `FOU` uniquement, leur propre
colonne de zone Europe (`FOU.EUROFO`). Ces colonnes de niveau Tiers et de niveau
Fournisseur/Débiteur sont distinctes et ne doivent pas être confondues — voir les
sections « Points de vigilance » ci-dessous, qui détaillent précisément ce qui est mappé
et ce qui ne l'est pas dans le FHIR actuel.

`ECO.DBT` et `ECO.FOU` sont chacune couvertes par un trigger d'audit
(`ET_DBT_A_R_IUD_H` et `ET_FOU_A_R_IUD_H` respectivement) qui recopie, à chaque
`INSERT`/`UPDATE`/`DELETE`, l'état de la ligne dans une table d'historique
(`DBT_H`, `FOU_H`) avec un identifiant de révision (`IDRVN`) et un type de révision
(`TYPERVN` = 0 création, 1 modification, 2 suppression). C'est le seul mécanisme
d'audit/historique disponible pour ces deux tables côté Oracle ; aucun trigger
équivalent n'apparaît pour `ECO.ETIER` dans l'export DDL disponible.

---

## 1. CPageFournisseurProfile

- **Parent** : `FournisseurProfile` (`ig-md-fhir-common`), lui-même dérivé de
  `TiersProfile`.
- **Table Oracle source** : `ECO.FOU` ("Fournisseurs"), liée à `ECO.ETIER` ("Tiers") via
  `FOU.ETIER_IDTITI`.
- **Niveau de vérification** : DDL Oracle réel.

### Colonne Oracle → Extension FHIR (Fournisseur)

| Colonne Oracle (`ECO.FOU`) | Type / contrainte | Extension CPage | Élément FHIR |
|---|---|---|---|
| `VALIFO` | `VARCHAR2(1)` défaut `'V'`, `CHECK IN ('V','I')` | `CPageValidity` | `extension[cpageValidity]` |
| `EUROFO` | `VARCHAR2(1)` défaut `'A'` (comment : « Fournisseur européen ») | `CPageEUZone` | `extension[cpageEUZone]` |
| `LBU6FO` | `VARCHAR2(1)` NOT NULL | `CPageSupplierAccountingClass6` | `extension[accountingClass6].extension[lbu]` |
| `CPT6FO` | `VARCHAR2(10)` NOT NULL, `CHECK SUBSTR(...,1,1) IN ('1'..'5')` | `CPageSupplierAccountingClass6` | `extension[accountingClass6].extension[cpt]` |
| `LBU2FO` | `VARCHAR2(1)` NOT NULL | `CPageSupplierAccountingClass2` | `extension[accountingClass2].extension[lbu]` |
| `CPT2FO` | `VARCHAR2(10)` NOT NULL, `CHECK SUBSTR(...,1,1) IN ('1'..'5')` | `CPageSupplierAccountingClass2` | `extension[accountingClass2].extension[cpt]` |
| `DEPAFO` | `NUMBER(3,0)`, `CHECK BETWEEN 0 AND 999` | `CPageSupplierPaymentTerms` | `extension[paymentTerms].extension[paymentDelayDays]` |
| `JOSPFO` | `NUMBER(2,0)` | `CPageSupplierPaymentTerms` | `extension[paymentTerms].extension[specificPaymentDay]` |
| `MTMIFO` | `NUMBER(15,2)` défaut `0`, `CHECK BETWEEN 0 AND 9999999999999.99` | `CPageSupplierPaymentTerms` | `extension[paymentTerms].extension[minimumOrderAmount]` |
| `TCMPFO` | `VARCHAR2(1)` défaut `'O'` NOT NULL, `CHECK IN ('O','N')` | `CPageSupplierPublicProcurement` | `extension[procurement].extension[publicProcurement]` |
| `GACHFO` | `VARCHAR2(1)` défaut `'N'` NOT NULL, `CHECK IN ('O','N')` | `CPageSupplierPublicProcurement` | `extension[procurement].extension[purchasingGroup]` |
| `ESCOFO` | `VARCHAR2(1)` défaut `'N'`, `CHECK IN ('O','N')` | `CPageSupplierPublicProcurement` | `extension[procurement].extension[discountable]` |
| `CHORFO` | `VARCHAR2(1)` défaut `'N'`, `CHECK IN ('O','N')` (comment : « Assujetti à Chorus ») | `CPageSupplierChorus` | `extension[chorus].extension[subjectToChorus]` |
| `TIDCFO` | `VARCHAR2(2)` (comment : « Type d'identifiant Chorus ») | `CPageSupplierChorus` | `extension[chorus].extension[chorusIdType]` |
| `IDCHFO` | `VARCHAR2(18)` (comment : « Identifiant Chorus ») | `CPageSupplierChorus` | `extension[chorus].extension[chorusIdentifier]` |
| `EXTRFO` | `VARCHAR2(1)` défaut `'N'`, `CHECK IN ('O','N')` (comment : « A extraire ») | `CPageSupplierInternalFlags` | `extension[internalFlags].extension[extractable]` |
| `MAJ_FO` | `VARCHAR2(1)` défaut `'N'`, `CHECK IN ('O','N')` | `CPageSupplierInternalFlags` | `extension[internalFlags].extension[changedSinceLastExtract]` |

### Points de vigilance (Fournisseur)

- **`EUROFO` vs `EUROTI`** : l'annotation `^short` de `extension[cpageEUZone]` dans
  `CPageFournisseurProfile.fsh` indique littéralement `« Zone européenne (EUROTI) »`.
  `EUROTI` est bien une colonne réelle, mais elle appartient à `ECO.ETIER` (niveau
  Tiers), pas à `ECO.FOU`. La colonne réellement portée par le rôle Fournisseur est
  `FOU.EUROFO` (« Fournisseur européen », défaut `'A'`). L'annotation FSH est donc
  imprécise (probablement un copier-coller de la version Tiers) ; ce document ne modifie
  pas le FSH mais retient `FOU.EUROFO` comme mapping correct.
- **Absence de contrainte `CHECK` explicite sur `EUROFO`** : contrairement à
  `ETIER.EUROTI` (contrainte nommée `EUROTI_CK`, valeurs `F`/`O`/`A`), le DDL de `ECO.FOU`
  ne montre pas de contrainte `CHECK` équivalente sur `EUROFO`. Le domaine de valeurs
  `F`/`O`/`A` utilisé par `CPageEUZoneCodeSystem` reste néanmoins cohérent avec l'usage
  attesté par le commentaire de colonne et par symétrie avec `ETIER.EUROTI`.
- **Chevauchement avec les extensions génériques de l'IG commun** : plusieurs colonnes
  ci-dessus sont *déjà* exposées par des extensions génériques de `ig-md-fhir-common`,
  portées par `FournisseurProfile` (le parent de ce profil) :
  - `FournisseurComptabiliteExtension` (`extension[comptabilite]`) couvre déjà
    `LBU2FO`/`CPT2FO`/`LBU6FO`/`CPT6FO` — les mêmes colonnes que
    `CPageSupplierAccountingClass2`/`CPageSupplierAccountingClass6`.
  - `FournisseurPaiementExtension` (`extension[paiement]`) couvre déjà
    `DEPAFO`/`JOSPFO`/`MTMIFO`/`ESCOFO` — les mêmes colonnes que
    `CPageSupplierPaymentTerms` et une partie de `CPageSupplierPublicProcurement`.
  - `FournisseurAttributsExtension` (`extension[attributs]`) couvre déjà
    `TCMPFO`/`GACHFO`/`CHORFO`/`TIDCFO`/`IDCHFO`/`EXTRFO`/`MAJ_FO` — les mêmes colonnes
    que `CPageSupplierPublicProcurement`, `CPageSupplierChorus` et
    `CPageSupplierInternalFlags`.

  Autrement dit, la quasi-totalité des extensions CPage de ce profil dupliquent des
  colonnes déjà mappées une couche au-dessus, dans l'IG commun. Ce constat est purement
  documentaire : il n'appartenait pas au périmètre de cette réécriture de modifier le
  FSH, mais il est important pour quiconque doit choisir où lire (ou écrire) une valeur.

---

## 2. CPageDebiteurProfile

- **Parent** : `DebiteurProfile` (`ig-md-fhir-common`), lui-même dérivé de
  `TiersProfile`.
- **Table Oracle source** : `ECO.DBT` ("Debiteurs des Titres de Recettes"), liée à
  `ECO.ETIER` via `DBT.ETIER_IDTITI` et, fonctionnellement, à `ECO.FOU` via
  `DBT.NUFODT` (pas de contrainte `FOREIGN KEY` déclarée dans le DDL pour ce lien,
  uniquement documentée par le commentaire de colonne).
- **Niveau de vérification** : DDL Oracle réel.

### Colonne Oracle → Extension FHIR (Débiteur)

| Colonne Oracle (`ECO.DBT`) | Type / contrainte | Extension CPage | Élément FHIR |
|---|---|---|---|
| `INVADT` | `VARCHAR2(1)` défaut `'V'` NOT NULL, `CHECK IN ('I','V')` (comment : « Code Validite ») | `CPageValidity` | `extension[cpageValidity]` |
| `RESIDT` | `VARCHAR2(1)` défaut `'R'` NOT NULL, `CHECK IN ('R','N','E')` | `CPageDebtorResidency` | `extension[residency]` |
| `LBTIDT` | `VARCHAR2(1)` NOT NULL (comment : « Lettre budgetaire ») | `CPageDebtorAccount` | `extension[debtorAccount].extension[budgetLetter]` |
| `CPTIDT` | `VARCHAR2(10)` NOT NULL (comment : « No du compte de tiers ») | `CPageDebtorAccount` | `extension[debtorAccount].extension[thirdPartyAccount]` |
| `ASAPDT` | `VARCHAR2(1)` défaut `'N'` NOT NULL (comment : « Ne pas générer d'ASAP dématérialisé O/N ») | `CPageDebtorAsap` | `extension[asap].extension[disableAsap]` |
| `FCENDT` | `VARCHAR2(1)` défaut `'N'` NOT NULL (comment : « Forcer une impression au Centre d'Editique National ») | `CPageDebtorAsap` | `extension[asap].extension[forceCenPrint]` |
| `IDEXDT` | `VARCHAR2(20)` (comment : « Identifiant Externe du débiteur ») | `CPageDebtorExternalId` | `extension[externalId]` |
| `NUFODT` | `VARCHAR2(6)` (comment : « Fournisseur associé ») | `CPageDebtorAssociatedSupplier` | `extension[associatedSupplier]` (référence `Organization`) |

### Points de vigilance (Débiteur)

- **Pas de colonne de zone Europe propre sur `DBT`** : contrairement au Fournisseur,
  `ECO.DBT` **ne possède aucune colonne EU-zone** dans le DDL vérifié (pas de
  `EURODT`/équivalent). L'annotation `^short` de `extension[cpageEUZone]` sur
  `CPageDebiteurProfile.fsh` indique pourtant `« Zone européenne (EUROTI) »`. La seule
  colonne réelle correspondante est `ECO.ETIER.EUROTI` (niveau Tiers, accessible via la
  clé étrangère `DBT.ETIER_IDTITI`), qui est mentionnée dans la description de
  l'extension commune `DebiteurParametresExtension` (« Correspond aux colonnes COMPTI,
  EUROTI, FACBTI, TRLSTI de la table ETIER ») **mais n'y est pas exposée comme
  sous-élément concret** (la liste réelle des sous-extensions de
  `DebiteurParametresExtension` est `compteLettre`/`typeResident`/`typeDebiteur`/
  `assuAutorise`/`forceImpressionCoh`/`facturationActesBiologie`/
  `liquidationSoupleAutorisee`/`asapDesactive`/`dateIntegration`/`fournisseurAssocie` —
  pas de champ « zone Europe »). **En l'état du FSH actuel, `ETIER.EUROTI` n'est donc
  câblé sur aucun élément FHIR concret pour le rôle Débiteur** ; seul le rôle
  Fournisseur dispose d'un mapping réel et propre (`FOU.EUROFO` → `cpageEUZone` sur
  `CPageFournisseurProfile`, voir section 1).
- **Référence à un profil obsolète dans le FSH** : la description de l'extension
  `CPageDebtorAssociatedSupplierExtension.fsh` indique que la référence pointe vers
  « une Organization de profil `CPageSupplierOrganization` ». Ce nom de profil
  **n'existe pas** dans le dépôt actuel ; le profil réel est `CPageFournisseurProfile`.
  Il s'agit très probablement d'un texte resté d'une itération antérieure du FSH avant
  renommage. Ce document ne corrige pas le FSH (hors périmètre), mais documente le
  mapping réel : `NUFODT` référence un `Organization` de profil `CPageFournisseurProfile`.
- **Chevauchement avec l'extension générique `DebiteurParametresExtension`** (IG
  commun, portée par `DebiteurProfile`) : `asapDesactive` (`ASAPDT`) et
  `fournisseurAssocie` (`NUFODT`) y sont déjà exposés, en plus des extensions CPage
  `CPageDebtorAsap.disableAsap` et `CPageDebtorAssociatedSupplier`. `DebiteurParametresExtension`
  couvre aussi `dateIntegration` (`DINTDT`), qu'aucune extension CPage ne reprend.

---

## 3. CPageEntiteJuridiqueProfile

- **Parent** : `EntiteJuridiqueProfile` (`ig-md-fhir-common`), lui-même dérivé de
  `FRCoreOrganizationEtablissementProfile` (FR Core 2.2.0).
- **Table Oracle source** : `STR.CHO`.
- **Niveau de vérification** : **non vérifié contre un DDL indépendant**. Le mapping
  ci-dessous provient exclusivement des commentaires embarqués dans
  `CPageEntiteJuridiqueProfile.fsh` (en-tête) et `CPageEntiteJuridiqueExtensions.fsh`
  (commentaires par extension), qui sont mutuellement cohérents mais n'ont pas pu être
  recoupés avec un export `CREATE TABLE` réel de `STR.CHO` (absent de ce dépôt).

### Receveur comptable — `CPageEJReceveurExtension`

| Colonne Oracle (`STR.CHO`) | Sous-élément de `extension[receveur]` |
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

| Colonne Oracle (`STR.CHO`) | Sous-élément |
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

| Colonne Oracle (`STR.CHO`) | Sous-élément |
|---|---|
| `TVARCH` | `extension[tauxRecuperableEnCours]` |
| `TVASCH` | `extension[tauxRecuperableSuivant]` |
| `LTVACH` (1 car.) | `extension[exploitationLettre]` |
| `CTVACH` (10 car.) | `extension[exploitationCompte]` |
| `LTVICH` (1 car.) | `extension[investissementLettre]` |
| `CTVICH` (10 car.) | `extension[investissementCompte]` |

### Indicateurs divers CPage

| Colonne Oracle (`STR.CHO`) | Extension CPage |
|---|---|
| `TBICCH` (1 car.) | `CPageEJIndicateurBicExtension` (`extension[indicateurBic]`) |
| `CM22CH` (O/N) | `CPageEJComptabiliteM22Extension` (`extension[comptabiliteM22]`, `boolean`) |
| `ITPGCH` (6 car.) | `CPageEJIdentifiantTpgExtension` (`extension[identifiantTpg]`) |

Les colonnes `CATGCH`/`NATJCH` sont mentionnées dans l'en-tête du profil mais renvoient
au modèle FR Core générique (nature/catégorie juridique), pas à une extension CPage
spécifique.

---

## 4. CPageEntiteGeographiqueProfile

- **Parent** : `EntiteGeographiqueProfile` (`ig-md-fhir-common`), lui-même dérivé de
  `FRCoreOrganizationEtablissementProfile` (FR Core 2.2.0).
- **Table Oracle source** : `STR.ETA`.
- **Niveau de vérification** : **non vérifié contre un DDL indépendant**, mêmes
  réserves que pour l'Entité Juridique — mapping issu des commentaires du fichier
  `CPageEntiteGeographiqueExtensions.fsh`.

### Dates d'activation T2A — `CPageEGDatesActivationT2AExtension`

14 dates, regroupées par type d'activité (`DB**` = bases de remboursement distinctes,
`DF**` = facturation individuelle ; `*E` = externe, `*H` = hospitalisation) :

| Colonne Oracle (`STR.ETA`) | Sous-élément |
|---|---|
| `DBMEET` | `extension[dbMcoHadExterne]` |
| `DBMHET` | `extension[dbMcoHadHospit]` |
| `DBSEET` | `extension[dbSsrExterne]` |
| `DBSHET` | `extension[dbSsrHospit]` |
| `DBPEET` | `extension[dbPsyExterne]` |
| `DBPHET` | `extension[dbPsyHospit]` |
| `DBLHET` | `extension[dbLongSejour]` |
| `DFMEET` | `extension[dfMcoHadExterne]` |
| `DFMHET` | `extension[dfMcoHadHospit]` |
| `DFSEET` | `extension[dfSsrExterne]` |
| `DFSHET` | `extension[dfSsrHospit]` |
| `DFPEET` | `extension[dfPsyExterne]` |
| `DFPHET` | `extension[dfPsyHospit]` |
| `DFLHET` | `extension[dfLongSejour]` |

### Coefficients tarifaires — `CPageEGCoefficientsTarifairesExtension`

| Colonne Oracle (`STR.ETA`) | Sous-élément |
|---|---|
| `CPRUET` | `extension[prudentiel]` |
| `CMCOET` | `extension[mco]` |
| `CFISCET` | `extension[cfisc]` |
| `CSEGURET` | `extension[segur]` |

### Paramètres de TVA — `CPageEGParametresTvaExtension`

| Colonne Oracle (`STR.ETA`) | Sous-élément |
|---|---|
| `TVARET` | `extension[tauxRecuperableEnCours]` |
| `TVASET` | `extension[tauxRecuperableSuivant]` |
| `LTVAET` | `extension[exploitationLettre]` |
| `CTVAET` | `extension[exploitationCompte]` |
| `LTVIET` | `extension[investissementLettre]` |
| `CTVIET` | `extension[investissementCompte]` |

**Point de vigilance** : l'en-tête de `CPageEntiteGeographiqueProfile.fsh` liste la
colonne `TVAIET` parmi les « Paramètres de TVA », mais aucun sous-élément de
`CPageEGParametresTvaExtension` ne lui correspond (la liste réelle des sous-éléments
est `tauxRecuperableEnCours`/`tauxRecuperableSuivant`/`exploitationLettre`/
`exploitationCompte`/`investissementLettre`/`investissementCompte`, comme ci-dessus).
Il s'agit d'une incohérence interne au FSH (commentaire de profil plus large que
l'extension réellement définie), signalée ici sans être corrigée (hors périmètre de
cette réécriture).

---

## 5. CPageUFProfile

- **Parent** : `UFProfile` (`ig-md-fhir-common`), lui-même dérivé de
  `FRCoreOrganizationUFProfile` (FR Core 2.2.0).
- **Table Oracle source** : `STR.UFO`.
- **Niveau de vérification** : **non vérifié contre un DDL indépendant** — mapping issu
  des commentaires du fichier `CPageUFExtensions.fsh`. Trois extensions correspondent
  aux trois modules applicatifs CPage historiques (MAL/ECO/PER).

### Module MAL (patients / activité médicale) — `CPageUFModuleMalExtension`

| Colonne Oracle (`STR.UFO`) | Sous-élément |
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
| `UFM_ETQHUF` / `UFM_NBEHUF` | `extension[etiquettes].extension[typeEtiqHospit]` / `[nbEtiqHospit]` |
| `UFM_ETQEUF` / `UFM_NBEEUF` | `extension[etiquettes].extension[typeEtiqExterne]` / `[nbEtiqExterne]` |
| `UFM_ETQUUF` / `UFM_NBEUUF` | `extension[etiquettes].extension[typeEtiqUrgence]` / `[nbEtiqUrgence]` |
| `UFM_ETQBUF` / `UFM_NBEBUF` | `extension[etiquettes].extension[typeEtiqBebe]` / `[nbEtiqBebe]` |

### Module ECO (comptabilité / trésorerie) — `CPageUFModuleEcoExtension`

| Colonne Oracle (`STR.UFO`) | Sous-élément |
|---|---|
| `UFE_LIBCUE` | `extension[libelleLong]` |
| `UFE_LIBRUE` | `extension[libelleReduit]` |
| `UFE_FECOUF` | `extension[utiliseCPageEco]` |
| `UFE_AUTOUE` | `extension[autoriseeConsommer]` |
| `UFE_MAGAUE` | `extension[magasin]` |
| `UFE_PRESUE` | `extension[prestataire]` |
| `UFE_UFSBUF` | `extension[ufSubstitution]` |
| `UFE_PTVAUE` / `UFE_PTSAUE` | `extension[tva].extension[tauxExploitationCours]` / `[tauxExploitationSuivant]` |
| `UFE_LTVAUE` / `UFE_CTVAUE` | `extension[tva].extension[lettreExploitation]` / `[compteExploitation]` |
| `UFE_PTVIUE` / `UFE_PTSIUE` | `extension[tva].extension[tauxInvestCours]` / `[tauxInvestSuivant]` |
| `UFE_LTVIUE` / `UFE_CTVIUE` | `extension[tva].extension[lettreInvest]` / `[compteInvest]` |
| `UFE_BONIUE` | `extension[ufBoni]` |
| `UFE_MALIUE` | `extension[ufMali]` |
| `UFE_ASMAUE` | `extension[magasinAutoRecep]` |

### Module PER (personnel / RH) — `CPageUFModulePerExtension`

| Colonne Oracle (`STR.UFO`) | Sous-élément |
|---|---|
| `UFP_LIBPUF` | `extension[libelleLong]` |
| `UFP_LBRPUF` | `extension[libelleReduit]` |
| `UFP_FPERUF` | `extension[utiliseCPageRH]` |
| `UFP_TINUUF` | `extension[travauxIntensifNuit]` |
| `UFP_SAGGUF` | `extension[indicateurSag]` |
| `UFP_BUVOUF` | `extension[bureauVote]` |
| `UFP_TSTPUF` | `extension[tauxTransportPatron]` |
| `UFP_PCIRUF` | `extension[pourcentIndResidence]` |

---

## Terminologies utilisées par ces extensions

| CodeSystem / ValueSet | Codes | Utilisé par |
|---|---|---|
| `CPageValidityCodeSystem` / `CPageValidityValueSet` | `V` (Valide) / `I` (Invalide) | `CPageValidity` (Fournisseur : `FOU.VALIFO` ; Débiteur : `DBT.INVADT`) |
| `CPageEUZoneCodeSystem` / `CPageEUZoneValueSet` | `F` (France) / `O` (Europe hors France) / `A` (Autre) | `CPageEUZone` (Fournisseur : `FOU.EUROFO` ; Débiteur : non câblé, voir section 2) |
| `CPageResidencyCodeSystem` / `CPageResidencyValueSet` | `R` (Résident) / `N` (Non-résident) / `E` (Étranger) | `CPageDebtorResidency` (`DBT.RESIDT`) |

---

## Récapitulatif des incohérences documentaires relevées

Cette réécriture a permis d'identifier, en plus du remplacement du contenu fictif
d'origine, plusieurs incohérences mineures **dans le FSH actuel lui-même** (commentaires
internes désynchronisés du modèle réel). Elles sont documentées ici pour information,
mais **volontairement non corrigées** : ce document est un livrable de documentation,
la modification des `.fsh` étant hors périmètre.

1. `CPageFournisseurProfile.fsh` : l'annotation `^short` de `cpageEUZone` cite
   `(EUROTI)` alors que la colonne réelle pour ce profil est `FOU.EUROFO`.
2. `CPageDebiteurProfile.fsh` : l'annotation `^short` de `cpageEUZone` cite `(EUROTI)`
   alors qu'aucune colonne de zone Europe n'existe sur `ECO.DBT` ; `ETIER.EUROTI`
   (mentionné mais non exposé par l'extension commune `DebiteurParametresExtension`)
   est la seule colonne candidate, et elle n'est câblée sur aucun élément FHIR concret
   à ce jour.
3. `CPageDebtorAssociatedSupplierExtension.fsh` : la description cite un profil cible
   `CPageSupplierOrganization`, qui n'existe pas ; le profil réel est
   `CPageFournisseurProfile`.
4. `CPageEntiteGeographiqueProfile.fsh` : l'en-tête mentionne la colonne `TVAIET` parmi
   les paramètres de TVA, alors qu'elle n'a pas de sous-élément dédié dans
   `CPageEGParametresTvaExtension`.
5. Plusieurs extensions CPage du profil Fournisseur (comptabilité classe 2/6,
   conditions de paiement, marchés publics, Chorus, flags internes) dupliquent des
   colonnes déjà exposées par des extensions génériques équivalentes de
   `ig-md-fhir-common` (`FournisseurComptabiliteExtension`, `FournisseurPaiementExtension`,
   `FournisseurAttributsExtension`) — voir section 1.
