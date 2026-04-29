// =============================================
// Extension : Date de mise à jour de la fiche commune
// =============================================
// Date de la dernière modification de la fiche dans le référentiel CPage.
// Distincte de dateCreation (COG INSEE) : elle reflète la fraîcheur de l'enregistrement.

Extension: CommuneDateMiseAJourExt
Id: commune-date-mise-a-jour-ext
Title: "Date de mise à jour"
Description: "Date de la dernière mise à jour de l'enregistrement de la commune dans le référentiel CPage. Distinct de la date de création COG : il reflète la fraîcheur des données (ex : suite à une correction de code postal, un changement de nom ou une mise à jour annuelle COG)."
Context: Location
* ^url = "https://www.cpage.fr/ig/masterdata/common/StructureDefinition/commune-date-mise-a-jour-ext"
* ^version = "1.0.0"
* ^status = #active
* ^context[0].type = #element
* ^context[0].expression = "Location"

* value[x] only dateTime
* valueDateTime 1..1 MS
* valueDateTime ^short = "Date et heure de dernière mise à jour (AAAA-MM-JJ ou AAAA-MM-JJThh:mm:ss+TZ)"
* valueDateTime ^definition = "Horodatage de la dernière modification de la fiche commune dans le référentiel CPage (ex : 2026-01-01T00:00:00+01:00 lors de la mise à jour COG annuelle)."
