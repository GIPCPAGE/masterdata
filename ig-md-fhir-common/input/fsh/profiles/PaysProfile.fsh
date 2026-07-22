// =============================================
// Profil : Pays (ISO 3166-1 / INSEE)
// =============================================
// Basé sur la ressource FHIR Location.
//
// Chaque instance représente un pays ou territoire selon la norme ISO 3166-1
// et le référentiel INSEE des pays et territoires étrangers (COG).
//
// Identifiants portés :
//   - code ISO alpha-2 (ex : FR) — identifiant pivot (ID-02)
//   - code ISO alpha-3 (ex : FRA)
//   - code ISO numérique (ex : 250)
//   - code INSEE pays (ex : 99100 pour la France)
//
// Trois patrons d'utilisation :
//   Patron A — Pays souverain actif
//   Patron B — Pays historique inactif (supprimé du référentiel ISO)
//   Patron C — Territoire ou collectivité rattaché à un pays souverain

Profile: PaysProfile
Parent: Location
Id: pays-profile
Title: "Pays (ISO 3166-1 / INSEE)"
Description: """
Profil Location représentant un pays ou territoire selon la norme ISO 3166-1
et le référentiel INSEE des pays et territoires étrangers.

Chaque instance porte :
- le **code ISO alpha-2** (2 lettres, identifiant pivot) via `identifier[codeAlpha2]`
- le **code ISO alpha-3** (3 lettres) via `identifier[codeAlpha3]`
- le **code ISO numérique** (3 chiffres) via `identifier[codeNumerique]`
- le **code INSEE pays** (5 caractères, ex : 99100) via `identifier[codeInsee]`
- le **libellé court** officiel ISO via `name`
- le **libellé long** via `extension[libelleLong]`
- le **type d'entité** (pays souverain, territoire, collectivité française) via `type`
- le **rattachement** à un pays souverain pour les territoires via `partOf`
- l'**appartenance à l'UE** via `extension[unionEuropeenne]` (obligatoire)
- la **nationalité** associée via `extension[nationalite]`
- les dates de référentiel via `extension[dateCreationInsee]` et `extension[dateFin]`

**Source** : ISO 3166-1 / INSEE — référentiel des pays et territoires étrangers.
Scope Smart on FHIR requis : `pays.read` (AUTH-01).
"""

// =============================================
// Identifiants — slicing sur system
// =============================================

* identifier ^slicing.discriminator.type = #value
* identifier ^slicing.discriminator.path = "system"
* identifier ^slicing.rules = #open
* identifier ^slicing.description = "Identifiants ISO 3166-1 et INSEE du pays"

* identifier 1..* MS
  * system 1..1 MS
  * value 1..1 MS

* identifier contains
    codeAlpha2    1..1 MS and
    codeAlpha3    0..1 MS and
    codeNumerique 0..1 MS and
    codeInsee     0..1 MS

* identifier[codeAlpha2].system = "urn:iso:std:iso:3166" (exactly)
* identifier[codeAlpha2].value 1..1
* identifier[codeAlpha2] ^short = "Code ISO 3166-1 alpha-2 — identifiant pivot"
* identifier[codeAlpha2] ^definition = "Code pays ISO 3166-1 alpha-2. Format : 2 lettres majuscules. Exemples : FR (France), DE (Allemagne), US (États-Unis). Identifiant pivot de la ressource Pays (décision ID-02). Système : urn:iso:std:iso:3166 (FHIR R4 canonical)."

* identifier[codeAlpha3].system = "urn:iso:std:iso:3166:-1:alpha3" (exactly)
* identifier[codeAlpha3].value 1..1
* identifier[codeAlpha3] ^short = "Code ISO 3166-1 alpha-3"
* identifier[codeAlpha3] ^definition = "Code pays ISO 3166-1 alpha-3. Format : 3 lettres majuscules. Exemples : FRA (France), DEU (Allemagne), USA (États-Unis)."

* identifier[codeNumerique].system = "urn:iso:std:iso:3166:-1:num" (exactly)
* identifier[codeNumerique].value 1..1
* identifier[codeNumerique] ^short = "Code ISO 3166-1 numérique"
* identifier[codeNumerique] ^definition = "Code pays ISO 3166-1 numérique. Format : 3 chiffres. Exemples : 250 (France), 276 (Allemagne), 840 (États-Unis)."

* identifier[codeInsee].system = "https://mos.esante.gouv.fr/NOS/TRE_R20-Pays/FHIR/TRE-R20-Pays" (exactly)
* identifier[codeInsee].value 1..1
* identifier[codeInsee] ^short = "Code INSEE pays (5 caractères commençant par 99)"
* identifier[codeInsee] ^definition = "Code pays du référentiel ANS TRE-R20-Pays (INSEE des pays et territoires étrangers). Format : 5 caractères commençant par 99. Exemples : 99100 (France), 99109 (Allemagne), 99101 (Andorre)."

// =============================================
// Statut actif / inactif
// =============================================

