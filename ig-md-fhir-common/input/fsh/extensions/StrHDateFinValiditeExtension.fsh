// =============================================
// Extension : Date de fin de validité structure hospitalière
// =============================================
// Fin de la période de validité fonctionnelle d'une entité de la structure
// hospitalière. Absente tant que l'entité est ouverte ; quand elle est présente,
// elle est postérieure ou égale à la date de début.

Extension: StrHDateFinValiditeExtension
Id: strh-date-fin-validite
Title: "Date de fin de validité structure hospitalière"
Description: "Date de fin de validité de l'entité de la structure hospitalière ; absente tant que l'entité est ouverte."
Context: Organization, Location

* value[x] only date
* valueDate ^short = "Date de fin de validité (AAAA-MM-JJ)"
* valueDate ^definition = "Date de fin de validité de l'entité, postérieure ou égale à la date de début quand elle est renseignée. Attribut du socle commun de la structure hospitalière (date_fin_validite)."
