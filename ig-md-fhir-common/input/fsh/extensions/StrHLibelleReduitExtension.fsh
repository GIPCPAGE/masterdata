// =============================================
// Extension : Libellé réduit structure hospitalière
// =============================================
// Libellé abrégé (20 caractères) d'une entité de la structure hospitalière.
// Porté en extension par la variante CPage ; la variante FR Core le porte
// nativement dans Organization.alias.

Extension: StrHLibelleReduitExtension
Id: strh-libelle-reduit
Title: "Libellé réduit structure hospitalière"
Description: "Libellé abrégé de l'entité de la structure hospitalière (20 caractères au plus)."
Context: Organization, Location

* value[x] only string
* valueString ^short = "Libellé réduit"
* valueString ^definition = "Libellé abrégé de l'entité, 20 caractères au plus. Attribut du socle commun de la structure hospitalière (libelle_reduit)."
