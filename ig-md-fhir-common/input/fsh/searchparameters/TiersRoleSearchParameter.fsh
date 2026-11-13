// =============================================
// SearchParameter: Tiers Role
// Permet de rechercher un tiers par son rôle (supplier, debtor, mixed)
// =============================================

Instance: tiers-role-search-parameter
InstanceOf: SearchParameter
Usage: #definition
Title: "Search Tiers by Role"
Description: "Permet de rechercher un tiers par son rôle: fournisseur (supplier), débiteur (debtor) ou mixte (mixed)."

* url = "https://www.cpage.fr/ig/masterdata/common/SearchParameter/tiers-role-search-parameter"
* version = "1.0.0"
* name = "TiersRoleSearchParameter"
* status = #active
* experimental = false
* date = "2026-03-17"
* publisher = "CPage"
* contact.name = "CPage Support"
* contact.telecom.system = #email
* contact.telecom.value = "support@cpage.org"

* description = "Recherche un tiers par son rôle. Permet de filtrer les organisations selon qu'elles sont fournisseurs, débiteurs ou mixtes. Un tiers porte un seul rôle ; la valeur mixed désigne un tiers à la fois fournisseur et débiteur."

* code = #tiers-role
* base = #Organization
* type = #token
* expression = "Organization.extension('https://www.cpage.fr/ig/masterdata/common/StructureDefinition/tiers-role-extension').value.ofType(Coding)"
* xpath = "f:Organization/f:extension[@url='https://www.cpage.fr/ig/masterdata/common/StructureDefinition/tiers-role-extension']/f:valueCoding"
* xpathUsage = #normal
* multipleOr = true
* multipleAnd = true

// Exemples d'usage:
// GET [base]/Organization?tiers-role=supplier
// GET [base]/Organization?tiers-role=debtor
// GET [base]/Organization?tiers-role=supplier,debtor (fournisseurs OU débiteurs)
