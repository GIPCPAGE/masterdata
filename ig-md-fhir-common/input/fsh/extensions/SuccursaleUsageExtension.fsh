// =============================================
// Extension Succursale Usage
// =============================================

Extension: SuccursaleUsageExtension
Id: succursale-usage-extension
Title: "Usage de la succursale"
Description: "Qualifie l'usage d'une succursale: point de livraison, siège de facturation, ou siège social secondaire."
* ^url = "http://cpage.org/fhir/StructureDefinition/succursale-usage-extension"
* ^version = "1.0.0"
* ^status = #active
* ^context[0].type = #element
* ^context[0].expression = "Organization"

* value[x] only code
* valueCode 1..1
* valueCode from SuccursaleUsageVS (required)
