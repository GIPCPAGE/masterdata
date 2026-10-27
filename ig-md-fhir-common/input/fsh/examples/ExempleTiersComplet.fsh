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
* extension[valide].valueBoolean = true

* name = "Multiservices Santé et Logistique"
* extension[complementNom].valueString = "Division hospitalière"
* alias = "MSL France"

// Rôle unique : fournisseur
* extension[tiersRole].valueCoding = https://www.cpage.fr/ig/masterdata/common/CodeSystem/tiers-role-cs#supplier

// Spécificités
* extension[specificite][0].valueCoding = https://www.cpage.fr/ig/masterdata/common/CodeSystem/tiers-specificity-cs#LABORATOIRE

// Adresse d'ordre 1 de l'établissement principal et ses contacts
* address.line[0] = "12 Avenue de la République"
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

// Code interne
* extension[codeInterne].valueString = "FRSUP00456"
