// =============================================
// Profil : Département
// =============================================
// ABSENT de CPage Oracle — pas de table source SIH.
// Créé et géré directement dans le Master Data pour compatibilité DPI / PMSI.
//
// Le département médical est utilisé dans certains CHU comme niveau structurel
// intermédiaire entre le pôle et les services. Il n'a pas de table dédiée dans
// les modules CPage (STR/PAT). Il est référencé dans la norme FR Core via le
// type DEPARTEMENT (fr-core-cs-v2-3307).
//
// Hérite de StructureHospitaliereOrganizationProfile (comme UniteMedicaleProfile).
// FR Core n'a pas de profil dédié — type = DEPARTEMENT (fr-core-cs-v2-3307).

Profile: DepartementProfile
Parent: StructureHospitaliereOrganizationProfile
Id: strh-departement-profile
Title: "Département"
Description: """
Profil FHIR R4 représentant un département médical.

Hérite de `StructureHospitaliereOrganizationProfile`.

**Origine** : concept absent de CPage Oracle, créé et géré directement dans
le Master Data pour assurer la compatibilité avec les DPI et le PMSI qui
référencent les départements médicaux (notamment dans les CHU).

Le département est un niveau structurel intermédiaire entre le pôle et les
services, utilisé dans certains établissements. FR Core n'a pas de profil
dédié — type = DEPARTEMENT (fr-core-cs-v2-3307).

**Scope** : TENANT uniquement.
"""

// type = DEPARTEMENT
* type 1..* MS
* type ^slicing.discriminator.type = #value
* type ^slicing.discriminator.path = "coding.code"
* type ^slicing.rules = #open
* type contains departementType 1..1 MS
* type[departementType].coding.system = "https://hl7.fr/ig/fhir/core/CodeSystem/fr-core-cs-v2-3307" (exactly)
* type[departementType].coding.code = #DEPARTEMENT (exactly)
* type[departementType] ^short = "Type : Département (DEPARTEMENT — fr-core-cs-v2-3307)"

// partOf non contraint : peut dépendre de EG, POLE ou SERVICE selon l'établissement
* partOf only Reference(StructureHospitaliereOrganizationProfile)
* partOf ^short = "Structure parente (EG, Pôle ou Service selon l'établissement)"
