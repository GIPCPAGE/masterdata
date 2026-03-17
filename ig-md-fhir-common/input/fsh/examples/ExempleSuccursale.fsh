// =============================================
// Exemple: Succursale avec partOf
// =============================================

Instance: ExempleSuccursale
InstanceOf: TiersProfile
Usage: #example
Title: "Succursale rattachée à un établissement principal"
Description: "Exemple d'une succursale (point de livraison, facturation, ou site secondaire) rattachée à son établissement principal via partOf. Illustre la relation hiérarchique organisation parente → succursale, distincte de l'héritage de profil."

* identifier[etierId].value = "SUCC000456789"

* identifier[siret].value = "85211234500026"

* active = true
* type = https://mos.esante.gouv.fr/NOS/TRE_R66-CategorieEtablissement/FHIR/TRE-R66-CategorieEtablissement#07 "Centre de santé"

* name = "Centre Médical Raspail - Annexe Montparnasse"
* alias = "CMR Montparnasse"

* telecom[0].system = #phone
* telecom[0].value = "+33143206789"
* telecom[0].use = #work

* telecom[1].system = #email
* telecom[1].value = "montparnasse@cm-raspail.fr"
* telecom[1].use = #work

* address.line[0] = "234 Boulevard Raspail"
* address.line[1] = "Résidence Le Montparnasse"
* address.city = "Paris"
* address.postalCode = "75014"
* address.country = "FR"

// Rôle: Débiteur (la succursale achète des fournitures)
* extension[tiersRole][0].valueCoding = http://cpage.org/fhir/CodeSystem/tiers-role-cs#debtor

// Nature juridique hérite du siège
* extension[legalNature].valueCodeableConcept = http://cpage.org/fhir/CodeSystem/gef-legal-nature-cs#03 "Société"

// TG Category
* extension[tgCategory].valueCodeableConcept = https://mos.esante.gouv.fr/NOS/TRE_R66-CategorieEtablissement/FHIR/TRE-R66-CategorieEtablissement#07 "Centre de santé"

// === PARTOF: Rattachement à l'établissement principal ===
// IMPORTANT: partOf est une relation hiérarchique (runtime), PAS un héritage de profil
* partOf = Reference(ExempleTiersDoubleRole)
* partOf.display = "Clinique du Parc (Établissement principal)"

// Extension pour usage de la succursale
* extension[succursaleUsage][0].valueCode = #POINT_LIVRAISON
* extension[succursaleUsage][1].valueCode = #FACTURATION

// === Extensions Débiteur ===
* extension[codeDebiteur].valueString = "DEBSUCC789"

* extension[parametres].extension[compteLettre].valueString = "411CMRMT"
* extension[parametres].extension[typeResident].valueCode = #R
* extension[parametres].extension[typeDebiteur].valueString = "SUC"
* extension[parametres].extension[assuAutorise].valueBoolean = false
* extension[parametres].extension[forceImpressionCoh].valueBoolean = false

* extension[debtorType].valueCode = #N

// === Domiciliation bancaire (peut être différente du siège) ===
* extension[bankAccount][0].extension[bankCode].valueString = "10278"
* extension[bankAccount][0].extension[branchCode].valueString = "06020"
* extension[bankAccount][0].extension[accountNumber].valueString = "00000147852"
* extension[bankAccount][0].extension[ribKey].valueString = "36"
* extension[bankAccount][0].extension[iban].valueString = "FR7610278060200000014785236"
* extension[bankAccount][0].extension[bic].valueString = "CMCIFR2A"
* extension[bankAccount][0].extension[ediEnabled].valueBoolean = false
* extension[bankAccount][0].extension[factoringEnabled].valueBoolean = false
* extension[bankAccount][0].extension[paymentMethod][0].valueCodeableConcept = http://cpage.org/fhir/CodeSystem/moyen-paiement#VIREMENT "Virement"
* extension[bankAccount][0].extension[paymentMethod][1].valueCodeableConcept = http://cpage.org/fhir/CodeSystem/moyen-paiement#CHEQUE "Chèque"
