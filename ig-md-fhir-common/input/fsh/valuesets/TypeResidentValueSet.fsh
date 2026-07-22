// =============================================
// ValueSet: Type de résident
// =============================================

ValueSet: TypeResidentVS
Id: type-resident-vs
Title: "ValueSet Type de résident fiscal"
Description: "ValueSet pour le type de résident fiscal"
* ^version = "1.0.0"
* ^status = #active
* ^experimental = false
* ^meta.profile = "http://hl7.org/fhir/StructureDefinition/shareablevalueset"
* include codes from system TypeResidentCS
