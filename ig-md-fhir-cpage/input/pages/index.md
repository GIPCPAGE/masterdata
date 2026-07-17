# Masterdata — IG FHIR CPage

Cet Implementation Guide (IG) FHIR R4 définit les profils et extensions
**spécifiques à CPage** pour le Master Data Management (MDM) hospitalier : les
Tiers (Fournisseurs, Débiteurs) et les structures hospitalières (Entité Juridique,
Entité Géographique, Unité Fonctionnelle).

Il n'est pas autonome : il **hérite** de l'[IG Socle Commun](https://www.cpage.fr/ig/masterdata/common/)
(`ig.mdm.fhir.common`, déclaré en dépendance `dev` dans `sushi-config.yaml`), qui
porte déjà les profils génériques, les contraintes FR Core et la majorité des
extensions. Ce guide n'ajoute que ce qui est propre au système CPage : les champs
issus des tables Oracle historiques `ECO.FOU`, `ECO.DBT`, `ECO.ETIER`, `STR.CHO`,
`STR.ETA` et `STR.UFO`.

## Architecture multi-IG

```text
FR Core 2.2.0 (HL7 France)
  FRCoreOrganizationEtablissementProfile, FRCoreOrganizationUFProfile
        │
        ▼
IG Socle Commun (ig-md-fhir-common)
  TiersProfile, FournisseurProfile, DebiteurProfile,
  EntiteJuridiqueProfile, EntiteGeographiqueProfile, UFProfile
  + extensions génériques et hiérarchie structure hospitalière (GHT, Pôle,
    Centre de Responsabilité, Service, Centre d'Activité, Secteur...)
        │
        ▼
IG CPage (ce guide)
  CPageFournisseurProfile, CPageDebiteurProfile,
  CPageEntiteJuridiqueProfile, CPageEntiteGeographiqueProfile, CPageUFProfile
  + terminologies CPage (validité, zone Europe, résidence)
```

Chaque profil CPage a pour unique responsabilité d'ajouter les extensions
manquantes issues du legacy Oracle CPage ; il n'entre jamais en contradiction avec
son parent commun et ne redéfinit rien de ce que celui-ci porte déjà (identifiants,
adresse, hiérarchie organisationnelle, etc.).

## Catalogue des profils

| Profil CPage | Parent (IG commun) | Table Oracle source | Fiabilité du mapping |
|---|---|---|---|
| `CPageFournisseurProfile` | `FournisseurProfile` | `ECO.FOU` (+ `ECO.ETIER`) | DDL Oracle réel |
| `CPageDebiteurProfile` | `DebiteurProfile` | `ECO.DBT` (+ `ECO.ETIER`) | DDL Oracle réel |
| `CPageEntiteJuridiqueProfile` | `EntiteJuridiqueProfile` | `STR.CHO` | Commentaires FSH uniquement |
| `CPageEntiteGeographiqueProfile` | `EntiteGeographiqueProfile` | `STR.ETA` | Commentaires FSH uniquement |
| `CPageUFProfile` | `UFProfile` | `STR.UFO` | Commentaires FSH uniquement |
| `CPageParametresApplicatifProfile` | *(aucun — `Parent: Parameters`)* | *(aucune — source Java `master-data-api`)* | Voir [Paramètres techniques](parametres-techniques.html) |

Pour les deux premiers profils, chaque colonne Oracle citée dans ce guide a été
vérifiée contre l'export `CREATE TABLE` réel de `ECO.ETIER`/`ECO.FOU`/`ECO.DBT`.
Pour les trois derniers, aucun export DDL équivalent n'existe pour `STR.CHO`,
`STR.ETA` ou `STR.UFO` dans ce dépôt : le mapping restitue fidèlement les
commentaires déjà présents dans le FSH, sans pouvoir les confronter à un schéma
Oracle indépendant. Cette différence de niveau de confiance est rappelée à chaque
section du document de mapping détaillé.

### CPageFournisseurProfile

Ajoute, depuis `ECO.FOU`, la validité (`VALIFO`), la zone Europe (`EUROFO`), les
comptes comptables classe 2 et classe 6, les conditions de paiement, les
indicateurs marchés publics/groupement d'achat/escompte, les informations Chorus
et deux drapeaux internes d'extraction.

### CPageDebiteurProfile

Ajoute, depuis `ECO.DBT`, la validité (`INVADT`), la résidence (`RESIDT`), le
compte de tiers débiteur, les paramètres ASAP, l'identifiant externe et une
référence vers le fournisseur associé (`NUFODT`). L'extension `CPageEUZone` existe
aussi sur ce profil, mais ne correspond en l'état du modèle à aucune colonne propre
à `ECO.DBT` — voir la section 2 de `LEGACY_SUPPORT.md`.

### CPageEntiteJuridiqueProfile

Ajoute, depuis `STR.CHO`, le receveur comptable (raison sociale, adresse, RIB,
BIC/IBAN, poste comptable, téléphones), les numéros d'organismes patronaux
(accident du travail, retraite complémentaire, CNAVTS, IRCANTEC, CAMARCA, CNRACL,
URSSAF), les paramètres de TVA et trois indicateurs (M22, TPG, BIC). Le profil
parent `EntiteJuridiqueProfile` (IG commun) porte déjà, indépendamment de CPage, le
rattachement à un GHT et la liste des Centres de Responsabilité membres — ce guide
ne les redéfinit pas.

### CPageEntiteGeographiqueProfile

Ajoute, depuis `STR.ETA`, les 14 dates d'activation T2A par type de séjour
(MCO/HAD, SSR, PSY, Long séjour, chacune en Externe et en Hospitalisation, pour les
bases de remboursement et pour la facturation individuelle), les paramètres de TVA
et quatre coefficients tarifaires (prudentiel, MCO, CFISC, SEGUR).

### CPageUFProfile

Ajoute, depuis `STR.UFO`, les trois modules métier historiques : **MAL** (lits,
étiquettes, options cliniques, fermetures automatiques, PMSI), **ECO** (TVA,
magasin, UF prestataire, paramètres comptables) et **PER** (personnel/RH,
indicateurs de paie).

### CPageParametresApplicatifProfile

Profil d'une nature différente des cinq précédents : il ne spécialise aucun
profil du socle commun (`Parent: Parameters`, ressource FHIR standard) et sa
terminologie ne vient pas d'Oracle mais de deux énumérations Java du code
applicatif `master-data-api`. Représente un paramètre de configuration
fonctionnelle centralisé (durée de session, taux de TVA, timeout de connecteur...) —
CPage ou **legacy** —, avec gestion optionnelle de périodes de validité
successives. Voir la page dédiée
[Paramètres techniques](parametres-techniques.html) pour le détail complet.

## Terminologies CPage

| CodeSystem | Codes | Rôle |
|---|---|---|
| `CPageValidityCodeSystem` | `V` / `I` | Validité (Valide / Invalide) |
| `CPageEUZoneCodeSystem` | `F` / `O` / `A` | Zone géographique (France / Europe hors France / Autre) |
| `CPageResidencyCodeSystem` | `R` / `N` / `E` | Résidence débiteur (Résident / Non-résident / Étranger) |
| `CPageParametresApplicatifTypeCodeSystem` | `A`/`S`/`U`/`C`/`D`/`P` | Type fonctionnel d'un paramètre applicatif (source : `TypeParametreEnum`, `master-data-api`) |
| `CPageParametresApplicatifTypeDonneeCodeSystem` | `B`/`D`/`I`/`S`/`F`/`C` | Type de la valeur d'un paramètre applicatif (source : `TypeDonneeEnum`, `master-data-api`) |

Chaque CodeSystem est accompagné d'un ValueSet `required` du même nom.

## Mapping Oracle → FHIR détaillé

Le tableau ci-dessus donne un résumé de premier niveau. Le mapping complet,
colonne Oracle par colonne, avec le niveau de vérification et les points de
vigilance identifiés pour chaque profil, est maintenu dans
[`LEGACY_SUPPORT.md`](https://github.com/GIPCPAGE/masterdata/blob/master/ig-md-fhir-cpage/LEGACY_SUPPORT.md)
à la racine du dépôt source. Toute décision d'implémentation ou de migration doit
s'y référer directement plutôt qu'à ce résumé.

## Limitations connues

Les contraintes de longueur (`maxLength`) et de motif sur les champs `string` de
cet IG ne sont, à ce jour, documentées que dans les annotations `^short` des
extensions CPage, pas appliquées comme contrainte FHIR de validation. Voir
[`FSH-LIMITATIONS.md`](https://github.com/GIPCPAGE/masterdata/blob/master/ig-md-fhir-cpage/FSH-LIMITATIONS.md)
pour le détail technique et les solutions FSH disponibles (`^maxLength`,
Invariant).

## Ressources de conformité

L'ensemble des profils, extensions, terminologies et exemples publiés par cet IG
est disponible sur la page [Ressources de conformité](artifacts.html).
