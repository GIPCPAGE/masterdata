// =============================================
// Extension GEF Bank Account
// =============================================

Extension: GEFBankAccount
Id: gef-bank-account
Title: "Domiciliation bancaire GEF"
Description: "Coordonnées bancaires RIB/IBAN du tiers pour paiements (fournisseurs) ou recettes (débiteurs). Conforme aux formats GEF (KERD et EMAF)"
* ^url = "http://cpage.org/fhir/StructureDefinition/gef-bank-account"
* ^version = "1.0.0"
* ^status = #active
* ^context[0].type = #element
* ^context[0].expression = "Organization"

* extension contains
    bankCode 0..1 MS and
    branchCode 0..1 MS and
    accountNumber 0..1 MS and
    ribKey 0..1 MS and
    iban 0..1 MS and
    bic 0..1 MS and
    ediEnabled 0..1 MS and
    factoringEnabled 0..1 MS and
    paymentMethod 0..* MS

* extension[bankCode] ^short = "Code banque"
* extension[bankCode] ^definition = "Code établissement bancaire (5 caractères) - Partie du RIB français"
* extension[bankCode].value[x] only string
* extension[bankCode].valueString 1..1
* extension[bankCode].valueString ^maxLength = 5

* extension[branchCode] ^short = "Code guichet"
* extension[branchCode] ^definition = "Code guichet bancaire (5 caractères) - Partie du RIB français"
* extension[branchCode].value[x] only string
* extension[branchCode].valueString 1..1
* extension[branchCode].valueString ^maxLength = 5

* extension[accountNumber] ^short = "Numéro de compte"
* extension[accountNumber] ^definition = "Numéro de compte bancaire (jusqu'à 11 caractères) - Partie du RIB français"
* extension[accountNumber].value[x] only string
* extension[accountNumber].valueString 1..1
* extension[accountNumber].valueString ^maxLength = 11

* extension[ribKey] ^short = "Clé RIB"
* extension[ribKey] ^definition = "Clé de contrôle RIB (2 caractères) - Partie du RIB français"
* extension[ribKey].value[x] only string
* extension[ribKey].valueString 1..1
* extension[ribKey].valueString ^maxLength = 2

* extension[iban] ^short = "IBAN"
* extension[iban] ^definition = "International Bank Account Number (format SEPA, jusqu'à 34 caractères)"
* extension[iban].value[x] only string
* extension[iban].valueString 1..1
* extension[iban].valueString ^maxLength = 34

* extension[bic] ^short = "BIC"
* extension[bic] ^definition = "Bank Identifier Code / SWIFT (8 ou 11 caractères)"
* extension[bic].value[x] only string
* extension[bic].valueString 1..1
* extension[bic].valueString ^maxLength = 11

* extension[ediEnabled] ^short = "EDI activé"
* extension[ediEnabled] ^definition = "Indique si les échanges EDI sont activés pour ce compte bancaire (paiements électroniques automatisés)"
* extension[ediEnabled].value[x] only boolean
* extension[ediEnabled].valueBoolean 1..1

* extension[factoringEnabled] ^short = "Affacturage activé"
* extension[factoringEnabled] ^definition = "Indique si le compte est sujet à l'affacturage (cession de créances à un factor pour financement)"
* extension[factoringEnabled].value[x] only boolean
* extension[factoringEnabled].valueBoolean 1..1

* extension[paymentMethod] ^short = "Moyens de paiement acceptés"
* extension[paymentMethod] ^definition = "Liste des moyens de paiement acceptés sur ce compte: numéraire, chèque, virement standard, virement application externe, virement gros montant, virement interne"
* extension[paymentMethod].value[x] only CodeableConcept
* extension[paymentMethod].valueCodeableConcept 1..1
* extension[paymentMethod].valueCodeableConcept from MoyenPaiementVS (required)
