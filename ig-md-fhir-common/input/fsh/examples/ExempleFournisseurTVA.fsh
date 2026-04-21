// =============================================
// Instance: Fournisseur Société Étrangère TVA
// =============================================

Instance: ExempleFournisseurTVA
InstanceOf: FournisseurProfile
Usage: #example
Title: "Exemple Fournisseur - Société Étrangère TVA UE"
Description: "Exemple d'une société étrangère européenne en tant que fournisseur, avec numéro de TVA intracommunautaire. Illustre la Catégorie TG 50 (Personne morale de droit privé) et Nature juridique 03 (Société)."

* identifier[etierId].value = "ETIER789012"
* identifier[etierId].use = #official

* identifier[tva].value = "DE123456789"
* identifier[tva].use = #official

* name = "MedTech Solutions GmbH"
* alias = "MedTech Solutions"

* extension[tgCategory].valueCodeableConcept = https://www.cpage.fr/ig/masterdata/common/CodeSystem/tiers-category-cs#50 "Personne morale de droit privé"
* extension[legalNature].valueCodeableConcept = https://www.cpage.fr/ig/masterdata/common/CodeSystem/tiers-legal-nature-cs#03 "Société"

* extension[tiersRole].valueCoding = https://www.cpage.fr/ig/masterdata/common/CodeSystem/tiers-role-cs#supplier "Fournisseur"

* extension[bankAccount][0].extension[iban].valueString = "DE89370400440532013000"
* extension[bankAccount][0].extension[bic].valueString = "COBADEFFXXX"

* address.line[0] = "Hauptstraße 123"
* address.city = "Berlin"
* address.postalCode = "10115"
* address.country = "DE"

* telecom[0].system = #phone
* telecom[0].value = "+49 30 12345678"
* telecom[0].use = #work

* telecom[1].system = #email
* telecom[1].value = "export@medtech-solutions.de"
* telecom[1].use = #work

* telecom[2].system = #url
* telecom[2].value = "https://www.medtech-solutions.de"
