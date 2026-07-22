// =============================================
// Extension : Date d'entrée dans le référentiel INSEE
// =============================================
// Correspond à date_creation_insee dans le modèle.
// Quand seule l'année est connue, la convention est 01/01 de l'année fournie.

Extension: PaysDateCreationInseeExt
Id: pays-date-creation-insee-ext
Title: "Date d'entrée dans le référentiel INSEE"
Description: "Date d'entrée en vigueur du pays dans le référentiel INSEE des pays et territoires étrangers. Format : AAAA-MM-JJ. Lorsque seule l'année est connue, la convention est d'utiliser le 01/01 de l'année fournie par l'INSEE."
Context: Location
* ^url = "https://www.cpage.fr/ig/masterdata/common/StructureDefinition/pays-date-creation-insee-ext"
* ^version = "1.0.0"
* ^status = #active
* ^context[0].type = #element
* ^context[0].expression = "Location"

* value[x] only date
* valueDate 1..1 MS
* valueDate ^short = "Date de création INSEE (AAAA-MM-JJ)"
* valueDate ^definition = "Date à partir de laquelle le pays figure dans le référentiel INSEE. Pour les pays présents depuis l'origine du COG : 1943-01-01 par convention. Pour les pays créés plus récemment, la date précise est fournie si connue."
