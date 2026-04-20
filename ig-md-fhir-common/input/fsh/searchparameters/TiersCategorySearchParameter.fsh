// =============================================
// SearchParameter: Tiers Category (TG)
// Permet de rechercher un tiers par sa catégorie TG (codes 00-74)
// =============================================

Instance: tiers-category-search-parameter
InstanceOf: SearchParameter
Usage: #definition
Title: "Search Tiers by TG Category"
Description: "Permet de rechercher un tiers par sa catégorie TG selon la nomenclature: État, collectivités territoriales, établissements publics, organismes sociaux, personnes morales de droit privé, personnes physiques..."

* url = "https://www.cpage.fr/ig/masterdata/common/SearchParameter/tiers-category-search-parameter"
* version = "1.0.0"
* name = "TiersCategorySearchParameter"
* status = #active
* experimental = false
* date = "2026-03-17"
* publisher = "CPage"
* contact.name = "CPage Support"
* contact.telecom.system = #email
* contact.telecom.value = "support@cpage.org"

* description = "Recherche un tiers par sa catégorie TG. Correspond aux codes 00-74 (État, collectivités, établissements publics de santé, organismes sociaux, entreprises, personnes physiques)."

* code = #tiers-category
* base = #Organization
* type = #token
* expression = "Organization.extension('https://www.cpage.fr/ig/masterdata/common/StructureDefinition/tiers-category').value.ofType(CodeableConcept)"
* xpath = "f:Organization/f:extension[@url='https://www.cpage.fr/ig/masterdata/common/StructureDefinition/tiers-category']/f:valueCodeableConcept"
* xpathUsage = #normal
* multipleOr = true
* multipleAnd = false

// Exemples d'usage:
// GET [base]/Organization?tiers-category=01 (État)
// GET [base]/Organization?tiers-category=02 (Collectivité territoriale)
// GET [base]/Organization?tiers-category=16 (Établissement public de santé)
// GET [base]/Organization?tiers-category=60 (Assurance maladie)
