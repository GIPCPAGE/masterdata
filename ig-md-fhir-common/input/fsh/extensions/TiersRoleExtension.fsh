// =============================================
// Extension Rôle Tiers (Générique)
// =============================================

Extension: TiersRoleExtension
Id: tiers-role-extension
Title: "Rôle générique du tiers"
Description: "Rôle(s) générique(s) du tiers : débiteur / fournisseur. Cette extension permet de qualifier la fonction d'une organisation dans le contexte métier (table fournisseurs, table debiteurs)."
* ^status = #active
* ^context[0].type = #element
* ^context[0].expression = "Organization"
* value[x] only Coding
* valueCoding 1..1
* valueCoding from TiersRoleValueSet (required)
