// =============================================
// Extension Rôle Tiers (Générique)
// =============================================

Extension: TiersRoleExtension
Id: tiers-role-extension
Title: "Rôle générique du tiers"
Description: "Rôle du tiers : fournisseur (supplier), débiteur (debtor) ou mixte (mixed). Qualifie la fonction d'une organisation dans le contexte métier."
* ^status = #active
* ^context[0].type = #element
* ^context[0].expression = "Organization"
* value[x] only Coding
* valueCoding 1..1
* valueCoding from TiersRoleValueSet (required)
