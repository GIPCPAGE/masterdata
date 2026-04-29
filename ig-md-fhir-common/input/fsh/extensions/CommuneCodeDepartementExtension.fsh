// =============================================
// Extension : Code département INSEE de la commune
// =============================================
// 2 caractères pour les départements métropolitains (01–95, 2A, 2B),
// 3 caractères pour les DROM (971–976).
// Correspond à la propriété `codeDepartement` (type code) du CodeSystem.

Extension: CommuneCodeDepartementExt
Id: commune-code-departement-ext
Title: "Code département INSEE"
Description: "Code département INSEE de la commune. Format : 2 caractères (01–95, 2A, 2B pour la Corse) ou 3 caractères pour les DROM (971–976). Correspond à la propriété `codeDepartement` du CodeSystem communes-fr-cs."
Context: Location
* ^url = "https://www.cpage.fr/ig/masterdata/common/StructureDefinition/commune-code-departement-ext"
* ^version = "1.0.0"
* ^status = #active
* ^context[0].type = #element
* ^context[0].expression = "Location"

* value[x] only code
* valueCode 1..1 MS
* valueCode ^short = "Code département (ex : 69, 2A, 971)"
* valueCode ^definition = "Code département INSEE associé à la commune. Exemples : 01 (Ain), 69 (Rhône), 2A (Corse-du-Sud), 971 (Guadeloupe)."
