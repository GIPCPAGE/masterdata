// =============================================
// ValueSet: Catégorie TG
// =============================================

ValueSet: TiersCategoryVS
Id: tiers-category-vs
Title: "Catégorie TG ValueSet"
Description: "ValueSet des catégories de tiers selon la nomenclature. Permet de classifier les organisations (codes 00-74)."
* ^version = "1.0.0"
* ^status = #active
* ^experimental = false
* ^meta.profile = "http://hl7.org/fhir/StructureDefinition/shareablevalueset"
* include codes from system TiersCategoryCS
