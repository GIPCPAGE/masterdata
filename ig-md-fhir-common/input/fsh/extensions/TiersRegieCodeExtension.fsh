// =============================================
// Extension: Code Régie
// =============================================

Extension: TiersRegieCode
Id: tiers-regie-code
Title: "Code Régie"
Description: "Extension pour le code régie du secteur public. Correspond au champ KERD position 7. Le code régie identifie de façon unique une régie d'avance ou de recettes au sein d'un établissement public. Les régies sont des services habilités à manier des fonds publics pour le compte d'une collectivité ou d'un établissement public."
Context: Organization
* ^url = "https://www.cpage.fr/ig/masterdata/common/StructureDefinition/tiers-regie-code"
* ^version = "1.0.0"
* ^status = #active
* ^context[0].type = #element
* ^context[0].expression = "Organization"

* value[x] only string
* valueString 1..1 MS
* valueString ^short = "Code régie (10 caractères max)"
* valueString ^definition = "Code identifiant la régie d'avance ou de recettes du secteur public"
* valueString ^maxLength = 10
