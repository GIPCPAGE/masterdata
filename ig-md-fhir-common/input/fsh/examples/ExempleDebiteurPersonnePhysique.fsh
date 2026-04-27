// =============================================
// Instance: Débiteur Personne Physique avec NIR
// =============================================

Instance: ExempleDebiteurPersonnePhysique
InstanceOf: DebiteurProfile
Usage: #example
Title: "Exemple Débiteur - Personne Physique avec NIR"
Description: "Exemple d'une personne physique en tant que débiteur, avec NIR (Sécurité Sociale), civilité Monsieur et prénom. Illustre la Catégorie TG 01 (Personne physique), Nature juridique 01 (Particulier), et type débiteur Normal. Démontre l'utilisation obligatoire de TiersPersonDetails (civilité + prénom) pour les personnes physiques."

* identifier[etierId].value = "ETIER345678"
* identifier[etierId].use = #official

* identifier[nir].value = "123456789012345"
* identifier[nir].use = #official

* name = "Dupont Jean"

* extension[tgCategory].valueCodeableConcept = https://www.cpage.fr/ig/masterdata/common/CodeSystem/tiers-category-cs#01 "Personne physique"
* extension[legalNature].valueCodeableConcept = https://www.cpage.fr/ig/masterdata/common/CodeSystem/tiers-legal-nature-cs#01 "Particulier"

* extension[tiersRole].valueCoding = https://www.cpage.fr/ig/masterdata/common/CodeSystem/tiers-role-cs#debtor "Débiteur"

// Type débiteur Normal
* extension[debtorAttributs].extension[debtorType].valueCode = #N

// Détails personne physique : civilité + prénom (OBLIGATOIRE pour Catégorie TG = 01)
* extension[personDetails].extension[civility].valueCode = #M
* extension[personDetails].extension[firstName].valueString = "Jean"

// RIB obligatoire pour débiteur
* extension[bankAccount][0].extension[bankCode].valueString = "30002"
* extension[bankAccount][0].extension[branchCode].valueString = "00550"
* extension[bankAccount][0].extension[accountNumber].valueString = "12345678901"
* extension[bankAccount][0].extension[ribKey].valueString = "23"
* extension[bankAccount][0].extension[iban].valueString = "FR7630002005501234567890123"
* extension[bankAccount][0].extension[bic].valueString = "CRLYFRPPXXX"

* address.line[0] = "15 Rue de la République"
* address.city = "Lyon"
* address.postalCode = "69002"
* address.country = "FR"
* address.extension[localization].valueCode = #FRANCE

* telecom[0].system = #phone
* telecom[0].value = "+33 4 78 00 00 00"
* telecom[0].use = #work

* telecom[1].system = #email
* telecom[1].value = "jean.dupont@example.fr"
* telecom[1].use = #work
