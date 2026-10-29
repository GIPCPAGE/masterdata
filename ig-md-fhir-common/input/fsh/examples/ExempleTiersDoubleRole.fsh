// =============================================
// Exemple: Tiers de rôle mixte (fournisseur et débiteur)
// =============================================

Instance: ExempleTiersDoubleRole
InstanceOf: TiersProfile
Usage: #example
Title: "Tiers de rôle mixte (fournisseur et débiteur)"
Description: "Exemple d'un tiers de rôle mixte (M) : à la fois fournisseur (vend des marchandises) et débiteur (achète des prestations). Un tiers porte un seul rôle ; le rôle payeur n'existe pas."

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

// Rôle unique : mixte (fournisseur et débiteur)
* extension[tiersRole].valueCoding = https://www.cpage.fr/ig/masterdata/common/CodeSystem/tiers-role-cs#mixed

// Nature juridique
* extension[legalNature].valueCodeableConcept = https://www.cpage.fr/ig/masterdata/common/CodeSystem/tiers-legal-nature-cs#03 "Société"

// TG Category
* extension[tgCategory].valueCodeableConcept = https://www.cpage.fr/ig/masterdata/common/CodeSystem/tiers-category-cs#50 "Personne morale de droit privé"

