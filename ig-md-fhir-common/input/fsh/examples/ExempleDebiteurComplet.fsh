// =============================================
// Exemple: Débiteur Complet (Profil Spécialisé)
// =============================================

Instance: ExempleDebiteurComplet
InstanceOf: DebiteurProfile
Usage: #example
Title: "Débiteur avec paramètres comptables et fiscaux complets"
Description: "Exemple d'un débiteur (établissement acheteur) avec tous les paramètres de gestion: code débiteur, compte lettre, type résident fiscal, type débiteur, autorisation assurances, COH."

* identifier[etierId].value = "DEB0000987654"

* identifier[siret].value = "78912345600011"

* identifier[finess].value = "920023456"

* active = true
* type = https://mos.esante.gouv.fr/NOS/TRE_R66-CategorieEtablissement/FHIR/TRE-R66-CategorieEtablissement#02 "CHU"

* name = "Centre Hospitalier Universitaire Necker"
* alias = "CHU Necker-Enfants Malades"

* telecom[0].system = #phone
* telecom[0].value = "+33144494040"
* telecom[0].use = #work

* telecom[1].system = #email
* telecom[1].value = "comptabilite@chu-necker.fr"
* telecom[1].use = #work

* telecom[2].system = #url
* telecom[2].value = "https://www.chu-necker.fr"

* address.line[0] = "149 Rue de Sèvres"
* address.city = "Paris"
* address.postalCode = "75015"
* address.country = "FR"

// Rôle: Débiteur uniquement
* extension[tiersRole][0].valueCoding = http://cpage.org/fhir/CodeSystem/tiers-role-cs#debtor

// Nature juridique
* extension[legalNature].valueCodeableConcept = http://cpage.org/fhir/CodeSystem/gef-legal-nature-cs#06 "Établissement public"

// TG Category
* extension[tgCategory].valueCodeableConcept = https://mos.esante.gouv.fr/NOS/TRE_R66-CategorieEtablissement/FHIR/TRE-R66-CategorieEtablissement#02 "CHU"

// === Extensions Débiteur ===
* extension[codeDebiteur].valueString = "DEBNECKER01"

// Paramètres de gestion débiteur
* extension[parametres].extension[compteLettre].valueString = "411NECKER"
* extension[parametres].extension[typeResident].valueCode = #R
* extension[parametres].extension[typeDebiteur].valueString = "CHU"
* extension[parametres].extension[assuAutorise].valueBoolean = true
* extension[parametres].extension[forceImpressionCoh].valueBoolean = true

* extension[debtorType].valueCode = #N

// === Domiciliation bancaire pour recettes ===
* extension[bankAccount][0].extension[bankCode].valueString = "30001"
* extension[bankAccount][0].extension[branchCode].valueString = "00850"
* extension[bankAccount][0].extension[accountNumber].valueString = "00000951753"
* extension[bankAccount][0].extension[ribKey].valueString = "14"
* extension[bankAccount][0].extension[iban].valueString = "FR7630001008500000095175314"
* extension[bankAccount][0].extension[bic].valueString = "BDFEFRPP"
* extension[bankAccount][0].extension[ediEnabled].valueBoolean = true
* extension[bankAccount][0].extension[factoringEnabled].valueBoolean = false
* extension[bankAccount][0].extension[paymentMethod][0].valueCodeableConcept = http://cpage.org/fhir/CodeSystem/moyen-paiement#VIREMENT "Virement"
* extension[bankAccount][0].extension[paymentMethod][1].valueCodeableConcept = http://cpage.org/fhir/CodeSystem/moyen-paiement#VIREMENT_INTERNE "Virement interne"

// === Second compte bancaire pour recettes importantes ===
* extension[bankAccount][1].extension[bankCode].valueString = "30004"
* extension[bankAccount][1].extension[branchCode].valueString = "01256"
* extension[bankAccount][1].extension[accountNumber].valueString = "00000753159"
* extension[bankAccount][1].extension[ribKey].valueString = "42"
* extension[bankAccount][1].extension[iban].valueString = "FR7630004012560000075315942"
* extension[bankAccount][1].extension[bic].valueString = "BNPAFRPP"
* extension[bankAccount][1].extension[ediEnabled].valueBoolean = true
* extension[bankAccount][1].extension[factoringEnabled].valueBoolean = false
* extension[bankAccount][1].extension[paymentMethod][0].valueCodeableConcept = http://cpage.org/fhir/CodeSystem/moyen-paiement#VIREMENT_GROS_MONTANT "Virement gros montant"
