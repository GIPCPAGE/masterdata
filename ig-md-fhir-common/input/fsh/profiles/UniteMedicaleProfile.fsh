// =============================================
// Profil : Unité Médicale
// =============================================
// ABSENT de CPage Oracle — pas de table source SIH.
// Créé et géré directement dans le Master Data pour compatibilité DPI / PMSI.
// L'UM n'est pas un sous-niveau de l'UF : dans le MOS/DGOS, l'UF est la plus
// petite unité de production médicale homogène.

Profile: UniteMedicaleProfile
Parent: StructureHospitaliereOrganizationProfile
Id: strh-unite-medicale-profile
Title: "Unité Médicale"
Description: """
Profil FHIR R4 représentant une unité médicale.

Hérite de `StructureHospitaliereOrganizationProfile`.

**Origine** : concept absent de CPage Oracle, créé et géré directement dans
le Master Data pour assurer la compatibilité avec les DPI et le PMSI qui
référencent les unités médicales.

Dans le MOS et l'organisation hospitalière française (DGOS), l'UF est la
plus petite unité de production médicale homogène. L'UM n'est pas un
sous-niveau de l'UF — la relation UM/UF dépend du cadre de référence utilisé.

FR Core n'a pas de profil dédié — type = UM (fr-core-cs-v2-3307).

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

// Rattachement : l'UM est une structure interne CPage dont le parent direct
// dépend du modèle Oracle de l'établissement (CR, Service, ou EG).
// Ne pas contraindre à UFProfile — la relation UM/UF n'est pas une simple hiérarchie.
* partOf only Reference(StructureHospitaliereOrganizationProfile)
* partOf ^short = "Structure parente dans la hiérarchie CPage (CR, Service ou EG selon établissement)"
