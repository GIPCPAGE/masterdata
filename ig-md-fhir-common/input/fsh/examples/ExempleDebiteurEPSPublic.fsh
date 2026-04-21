// =============================================
// Instance: Débiteur EPS Comptabilité Publique
// =============================================

Instance: ExempleDebiteurEPSPublic
InstanceOf: DebiteurProfile
Usage: #example
Title: "Exemple Débiteur - EPS Comptabilité Publique"
Description: "Exemple d'un établissement public de santé en tant que débiteur, avec FINESS, compte de contrepartie comptabilité publique et code régie. Illustre la Catégorie TG 27 (EPS), Nature juridique 09 (Collectivité territoriale - EPL - EPS), type débiteur Normal, et les extensions spécifiques au secteur public (TiersPublicAccountingCounterpart, TiersRegieCode). Démontre aussi l'identifiant CHORUS."

* identifier[etierId].value = "ETIER901234"
* identifier[etierId].use = #official

* identifier[finess].value = "750712184"
* identifier[finess].extension[chorusType].valueCodeableConcept = https://www.cpage.fr/ig/masterdata/common/CodeSystem/chorus-identifier-type-cs#03 "FINESS"
* identifier[finess].use = #official

* name = "Centre Hospitalier de Marseille"
* alias = "CH Marseille"

* extension[tgCategory].valueCodeableConcept = https://www.cpage.fr/ig/masterdata/common/CodeSystem/tiers-category-cs#27 "Établissement public de santé"
* extension[legalNature].valueCodeableConcept = https://www.cpage.fr/ig/masterdata/common/CodeSystem/tiers-legal-nature-cs#09 "Collectivité territoriale - EPL - EPS"

* extension[tiersRole].valueCoding = https://www.cpage.fr/ig/masterdata/common/CodeSystem/tiers-role-cs#debtor "Débiteur"

// Type débiteur Normal
* extension[debtorType].valueCode = #N

// Compte contrepartie comptabilité publique (KERD positions 3-4)
* extension[counterpart].extension[letterCode].valueString = "A"
* extension[counterpart].extension[accountNumber].valueString = "4110000000"

// Code régie (KERD position 7)
* extension[regieCode].valueString = "REG001"

// RIB obligatoire pour débiteur
* extension[bankAccount][0].extension[bankCode].valueString = "10071"
* extension[bankAccount][0].extension[branchCode].valueString = "75000"
* extension[bankAccount][0].extension[accountNumber].valueString = "00001234567"
* extension[bankAccount][0].extension[ribKey].valueString = "89"
* extension[bankAccount][0].extension[iban].valueString = "FR7610071750000000123456789"
* extension[bankAccount][0].extension[bic].valueString = "BDFEFRPPCCT"

* address.line[0] = "147 Boulevard Baille"
* address.city = "Marseille"
* address.postalCode = "13005"
* address.country = "FR"
* address.extension[localization].valueCode = #FRANCE

* telecom[0].system = #phone
* telecom[0].value = "+33 4 91 00 00 00"
* telecom[0].use = #work

* telecom[1].system = #email
* telecom[1].value = "finances@ch-marseille.fr"
* telecom[1].use = #work

* telecom[2].system = #url
* telecom[2].value = "https://www.ch-marseille.fr"
