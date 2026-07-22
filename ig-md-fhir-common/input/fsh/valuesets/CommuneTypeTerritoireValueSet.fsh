// =============================================
// ValueSet: Type de territoire communal
// =============================================

ValueSet: CommuneTypeTerritoireVS
Id: commune-type-territoire-vs
Title: "Types de territoire communal"
Description: "Nature administrative d'une commune française : commune ordinaire, commune nouvelle (issue d'une fusion depuis 2016) ou commune déléguée (ancienne commune conservée dans une commune nouvelle)."
* ^version = "1.0.0"
* ^status = #active
* ^experimental = false
* ^immutable = true
* ^publisher = "CPage"
* ^meta.profile = "http://hl7.org/fhir/StructureDefinition/shareablevalueset"

* include codes from system CommuneTypeTerritoireCS
