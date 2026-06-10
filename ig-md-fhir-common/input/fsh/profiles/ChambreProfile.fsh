// =============================================
// Profil : Chambre
// =============================================
// FR Core définit l'extension fr-core-location-type-chambre
// (type chambre : STD/PRSN_NGTV/PRSN_PSTV/CRCRL/CPTN).

Profile: ChambreProfile
Parent: StructureHospitaliereSiteProfile
Id: strh-chambre-profile
Title: "Chambre"
Description: """
Profil représentant une chambre d'hospitalisation dans la structure hospitalière CPage.

Hérite de `StructureHospitaliereSiteProfile` (issu de FRCoreLocationProfile).

FR Core définit déjà l'extension `fr-core-location-type-chambre` pour le type de chambre
(STD, PRSN_NGTV, PRSN_PSTV, CRCRL, CPTN).

**Scope** : TENANT uniquement.
"""

// type = CHAMB (Location type)
* type 1..* MS
* type ^slicing.discriminator.type = #value
* type ^slicing.discriminator.path = "coding.code"
* type ^slicing.rules = #open
* type contains chambreType 1..1 MS
* type[chambreType].coding.system = "http://terminology.hl7.org/CodeSystem/v3-RoleCode" (exactly)
* type[chambreType].coding.code = #CHAMB (exactly)
* type[chambreType] ^short = "Type : Chambre (CHAMB)"

// Capacité : nombre de lits dans la chambre (via numberOfBeds si disponible)
* capacity 0..1 MS
* capacity ^short = "Nombre de lits dans la chambre"

// Rattachement à l'UF ou à l'unité médicale
* managingOrganization 0..1 MS
* managingOrganization only Reference(UFProfile or UniteMedicaleProfile)
* managingOrganization ^short = "UF ou unité médicale responsable de la chambre"
