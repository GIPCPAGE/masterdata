// =============================================
// Profil : Pôle
// =============================================

Profile: PoleProfile
Parent: StructureHospitaliereOrganizationProfile
Id: strh-pole-profile
Title: "Pôle"
Description: """
Profil représentant un pôle médico-chirurgical dans la structure hospitalière CPage.

Hérite de `StructureHospitaliereOrganizationProfile` (lui-même issu de FRCoreOrganizationProfile).

Le pôle regroupe plusieurs unités fonctionnelles ou unités médicales.
Rattaché à une entité géographique via `partOf`.

**Scope** : TENANT uniquement.
"""

// type = POLE (CodeSystem v2-3307)
* type 1..* MS
* type ^slicing.discriminator.type = #value
* type ^slicing.discriminator.path = "coding.code"
* type ^slicing.rules = #open
* type contains poleType 1..1 MS
* type[poleType].coding.system = "https://hl7.fr/ig/fhir/core/CodeSystem/fr-core-cs-v2-3307" (exactly)
* type[poleType].coding.code = #POLE (exactly)
* type[poleType] ^short = "Type : Pôle (POLE)"

// Rattachement à l'entité géographique
* partOf only Reference(EntiteGeographiqueProfile)
* partOf ^short = "Entité géographique parente"
