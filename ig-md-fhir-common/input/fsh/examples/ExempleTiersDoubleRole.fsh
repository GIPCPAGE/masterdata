// =============================================
// Exemple: Tiers Double Rôle (Fournisseur + Débiteur)
// =============================================

Instance: ExempleTiersDoubleRole
InstanceOf: TiersProfile
Usage: #example
Title: "Tiers Double Rôle (Fournisseur ET Débiteur)"
Description: "Exemple d'un tiers qui est à la fois fournisseur (vend des marchandises) ET débiteur (achète des prestations). Illustre la capacité à échanger dans les deux sens avec le même partenaire commercial."

* identifier[etierId].value = "TIERS987654321"

* identifier[siret].value = "45312345600029"

* identifier[tva].value = "FR12453123456"

* active = true
* type = https://www.cpage.fr/ig/masterdata/common/CodeSystem/tiers-category-cs#50 "Personne morale de droit privé"

* name = "Clinique du Parc"
* alias = "CDP SAS"

* telecom[0].system = #phone
* telecom[0].value = "+33142654321"
* telecom[0].use = #work

* telecom[1].system = #fax
* telecom[1].value = "+33142654322"

* telecom[2].system = #email
* telecom[2].value = "comptabilite@clinique-parc.fr"
* telecom[2].use = #work

* telecom[3].system = #url
* telecom[3].value = "https://www.clinique-parc.fr"

* address.line[0] = "85 Boulevard du Parc"
* address.line[1] = "Bâtiment B"
* address.city = "Lyon"
* address.postalCode = "69006"
* address.country = "FR"

// Double rôle: Fournisseur ET Débiteur
* extension[tiersRole][0].valueCoding = https://www.cpage.fr/ig/masterdata/common/CodeSystem/tiers-role-cs#supplier
* extension[tiersRole][1].valueCoding = https://www.cpage.fr/ig/masterdata/common/CodeSystem/tiers-role-cs#debtor

// Nature juridique
* extension[legalNature].valueCodeableConcept = https://www.cpage.fr/ig/masterdata/common/CodeSystem/tiers-legal-nature-cs#03 "Société"

// TG Category
* extension[tgCategory].valueCodeableConcept = https://www.cpage.fr/ig/masterdata/common/CodeSystem/tiers-category-cs#50 "Personne morale de droit privé"

// === Extensions Fournisseur (la clinique vend des prestations) ===
* extension[codeFournisseur].valueString = "FRCLIN00123"

* extension[comptabilite].extension[compteLettreClasse2].valueString = "4011CDP"
* extension[comptabilite].extension[compteLettreClasse6].valueString = "6011CDP"

* extension[paiement].extension[delaiPaiement].valueInteger = 30
* extension[paiement].extension[jourPaiement].valueInteger = 30
* extension[paiement].extension[montantMinimum].valueDecimal = 100.00
* extension[paiement].extension[tauxTransitaire].valueDecimal = 0.0
* extension[paiement].extension[escomptable].valueBoolean = false

// === Extensions Débiteur (la clinique achète médicaments et équipements) ===
* extension[codeDebiteur].valueString = "DEB123456"

* extension[parametres].extension[compteLettre].valueString = "411CDP"
* extension[parametres].extension[typeResident].valueCode = #R
* extension[parametres].extension[typeDebiteur].valueString = "CLI"
* extension[parametres].extension[assuAutorise].valueBoolean = true
* extension[parametres].extension[forceImpressionCoh].valueBoolean = true

* extension[debtorType].valueCode = #N

// === Domiciliation bancaire (compte unique pour flux créditeurs et débiteurs) ===
* extension[bankAccount][0].extension[bankCode].valueString = "30002"
* extension[bankAccount][0].extension[branchCode].valueString = "00123"
* extension[bankAccount][0].extension[accountNumber].valueString = "00000987654"
* extension[bankAccount][0].extension[ribKey].valueString = "21"
* extension[bankAccount][0].extension[iban].valueString = "FR7630002001230000098765421"
* extension[bankAccount][0].extension[bic].valueString = "CRLYFRPP"
* extension[bankAccount][0].extension[ediEnabled].valueBoolean = true
* extension[bankAccount][0].extension[factoringEnabled].valueBoolean = false
* extension[bankAccount][0].extension[paymentMethod][0].valueCodeableConcept = https://www.cpage.fr/ig/masterdata/common/CodeSystem/moyen-paiement-cs#VIREMENT "Virement bancaire"
* extension[bankAccount][0].extension[paymentMethod][1].valueCodeableConcept = https://www.cpage.fr/ig/masterdata/common/CodeSystem/moyen-paiement-cs#VIREMENT_APPLI_EXT "Virement via application externe"

// === Second compte bancaire (Pour séparer flux importants) ===
* extension[bankAccount][1].extension[bankCode].valueString = "30004"
* extension[bankAccount][1].extension[branchCode].valueString = "00790"
* extension[bankAccount][1].extension[accountNumber].valueString = "00000555666"
* extension[bankAccount][1].extension[ribKey].valueString = "83"
* extension[bankAccount][1].extension[iban].valueString = "FR7630004007900000055566683"
* extension[bankAccount][1].extension[bic].valueString = "BNPAFRPP"
* extension[bankAccount][1].extension[ediEnabled].valueBoolean = false
* extension[bankAccount][1].extension[factoringEnabled].valueBoolean = false
* extension[bankAccount][1].extension[paymentMethod][0].valueCodeableConcept = https://www.cpage.fr/ig/masterdata/common/CodeSystem/moyen-paiement-cs#VIREMENT_GROS_MONTANT "Virement gros montant"
* extension[bankAccount][1].extension[paymentMethod][1].valueCodeableConcept = https://www.cpage.fr/ig/masterdata/common/CodeSystem/moyen-paiement-cs#CHEQUE "Chèque"
