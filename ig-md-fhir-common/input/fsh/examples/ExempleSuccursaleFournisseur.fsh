// =============================================
// Exemple: Succursale d'un Fournisseur
// =============================================
// Illustre le modèle en deux ressources :
//   1. ExempleFournisseurSiege  — le fournisseur (siège social, SIREN)
//   2. ExempleFournisseurSuccursale — la succursale (SIRET propre, partOf → siège)
//
// Points clés :
//   - partOf lie la succursale à son siège (relation organisationnelle)
//   - La succursale a son propre SIRET (établissement distinct au sens INSEE)
//   - L'extension succursaleUsage qualifie le rôle du site (livraison / facturation / siège)
//   - Chaque ressource a son propre codeInterne si elle est gérée indépendamment
// =============================================

// --------------------------------------------------
// Ressource 1/2 : Fournisseur Siège Social
// --------------------------------------------------
Instance: ExempleFournisseurSiege
InstanceOf: FournisseurProfile
Usage: #example
Title: "Fournisseur — Siège social (Laboratoires Durand)"
Description: "Siège social du fournisseur Laboratoires Durand. Identifié par son SIREN (entreprise). Ses succursales le référencent via partOf."

* identifier[etierId].value = "FRNS0000100001"
* identifier[siren].value = "425123456"
* identifier[tva].value = "FR23425123456"

* active = true

* name = "Laboratoires Durand SA"
* alias = "LPD SA"

* telecom[0].system = #phone
* telecom[0].value = "+33147896500"
* telecom[0].use = #work
* telecom[1].system = #email
* telecom[1].value = "contact@lpdurand.fr"
* telecom[1].use = #work
* telecom[2].system = #url
* telecom[2].value = "https://www.lpdurand.fr"

* address.use = #work
* address.line[0] = "12 Rue des Laboratoires"
* address.city = "Toulouse"
* address.postalCode = "31000"
* address.country = "FR"

* extension[tiersRole][0].valueCoding = https://www.cpage.fr/ig/masterdata/common/CodeSystem/tiers-role-cs#supplier

* extension[legalNature].valueCodeableConcept = https://www.cpage.fr/ig/masterdata/common/CodeSystem/tiers-legal-nature-cs#03 "Société"
* extension[tgCategory].valueCodeableConcept = https://www.cpage.fr/ig/masterdata/common/CodeSystem/tiers-category-cs#50 "Personne morale de droit privé"

* extension[codeInterne].valueString = "FRNSLPD000"

* extension[comptabilite].extension[compteLettreClasse2].valueString = "4"
* extension[comptabilite].extension[compteNumeroClasse2].valueString = "4011LPD"
* extension[comptabilite].extension[compteLettreClasse6].valueString = "6"
* extension[comptabilite].extension[compteNumeroClasse6].valueString = "6012MED"

* extension[paiement].extension[delaiPaiement].valueInteger = 60
* extension[paiement].extension[jourPaiement].valueInteger = 10
* extension[paiement].extension[montantMinimum].valueDecimal = 1000.00
* extension[paiement].extension[tauxTransitaire].valueDecimal = 3.5
* extension[paiement].extension[escomptable].valueBoolean = true

* extension[bankAccount][0].extension[iban].valueString = "FR7618206000250000078912345"
* extension[bankAccount][0].extension[bic].valueString = "AGRIFRPP"
* extension[bankAccount][0].extension[ediEnabled].valueBoolean = true
* extension[bankAccount][0].extension[factoringEnabled].valueBoolean = false
* extension[bankAccount][0].extension[paymentMethod][0].valueCodeableConcept = https://www.cpage.fr/ig/masterdata/common/CodeSystem/moyen-paiement-cs#VIREMENT "Virement bancaire"


// --------------------------------------------------
// Ressource 2/2 : Succursale (dépôt de livraison Paris Nord)
// --------------------------------------------------
Instance: ExempleFournisseurSuccursale
InstanceOf: FournisseurProfile
Usage: #example
Title: "Fournisseur — Succursale / Dépôt Paris Nord (Laboratoires Durand)"
Description: "Succursale parisienne des Laboratoires Durand, utilisée comme point de livraison et adresse de facturation locale. Référence le siège via partOf. Possède son propre SIRET (établissement INSEE distinct), son propre code fournisseur et un RIB dédié."

