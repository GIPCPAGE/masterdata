// =============================================
// ValueSet Validité CPage
// =============================================

ValueSet: CPageValidityValueSet
Id: cpage-validity-valueset
Title: "ValueSet Validité CPage"
Description: "Codes de validité : V (Valide) ou I (Invalide)."
* ^status = #active
* ^experimental = false
* ^meta.profile = "http://hl7.org/fhir/StructureDefinition/shareablevalueset"
* include codes from system CPageValidityCodeSystem
