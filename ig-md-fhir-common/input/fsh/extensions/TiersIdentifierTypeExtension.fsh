// =============================================
// Extension Identifier Type
// =============================================

Extension: TiersIdentifierType
Id: tiers-identifier-type
Title: "Type d'identifiant"
Description: "Type d'identifiant utilisé dans les interfaces (codes 01-09): SIRET, SIREN, FINESS, NIR, TVA intracommunautaire, hors UE, Tahiti, RIDET, en cours d'immatriculation"
* ^url = "https://www.cpage.fr/ig/masterdata/common/StructureDefinition/tiers-identifier-type"
* ^version = "1.0.0"
* ^status = #active
* ^context[0].type = #element
* ^context[0].expression = "Identifier"

* value[x] only CodeableConcept
* valueCodeableConcept 1..1 MS
* valueCodeableConcept from TiersIdentifierTypeVS (required)
* valueCodeableConcept ^short = "Type d'identifiant selon nomenclature"
* valueCodeableConcept ^definition = "Code 01-09 indiquant le type d'identifiant: 01=SIRET (14 car), 02=SIREN (9 car), 03=FINESS (9 car), 04=NIR (15 car), 05=TVA intracommunautaire, 06=Hors UE, 07=N° Tahiti (Polynésie française), 08=RIDET (Nouvelle-Calédonie), 09=En cours d'immatriculation"
