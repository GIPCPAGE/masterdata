// =============================================
// SearchParameter: Tiers Role
// Permet de rechercher un tiers par son rôle (supplier, debtor, payer)
// =============================================

Instance: TiersRoleSearchParameter
InstanceOf: SearchParameter
Usage: #definition
Title: "Search Tiers by Role"
Description: "Permet de rechercher un tiers par son rôle: fournisseur (supplier), débiteur (debtor), ou payeur santé (payer). Supporte les recherches multi-rôles."

* url = "http://cpage.org/fhir/SearchParameter/tiers-role"
* version = "1.0.0"
* name = "TiersRoleSearchParameter"
* status = #active
* experimental = false
* date = "2026-03-17"
* publisher = "CPage"
* contact.name = "CPage Support"
* contact.telecom.system = #email
* contact.telecom.value = "support@cpage.org"

* description = "Recherche un tiers par son rôle. Permet de filtrer les organisations selon qu'elles sont fournisseurs, débiteurs, ou payeurs santé. Un même tiers peut avoir plusieurs rôles simultanément."

* code = #tiers-role
* base = #Organization
* type = #token
* expression = "Organization.extension('http://cpage.org/fhir/StructureDefinition/tiers-role-extension').value.ofType(code)"
* xpath = "f:Organization/f:extension[@url='http://cpage.org/fhir/StructureDefinition/tiers-role-extension']/f:valueCode"
* xpathUsage = #normal
* multipleOr = true
* multipleAnd = true

// Exemples d'usage:
// GET [base]/Organization?tiers-role=supplier
// GET [base]/Organization?tiers-role=debtor
// GET [base]/Organization?tiers-role=supplier,debtor (multi-rôles OU)
// GET [base]/Organization?tiers-role=supplier&tiers-role=debtor (multi-rôles ET)
