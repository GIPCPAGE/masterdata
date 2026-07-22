// =============================================
// Extension : Date de mise à jour du pays
// =============================================
// Horodatage de la dernière modification de la fiche pays dans le référentiel CPage.
// Correspond au champ updatedDate du modèle de données (toujours renseigné).

Extension: PaysDateMiseAJourExt
Id: pays-date-mise-a-jour-ext
Title: "Date de mise à jour du pays"
Description: """
  Horodatage de la dernière mise à jour de la fiche pays dans le référentiel CPage.
  Correspond au champ `updatedDate` du modèle de données (toujours renseigné).
"""
Context: Location
* ^url = "https://www.cpage.fr/ig/masterdata/common/StructureDefinition/pays-date-mise-a-jour-ext"
* ^version = "1.0.0"
* ^status = #active
* ^context[0].type = #element
* ^context[0].expression = "Location"

* value[x] only dateTime
* value[x] 1..1
