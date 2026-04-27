// =============================================
// Extension: Commentaires Fournisseur
// =============================================

Extension: FournisseurCommentairesExtension
Id: fournisseur-commentaires
Title: "Commentaires Fournisseur"
Description: "Commentaires libres associés à un fournisseur et option d'édition. Correspond aux colonnes COM1FO, COM2FO, COM3FO, EDCOFO de la table FOU."
* ^url = "https://www.cpage.fr/ig/masterdata/common/StructureDefinition/fournisseur-commentaires"
* ^version = "1.0.0"
* ^status = #active
* ^context[0].type = #element
* ^context[0].expression = "Organization"

* extension contains
    commentaire1 0..1 MS and
    commentaire2 0..1 MS and
    commentaire3 0..1 MS and
    editionCommentaire 0..1 MS

* extension[commentaire1] ^short = "Commentaire 1 (COM1FO)"
* extension[commentaire1] ^definition = "Premier commentaire libre associé au fournisseur (60 caractères). Correspond à la colonne COM1FO de la table FOU."
* extension[commentaire1].value[x] only string
* extension[commentaire1].valueString 1..1 MS
* extension[commentaire1].valueString ^maxLength = 60

* extension[commentaire2] ^short = "Commentaire 2 (COM2FO)"
* extension[commentaire2] ^definition = "Deuxième commentaire libre associé au fournisseur (60 caractères). Correspond à la colonne COM2FO de la table FOU."
* extension[commentaire2].value[x] only string
* extension[commentaire2].valueString 1..1 MS
* extension[commentaire2].valueString ^maxLength = 60

* extension[commentaire3] ^short = "Commentaire 3 (COM3FO)"
* extension[commentaire3] ^definition = "Troisième commentaire libre associé au fournisseur (60 caractères). Correspond à la colonne COM3FO de la table FOU."
* extension[commentaire3].value[x] only string
* extension[commentaire3].valueString 1..1 MS
* extension[commentaire3].valueString ^maxLength = 60

* extension[editionCommentaire] ^short = "Édition du commentaire (EDCOFO)"
* extension[editionCommentaire] ^definition = "Indique si les commentaires doivent être imprimés sur les documents édités pour ce fournisseur (O/N). Correspond à la colonne EDCOFO de la table FOU."
* extension[editionCommentaire].value[x] only boolean
* extension[editionCommentaire].valueBoolean 1..1 MS
