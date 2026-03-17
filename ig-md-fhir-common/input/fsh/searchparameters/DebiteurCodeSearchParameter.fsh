// =============================================
// SearchParameter: Débiteur Code
// Permet de rechercher un débiteur par son code unique
// =============================================

Instance: DebiteurCodeSearchParameter
InstanceOf: SearchParameter
Usage: #definition
Title: "Search Débiteur by Code"
Description: "Permet de rechercher un débiteur par son code débiteur unique (numéro interne de gestion)."

* url = "http://cpage.org/fhir/SearchParameter/debiteur-code"
* version = "1.0.0"
* name = "DebiteurCodeSearchParameter"
* status = #active
* experimental = false
* date = "2026-03-17"
* publisher = "CPage"
* contact.name = "CPage Support"
* contact.telecom.system = #email
* contact.telecom.value = "support@cpage.org"

* description = "Recherche un débiteur par son code débiteur unique attribué dans le système de gestion. Correspond au 'Code débiteur' du message KERD GEF."

* code = #debiteur-code
* base = #Organization
* type = #string
* expression = "Organization.extension('http://cpage.org/fhir/StructureDefinition/debiteur-code-extension').value.ofType(string)"
* xpath = "f:Organization/f:extension[@url='http://cpage.org/fhir/StructureDefinition/debiteur-code-extension']/f:valueString"
* xpathUsage = #normal
* multipleOr = true
* multipleAnd = false

// Exemples d'usage:
// GET [base]/Organization?debiteur-code=DEB000789
// GET [base]/Organization?debiteur-code:exact=DEBNECKER01
// GET [base]/Organization?debiteur-code:contains=NECKER
