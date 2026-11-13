// =============================================
// Extension Restriction de rôle (adresse)
// =============================================

Extension: TiersRoleRestrictionExtension
Id: tiers-role-restriction-extension
Title: "Restriction de rôle d'une adresse"
Description: "Restreint une adresse au circuit fournisseur (supplier) ou débiteur (debtor). Facultative : l'absence de l'extension signifie que l'adresse est commune aux deux circuits. La restriction doit faire partie du rôle du tiers (un tiers fournisseur ne peut pas porter une adresse restreinte au circuit débiteur)."
* ^status = #active
* ^context[0].type = #element
* ^context[0].expression = "Address"
* value[x] only Coding
* valueCoding 1..1
* valueCoding from TiersRestrictionRoleValueSet (required)
