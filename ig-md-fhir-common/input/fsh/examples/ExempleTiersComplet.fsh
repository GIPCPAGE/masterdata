// =============================================
// Exemple: Tiers complet (modèle Tiers du Master Data)
// =============================================

Instance: ExempleTiersComplet
InstanceOf: TiersProfile
Usage: #example
Title: "Tiers complet (fournisseur, établissement principal)"
Description: "Exemple d'un tiers fournisseur illustrant le modèle Tiers : établissement principal (SIRET, adresse d'ordre 1, contacts), seconde adresse portée par contact, complément de nom, alias, spécificité, identifiants légaux, catégorie TG et nature juridique."

* identifier[etierId].value = "TIERS000123456"
* identifier[siren].value = "852112345"
* identifier[siret].value = "85211234500018"
* identifier[tva].value = "FR12852112345"

* active = true

* name = "Multiservices Santé et Logistique"
* extension[shortName].valueString = "Division hospitalière"
* alias = "MSL France"

// Rôle unique : fournisseur
* extension[tiersRole].valueCoding = https://www.cpage.fr/ig/masterdata/common/CodeSystem/tiers-role-cs#supplier

// Spécificités
* extension[specificite][0].valueCoding = https://www.cpage.fr/ig/masterdata/common/CodeSystem/tiers-specificity-cs#LABORATOIRE

// Adresse d'ordre 1 de l'établissement principal et ses contacts
* address.line[0] = "12 Avenue de la République"
* address.line[0].extension[numeroVoie].valueString = "12"
* address.line[0].extension[typeVoie].valueString = "Avenue"
* address.line[0].extension[nomVoie].valueString = "de la République"
* address.city = "Paris"
* address.postalCode = "75011"
* address.country = "FR"

* telecom[0].system = #phone
* telecom[0].value = "+33140123456"
* telecom[0].use = #work

* telecom[1].system = #email
* telecom[1].value = "contact@msl-france.fr"
* telecom[1].use = #work

// Seconde adresse de l'établissement principal (ordre 2), avec son destinataire et ses contacts
* contact[0].name.text = "Service comptabilité fournisseurs"
* contact[0].address.line[0] = "4 Rue des Entrepôts"
* contact[0].address.city = "Saint-Denis"
* contact[0].address.postalCode = "93200"
* contact[0].address.country = "FR"
* contact[0].telecom[0].system = #phone
* contact[0].telecom[0].value = "+33149876543"

// Nature juridique
* extension[legalNature].valueCodeableConcept = https://www.cpage.fr/ig/masterdata/common/CodeSystem/tiers-legal-nature-cs#03 "Société"

// Catégorie TG
* extension[tgCategory].valueCodeableConcept = https://www.cpage.fr/ig/masterdata/common/CodeSystem/tiers-category-cs#50 "Personne morale de droit privé"


// Restriction de rôle sur la seconde adresse : réservée au circuit fournisseur
* contact[0].address.extension[roleRestriction].valueCoding = https://www.cpage.fr/ig/masterdata/common/CodeSystem/tiers-role-cs#supplier

// Compte bancaire commun à toute la société (porté par l'établissement principal)
* extension[bankAccount][0].extension[titulaire].valueString = "Multiservices Santé et Logistique"
* extension[bankAccount][0].extension[iban].valueString = "FR7630002005500000157845Z02"
* extension[bankAccount][0].extension[bic].valueString = "CRLYFRPPXXX"
* extension[bankAccount][0].extension[actif].valueBoolean = true
* extension[bankAccount][0].extension[communSociete].valueBoolean = true

// Compte bancaire réservé au circuit fournisseur
* extension[bankAccount][1].extension[titulaire].valueString = "Multiservices Santé et Logistique"
* extension[bankAccount][1].extension[iban].valueString = "FR7630004000031234567890143"
* extension[bankAccount][1].extension[actif].valueBoolean = true
* extension[bankAccount][1].extension[role].valueCoding = https://www.cpage.fr/ig/masterdata/common/CodeSystem/tiers-role-cs#supplier
* extension[bankAccount][1].extension[communSociete].valueBoolean = false
