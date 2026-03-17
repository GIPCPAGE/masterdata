// =============================================
// SearchParameter: Payeur Santé - Type Payeur
// Permet de rechercher un payeur santé par son type (RO ou RC)
// =============================================

Instance: PayeurTypeSearchParameter
InstanceOf: SearchParameter
Usage: #definition
Title: "Search Payeur Santé by Type"
Description: "Permet de rechercher un payeur santé par son type: Régime Obligatoire (RO) ou Régime Complémentaire (RC)."

* url = "http://cpage.org/fhir/SearchParameter/payeur-type"
* version = "1.0.0"
* name = "PayeurTypeSearchParameter"
* status = #active
* experimental = false
* date = "2026-03-17"
* publisher = "CPage"
* contact.name = "CPage Support"
* contact.telecom.system = #email
* contact.telecom.value = "support@cpage.org"

* description = "Recherche un payeur santé par son type: Régime Obligatoire (RO) pour CPAM/MSA/RSI, ou Régime Complémentaire (RC) pour mutuelles et assurances privées."

* code = #payeur-type
* base = #Organization
* type = #string
* expression = "Organization.extension('http://cpage.org/fhir/StructureDefinition/payeur-sante-extension').extension('typePayeur').value.ofType(string)"
* xpath = "f:Organization/f:extension[@url='http://cpage.org/fhir/StructureDefinition/payeur-sante-extension']/f:extension[@url='typePayeur']/f:valueString"
* xpathUsage = #normal
* multipleOr = true
* multipleAnd = false

// Exemples d'usage:
// GET [base]/Organization?payeur-type=RO (Régime Obligatoire)
// GET [base]/Organization?payeur-type=RC (Régime Complémentaire)
