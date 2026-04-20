// =============================================
// Exemple: Payeur Santé Mutuelle (Régime Complémentaire)
// =============================================

Instance: ExemplePayeurSanteMutuelle
InstanceOf: PayeurSanteProfile
Usage: #example
Title: "Mutuelle MGEN - Mutuelle Générale de l'Éducation Nationale"
Description: "Exemple de payeur santé du régime complémentaire (mutuelle). Illustre les paramètres spécifiques: grand régime Mutuelle, type payeur RC, code centre, numéro caisse, organisme, éclatement factures, délai PEC."

* identifier[etierId].value = "MGEN000001"

* active = true
* type = https://mos.esante.gouv.fr/NOS/TRE_R66-CategorieEtablissement/FHIR/TRE-R66-CategorieEtablissement#63 "Mutuelle"

* name = "MGEN - Mutuelle Générale de l'Éducation Nationale"
* alias = "MGEN"

* telecom[0].system = #phone
* telecom[0].value = "+33336075036"
* telecom[0].use = #work

* telecom[1].system = #email
* telecom[1].value = "contact@mgen.fr"
* telecom[1].use = #work

* telecom[2].system = #url
* telecom[2].value = "https://www.mgen.fr"

* address.line[0] = "3 Square Max Hymans"
* address.city = "Paris"
* address.postalCode = "75015"
* address.country = "FR"

// Rôle: Payeur uniquement
* extension[tiersRole][0].valueCoding = https://www.cpage.fr/ig/masterdata/common/CodeSystem/tiers-role-cs#payer

// Nature juridique
* extension[legalNature].valueCodeableConcept = https://www.cpage.fr/ig/masterdata/common/CodeSystem/tiers-legal-nature-cs#05 "Caisse complémentaire"

// TG Category
* extension[tgCategory].valueCodeableConcept = https://mos.esante.gouv.fr/NOS/TRE_R66-CategorieEtablissement/FHIR/TRE-R66-CategorieEtablissement#63 "Mutuelle"

// === Extension Payeur Santé ===
* extension[payeurSante].extension[typePayeur].valueString = "RC"
* extension[payeurSante].extension[codeCentre].valueString = "999"
* extension[payeurSante].extension[numeroCaisse].valueString = "99901"
* extension[payeurSante].extension[grandRegime].valueCodeableConcept = https://www.cpage.fr/ig/masterdata/common/CodeSystem/grand-regime-cs#MUTUELLE
* extension[payeurSante].extension[numeroOrganisme].valueString = "509941"
* extension[payeurSante].extension[flagEclatement].valueString = "true"
* extension[payeurSante].extension[delaiPec].valueInteger = 60
