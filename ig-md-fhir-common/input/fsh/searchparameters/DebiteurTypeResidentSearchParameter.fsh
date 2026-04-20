// =============================================
// SearchParameter: Débiteur Type Résident
// Permet de rechercher un débiteur par son type de résidence fiscale
// =============================================

Instance: debiteur-type-resident
InstanceOf: SearchParameter
Usage: #definition
Title: "Search Débiteur by Type Résident"
Description: "Permet de rechercher un débiteur par son type de résidence fiscale: Résident (R) ou Non-résident (NR)."

* url = "https://www.cpage.fr/ig/masterdata/common/SearchParameter/debiteur-type-resident"
* version = "1.0.0"
* name = "DebiteurTypeResidentSearchParameter"
* status = #active
* experimental = false
* date = "2026-03-17"
* publisher = "CPage"
* contact.name = "CPage Support"
* contact.telecom.system = #email
* contact.telecom.value = "support@cpage.org"

* description = "Recherche un débiteur par son type de résidence fiscale (résident français ou non-résident). Important pour la gestion des retenues à la source et obligations fiscales."

* code = #debiteur-type-resident
* base = #Organization
* type = #token
* expression = "Organization.extension('https://www.cpage.fr/ig/masterdata/common/StructureDefinition/debiteur-parametres-extension').extension('typeResident').value.ofType(code)"
* xpath = "f:Organization/f:extension[@url='https://www.cpage.fr/ig/masterdata/common/StructureDefinition/debiteur-parametres-extension']/f:extension[@url='typeResident']/f:valueCode"
* xpathUsage = #normal
* multipleOr = true
* multipleAnd = false

// Exemples d'usage:
// GET [base]/Organization?debiteur-type-resident=R (Résident)
// GET [base]/Organization?debiteur-type-resident=NR (Non-résident)
