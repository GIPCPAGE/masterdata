// =============================================
// ValueSet: Identifier Type
// =============================================

ValueSet: TiersIdentifierTypeVS
Id: tiers-identifier-type-vs
Title: "Type d'identifiant ValueSet"
Description: "Types d'identifiants supportés dans les interfaces pour la qualification des identifiants fournisseurs et débiteurs"
* ^version = "1.0.0"
* ^status = #active
* ^experimental = false
* ^meta.profile = "http://hl7.org/fhir/StructureDefinition/shareablevalueset"
* include codes from system TiersIdentifierTypeCS
