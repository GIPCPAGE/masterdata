// =============================================
// Extension : URI officiel INSEE du pays
// =============================================
// Identifiant Linked Data INSEE (uri_insee dans le modèle de données).
// Exemple : http://id.insee.fr/geo/pays/france

Extension: PaysUriInseeExt
Id: pays-uri-insee-ext
Title: "URI officiel INSEE"
Description: "Identifiant officiel INSEE sous forme d'URI. Référence normative dans le graphe de données de l'INSEE (Linked Data). Exemple : http://id.insee.fr/geo/pays/france."
Context: Location
* ^url = "https://www.cpage.fr/ig/masterdata/common/StructureDefinition/pays-uri-insee-ext"
* ^version = "1.0.0"
* ^status = #active
* ^context[0].type = #element
* ^context[0].expression = "Location"

* value[x] only uri
* valueUri 1..1 MS
* valueUri ^short = "URI INSEE du pays (ex : http://id.insee.fr/geo/pays/france)"
* valueUri ^definition = "Identifiant officiel du pays dans le référentiel Linked Data de l'INSEE. Permet de lier l'enregistrement Master Data à la source faisant autorité."
