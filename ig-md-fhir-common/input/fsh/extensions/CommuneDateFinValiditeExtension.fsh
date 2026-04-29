// =============================================
// Extension : Date de fin de validité du code INSEE
// =============================================
// Correspond à la propriété `dateSuppression` du CodeSystem communes-fr-cs.
// Renseignée uniquement pour les communes inactives (fusionnées ou supprimées).

Extension: CommuneDateFinValiditeExt
Id: commune-date-fin-validite-ext
Title: "Date de fin de validité"
Description: "Date à laquelle le code INSEE a cessé d'être actif (fusion, suppression ou transformation). Correspond à la propriété `dateSuppression` du CodeSystem communes-fr-cs. Présente uniquement quand `status = inactive`."
Context: Location
* ^url = "https://www.cpage.fr/ig/masterdata/common/StructureDefinition/commune-date-fin-validite-ext"
* ^version = "1.0.0"
* ^status = #active
* ^context[0].type = #element
* ^context[0].expression = "Location"

* value[x] only date
* valueDate 1..1 MS
* valueDate ^short = "Date de fin de validité du code INSEE (AAAA-MM-JJ)"
* valueDate ^definition = "Date à laquelle la commune a été fusionnée, supprimée ou transformée. Exemples : 2019-01-01 pour Saint-Jean-d'Ardières (fusionnée dans Belleville-en-Beaujolais)."
