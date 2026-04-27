// =============================================
// Extensions : Commune française (COG INSEE)
// =============================================
// Trois extensions portées par Location/CommuneFrancaiseProfile :
//   1. CommuneCodePostalExt       — code postal (répétable 0..*)
//   2. CommuneCodeDepartementExt  — code département INSEE (0..1)
//   3. CommuneCodeRegionExt       — code région INSEE (0..1)

// -------------------------------------------------------
// 1. Code postal
// -------------------------------------------------------
// Répétable : une commune peut être couverte par plusieurs codes postaux
// (grandes villes, communes géographiquement étendues, arrondissements).
// Correspond exactement à la propriété `codePostal` (type string, répétable)
// définie dans CommunesFrancaisesCodeSystem.

Extension: CommuneCodePostalExt
Id: commune-code-postal-ext
Title: "Code postal de la commune"
Description: "Code postal rattaché à la commune. Répétable : une commune peut avoir plusieurs codes postaux. Chaque instance porte un code à 5 chiffres issu de la base La Poste HEXASIMAL."
Context: Location
* ^url = "https://www.cpage.fr/ig/masterdata/common/StructureDefinition/commune-code-postal-ext"
* ^version = "1.0.0"
* ^status = #active
* ^context[0].type = #element
* ^context[0].expression = "Location"

* value[x] only string
* valueString 1..1 MS
* valueString ^short = "Code postal (5 chiffres)"
* valueString ^definition = "Code postal de la commune ou du secteur concerné. Format : 5 chiffres numériques."

// -------------------------------------------------------
// 2. Code département INSEE
// -------------------------------------------------------
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

// -------------------------------------------------------
// 3. Code région INSEE
// -------------------------------------------------------
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
