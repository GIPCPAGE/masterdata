// =============================================
// Extension: Type Identifiant CHORUS
// =============================================

Extension: ChorusIdentifierType
Id: chorus-identifier-type
Title: "Type Identifiant CHORUS"
Description: "Extension pour qualifier le type d'identifiant reconnu par CHORUS (système de comptabilité publique). Correspond à la nomenclature 'Type identifiant CHORUS' (codes 01-08, sans le 09 'En cours'). CHORUS est le système d'information financière de l'État français qui gère la comptabilité des organismes publics et n'accepte que les identifiants définitifs."
Context: Identifier
* ^url = "https://www.cpage.fr/ig/masterdata/common/StructureDefinition/chorus-identifier-type"
* ^version = "1.0.0"
* ^status = #active
* ^context[0].type = #element
* ^context[0].expression = "Identifier"

* value[x] only CodeableConcept
* valueCodeableConcept 1..1 MS
* valueCodeableConcept from ChorusIdentifierTypeVS (required)
* valueCodeableConcept ^short = "Type identifiant CHORUS (01-08)"
* valueCodeableConcept ^definition = "Code indiquant le type d'identifiant reconnu par CHORUS : SIRET, SIREN, FINESS, NIR, TVA, Hors UE, Tahiti, RIDET. Les identifiants temporaires (code 09) ne sont pas acceptés par CHORUS."
