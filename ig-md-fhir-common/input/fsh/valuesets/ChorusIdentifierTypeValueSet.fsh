// =============================================
// ValueSet: Type Identifiant CHORUS
// =============================================

ValueSet: ChorusIdentifierTypeVS
Id: chorus-identifier-type-vs
Title: "Type Identifiant CHORUS"
Description: "ValueSet des types d'identifiants acceptés par CHORUS (codes 01-08, sans le 09 En cours)"
* ^version = "1.0.0"
* ^status = #active
* ^experimental = false
* ^meta.profile = "http://hl7.org/fhir/StructureDefinition/shareablevalueset"
* include codes from system ChorusIdentifierTypeCS
