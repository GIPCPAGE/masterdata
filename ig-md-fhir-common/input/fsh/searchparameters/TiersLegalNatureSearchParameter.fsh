// =============================================
// SearchParameter: Tiers Legal Nature
// Permet de rechercher un tiers par sa nature juridique (GEF codes 00-11)
// =============================================

Instance: TiersLegalNatureSearchParameter
InstanceOf: SearchParameter
Usage: #definition
Title: "Search Tiers by Legal Nature"
Description: "Permet de rechercher un tiers par sa nature juridique selon la nomenclature GEF: particulier, société, association, établissement public, collectivité territoriale..."

* url = "http://cpage.org/fhir/SearchParameter/tiers-legal-nature"
* version = "1.0.0"
* name = "TiersLegalNatureSearchParameter"
* status = #active
* experimental = false
* date = "2026-03-17"
* publisher = "CPage"
* contact.name = "CPage Support"
* contact.telecom.system = #email
* contact.telecom.value = "support@cpage.org"

* description = "Recherche un tiers par sa nature juridique. Correspond aux codes GEF 00-11 (particulier, société, association, établissement public, collectivité, administration, régime spécial...)."

* code = #tiers-legal-nature
* base = #Organization
* type = #token
* expression = "Organization.extension('http://cpage.org/fhir/StructureDefinition/gef-legal-nature').value.ofType(CodeableConcept)"
* xpath = "f:Organization/f:extension[@url='http://cpage.org/fhir/StructureDefinition/gef-legal-nature']/f:valueCodeableConcept"
* xpathUsage = #normal
* multipleOr = true
* multipleAnd = false

// Exemples d'usage:
// GET [base]/Organization?tiers-legal-nature=00 (Particulier)
// GET [base]/Organization?tiers-legal-nature=03 (Société)
// GET [base]/Organization?tiers-legal-nature=04 (Association)
// GET [base]/Organization?tiers-legal-nature=06 (Établissement public)
