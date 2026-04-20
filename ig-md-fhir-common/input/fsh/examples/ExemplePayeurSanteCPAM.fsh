// =============================================
// Exemple: Payeur Santé CPAM (Régime Obligatoire)
// =============================================

Instance: ExemplePayeurSanteCPAM
InstanceOf: PayeurSanteProfile
Usage: #example
Title: "CPAM - Caisse Primaire d'Assurance Maladie de Paris"
Description: "Exemple de payeur santé du régime obligatoire (CPAM). Illustre les paramètres spécifiques: grand régime SS, type payeur RO, code centre, numéro caisse, organisme, délai PEC."

* identifier[etierId].value = "CPAM75001"

* active = true
* type = https://mos.esante.gouv.fr/NOS/TRE_R66-CategorieEtablissement/FHIR/TRE-R66-CategorieEtablissement#60 "Assurance maladie (caté. générique)"

* name = "CPAM de Paris"
* alias = "Caisse Primaire d'Assurance Maladie de Paris"

* telecom[0].system = #phone
* telecom[0].value = "3646"
* telecom[0].use = #work

* telecom[1].system = #url
* telecom[1].value = "https://www.ameli.fr"

* address.line[0] = "21 Rue Georges Auric"
* address.city = "Paris"
* address.postalCode = "75019"
* address.country = "FR"

// Rôle: Payeur uniquement
* extension[tiersRole][0].valueCoding = https://www.cpage.fr/ig/masterdata/common/CodeSystem/tiers-role-cs#payer

// Nature juridique
* extension[legalNature].valueCodeableConcept = https://www.cpage.fr/ig/masterdata/common/CodeSystem/tiers-legal-nature-cs#04 "CAM ou caisse appliquant les mêmes règles"

// TG Category
* extension[tgCategory].valueCodeableConcept = https://mos.esante.gouv.fr/NOS/TRE_R66-CategorieEtablissement/FHIR/TRE-R66-CategorieEtablissement#60 "Assurance maladie (caté. générique)"

// === Extension Payeur Santé ===
* extension[payeurSante].extension[typePayeur].valueString = "RO"
* extension[payeurSante].extension[codeCentre].valueString = "750"
* extension[payeurSante].extension[numeroCaisse].valueString = "75001"
* extension[payeurSante].extension[grandRegime].valueCodeableConcept = https://www.cpage.fr/ig/masterdata/common/CodeSystem/grand-regime-cs#SS
* extension[payeurSante].extension[numeroOrganisme].valueString = "007501"
* extension[payeurSante].extension[flagEclatement].valueString = "false"
* extension[payeurSante].extension[delaiPec].valueInteger = 90
