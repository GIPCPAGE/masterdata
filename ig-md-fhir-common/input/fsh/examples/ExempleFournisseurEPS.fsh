// =============================================
// Instance: Fournisseur EPS avec SIRET et RIB
// =============================================

Instance: ExempleFournisseurEPS
InstanceOf: FournisseurProfile
Usage: #example
Title: "Exemple Fournisseur - EPS avec SIRET"
Description: "Exemple d'un établissement public de santé (CHU) en tant que fournisseur, avec identifiant SIRET et coordonnées bancaires RIB complètes. Illustre la Catégorie TG 27 (EPS) et Nature juridique 09 (Collectivité territoriale - EPL - EPS)."

* identifier[etierId].value = "ETIER123456"
* identifier[etierId].use = #official

* identifier[siret].value = "12345678901234"
* identifier[siret].use = #official

* name = "CHU de Paris"
* alias = "Centre Hospitalier Universitaire de Paris"

* extension[tgCategory].valueCodeableConcept = https://www.cpage.fr/ig/masterdata/common/CodeSystem/tiers-category-cs#27 "Établissement public de santé"
* extension[legalNature].valueCodeableConcept = https://www.cpage.fr/ig/masterdata/common/CodeSystem/tiers-legal-nature-cs#09 "Collectivité territoriale - EPL - EPS"

* extension[tiersRole].valueCoding = https://www.cpage.fr/ig/masterdata/common/CodeSystem/tiers-role-cs#supplier "Fournisseur"

* extension[bankAccount][0].extension[bankCode].valueString = "12345"
* extension[bankAccount][0].extension[branchCode].valueString = "67890"
* extension[bankAccount][0].extension[accountNumber].valueString = "12345678901"
* extension[bankAccount][0].extension[ribKey].valueString = "12"
* extension[bankAccount][0].extension[iban].valueString = "FR7612345678901234567890112"
* extension[bankAccount][0].extension[bic].valueString = "SOGEFRPPXXX"

* address.line[0] = "1 Avenue de l'Hôpital"
* address.city = "Paris"
* address.postalCode = "75012"
* address.country = "FR"

* telecom[0].system = #phone
* telecom[0].value = "+33 1 40 00 00 00"
* telecom[0].use = #work

* telecom[1].system = #email
* telecom[1].value = "contact@chu-paris.fr"
* telecom[1].use = #work

* telecom[2].system = #url
* telecom[2].value = "https://www.chu-paris.fr"
