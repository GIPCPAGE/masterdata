// =============================================
// Profil : Salle d'examen
// =============================================
// ABSENT de CPage Oracle — pas de table source SIH.
// Créé et géré directement dans le Master Data pour compatibilité DPI / PMSI.
//
// La salle d'examen est référencée dans FR Core via le type SL_EXM
// (fr-core-cs-location-type). Elle n'a pas de table dédiée dans les modules
// CPage (STR/PAT) mais peut être transmise par les DPI.
//
// Hérite de StructureHospitaliereSiteProfile (comme ChambreProfile et LitProfile).

Profile: SalleExamenProfile
Parent: StructureHospitaliereSiteProfile
Id: strh-salle-examen-profile
Title: "Salle d'examen"
Description: """
Profil FHIR R4 représentant une salle d'examen.

Hérite de `StructureHospitaliereSiteProfile` (issu de `FRCoreLocationProfile`).

**Origine** : concept absent de CPage Oracle, créé et géré directement dans
le Master Data pour assurer la compatibilité avec les DPI et le PMSI qui
référencent les salles d'examen (type SL_EXM / fr-core-cs-location-type).

**Scope** : TENANT uniquement.
"""

// ── Identifiants ──────────────────────────────────────────────────────────────

* identifier ^slicing.discriminator.type = #value
* identifier ^slicing.discriminator.path = "system"
* identifier ^slicing.rules = #open

* identifier contains
    salleExamenCode 0..1 MS

* identifier[salleExamenCode].system = "https://www.cpage.fr/ig/masterdata/common/identifiers/salle-examen-code" (exactly)
* identifier[salleExamenCode].value 1..1
* identifier[salleExamenCode] ^short = "Code salle d'examen"

// ── Type Location ─────────────────────────────────────────────────────────────

* type 1..* MS
* type ^slicing.discriminator.type = #value
* type ^slicing.discriminator.path = "coding.code"
* type ^slicing.rules = #open

* type contains salleExamenType 1..1 MS
* type[salleExamenType].coding.system = "https://hl7.fr/ig/fhir/core/CodeSystem/fr-core-cs-location-type" (exactly)
* type[salleExamenType].coding.code = #SL_EXM (exactly)
* type[salleExamenType] ^short = "Type : Salle d'examen (SL_EXM — FR Core fr-core-cs-location-type)"

// ── Dénomination ─────────────────────────────────────────────────────────────

* name 1..1 MS
* name ^short = "Libellé de la salle d'examen"

// ── Statut actif ──────────────────────────────────────────────────────────────

* status 0..1 MS

// ── Hiérarchie : UF gestionnaire ─────────────────────────────────────────────

* managingOrganization 0..1 MS
* managingOrganization only Reference(UFProfile)
* managingOrganization ^short = "UF gestionnaire"
