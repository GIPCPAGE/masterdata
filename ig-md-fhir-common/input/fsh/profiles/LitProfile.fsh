// =============================================
// Profil : Lit
// =============================================
// FR Core définit l'extension fr-core-location-position-lit
// pour la position du lit dans la chambre.

Profile: LitProfile
Parent: StructureHospitaliereSiteProfile
Id: strh-lit-profile
Title: "Lit"
Description: """
Profil représentant un lit d'hospitalisation dans la structure hospitalière CPage.

Hérite de `StructureHospitaliereSiteProfile` (issu de FRCoreLocationProfile).

FR Core définit déjà l'extension `fr-core-location-position-lit` pour la position du lit dans la chambre.

**Scope** : TENANT uniquement.
"""

// type = LIT
* type 1..* MS
* type ^slicing.discriminator.type = #value
* type ^slicing.discriminator.path = "coding.code"
* type ^slicing.rules = #open
* type contains litType 1..1 MS
* type[litType].coding.system = "http://terminology.hl7.org/CodeSystem/v3-RoleCode" (exactly)
* type[litType].coding.code = #BED (exactly)
* type[litType] ^short = "Type : Lit (BED)"

// Rattachement à la chambre
* partOf 0..1 MS
* partOf only Reference(ChambreProfile)
* partOf ^short = "Chambre parente"

// Organisation responsable (UF)
* managingOrganization 0..1 MS
* managingOrganization only Reference(UFProfile or UniteMedicaleProfile)
* managingOrganization ^short = "UF ou unité médicale responsable"
