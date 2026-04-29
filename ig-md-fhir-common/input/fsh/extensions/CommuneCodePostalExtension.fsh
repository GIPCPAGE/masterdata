// =============================================
// Extension : Code postal de la commune
// =============================================
// Répétable : une commune peut être couverte par plusieurs codes postaux
// (grandes villes, communes géographiquement étendues, arrondissements).
// Chaque occurrence regroupe le code postal (5 chiffres) et le nom postal
// associé (libellé La Poste HEXASIMAL, ex : "PARIS 15" ou "LYON CEDEX 03").
// Correspond à la propriété `codePostal` (répétable) du CodeSystem communes-fr-cs.

Extension: CommuneCodePostalExt
Id: commune-code-postal-ext
Title: "Code postal de la commune"
Description: "Code postal rattaché à la commune avec son nom postal associé. Répétable : une commune peut avoir plusieurs codes postaux. Chaque instance regroupe un code à 5 chiffres et le libellé postal correspondant, issus de la base La Poste HEXASIMAL."
Context: Location
* ^url = "https://www.cpage.fr/ig/masterdata/common/StructureDefinition/commune-code-postal-ext"
* ^version = "1.0.0"
* ^status = #active
* ^context[0].type = #element
* ^context[0].expression = "Location"

* extension contains
    codePostal 1..1 MS and
    nomPostal 0..1 MS

* extension[codePostal] ^short = "Code postal (5 chiffres)"
* extension[codePostal] ^definition = "Code postal de la commune ou du secteur concerné. Format : 5 chiffres numériques. Issu de la base La Poste HEXASIMAL."
* extension[codePostal].value[x] only string
* extension[codePostal].valueString 1..1
* extension[codePostal].valueString ^maxLength = 5

* extension[nomPostal] ^short = "Nom postal associé au code postal"
* extension[nomPostal] ^definition = "Libellé postal tel que défini par La Poste (base HEXASIMAL) pour ce code postal. Exemples : 'PARIS 15', 'LYON CEDEX 03', 'BELLEVILLE EN BEAUJOLAIS'."
* extension[nomPostal].value[x] only string
* extension[nomPostal].valueString 1..1
* extension[nomPostal].valueString ^maxLength = 38
