// =============================================
// Extension : Libellé long officiel ISO du pays
// =============================================
// Complète le champ name (libelle_court) avec la dénomination longue.
// Exemples : "République française" pour la France.

Extension: PaysLibelleLongExt
Id: pays-libelle-long-ext
Title: "Libellé long officiel ISO"
Description: "Dénomination longue officielle du pays selon la norme ISO 3166-1. Exemples : 'République française', 'République fédérale d'Allemagne'. Complète le libellé court porté par `name`."
Context: Location
* ^url = "https://www.cpage.fr/ig/masterdata/common/StructureDefinition/pays-libelle-long-ext"
* ^version = "1.0.0"
* ^status = #active
* ^context[0].type = #element
* ^context[0].expression = "Location"

* value[x] only string
* valueString 1..1 MS
* valueString ^short = "Libellé long (ex : République française)"
* valueString ^definition = "Dénomination longue officielle du pays selon ISO 3166-1. Exemple : 'République française' pour FR, 'République fédérale d'Allemagne' pour DE."
