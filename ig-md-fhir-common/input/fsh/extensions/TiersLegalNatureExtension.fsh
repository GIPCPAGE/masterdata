// =============================================
// Extension Legal Nature
// =============================================

Extension: TiersLegalNature
Id: tiers-legal-nature
Title: "Nature juridique"
Description: "Nature juridique du tiers selon la nomenclature (codes 00-11). Structure juridique: particulier, société, association, établissement public, collectivité territoriale, etc."
* ^url = "https://www.cpage.fr/ig/masterdata/common/StructureDefinition/tiers-legal-nature"
* ^version = "1.0.0"
* ^status = #active
* ^context[0].type = #element
* ^context[0].expression = "Organization"

* value[x] only CodeableConcept
* valueCodeableConcept 1..1 MS
* valueCodeableConcept from TiersLegalNatureVS (required)
* valueCodeableConcept ^short = "Nature juridique selon nomenclature"
* valueCodeableConcept ^definition = "Code 00-11 qualifiant la structure juridique: 01=Particulier, 02=Artisan-Commerçant-Agriculteur, 03=Société, 06=Association, 07=État, 08=Établissement public national, 09=Collectivité territoriale, etc. Correspond au champ 'Nature juridique' position 9 du interface debiteurs et position 238 du interface fournisseurs."
