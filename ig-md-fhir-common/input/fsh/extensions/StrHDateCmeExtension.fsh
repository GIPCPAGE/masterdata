// =============================================
// Extension : Date CME
// =============================================
// Date associée à la commission médicale d'établissement (CME), portée à titre d'attribut LOCAL
// par plusieurs entités de la structure hospitalière (pôle, service...).
// Ni FR Core ni HL7 n'ont d'élément équivalent.

Extension: StrHDateCmeExtension
Id: strh-date-cme
Title: "Date CME"
Description: "Date associée à la commission médicale d'établissement (CME) pour l'entité. Attribut de portée LOCAL, actif selon le tenant."
Context: Organization

* value[x] only date
* valueDate ^short = "Date de la commission médicale d'établissement"
