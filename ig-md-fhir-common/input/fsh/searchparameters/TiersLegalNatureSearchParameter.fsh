// =============================================
// SearchParameter: Tiers Legal Nature
// Permet de rechercher un tiers par sa nature juridique (codes 00-11)
// =============================================

Instance: tiers-legal-nature-search-parameter
InstanceOf: SearchParameter
Usage: #definition
Title: "Search Tiers by Legal Nature"
Description: "Permet de rechercher un tiers par sa nature juridique selon la nomenclature: particulier, société, association, établissement public, collectivité territoriale..."

* url = "https://www.cpage.fr/ig/masterdata/common/SearchParameter/tiers-legal-nature-search-parameter"
* version = "1.0.0"
* name = "TiersLegalNatureSearchParameter"
* status = #active
* experimental = false
* date = "2026-03-17"
* publisher = "CPage"
* contact.name = "CPage Support"
* contact.telecom.system = #email
* contact.telecom.value = "support@cpage.org"

* description = "Recherche un tiers par sa nature juridique. Correspond aux codes 00-11 (particulier, société, association, établissement public, collectivité, administration, régime spécial...)."

* code = #tiers-legal-nature
* base = #Organization
* type = #token
* expression = "Organization.extension('https://www.cpage.fr/ig/masterdata/common/StructureDefinition/tiers-legal-nature').value.ofType(CodeableConcept)"
* xpath = "f:Organization/f:extension[@url='https://www.cpage.fr/ig/masterdata/common/StructureDefinition/tiers-legal-nature']/f:valueCodeableConcept"
* xpathUsage = #normal
* multipleOr = true
* multipleAnd = false

// Exemples d'usage:
// GET [base]/Organization?tiers-legal-nature=00 (Particulier)
// GET [base]/Organization?tiers-legal-nature=03 (Société)
// GET [base]/Organization?tiers-legal-nature=04 (Association)
// GET [base]/Organization?tiers-legal-nature=06 (Établissement public)
