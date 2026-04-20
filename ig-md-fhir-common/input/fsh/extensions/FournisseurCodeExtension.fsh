// =============================================
// Extension: Code Fournisseur
// =============================================

Extension: FournisseurCodeExtension
Id: fournisseur-code
Title: "Code Fournisseur"
Description: "Code unique identifiant le fournisseur dans le système de gestion"
* ^url = "https://www.cpage.fr/ig/masterdata/common/StructureDefinition/fournisseur-code"
* ^version = "1.0.0"
* ^status = #active
* ^context[0].type = #element
* ^context[0].expression = "Organization"

* value[x] only string
* valueString 1..1 MS
* valueString ^short = "Code fournisseur"
* valueString ^definition = "Code unique du fournisseur (ex: FOU123456)"
