// =============================================
// Exemple: Tiers personne physique (débiteur)
// =============================================
Instance: ExempleTiersPersonnePhysique
InstanceOf: TiersProfile
Usage: #example
Title: "Tiers personne physique (débiteur)"
Description: "Exemple d'une personne physique de rôle débiteur, avec NIR, civilité, prénom et date de naissance. Catégorie TG 01 (personne physique), nature juridique 01 (particulier)."

* identifier[etierId].value = "TIERS345678"
* identifier[nir].value = "123456789012345"
* active = true

* name = "Dupont"
* extension[tiersRole].valueCoding = https://www.cpage.fr/ig/masterdata/common/CodeSystem/tiers-role-cs#debtor
* extension[tgCategory].valueCodeableConcept = https://www.cpage.fr/ig/masterdata/common/CodeSystem/tiers-category-cs#01 "Personne physique"
* extension[legalNature].valueCodeableConcept = https://www.cpage.fr/ig/masterdata/common/CodeSystem/tiers-legal-nature-cs#01 "Particulier"

// Personne physique : civilité, prénom, nom, date de naissance
* contact[personnePhysique].name.prefix = "M"
* contact[personnePhysique].name.given = "Jean"
* contact[personnePhysique].name.family = "Dupont"
* contact[personnePhysique].extension[birthDate].valueDate = "1975-04-12"

* address.line[0] = "15 Rue de la République"
* address.city = "Lyon"
* address.postalCode = "69002"
* address.country = "FR"
* telecom[0].system = #phone
* telecom[0].value = "+33478000000"
* telecom[0].use = #work
* telecom[1].system = #email
* telecom[1].value = "jean.dupont@example.fr"
* telecom[1].use = #work

* extension[bankAccount][0].extension[titulaire].valueString = "Jean Dupont"
* extension[bankAccount][0].extension[iban].valueString = "FR7630002005501234567890123"
* extension[bankAccount][0].extension[bic].valueString = "CRLYFRPPXXX"
* extension[bankAccount][0].extension[actif].valueBoolean = true
