// =============================================
// Extension: Attributs Secteur Public
// =============================================

Extension: TiersPublicSectorExtension
Id: tiers-public-sector
Title: "Attributs Secteur Public"
Description: "Attributs spécifiques aux tiers du secteur public : compte de contrepartie en comptabilité publique et code régie"
* ^url = "https://www.cpage.fr/ig/masterdata/common/StructureDefinition/tiers-public-sector"
* ^version = "1.0.0"
* ^status = #active
* ^context[0].type = #element
* ^context[0].expression = "Organization"

* extension contains
    letterCode 0..1 MS and
    accountNumber 0..1 MS and
    regieCode 0..1 MS and
    idTresorerie 0..1 MS

* extension[letterCode] ^short = "Code lettre compte contrepartie"
* extension[letterCode] ^definition = "Code alphabétique identifiant le type de compte de contrepartie en comptabilité publique (1 caractère)"
* extension[letterCode].value[x] only string
* extension[letterCode].valueString 1..1 MS
* extension[letterCode].valueString ^maxLength = 1

* extension[accountNumber] ^short = "Numéro de compte contrepartie"
* extension[accountNumber] ^definition = "Numéro du compte de contrepartie en comptabilité publique (10 caractères)"
* extension[accountNumber].value[x] only string
* extension[accountNumber].valueString 1..1 MS
* extension[accountNumber].valueString ^maxLength = 10

* extension[regieCode] ^short = "Code régie"
* extension[regieCode] ^definition = "Code identifiant une régie d'avance ou de recettes du secteur public (10 caractères max)"
* extension[regieCode].value[x] only string
* extension[regieCode].valueString 1..1 MS
* extension[regieCode].valueString ^maxLength = 10

* extension[idTresorerie] ^short = "Identifiant Trésorerie Générale (IDTGDT)"
* extension[idTresorerie] ^definition = "Code interne identifiant la Trésorerie Générale (TG) rattachée au débiteur (2 caractères). Correspond à la colonne IDTGDT de la table DBT."
* extension[idTresorerie].value[x] only string
* extension[idTresorerie].valueString 1..1 MS
* extension[idTresorerie].valueString ^maxLength = 2
