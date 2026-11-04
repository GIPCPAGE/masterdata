// =============================================
// Extension : Date de début de validité structure hospitalière
// =============================================
// Début de la période de validité fonctionnelle d'une entité de la structure
// hospitalière. Chaque nouvelle période de validité donne lieu à une nouvelle
// version de l'entité. Obligatoire dans le modèle ; extension distincte de la
// date de fin, qui est facultative.

Extension: StrHDateDebutValiditeExtension
Id: strh-date-debut-validite
Title: "Date de début de validité structure hospitalière"
Description: "Date à partir de laquelle l'entité de la structure hospitalière est valide (période fonctionnelle)."
Context: Organization, Location

* value[x] only date
* valueDate ^short = "Date de début de validité (AAAA-MM-JJ)"
* valueDate ^definition = "Date à partir de laquelle l'entité est valide. Attribut du socle commun de la structure hospitalière (date_debut_validite)."
