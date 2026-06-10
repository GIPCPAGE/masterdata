// =============================================
// Profil : Unité Médicale
// =============================================

Profile: UniteMedicaleProfile
Parent: StructureHospitaliereOrganizationProfile
Id: strh-unite-medicale-profile
Title: "Unité Médicale"
Description: """
Profil représentant une unité médicale dans la structure hospitalière CPage.

Hérite de `StructureHospitaliereOrganizationProfile`.

L'unité médicale est une subdivision de l'UF dédiée à une spécialité médicale.
FR Core n'a pas de profil dédié — implémentée avec `type = UM`.

**Scope** : TENANT uniquement.
"""

// type = UM
* type 1..* MS
* type ^slicing.discriminator.type = #value
* type ^slicing.discriminator.path = "coding.code"
* type ^slicing.rules = #open
* type contains umType 1..1 MS
* type[umType].coding.system = "https://hl7.fr/ig/fhir/core/CodeSystem/fr-core-cs-v2-3307" (exactly)
* type[umType].coding.code = #UM (exactly)
* type[umType] ^short = "Type : Unité médicale (UM)"

// Rattachement UF
* partOf only Reference(UFProfile)
* partOf ^short = "Unité Fonctionnelle parente"
