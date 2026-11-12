// =============================================
// Profil : GHT — Groupement Hospitalier de Territoire
// =============================================
// Hérite de FRCoreOrganizationProfile.
// Conforme FR Core structure_intro.html : le GHT est le niveau supérieur
// qui regroupe les établissements (Entités Juridiques) du territoire.
//
// Dans le contexte CPage Master Data, le GHT est une ressource de la structure
// hospitalière, créée à la main par l'administrateur du GHT, portée par le tenant
// GLOBAL et lisible par tous les tenants. Racine de la hiérarchie : les entités
// juridiques pointent vers lui. Ce profil l'expose dans les Bundles FHIR.
//
// Socle de 7 attributs (décisions MD-Q01/PB-Q03) : identifiant technique -> identifier[strHId],
// code interne -> identifier[ghtCode], libellé -> name, libellé réduit -> alias[0].
// Les cinq éléments internes du socle (code interne, libellé réduit, libellé de diffusion,
// début et fin de validité) sont portés ici par des extensions du socle commun de la structure
// hospitalière : le GHT n'a pas d'équivalent CPage, il n'y a donc pas de profil dédié dans
// ig-md-fhir-cpage.

Profile: GHTProfile
Parent: FRCoreOrganizationProfile
Id: strh-ght-profile
Title: "GHT — Groupement Hospitalier de Territoire"
Description: """
Profil FHIR R4 représentant un Groupement Hospitalier de Territoire (GHT).

Hérite de `FRCoreOrganizationProfile` (FR Core 2.2.0).

Le GHT est le niveau organisationnel supérieur de la structure hospitalière.
Il regroupe les Entités Juridiques (`EntiteJuridiqueProfile`) membres du territoire.

**Dans le contexte CPage** : le GHT est une ressource créée par l'administrateur du GHT,
racine de la hiérarchie (pas de `partOf`). Ce profil l'expose dans les Bundles FHIR.

**Scope** : GLOBAL — le GHT est visible par tous les tenants membres.

Les éléments internes du socle (code interne, libellé réduit, libellé de diffusion, dates de début
et de fin de validité) sont portés par les extensions du socle commun de la structure hospitalière.
"""

// ── Identifiants ──────────────────────────────────────────────────────────────

* identifier ^slicing.discriminator.type = #value
* identifier ^slicing.discriminator.path = "system"
* identifier ^slicing.rules = #open

* identifier 1..* MS

* identifier contains strHId 1..1 MS and ghtCode 1..1 MS
* identifier[strHId].system = "https://www.cpage.fr/ig/masterdata/common/identifiers/strh" (exactly)
* identifier[strHId].value 1..1 MS
* identifier[strHId] ^short = "Identifiant technique MDM (clé unique attribuée à la création, jamais modifiée)"

* identifier[ghtCode].system = "https://www.cpage.fr/ig/masterdata/common/identifiers/ght-code" (exactly)
* identifier[ghtCode].value 1..1 MS
* identifier[ghtCode] ^short = "Code interne du GHT (code fonctionnel, unique, 20 caractères au plus)"

// ── Type organisationnel ──────────────────────────────────────────────────────

* type 1..* MS
* type ^slicing.discriminator.type = #value
* type ^slicing.discriminator.path = "coding.code"
* type ^slicing.rules = #open

* type contains ghtType 1..1 MS
* type[ghtType].coding.system = "https://hl7.fr/ig/fhir/core/CodeSystem/fr-core-cs-v2-3307" (exactly)
* type[ghtType].coding.code = #GHT (exactly)
* type[ghtType] ^short = "Type : Groupement Hospitalier de Territoire (GHT)"

// ── Dénomination ─────────────────────────────────────────────────────────────

* name 1..1 MS
* name ^short = "Dénomination officielle du GHT"

* active 1..1 MS

* alias 0..1 MS
* alias ^short = "Libellé réduit du GHT (20 caractères au plus)"

// ── Membres : Entités Juridiques du GHT ───────────────────────────────────────
// Les EJ membres referencent le GHT via partOf (EntiteJuridiqueProfile.partOf → GHTProfile).
// FR Core extension member permet aussi de lister les membres depuis le GHT.

* extension contains fr-core-organization-member named membres 0..* MS
* extension[membres] ^short = "Entités Juridiques membres du GHT"

// ── Éléments internes du socle : extensions du socle commun ───────────────────

* extension contains
    StrHCodeInterneExtension          named codeInterne       0..1 MS and
    StrHLibelleReduitExtension        named libelleReduit     0..1 MS and
    StrHDateDebutValiditeExtension    named dateDebutValidite 0..1 MS and
    StrHDateFinValiditeExtension      named dateFinValidite   0..1 MS and
    StrHLibelleDiffusionExtension     named libelleDiffusion  0..1 MS

* extension[codeInterne]       ^short = "Code interne du GHT"
* extension[libelleReduit]     ^short = "Libellé réduit du GHT"
* extension[dateDebutValidite] ^short = "Date de début de validité du GHT"
* extension[dateFinValidite]   ^short = "Date de fin de validité du GHT (absente tant qu'il est ouvert)"
* extension[libelleDiffusion]  ^short = "Libellé de diffusion du GHT (250 caractères au plus)"

// ── Pas de partOf : le GHT est le niveau racine ───────────────────────────────
* partOf 0..0
