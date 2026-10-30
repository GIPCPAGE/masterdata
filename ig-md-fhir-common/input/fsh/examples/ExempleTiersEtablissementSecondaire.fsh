// =============================================
// Exemple: Établissement secondaire d'un tiers
// =============================================
Instance: ExempleTiersEtablissementSecondaire
InstanceOf: TiersEtablissementSecondaireProfile
Usage: #example
Title: "Établissement secondaire d'un tiers"
Description: "Exemple d'un établissement secondaire rattaché à l'établissement principal ExempleTiersComplet : SIRET propre (même SIREN que le tiers), adresse, contact et compte bancaire propre au site. Le drapeau communSociete est interdit sur un établissement secondaire."

* identifier[etablissementId].value = "11"
* identifier[siret].value = "85211234500026"
* active = true
* name = "Multiservices Santé et Logistique - Site de Lyon"

* partOf = Reference(ExempleTiersComplet)
* partOf.display = "Multiservices Santé et Logistique (établissement principal)"

* address.line[0] = "28 Quai Claude Bernard"
* address.city = "Lyon"
* address.postalCode = "69007"
* address.country = "FR"
* telecom[0].system = #phone
* telecom[0].value = "+33478123456"
* telecom[0].use = #work

// Seconde adresse du site, avec son destinataire, réservée au circuit débiteur
* contact[0].name.text = "Service facturation"
* contact[0].address.line[0] = "5 Rue de la Part-Dieu"
* contact[0].address.city = "Lyon"
* contact[0].address.postalCode = "69003"
* contact[0].address.country = "FR"
* contact[0].address.extension[roleRestriction].valueCoding = https://www.cpage.fr/ig/masterdata/common/CodeSystem/tiers-role-cs#debtor

// Compte bancaire propre au site
* extension[bankAccount][0].extension[titulaire].valueString = "Multiservices Santé et Logistique - Site de Lyon"
* extension[bankAccount][0].extension[iban].valueString = "FR7630004000031234567890143"
* extension[bankAccount][0].extension[actif].valueBoolean = true
