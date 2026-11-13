// =============================================
// Extension : Libellé de diffusion structure hospitalière
// =============================================
// Libellé destiné aux échanges et aux affichages externes.
// Applicable à toutes les entités de la structure hospitalière
// (Organisation et Location) ; ni FR Core ni HL7 n'ont d'élément équivalent.

Extension: StrHLibelleDiffusionExtension
Id: strh-libelle-diffusion
Title: "Libellé de diffusion structure hospitalière"
Description: "Libellé de diffusion de l'entité de la structure hospitalière, destiné aux échanges et aux affichages externes (250 caractères au plus)."
Context: Organization, Location

* value[x] only string
* valueString ^short = "Libellé de diffusion"
* valueString ^definition = "Libellé de l'entité destiné aux échanges et aux affichages externes, distinct du libellé, du libellé réduit et du libellé court."
