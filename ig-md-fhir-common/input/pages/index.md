# IG FHIR Commun — Socle Master Data CPage

Cet Implementation Guide (IG) définit le **socle FHIR générique** du Master Data CPage : les profils,
extensions et terminologies **communs, vendor-neutral**, réutilisés par les IG spécialisés du système
d'information hospitalier (SIH) CPage — notamment `ig-md-fhir-cpage` (extensions propriétaires CPage)
et `ig-md-fhir-operations` (opérations de publication/synchronisation du Master Data).

Il modélise deux domaines métier distincts :

1. **Tiers financiers** — les organisations avec lesquelles l'établissement a une relation
   financière : fournisseurs, débiteurs, organismes payeurs de santé.
2. **Structure hospitalière** — la hiérarchie organisationnelle complète d'un établissement,
   du groupement de territoire jusqu'au lit.

**Ce guide ne modélise aucune ressource clinique.** Il n'y a ici ni `Patient`, ni `Practitioner`,
ni `PractitionerRole`, ni aucune ressource d'échange de données de soins. C'est une caractéristique
architecturale volontaire : cet IG décrit exclusivement des **données de référence (master data)** —
des tiers financiers et des structures organisationnelles — et non des événements ou des données de
prise en charge patient. Ce positionnement le distingue d'IG français centrés sur le patient (par
exemple les IG FHIR de l'APHP ou de FHIR France), qui exposent des parcours de soins et des données
cliniques individuelles.

## Architecture

```text
┌──────────────────────────────────────────────────────────┐
│  FHIR R4 (4.0.1) + hl7.fhir.fr.core 2.2.0                 │
│  Profils Organization / Location / etc. du cœur français  │
└───────────────────────────┬────────────────────────────────┘
                            │ dépendance FHIR IG (sushi-config.yaml)
              ┌─────────────▼──────────────┐
              │   ig-md-fhir-common (CE GUIDE)         │
              │   • Tiers financiers (4 profils)       │
              │   • Structure hospitalière (16 profils)│
              │   • Référentiel communes COG INSEE      │
              │   • ~80 extensions, ~25 terminologies   │
              │   • Opération $hierarchy                │
              └─────────────┬──────────────┘
                            │
        ┌───────────────────┼───────────────────────┐
        ▼                                            ▼
┌───────────────────────┐               ┌─────────────────────────────┐
│  ig-md-fhir-cpage      │               │  ig-md-fhir-operations       │
│  Extensions/profils    │               │  Opérations de publication   │
│  propriétaires CPage   │               │  et de synchronisation MDM   │
│  (comptabilité M21/M22,│               │  (PublicationBatch /         │
│  URSSAF, TVA, T2A...)  │               │  PublicationBatchItem, etc.) │
└───────────────────────┘               └─────────────────────────────┘
```

Ce guide dépend directement de `hl7.fhir.fr.core` en version **2.2.0** — il n'est pas un socle
« à côté » de FR Core, il est construit **sur** FR Core : la plupart des profils héritent directement
d'un profil FR Core (`FRCoreOrganizationProfile`, `FRCoreOrganizationEtablissementProfile`,
`FRCoreOrganizationUFProfile`, `FRCoreOrganizationUACProfile`, `FRCoreLocationProfile`) et n'ajoutent
que les éléments spécifiques au Master Data CPage.

## Les deux domaines métier

### 1. Tiers financiers

Un **Tiers** (au sens de la comptabilité publique française) est toute personne physique ou morale
avec laquelle l'établissement entretient une relation financière : elle lui doit de l'argent, elle en
est créancière, ou elle lui reverse un remboursement de soins. Ce domaine modélise ces relations sous
forme d'`Organization` FHIR, avec un profil de base (`TiersProfile`) spécialisé en trois rôles
métier : **fournisseur** (comptes fournisseurs), **débiteur** (comptes clients / titres de recette),
et **payeur santé** (assurance maladie obligatoire et complémentaire).

Ce domaine est directement adossé aux tables Oracle historiques `ECO.ETIER` (tiers), `ECO.FOU`
(fournisseurs) et `ECO.DBT` (débiteurs), et à la nomenclature **PESv2** (Protocole d'Échange Standard
v2, DGFiP) pour les catégories, natures juridiques et types d'identifiants.

**Détail complet** : [Tiers financiers](tiers-financiers.html).

### 2. Structure hospitalière

La **structure hospitalière** est la hiérarchie organisationnelle et physique d'un établissement de
santé, du groupement de territoire jusqu'au lit :

