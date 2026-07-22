// =============================================
// Extension : Appartenance à l'Union européenne
// =============================================
// Valeur booléenne déduite du statut politique actuel du pays.
// Obligatoire sur tous les pays (union_europeenne NOT NULL dans le modèle).

Extension: PaysUnionEuropeenneExt
Id: pays-union-europeenne-ext
Title: "Appartenance à l'Union européenne"
Description: "Indique si le pays est membre de l'Union européenne. Valeur booléenne déduite du statut politique. Un pays historique inactif conserve la valeur qu'il avait à sa date de suppression."
Context: Location
* ^url = "https://www.cpage.fr/ig/masterdata/common/StructureDefinition/pays-union-europeenne-ext"
* ^version = "1.0.0"
* ^status = #active
* ^context[0].type = #element
* ^context[0].expression = "Location"

* value[x] only boolean
* valueBoolean 1..1 MS
* valueBoolean ^short = "true si membre de l'Union européenne"
* valueBoolean ^definition = "Membre actuel de l'Union européenne. true = oui, false = non. Exemples : true pour FR, DE, ES ; false pour CH, NO, US."
