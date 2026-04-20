// =============================================
// Instance: Fournisseur Overseas RIDET
// =============================================

Instance: ExempleFournisseurRIDET
InstanceOf: FournisseurProfile
Usage: #example
Title: "Exemple Fournisseur - Nouvelle-Calédonie RIDET"
Description: "Exemple d'une société calédonienne en tant que fournisseur, avec identifiant RIDET (Répertoire d'IDEntification des Entreprises et des Établissements de Nouvelle-Calédonie). Illustre la Catégorie TG 50 (Personne morale de droit privé), Nature juridique 03 (Société), et l'utilisation du système d'identification spécifique à la Nouvelle-Calédonie (territoire d'outre-mer français avec système d'identification distinct du SIRET métropolitain)."

* identifier[etierId].value = "ETIER567890"
* identifier[etierId].use = #official

* identifier[ridet].value = "1234567"
* identifier[ridet].use = #official

* name = "Société Calédonienne Médical Équipement"
* alias = "SCME Nouméa"

* extension[tgCategory].valueCodeableConcept = https://www.cpage.fr/ig/masterdata/common/CodeSystem/tiers-category-cs#50 "Personne morale de droit privé"
* extension[legalNature].valueCodeableConcept = https://www.cpage.fr/ig/masterdata/common/CodeSystem/tiers-legal-nature-cs#03 "Société"

* extension[tiersRole].valueCoding = https://www.cpage.fr/ig/masterdata/common/CodeSystem/tiers-role-cs#supplier "Fournisseur"

* extension[bankAccount][0].extension[bankCode].valueString = "18506"
* extension[bankAccount][0].extension[branchCode].valueString = "00001"
* extension[bankAccount][0].extension[accountNumber].valueString = "98765432101"
* extension[bankAccount][0].extension[ribKey].valueString = "45"
* extension[bankAccount][0].extension[bic].valueString = "BNPAFRPPPPT"

* address.line[0] = "12 Avenue du Maréchal Foch"
* address.city = "Nouméa"
* address.postalCode = "98800"
* address.country = "NC"

* telecom[0].system = #phone
* telecom[0].value = "+687 25 00 00"
* telecom[0].use = #work

* telecom[1].system = #email
* telecom[1].value = "contact@scme-noumea.nc"
* telecom[1].use = #work

* telecom[2].system = #url
* telecom[2].value = "https://www.scme-noumea.nc"
