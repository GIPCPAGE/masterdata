// =============================================
// Extension : Nationalité associée au pays
// =============================================
// Valeur déduite, non normalisée — usage informatif.
// Correspond au champ nationalite du modèle de données.

Extension: PaysNationaliteExt
Id: pays-nationalite-ext
Title: "Nationalité associée"
Description: "Libellé de la nationalité associée au pays. Exemple : 'française' pour la France, 'allemande' pour l'Allemagne. Valeur déduite, non normalisée — usage informatif pour les formulaires et listes de sélection."
Context: Location
* ^url = "https://www.cpage.fr/ig/masterdata/common/StructureDefinition/pays-nationalite-ext"
* ^version = "1.0.0"
* ^status = #active
* ^context[0].type = #element
* ^context[0].expression = "Location"

* value[x] only string
* valueString 1..1 MS
* valueString ^short = "Nationalité (ex : française, allemande)"
* valueString ^definition = "Libellé de nationalité au féminin singulier selon la convention française. Exemples : 'française' (FR), 'allemande' (DE), 'espagnole' (ES). Valeur informative, non issue d'une terminologie normée."
