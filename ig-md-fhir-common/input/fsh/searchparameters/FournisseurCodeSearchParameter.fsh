// =============================================
// SearchParameter: Fournisseur Code
// Permet de rechercher un fournisseur par son code unique
// =============================================

Instance: fournisseur-code
InstanceOf: SearchParameter
Usage: #definition
Title: "Search Fournisseur by Code"
Description: "Permet de rechercher un fournisseur par son code fournisseur unique (numéro interne de gestion)."

* url = "https://www.cpage.fr/ig/masterdata/common/SearchParameter/fournisseur-code"
* version = "1.0.0"
* name = "FournisseurCodeSearchParameter"
* status = #active
* experimental = false
* date = "2026-03-17"
* publisher = "CPage"
* contact.name = "CPage Support"
* contact.telecom.system = #email
* contact.telecom.value = "support@cpage.org"

* description = "Recherche un fournisseur par son code fournisseur unique attribué dans le système de gestion. Correspond au 'Numéro fournisseur' du interface fournisseurs."

* code = #fournisseur-code
* base = #Organization
* type = #string
* expression = "Organization.extension('https://www.cpage.fr/ig/masterdata/common/StructureDefinition/fournisseur-code-extension').value.ofType(string)"
* xpath = "f:Organization/f:extension[@url='https://www.cpage.fr/ig/masterdata/common/StructureDefinition/fournisseur-code-extension']/f:valueString"
* xpathUsage = #normal
* multipleOr = true
* multipleAnd = false

// Exemples d'usage:
// GET [base]/Organization?fournisseur-code=FRSUP00456
// GET [base]/Organization?fournisseur-code:exact=FRNSLPD001
// GET [base]/Organization?fournisseur-code:contains=LPD
