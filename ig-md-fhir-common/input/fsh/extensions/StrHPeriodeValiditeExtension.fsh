// =============================================
// Extension : Période de validité d'un site de la structure hospitalière
// =============================================
// Période de validité fonctionnelle d'une entité physique (Location).
// Les entités organisationnelles (Organization) utilisent l'extension standard
// organization-period héritée de FR Core (usePeriod) ; ni FR Core ni HL7 n'ont
// d'élément équivalent pour Location.

Extension: StrHPeriodeValiditeExtension
Id: strh-periode-validite
Title: "Période de validité d'un site de la structure hospitalière"
Description: "Période de validité fonctionnelle d'une entité physique de la structure hospitalière : date de début obligatoire, date de fin vide tant que l'entité est ouverte."
Context: Location

* value[x] only Period
* valuePeriod.start 1..1 MS
* valuePeriod.start ^short = "Date de début de validité"
* valuePeriod.end 0..1 MS
* valuePeriod.end ^short = "Date de fin de validité (vide tant que l'entité est ouverte)"
