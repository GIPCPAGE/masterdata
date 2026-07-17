// =============================================
// ValueSet Résidence CPage
// =============================================

ValueSet: CPageResidencyValueSet
Id: cpage-residency-valueset
Title: "ValueSet Résidence CPage"
Description: "Codes RESIDT : R (Résident), N (Non-résident), E (Étranger)."
* ^status = #active
* ^experimental = false
* ^meta.profile = "http://hl7.org/fhir/StructureDefinition/shareablevalueset"
* include codes from system CPageResidencyCodeSystem
