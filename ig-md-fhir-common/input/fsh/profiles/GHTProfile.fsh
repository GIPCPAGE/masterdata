// =============================================
// Profil : GHT — Groupement Hospitalier de Territoire
// =============================================
// Hérite de FRCoreOrganizationProfile.
// Conforme FR Core structure_intro.html : le GHT est le niveau supérieur
// qui regroupe les établissements (Entités Juridiques) du territoire.
//
// Dans le contexte CPage Master Data, le GHT est l'instance MDM elle-même
// (la plateforme MDM est déployée pour un GHT). Ce profil permet de l'exposer
// explicitement dans les Bundles FHIR pour les consommateurs externes.

Profile: GHTProfile
Parent: FRCoreOrganizationProfile
Id: strh-ght-profile
Title: "GHT — Groupement Hospitalier de Territoire"
Description: """
Profil FHIR R4 représentant un Groupement Hospitalier de Territoire (GHT).

Hérite de `FRCoreOrganizationProfile` (FR Core 2.2.0).

Le GHT est le niveau organisationnel supérieur de la structure hospitalière.
Il regroupe les Entités Juridiques (`EntiteJuridiqueProfile`) membres du territoire.

**Dans le contexte CPage** : l'instance Master Data est déployée pour un GHT.
Ce profil permet d'exposer explicitement le GHT dans les Bundles FHIR.

**Scope** : GLOBAL — le GHT est visible par tous les tenants membres.
"""

// ── Identifiants ──────────────────────────────────────────────────────────────

* identifier ^slicing.discriminator.type = #value
* identifier ^slicing.discriminator.path = "system"
* identifier ^slicing.rules = #open

* identifier 1..* MS

* identifier contains strHId 1..1 MS
* identifier[strHId].system = "https://www.cpage.fr/ig/masterdata/common/identifiers/strh" (exactly)
* identifier[strHId].value 1..1 MS
* identifier[strHId] ^short = "Identifiant MDM interne (UUID)"

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

// ── Membres : Entités Juridiques du GHT ───────────────────────────────────────
// Les EJ membres referencent le GHT via partOf (EntiteJuridiqueProfile.partOf → GHTProfile).
// FR Core extension member permet aussi de lister les membres depuis le GHT.

* extension contains fr-core-organization-member named membres 0..* MS
* extension[membres] ^short = "Entités Juridiques membres du GHT"

// ── Pas de partOf : le GHT est le niveau racine ───────────────────────────────
* partOf 0..0
