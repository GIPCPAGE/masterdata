// =============================================
// ValueSet: Types d'usage de succursale
// =============================================

ValueSet: SuccursaleUsageVS
Id: succursale-usage-vs
Title: "ValueSet Types d'usage de succursale"
Description: "ValueSet pour les types d'usage des succursales"
* ^version = "1.0.0"
* ^status = #active
* ^experimental = false
* ^meta.profile = "http://hl7.org/fhir/StructureDefinition/shareablevalueset"
* include codes from system SuccursaleUsageCS
