// =============================================
// ValueSet: Nature Juridique
// =============================================

ValueSet: TiersLegalNatureVS
Id: tiers-legal-nature-vs
Title: "Nature juridique ValueSet"
Description: "ValueSet des natures juridiques selon la nomenclature. Utilisé pour qualifier la structure juridique des organisations dans les interfaces"
* ^version = "1.0.0"
* ^status = #active
* ^experimental = false
* ^meta.profile = "http://hl7.org/fhir/StructureDefinition/shareablevalueset"
* include codes from system TiersLegalNatureCS
