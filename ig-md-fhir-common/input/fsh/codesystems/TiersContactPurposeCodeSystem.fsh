// =============================================
// CodeSystem Objet d'un contact du Tiers
// =============================================

CodeSystem: TiersContactPurposeCS
Id: tiers-contact-purpose-cs
Title: "Objet d'un contact du tiers"
Description: "Objet (purpose) d'un contact du tiers. Un contact sans objet est une adresse d'ordre supérieur à 1."
* ^status = #active
* ^experimental = false
* ^content = #complete
* ^caseSensitive = true
* ^meta.profile = "http://hl7.org/fhir/StructureDefinition/shareablecodesystem"
* #personne-physique "Personne physique" "Le contact porte l'identité du tiers personne physique : civilité, prénom, nom et date de naissance"
