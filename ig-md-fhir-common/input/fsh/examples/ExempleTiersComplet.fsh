// =============================================
// Exemple: Tiers Complet avec Multi-Rôles
// =============================================

Instance: ExempleTiersComplet
InstanceOf: TiersProfile
Usage: #example
Title: "Tiers avec Multi-Rôles (Fournisseur + Débiteur + Payeur)"
Description: "Exemple d'un tiers qui cumule trois rôles: fournisseur, débiteur ET payeur santé. Illustre la capacité d'un même organisme à avoir plusieurs profils actifs simultanément."

* identifier[etierId].value = "TIERS000123456"

* identifier[siret].value = "85211234500018"

* identifier[finess].value = "750012345"

* active = true
* type = https://www.cpage.fr/ig/masterdata/common/CodeSystem/tiers-category-cs#60 "Caisse de sécurité sociale régime général"

* name = "Multiservices Santé et Logistique"
* alias = "MSL France"

* telecom[0].system = #phone
* telecom[0].value = "+33140123456"
* telecom[0].use = #work

* telecom[1].system = #email
* telecom[1].value = "contact@msl-france.fr"
* telecom[1].use = #work

* address.line[0] = "12 Avenue de la République"
* address.city = "Paris"
* address.postalCode = "75011"
* address.country = "FR"

// Multi-rôle: Fournisseur + Débiteur + Payeur
* extension[tiersRole][0].valueCoding = https://www.cpage.fr/ig/masterdata/common/CodeSystem/tiers-role-cs#supplier
* extension[tiersRole][1].valueCoding = https://www.cpage.fr/ig/masterdata/common/CodeSystem/tiers-role-cs#debtor
* extension[tiersRole][2].valueCoding = https://www.cpage.fr/ig/masterdata/common/CodeSystem/tiers-role-cs#payer

// Nature juridique
* extension[legalNature].valueCodeableConcept = https://www.cpage.fr/ig/masterdata/common/CodeSystem/tiers-legal-nature-cs#03 "Société"

// TG Category
* extension[tgCategory].valueCodeableConcept = https://www.cpage.fr/ig/masterdata/common/CodeSystem/tiers-category-cs#60 "Caisse de sécurité sociale régime général"

// Code interne (partagé entre les rôles)
* extension[codeInterne].valueString = "FRSUP00456"

// Note: les détails spécifiques à chaque rôle sont portés par des instances enfant dédiées :
//   - rôle fournisseur : instance FournisseurProfile (avec extensions comptabilite/paiement)
//   - rôle débiteur   : instance DebiteurProfile (avec extensions parametres/debtorAttributs)
//   - rôle payeur     : instance PayeurSanteProfile (avec extension payeurSante)

// === Domiciliation bancaire ===
* extension[bankAccount][0].extension[bankCode].valueString = "30004"
* extension[bankAccount][0].extension[branchCode].valueString = "00002"
* extension[bankAccount][0].extension[accountNumber].valueString = "00000123456"
* extension[bankAccount][0].extension[ribKey].valueString = "78"
* extension[bankAccount][0].extension[iban].valueString = "FR7630004000020000012345678"
* extension[bankAccount][0].extension[bic].valueString = "BNPAFRPP"
* extension[bankAccount][0].extension[ediEnabled].valueBoolean = true
* extension[bankAccount][0].extension[factoringEnabled].valueBoolean = false
* extension[bankAccount][0].extension[paymentMethod][0].valueCodeableConcept = https://www.cpage.fr/ig/masterdata/common/CodeSystem/moyen-paiement-cs#VIREMENT "Virement bancaire"
* extension[bankAccount][0].extension[paymentMethod][1].valueCodeableConcept = https://www.cpage.fr/ig/masterdata/common/CodeSystem/moyen-paiement-cs#CHEQUE "Chèque"
