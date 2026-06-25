// =============================================
// CodeSystem Type de données — Paramètres Applicatif CPage
// Source : TypeDonneeEnum (master-data-api)
// =============================================

CodeSystem: CPageParametresApplicatifTypeDonneeCodeSystem
Id: cpage-parametres-applicatif-type-donnee-codesystem
Title: "Type de données d'un paramètre applicatif (CPage)"
Description: "Code indiquant le type de données de la valeur d'un paramètre applicatif. Permet au module consommateur de désérialiser correctement la valeur string. Source : TypeDonneeEnum."
* ^status = #draft
* ^experimental = false
* ^content = #complete
* ^caseSensitive = true
* ^meta.profile = "http://hl7.org/fhir/StructureDefinition/shareablecodesystem"
* #B "Boolean"   "Valeur booléenne sérialisée en string (\"true\" / \"false\")."
* #D "Date"      "Valeur date sérialisée au format ISO-8601 (ex : \"2026-06-24\")."
* #I "Integer"   "Valeur entière (ex : \"60\", \"480\")."
* #S "String"    "Valeur chaîne de caractères."
* #F "Float"     "Valeur décimale (ex : \"3.14\")."
* #C "Character" "Valeur caractère unique."
