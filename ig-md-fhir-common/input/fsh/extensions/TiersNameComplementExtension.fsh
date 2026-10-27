// =============================================
// Extension Complément de nom du tiers
// =============================================

Extension: TiersNameComplementExtension
Id: tiers-name-complement-extension
Title: "Complément de nom du tiers"
Description: "Complément de la raison sociale du tiers. Organization.name n'accepte qu'une valeur et Organization.alias porte les noms alternatifs : le complément a donc sa propre extension."
* ^status = #active
* ^context[0].type = #element
* ^context[0].expression = "Organization"
* value[x] only string
* valueString 1..1
