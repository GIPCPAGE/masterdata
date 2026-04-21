// =============================================
// Extension TG Category
// =============================================

Extension: TiersCategory
Id: tiers-category
Title: "Catégorie TG"
Description: "Catégorie du tiers selon la nomenclature (codes 00-74). Classification des organisations: État, collectivités territoriales, établissements publics, organismes sociaux, personnes physiques, etc."
* ^url = "https://www.cpage.fr/ig/masterdata/common/StructureDefinition/tiers-category"
* ^version = "1.0.0"
* ^status = #active
* ^context[0].type = #element
* ^context[0].expression = "Organization"

* value[x] only CodeableConcept
* valueCodeableConcept 1..1 MS
* valueCodeableConcept from TiersCategoryVS (required)
* valueCodeableConcept ^short = "Catégorie TG selon nomenclature"
* valueCodeableConcept ^definition = "Code 00-74 classifiant le type d'organisation: 01=Personne physique, 20=État, 21=Région, 22=Département, 23=Commune, 27=Établissement public de santé, 60-74=Organismes sociaux, etc. Correspond au champ 'Catégorie TG' position 8 du interface debiteurs et position 237 du interface fournisseurs."