// Identifiant interne propre à ce site
* identifier[etierId].value = "FRNS0000100002"

// SIRET propre : établissement distinct au sens INSEE (même SIREN 425123456, NIC différent)
* identifier[siret].value = "42512345600026"

* active = true

* name = "Laboratoires Durand SA — Dépôt Paris Nord"
* alias = "LPD Paris Nord"

* telecom[0].system = #phone
* telecom[0].value = "+33148123456"
* telecom[0].use = #work
* telecom[1].system = #email
* telecom[1].value = "depot-paris@lpdurand.fr"
* telecom[1].use = #work

// Adresse du dépôt (différente du siège)
* address.use = #work
* address.line[0] = "55 Avenue du Président Wilson"
* address.line[1] = "Entrepôt B2 — Zone Logistique"
* address.city = "La Plaine Saint-Denis"
* address.postalCode = "93210"
* address.country = "FR"

// Rôle : fournisseur (hérité du siège)
* extension[tiersRole][0].valueCoding = https://www.cpage.fr/ig/masterdata/common/CodeSystem/tiers-role-cs#supplier

// Nature juridique et catégorie identiques au siège
* extension[legalNature].valueCodeableConcept = https://www.cpage.fr/ig/masterdata/common/CodeSystem/tiers-legal-nature-cs#03 "Société"
* extension[tgCategory].valueCodeableConcept = https://www.cpage.fr/ig/masterdata/common/CodeSystem/tiers-category-cs#50 "Personne morale de droit privé"

// === RELATION HIÉRARCHIQUE : rattachement au siège ===
// partOf est une référence entre ressources (runtime), pas un héritage de profil.
// La succursale pointe vers le siège ; le siège ne liste pas ses succursales.
* partOf = Reference(ExempleFournisseurSiege)
* partOf.display = "Laboratoires Durand SA (Siège — Toulouse)"

// === Usage de la succursale (peut en avoir plusieurs) ===
// Ce dépôt sert à la fois de point de livraison et d'adresse de facturation locale
* extension[succursaleUsage][0].valueCode = #POINT_LIVRAISON
* extension[succursaleUsage][1].valueCode = #FACTURATION

// Code fournisseur propre au site (gestion différenciée des commandes)
* extension[codeInterne].valueString = "FRNSLPDPN1"

// Paramètres comptables du site (même comptes que le siège dans cet exemple)
* extension[comptabilite].extension[compteLettreClasse2].valueString = "4"
* extension[comptabilite].extension[compteNumeroClasse2].valueString = "4011LPD"
* extension[comptabilite].extension[compteLettreClasse6].valueString = "6"
* extension[comptabilite].extension[compteNumeroClasse6].valueString = "6012MED"

// Conditions de paiement héritées du contrat siège
* extension[paiement].extension[delaiPaiement].valueInteger = 60
* extension[paiement].extension[jourPaiement].valueInteger = 10
* extension[paiement].extension[montantMinimum].valueDecimal = 500.00
* extension[paiement].extension[tauxTransitaire].valueDecimal = 0.0
* extension[paiement].extension[escomptable].valueBoolean = false

// RIB dédié au dépôt Paris (compte de réception des paiements locaux)
* extension[bankAccount][0].extension[bankCode].valueString = "30004"
* extension[bankAccount][0].extension[branchCode].valueString = "00848"
* extension[bankAccount][0].extension[accountNumber].valueString = "00009876543"
* extension[bankAccount][0].extension[ribKey].valueString = "21"
* extension[bankAccount][0].extension[iban].valueString = "FR7630004008480000987654321"
* extension[bankAccount][0].extension[bic].valueString = "BNPAFRPPXXX"
* extension[bankAccount][0].extension[ediEnabled].valueBoolean = false
* extension[bankAccount][0].extension[factoringEnabled].valueBoolean = false
* extension[bankAccount][0].extension[paymentMethod][0].valueCodeableConcept = https://www.cpage.fr/ig/masterdata/common/CodeSystem/moyen-paiement-cs#VIREMENT "Virement bancaire"
* extension[bankAccount][0].extension[paymentMethod][1].valueCodeableConcept = https://www.cpage.fr/ig/masterdata/common/CodeSystem/moyen-paiement-cs#CHEQUE "Chèque"
