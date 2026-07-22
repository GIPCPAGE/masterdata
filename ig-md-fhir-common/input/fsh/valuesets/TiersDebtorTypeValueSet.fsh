// =============================================
// ValueSet: Type Débiteur
// =============================================

ValueSet: TiersDebtorTypeVS
Id: tiers-debtor-type-vs
Title: "Type Débiteur"
Description: "ValueSet des types de débiteur (Occasionnel O / Normal N)"
* ^version = "1.0.0"
* ^status = #active
* ^experimental = false
* ^meta.profile = "http://hl7.org/fhir/StructureDefinition/shareablevalueset"
* include codes from system TiersDebtorTypeCS
