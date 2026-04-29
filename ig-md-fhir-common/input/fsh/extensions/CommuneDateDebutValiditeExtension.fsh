// =============================================
// Extension : Date de début de validité du code INSEE
// =============================================
// Correspond à la propriété `dateCreation` du CodeSystem communes-fr-cs.
// Pour les communes antérieures au COG numérique : conventionnellement 1943-01-01.

Extension: CommuneDateDebutValiditeExt
Id: commune-date-debut-validite-ext
Title: "Date de début de validité"
Description: "Date d'entrée en vigueur du code INSEE de la commune. Correspond à la propriété `dateCreation` du CodeSystem communes-fr-cs. Pour les communes antérieures au COG numérique, la convention est 1943-01-01."
Context: Location
* ^url = "https://www.cpage.fr/ig/masterdata/common/StructureDefinition/commune-date-debut-validite-ext"
* ^version = "1.0.0"
* ^status = #active
* ^context[0].type = #element
* ^context[0].expression = "Location"

* value[x] only date
* valueDate 1..1 MS
* valueDate ^short = "Date de début de validité du code INSEE (AAAA-MM-JJ)"
* valueDate ^definition = "Date à partir de laquelle le code INSEE est en vigueur. Exemples : 1943-01-01 pour les communes historiques, 2019-01-01 pour Belleville-en-Beaujolais (commune nouvelle)."
