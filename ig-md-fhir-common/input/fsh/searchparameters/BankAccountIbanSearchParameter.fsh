// =============================================
// SearchParameter: Bank Account IBAN
// Permet de rechercher un tiers par son IBAN
// =============================================

Instance: bank-account-iban
InstanceOf: SearchParameter
Usage: #definition
Title: "Search Tiers by IBAN"
Description: "Permet de rechercher un tiers par son IBAN (International Bank Account Number). Utile pour identifier le bénéficiaire d'un virement ou l'émetteur d'un paiement."

* url = "https://www.cpage.fr/ig/masterdata/common/SearchParameter/bank-account-iban"
* version = "1.0.0"
* name = "BankAccountIbanSearchParameter"
* status = #active
* experimental = false
* date = "2026-03-17"
* publisher = "CPage"
* contact.name = "CPage Support"
* contact.telecom.system = #email
* contact.telecom.value = "support@cpage.org"

* description = "Recherche un tiers par son IBAN. Permet d'identifier rapidement le propriétaire d'un compte bancaire pour rapprochements comptables ou contrôles de paiements."

* code = #bank-account-iban
* base = #Organization
* type = #string
* expression = "Organization.extension('https://www.cpage.fr/ig/masterdata/common/StructureDefinition/tiers-bank-account').extension('iban').value.ofType(string)"
* xpath = "f:Organization/f:extension[@url='https://www.cpage.fr/ig/masterdata/common/StructureDefinition/tiers-bank-account']/f:extension[@url='iban']/f:valueString"
* xpathUsage = #normal
* multipleOr = true
* multipleAnd = false

// Exemples d'usage:
// GET [base]/Organization?bank-account-iban=FR7630004000020000012345678
// GET [base]/Organization?bank-account-iban:exact=DE89370400440532013000
// GET [base]/Organization?bank-account-iban:contains=30004
