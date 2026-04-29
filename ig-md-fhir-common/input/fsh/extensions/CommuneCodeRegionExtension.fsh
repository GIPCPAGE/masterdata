// =============================================
// Extension : Code région INSEE de la commune
// =============================================
// Issu de la réforme territoriale de 2016 (loi NOTRe).
// Ex : 11 = Île-de-France, 84 = Auvergne-Rhône-Alpes, 93 = PACA.
// Correspond à la propriété `codeRegion` (type code) du CodeSystem.

Extension: CommuneCodeRegionExt
Id: commune-code-region-ext
Title: "Code région INSEE"
Description: "Code région INSEE de la commune, issu de la réforme territoriale de 2016 (loi NOTRe). Correspond à la propriété `codeRegion` du CodeSystem communes-fr-cs."
Context: Location
* ^url = "https://www.cpage.fr/ig/masterdata/common/StructureDefinition/commune-code-region-ext"
* ^version = "1.0.0"
* ^status = #active
* ^context[0].type = #element
* ^context[0].expression = "Location"

* value[x] only code
* valueCode 1..1 MS
* valueCode ^short = "Code région (ex : 84, 11, 93)"
* valueCode ^definition = "Code région INSEE. Exemples : 11 (Île-de-France), 84 (Auvergne-Rhône-Alpes), 93 (Provence-Alpes-Côte d'Azur), 02 (Martinique), 03 (Guyane)."
