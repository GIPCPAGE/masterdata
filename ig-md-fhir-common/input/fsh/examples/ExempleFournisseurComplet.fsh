// =============================================
// Exemple: Fournisseur Complet (Profil Spécialisé)
// =============================================

Instance: ExempleFournisseurComplet
InstanceOf: FournisseurProfile
Usage: #example
Title: "Fournisseur avec paramètres comptables et paiement complets"
Description: "Exemple d'un fournisseur avec tous les paramètres de gestion: code fournisseur, comptes lettres classe 2 et 6, délais et modalités de paiement, montant minimum, taux transitaire, escompte."

* identifier[etierId].value = "FRNS0000123456"

* identifier[siret].value = "42512345600018"

* identifier[tva].value = "FR23425123456"

* active = true
* type = https://www.cpage.fr/ig/masterdata/common/CodeSystem/tiers-category-cs#50 "Personne morale de droit privé"

* name = "Laboratoires Pharmaceutiques Durand"
* alias = "LPD SA"

* telecom[0].system = #phone
* telecom[0].value = "+33147896543"
* telecom[0].use = #work

* telecom[1].system = #fax
* telecom[1].value = "+33147896544"

* telecom[2].system = #email
* telecom[2].value = "facturation@lpdurand.fr"
* telecom[2].use = #work

* telecom[3].system = #url
* telecom[3].value = "https://www.lpdurand.fr"

* address.line[0] = "12 Rue des Laboratories"
* address.line[1] = "Zone Industrielle Nord"
* address.city = "Toulouse"
* address.postalCode = "31000"
* address.country = "FR"

// Rôle: Fournisseur uniquement
* extension[tiersRole][0].valueCoding = https://www.cpage.fr/ig/masterdata/common/CodeSystem/tiers-role-cs#supplier

// Nature juridique
* extension[legalNature].valueCodeableConcept = https://www.cpage.fr/ig/masterdata/common/CodeSystem/tiers-legal-nature-cs#03 "Société"

// TG Category
* extension[tgCategory].valueCodeableConcept = https://www.cpage.fr/ig/masterdata/common/CodeSystem/tiers-category-cs#50 "Personne morale de droit privé"

// === Extensions Fournisseur ===
* extension[codeInterne].valueString = "FRNSLPD001"

// Paramètres comptables
* extension[comptabilite].extension[compteLettreClasse2].valueString = "4"
* extension[comptabilite].extension[compteNumeroClasse2].valueString = "4011LPD"
* extension[comptabilite].extension[compteLettreClasse6].valueString = "6"
* extension[comptabilite].extension[compteNumeroClasse6].valueString = "6012MED"

// Paramètres de paiement
* extension[paiement].extension[delaiPaiement].valueInteger = 60
* extension[paiement].extension[jourPaiement].valueInteger = 10
* extension[paiement].extension[montantMinimum].valueDecimal = 1000.00
* extension[paiement].extension[tauxTransitaire].valueDecimal = 3.5
* extension[paiement].extension[escomptable].valueBoolean = true

// === Domiciliation bancaire pour paiements ===
* extension[bankAccount][0].extension[bankCode].valueString = "18206"
* extension[bankAccount][0].extension[branchCode].valueString = "00025"
* extension[bankAccount][0].extension[accountNumber].valueString = "00000789123"
* extension[bankAccount][0].extension[ribKey].valueString = "45"
* extension[bankAccount][0].extension[iban].valueString = "FR7618206000250000078912345"
* extension[bankAccount][0].extension[bic].valueString = "AGRIFRPP"
* extension[bankAccount][0].extension[ediEnabled].valueBoolean = true
* extension[bankAccount][0].extension[factoringEnabled].valueBoolean = true
* extension[bankAccount][0].extension[paymentMethod][0].valueCodeableConcept = https://www.cpage.fr/ig/masterdata/common/CodeSystem/moyen-paiement-cs#VIREMENT "Virement bancaire"
* extension[bankAccount][0].extension[paymentMethod][1].valueCodeableConcept = https://www.cpage.fr/ig/masterdata/common/CodeSystem/moyen-paiement-cs#VIREMENT_APPLI_EXT "Virement via application externe"

// === Second compte pour paiements en numéraire ou chèque ===
* extension[bankAccount][1].extension[bankCode].valueString = "30003"
* extension[bankAccount][1].extension[branchCode].valueString = "03025"
* extension[bankAccount][1].extension[accountNumber].valueString = "00000741852"
* extension[bankAccount][1].extension[ribKey].valueString = "96"
* extension[bankAccount][1].extension[iban].valueString = "FR7630003030250000074185296"
* extension[bankAccount][1].extension[bic].valueString = "SOGEFRPP"
* extension[bankAccount][1].extension[ediEnabled].valueBoolean = false
* extension[bankAccount][1].extension[factoringEnabled].valueBoolean = false
* extension[bankAccount][1].extension[paymentMethod][0].valueCodeableConcept = https://www.cpage.fr/ig/masterdata/common/CodeSystem/moyen-paiement-cs#CHEQUE "Chèque"
* extension[bankAccount][1].extension[paymentMethod][1].valueCodeableConcept = https://www.cpage.fr/ig/masterdata/common/CodeSystem/moyen-paiement-cs#NUMERAIRE "Numéraire"
