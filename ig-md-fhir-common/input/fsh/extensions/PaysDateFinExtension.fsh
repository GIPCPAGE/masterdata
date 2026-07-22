// =============================================
// Extension : Date de suppression du référentiel ISO
// =============================================
// Correspond au champ date_fin du modèle de données.
// Renseignée uniquement quand status = inactive (LV-04 : désactivation sans suppression).

Extension: PaysDateFinExt
Id: pays-date-fin-ext
Title: "Date de suppression du référentiel ISO"
Description: "Date à laquelle le pays a été supprimé du référentiel ISO 3166-1. Renseignée uniquement quand `status = inactive`. Un pays inactif reste consultable dans l'historique (LV-04)."
Context: Location
* ^url = "https://www.cpage.fr/ig/masterdata/common/StructureDefinition/pays-date-fin-ext"
* ^version = "1.0.0"
* ^status = #active
* ^context[0].type = #element
* ^context[0].expression = "Location"

* value[x] only date
* valueDate 1..1 MS
* valueDate ^short = "Date de fin de validité ISO (AAAA-MM-JJ)"
* valueDate ^definition = "Date à laquelle le pays a cessé d'exister dans le référentiel ISO 3166-1. Exemples : 1991-12-26 pour l'URSS, 1993-01-01 pour la Tchécoslovaquie. Absent si le pays est toujours actif."
