// =============================================
// SearchParameter: Succursale Usage
// Permet de rechercher une succursale par son usage
// =============================================

Instance: SuccursaleUsageSearchParameter
InstanceOf: SearchParameter
Usage: #definition
Title: "Search Succursale by Usage"
Description: "Permet de rechercher une succursale par son usage: point de livraison, siège de facturation, ou siège social secondaire."

* url = "http://cpage.org/fhir/SearchParameter/succursale-usage"
* version = "1.0.0"
* name = "SuccursaleUsageSearchParameter"
* status = #active
* experimental = false
* date = "2026-03-17"
* publisher = "CPage"
* contact.name = "CPage Support"
* contact.telecom.system = #email
* contact.telecom.value = "support@cpage.org"

* description = "Recherche une succursale par son usage. Permet de distinguer les points de livraison, les adresses de facturation, et les sièges sociaux secondaires."

* code = #succursale-usage
* base = #Organization
* type = #token
* expression = "Organization.extension('http://cpage.org/fhir/StructureDefinition/succursale-usage-extension').value.ofType(code)"
* xpath = "f:Organization/f:extension[@url='http://cpage.org/fhir/StructureDefinition/succursale-usage-extension']/f:valueCode"
* xpathUsage = #normal
* multipleOr = true
* multipleAnd = true

// Exemples d'usage:
// GET [base]/Organization?succursale-usage=POINT_LIVRAISON
// GET [base]/Organization?succursale-usage=FACTURATION
// GET [base]/Organization?succursale-usage=SIEGE_SOCIAL
// GET [base]/Organization?succursale-usage=POINT_LIVRAISON,FACTURATION (OU)
