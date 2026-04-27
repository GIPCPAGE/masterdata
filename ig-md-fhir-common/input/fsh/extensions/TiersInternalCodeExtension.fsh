// =============================================
// Extension: Code Interne Tiers
// =============================================

Extension: TiersInternalCodeExtension
Id: tiers-internal-code
Title: "Code Interne Tiers"
Description: "Code interne unique identifiant le tiers dans le référentiel de gestion"
* ^url = "https://www.cpage.fr/ig/masterdata/common/StructureDefinition/tiers-internal-code"
* ^version = "1.0.0"
* ^status = #active
* ^context[0].type = #element
* ^context[0].expression = "Organization"

* value[x] only string
* valueString 1..1 MS
* valueString ^short = "Code interne du tiers"
* valueString ^definition = "Code unique du tiers dans le référentiel de gestion"
