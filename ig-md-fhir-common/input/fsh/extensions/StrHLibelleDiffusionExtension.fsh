// =============================================
// Extension : Libellé de diffusion structure hospitalière
// =============================================
// Libellé destiné à la diffusion (documents, éditions), plus long que le libellé réduit
// (250 caractères au plus). Attribut du socle commun de la structure hospitalière.

Extension: StrHLibelleDiffusionExtension
Id: strh-libelle-diffusion
Title: "Libellé de diffusion structure hospitalière"
Description: "Libellé de diffusion de l'entité de la structure hospitalière (250 caractères au plus)."
Context: Organization, Location

* value[x] only string
* valueString ^short = "Libellé de diffusion"
* valueString ^definition = "Libellé destiné à la diffusion. Attribut du socle commun de la structure hospitalière (libelle_diffusion)."
