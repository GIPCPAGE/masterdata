// =============================================
// SearchParameter: Payeur Santé - Grand Régime
// Permet de rechercher un payeur santé par son grand régime
// =============================================

Instance: PayeurGrandRegimeSearchParameter
InstanceOf: SearchParameter
Usage: #definition
Title: "Search Payeur Santé by Grand Régime"
Description: "Permet de rechercher un payeur santé par son grand régime: Sécurité Sociale (SS), MSA, RSI, CNAV, Mutuelle."

* url = "http://cpage.org/fhir/SearchParameter/payeur-grand-regime"
* version = "1.0.0"
* name = "PayeurGrandRegimeSearchParameter"
* status = #active
* experimental = false
* date = "2026-03-17"
* publisher = "CPage"
* contact.name = "CPage Support"
* contact.telecom.system = #email
* contact.telecom.value = "support@cpage.org"

* description = "Recherche un payeur santé par son grand régime de protection sociale. Permet de filtrer les CPAM, caisses MSA, RSI, CNAV, ou mutuelles complémentaires."

* code = #payeur-grand-regime
* base = #Organization
* type = #token
* expression = "Organization.extension('http://cpage.org/fhir/StructureDefinition/payeur-sante-extension').extension('grandRegime').value.ofType(code)"
* xpath = "f:Organization/f:extension[@url='http://cpage.org/fhir/StructureDefinition/payeur-sante-extension']/f:extension[@url='grandRegime']/f:valueCode"
* xpathUsage = #normal
* multipleOr = true
* multipleAnd = false

// Exemples d'usage:
// GET [base]/Organization?payeur-grand-regime=SS (Sécurité Sociale)
// GET [base]/Organization?payeur-grand-regime=MSA (Mutualité Sociale Agricole)
// GET [base]/Organization?payeur-grand-regime=MUTUELLE (Mutuelles complémentaires)
// GET [base]/Organization?payeur-grand-regime=SS,MSA (SS OU MSA)
