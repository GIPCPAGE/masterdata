// =============================================
// Extensions : Entité Géographique (Common IG)
// =============================================
// Champs génériques issus de STR.ETA applicables à tout site hospitalier.

// ── Code de validité (INVAET) ────────────────────────────────────────────────

Extension: EGCodeValiditeExtension
Id: eg-code-validite
Title: "Code de validité du site"
Description: "Code de validité du site géographique (INVAET : F=Fermé / I=Invalide / V=Valide)."
Context: Organization

* value[x] only code
* valueCode from EGCodeValiditeVS (required)
* valueCode ^short = "Code validité (INVAET)"

ValueSet: EGCodeValiditeVS
Id: eg-code-validite-vs
Title: "Code de validité (INVAET)"
Description: "Codes de validité d'un site géographique (INVAET) : Fermé, Invalide ou Valide."
* ^experimental = false
* ^meta.profile = "http://hl7.org/fhir/StructureDefinition/shareablevalueset"
* EGCodeValiditeCS#F "Fermé"
* EGCodeValiditeCS#I "Invalide"
* EGCodeValiditeCS#V "Valide"

CodeSystem: EGCodeValiditeCS
Id: eg-code-validite-cs
Title: "Code de validité du site"
Description: "Code de validité du site géographique (INVAET) : F=Fermé, I=Invalide, V=Valide."
* ^experimental = false
* ^caseSensitive = true
* ^meta.profile = "http://hl7.org/fhir/StructureDefinition/shareablecodesystem"
* #F "Fermé"
* #I "Invalide"
* #V "Valide"
