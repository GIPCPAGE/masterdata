// =============================================
// ValueSet Restriction de rôle (adresse, compte bancaire)
// =============================================

ValueSet: TiersRestrictionRoleValueSet
Id: tiers-restriction-role-valueset
Title: "ValueSet Restriction de rôle"
Description: "Restriction facultative d'une adresse ou d'un compte bancaire à un seul circuit : fournisseur (F) ou débiteur (D). L'absence de restriction signifie que l'élément est commun aux deux circuits."
* ^status = #active
* ^experimental = false
* ^meta.profile = "http://hl7.org/fhir/StructureDefinition/shareablevalueset"
* TiersRoleCodeSystem#supplier
* TiersRoleCodeSystem#debtor