```text
GHT
 └─ Entité Juridique (EJ)
     └─ Entité Géographique (EG, site)
         ├─ Service (hiérarchie historique parallèle)
         └─ Pôle
             └─ Centre de Responsabilité (CR)
                 ├─ Centre d'Activité (CAC, analytique)
                 └─ Unité Fonctionnelle (UF)
                     ├─ PAC/UAC (facturation PMSI)
                     ├─ Salle d'examen
                     └─ Chambre
                         └─ Lit
```

Cette hiérarchie est adossée aux tables Oracle du module structure (`STR.CHO`, `STR.ETA`, `STR.POA`,
`STR.SER`, `STR.CRE`) et du module patients (`PAT.PIE`, `PAT.LLI`) pour les chambres et les lits.
Certaines entités (**Département**, **Unité Médicale**, **Salle d'examen**, **PAC/UAC**) n'ont pas de
table Oracle CPage dédiée : elles ont été ajoutées au Master Data uniquement pour assurer
l'interopérabilité avec les DPI et le PMSI, qui référencent ces concepts nationaux (MOS/DGOS) même
quand CPage ne les gère pas nativement.

**Détail complet** : [Structure hospitalière](structure-hospitaliere.html).

### Un référentiel transverse : les communes françaises

Les deux domaines ci-dessus partagent un besoin commun : qualifier une adresse par sa commune
française. Le profil `CommuneFrancaiseProfile` (ressource `Location`) expose le Code Officiel
Géographique (COG) de l'INSEE — environ 35 000 communes actives, avec gestion de l'historique des
fusions (communes nouvelles / communes déléguées). Détails dans la page
[Structure hospitalière](structure-hospitaliere.html#référentiel-communes-françaises-cog-insee).

## Catalogue résumé des profils

| Domaine | Profils | Nombre |
|---|---|---|
| Tiers financiers | `TiersProfile`, `FournisseurProfile`, `DebiteurProfile`, `PayeurSanteProfile` | 4 |
| Structure hospitalière | `EntiteJuridiqueProfile`, `EntiteGeographiqueProfile`, `GHTProfile`, `StructureHospitaliereOrganizationProfile` (socle), `PoleProfile`, `ServiceProfile`, `CentreResponsabiliteProfile`, `CentreActiviteProfile`, `DepartementProfile`, `UniteMedicaleProfile`, `UFProfile`, `PacUacProfile`, `StructureHospitaliereSiteProfile` (socle), `ChambreProfile`, `LitProfile`, `SalleExamenProfile` | 16 |
| Référentiel géographique | `CommuneFrancaiseProfile` | 1 |
| **Total** | | **21** |

Le détail (parent FHIR, table Oracle source ou absence, rôle métier) est présenté profil par profil
dans les deux pages de domaine.

## Extensions et terminologies

Cet IG définit environ **80 extensions** FHIR (StructureDefinition de type Extension) réparties
principalement en trois familles :

- **Tiers** (18 extensions) : rôle, catégorie TG, nature juridique, domiciliation bancaire (structure
  `TBancaire` du PESv2), type d'identifiant, attributs fournisseur/débiteur, paramètres payeur santé,
  usage de succursale, identifiant CHORUS, etc.
- **Structure hospitalière** (~58 extensions) : pour chaque entité (EJ, EG, Pôle, Service, CR, UF,
  Chambre, Lit), une paire récurrente `periodValidite` / `codeValidite` qui porte le modèle temporel
  des tables Oracle sources (clé primaire composite avec date de début), plus les attributs métier
  propres à chaque entité (ex. lettre budgétaire du CR, type UF médicale, type de lit, etc.).
- **Communes** (6 extensions) : codes postaux (répétables), code département, code région, dates de
  validité et de mise à jour du référentiel INSEE.

Cet IG définit également une **vingtaine de CodeSystems/ValueSets** — nomenclatures PESv2 (catégorie
tiers, nature juridique, type d'identifiant), nomenclatures internes CPage (type de lit, type de
service, catégorie PMSI, etc.), et le CodeSystem des communes françaises COG INSEE — ainsi que
**10 SearchParameter** personnalisés (recherche par rôle de tiers, par IBAN, par code débiteur/
fournisseur, par grand régime payeur, etc.).

Le détail complet de chaque extension et terminologie est présenté dans les pages de domaine, et
la liste exhaustive de tous les artefacts est disponible sur la page
[Ressources de conformité](artifacts.html).

## L'opération `$hierarchy`

`Organization/$hierarchy` est une opération FHIR **personnalisée** (sans équivalent natif dans FHIR
R4) qui retourne, en un seul appel, l'intégralité de la hiérarchie organisationnelle d'un
établissement sous forme d'un `Bundle` FHIR (`type=collection`) :

```text
GHT → EJ → EG → (Service | Pôle → CR → Centre d'Activité) → UF → Chambre → Lit
```

Elle existe pour éviter à un consommateur de devoir reconstituer cette hiérarchie par une succession
de requêtes `_include`/`_revinclude` recursives sur `partOf`, ce qui serait coûteux et fragile compte
tenu du nombre de niveaux et des relations multi-parents (UF pouvant être rattachée simultanément à un
Service et à un Centre d'Activité). Elle accepte un paramètre `_since` (delta sync) et un paramètre
`includeInactive`. Elle est exposée de façon identique sur les trois IG (`common`, `cpage`, `frcore`)
pour que le consommateur obtienne la hiérarchie dans le vocabulaire de son choix. Voir le détail
complet dans [Structure hospitalière](structure-hospitaliere.html#lopération-hierarchy).

## Méthodologie et gouvernance

### Méthode de construction des profils

Les profils de cet IG n'ont pas été élaborés par recueil de besoin structuré au moyen de
`Questionnaire`/SDC (Structured Data Capture) — méthodologie plus lourde utilisée par exemple par
l'IG *Data Management* de l'APHP pour capturer des besoins de recherche clinique auprès d'experts
métier au moyen de formulaires FHIR. La méthode ici est plus directe, cohérente avec un objectif de
**catalogue de données de référence** plutôt que d'outil de recueil clinique :

1. **Analyse des tables Oracle historiques** du SIH CPage (`ECO.ETIER`/`FOU`/`DBT` pour les tiers,
   `STR.CHO`/`ETA`/`POA`/`SER`/`CRE`/`UFO` et `PAT.PIE`/`LLI` pour la structure hospitalière) —
   colonnes, contraintes, clés étrangères, déclencheurs d'historisation.
2. **Rédaction des profils FSH** alignés sur les profils parents FR Core 2.2.0, avec mapping explicite
   colonne Oracle → élément/extension FHIR documenté en commentaire dans chaque fichier `.fsh`.
3. **Validation qualité par le IG Publisher** : build SUSHI (génération des snapshots), puis
   génération complète du guide et vérification du rapport `qa.html` (absence d'erreur de profil, de
   binding ou de référence cassée).

Cette approche est volontairement plus légère qu'une démarche de recueil structuré : elle convient à
un référentiel de données déjà stabilisées dans un système source (Oracle), et non à la découverte
itérative d'un besoin clinique nouveau.

### Traçabilité des publications, pas de `Provenance`

Cet IG n'utilise pas la ressource FHIR `Provenance`. Ce choix est délibéré et documenté, pas un oubli.
Le rôle de traçabilité est tenu par les modèles logiques `PublicationBatch` et `PublicationBatchItem`
de l'IG `ig-md-fhir-operations` : chaque ressource publiée par le Master Data est rattachée à un item
(`PublicationBatchItem`, avec `eventType`, `logicalId`, `rootInstanceId`, `sortOrder`) lui-même membre
d'un lot (`PublicationBatch`, avec `sourceTransactionId`, `sourceVersionNum`). Ce mécanisme répond à
une question précise et volontairement limitée : *quelle ressource a changé, dans quel lot, dans quel
ordre, selon quel type d'événement, et à partir de quelle transaction/version métier source* — pour
permettre à un consommateur de détecter un lot manqué et de le rejouer sans dupliquer ni perdre une
modification.

Ce n'est **pas** une provenance complète au sens FHIR (qui tracerait aussi le *qui* a modifié une
ressource et le *pourquoi*, avec signatures, agents, politiques). C'est une limite de périmètre
assumée : le Master Data CPage trace la publication technique des objets, pas l'audit métier complet
de leur cycle de vie.

### Gouvernance

- **Éditeur** : CPage.
- **Dépendance FHIR** : `hl7.fhir.fr.core` version **2.2.0** — cet IG est construit directement sur
  FR Core, il n'en est pas une alternative ni une déviation.
- **Portée (`scope_type`)** : la quasi-totalité des profils de structure hospitalière sont à portée
  **TENANT** (propres à l'établissement propriétaire, sans golden record ni déduplication inter-
  établissements) ; le `GHTProfile` est la seule exception, à portée **GLOBAL** (visible par tous les
  tenants membres du groupement).
- **Statut** : Draft, version 0.1.0.

## Pour aller plus loin

- [Tiers financiers](tiers-financiers.html) — catalogue détaillé des profils, extensions et
  terminologies du domaine Tiers.
- [Structure hospitalière](structure-hospitaliere.html) — catalogue détaillé des profils, extensions,
  terminologies et de l'opération `$hierarchy`.
- [Ressources de conformité](artifacts.html) — liste exhaustive générée automatiquement de tous les
  artefacts FHIR définis dans cet IG.
- [Téléchargements](downloads.html) — package NPM, définitions JSON/XML/Turtle, exemples.
