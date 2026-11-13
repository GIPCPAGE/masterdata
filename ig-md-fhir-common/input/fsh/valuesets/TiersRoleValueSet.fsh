// =============================================
// ValueSet Rôles Tiers
// =============================================

ValueSet: TiersRoleValueSet
Id: tiers-role-valueset
Title: "ValueSet Rôles Tiers"
Description: "Rôle d'un tiers : fournisseur, débiteur ou mixte."
* ^status = #active
* ^experimental = false
* ^meta.profile = "http://hl7.org/fhir/StructureDefinition/shareablevalueset"
* include codes from system TiersRoleCodeSystem
