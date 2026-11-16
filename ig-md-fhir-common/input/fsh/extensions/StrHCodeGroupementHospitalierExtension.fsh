// =============================================
// Extension : Code du groupement hospitalier
// =============================================
// Code du groupement hospitalier porté, à titre d'attribut LOCAL, par plusieurs entités de la
// structure hospitalière (centre de responsabilité, section d'analyse...). Ce n'est pas un
// rattachement hiérarchique : le lien de hiérarchie est porté par partOf.
// Ni FR Core ni HL7 n'ont d'élément équivalent.

Extension: StrHCodeGroupementHospitalierExtension
Id: strh-code-groupement-hospitalier
Title: "Code du groupement hospitalier"
Description: "Code du groupement hospitalier dont relève l'entité (2 caractères). Attribut de portée LOCAL, actif selon le tenant ; il ne remplace pas le rattachement hiérarchique, porté par partOf."
Context: Organization

* value[x] only string
* valueString ^short = "Code du groupement hospitalier (2 caractères)"
