// =============================================
// Extension Fiche valide
// =============================================

Extension: TiersValidExtension
Id: tiers-valid-extension
Title: "Fiche tiers valide"
Description: "Indicateur de validité de la fiche tiers, repris du référentiel source. Distinct de Organization.active, qui porte le statut actif ou inactif (désactivation logique)."
* ^status = #active
* ^context[0].type = #element
* ^context[0].expression = "Organization"
* value[x] only boolean
* valueBoolean 1..1
