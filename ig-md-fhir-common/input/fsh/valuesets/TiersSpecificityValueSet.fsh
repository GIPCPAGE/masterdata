// =============================================
// ValueSet Spécificités Tiers
// =============================================

ValueSet: TiersSpecificityValueSet
Id: tiers-specificity-valueset
Title: "ValueSet Spécificités Tiers"
Description: "Particularités d'un tiers : laboratoire, locataire, agent, débiteur mortuaire, hospitalier."
* ^status = #active
* ^experimental = false
* ^meta.profile = "http://hl7.org/fhir/StructureDefinition/shareablevalueset"
* include codes from system TiersSpecificityCodeSystem
