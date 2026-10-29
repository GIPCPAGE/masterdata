// =============================================
// Extension Spécificité du tiers
// =============================================

Extension: TiersSpecificityExtension
Id: tiers-specificity-extension
Title: "Spécificité du tiers"
Description: "Particularité du tiers cochée sur la fiche (laboratoire, locataire, agent, débiteur mortuaire, hospitalier). Répétable : un tiers peut cumuler plusieurs spécificités."
* ^status = #active
* ^context[0].type = #element
* ^context[0].expression = "Organization"
* value[x] only Coding
* valueCoding 1..1
* valueCoding from TiersSpecificityValueSet (required)
