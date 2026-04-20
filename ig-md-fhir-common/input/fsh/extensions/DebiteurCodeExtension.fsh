// =============================================
// Extension: Code Débiteur
// =============================================

Extension: DebiteurCodeExtension
Id: debiteur-code
Title: "Code Débiteur"
Description: "Code unique identifiant le débiteur/client dans le système de gestion"
* ^url = "https://www.cpage.fr/ig/masterdata/common/StructureDefinition/debiteur-code"
* ^version = "1.0.0"
* ^status = #active
* ^context[0].type = #element
* ^context[0].expression = "Organization"

* value[x] only string
* valueString 1..1 MS
* valueString ^short = "Code débiteur"
* valueString ^definition = "Code unique du débiteur (ex: DBT123456)"
