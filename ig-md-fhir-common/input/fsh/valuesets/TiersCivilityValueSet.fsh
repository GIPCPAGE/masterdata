// =============================================
// ValueSet: Civilité
// =============================================

ValueSet: TiersCivilityVS
Id: tiers-civility-vs
Title: "Civilité"
Description: "ValueSet des codes de civilité (M, MME, MLLE, METMME, MOUMME)"
* ^version = "1.0.0"
* ^status = #active
* ^experimental = false
* ^meta.profile = "http://hl7.org/fhir/StructureDefinition/shareablevalueset"
* include codes from system TiersCivilityCS