* status 1..1 MS
* status ^short = "active | inactive"
* status ^definition = """
active = pays actuellement en vigueur dans le référentiel ISO 3166-1 (date_fin null) ;
inactive = pays historique supprimé du référentiel ISO (date_fin renseignée).
Un pays inactif reste consultable dans l'historique — conservation illimitée (LV-03).
"""

// =============================================
// Libellé court (nom officiel ISO)
// =============================================

* name 1..1 MS
* name ^short = "Libellé court officiel ISO"
* name ^definition = "Dénomination courte officielle du pays selon la norme ISO 3166-1. Exemples : France, Allemagne, États-Unis d'Amérique. Correspond au champ libelle_court du modèle de données."

// =============================================
// Type d'entité (pays | territoire | collectivite_francaise)
// =============================================

* type 1..1 MS
* type from PaysTypeEntiteVS (required)
* type ^short = "Nature de l'entité : pays souverain, territoire ou collectivité française"
* type ^definition = "Qualifie la nature administrative de l'entité selon la classification INSEE. Binding required sur PaysTypeEntiteVS. Correspond au champ type_entite (NOT NULL) du modèle de données."

// =============================================
// Type physique : juridiction administrative
// =============================================

* physicalType 0..1 MS
* physicalType = http://terminology.hl7.org/CodeSystem/location-physical-type#jdn "Jurisdiction"
* physicalType ^short = "Type physique : juridiction (entité géopolitique)"

// =============================================
// Extensions
// =============================================

* extension contains
    PaysLibelleLongExt       named libelleLong       0..1 MS and
    PaysUriInseeExt          named uriInsee          0..1 MS and
    PaysUnionEuropeenneExt   named unionEuropeenne   1..1 MS and
    PaysNationaliteExt       named nationalite       0..1 MS and
    PaysDateCreationInseeExt named dateCreationInsee 0..1 MS and
    PaysDateFinExt           named dateFin           0..1 MS and
    PaysDateMiseAJourExt     named dateMiseAJour     0..1 MS

* extension[libelleLong] ^short = "Libellé long officiel ISO (ex : République française)"
* extension[libelleLong] ^definition = "Dénomination longue officielle du pays selon ISO 3166-1. Correspond au champ libelle_long du modèle de données."

* extension[uriInsee] ^short = "URI officiel INSEE du pays (Linked Data)"
* extension[uriInsee] ^definition = "Identifiant officiel INSEE sous forme d'URI (uri_insee). Exemple : http://id.insee.fr/geo/pays/france."

* extension[unionEuropeenne] ^short = "Appartenance à l'Union européenne (obligatoire)"
* extension[unionEuropeenne] ^definition = "Indique si le pays est membre de l'UE. Obligatoire (union_europeenne NOT NULL). Un pays historique conserve la valeur qu'il avait à sa date de suppression."

* extension[nationalite] ^short = "Nationalité associée (ex : française)"
* extension[nationalite] ^definition = "Libellé de la nationalité au féminin singulier. Valeur déduite, non normalisée. Correspond au champ nationalite du modèle de données."

* extension[dateCreationInsee] ^short = "Date d'entrée dans le référentiel INSEE"
* extension[dateCreationInsee] ^definition = "Date de création dans le référentiel INSEE (date_creation_insee). Convention : 01/01 de l'année lorsque seule l'année est connue."

* extension[dateFin] ^short = "Date de suppression du référentiel ISO (pays inactifs)"
* extension[dateFin] ^definition = "Date à laquelle le pays a été supprimé du référentiel ISO 3166-1 (date_fin). Renseignée uniquement quand status = inactive. Exemples : 1991-12-26 (URSS), 1993-01-01 (Tchécoslovaquie)."

* extension[dateMiseAJour] ^short = "Date de dernière mise à jour dans le référentiel CPage"
* extension[dateMiseAJour] ^definition = "Horodatage de la dernière modification de la fiche pays dans le référentiel CPage (updatedDate). Toujours renseigné."

// =============================================
// Hiérarchie : territoire / collectivité → pays souverain
// =============================================

* partOf 0..1 MS
* partOf only Reference(PaysProfile)
* partOf ^short = "Pays souverain de rattachement (territoires et collectivités)"
* partOf ^definition = "Pour les territoires non souverains et les collectivités françaises : référence vers la Location représentant le pays souverain dont ils dépendent. Null pour les pays souverains indépendants. Correspond au champ pays_rattachement du modèle de données."

* obeys cpage-pays-1
* obeys cpage-pays-2

// =============================================
// Invariant : dateFin obligatoire si status = inactive
// =============================================

Invariant: cpage-pays-1
Description: "Un pays inactif doit avoir une date de fin renseignée"
Expression: "status = 'inactive' implies extension.where(url = 'https://www.cpage.fr/ig/masterdata/common/StructureDefinition/pays-date-fin-ext').exists()"
Severity: #error

// =============================================
// Invariant : partOf uniquement pour les non-souverains
// =============================================

Invariant: cpage-pays-2
Description: "partOf ne doit être renseigné que pour les territoires et collectivités françaises"
Expression: "partOf.exists() implies type.coding.where(code = 'pays').empty()"
Severity: #warning
