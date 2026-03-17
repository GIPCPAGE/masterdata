// =============================================
// Extension: Paramètres Payeur Santé
// =============================================

Extension: PayeurSanteExtension
Id: payeur-sante
Title: "Paramètres Payeur Santé"
Description: "Paramètres de gestion pour un organisme payeur dans le secteur de la santé (Sécurité sociale, mutuelles, etc.)"
* ^url = "http://cpage.org/fhir/StructureDefinition/payeur-sante"
* ^version = "1.0.0"
* ^status = #active
* ^context[0].type = #element
* ^context[0].expression = "Organization"

* extension contains
    typePayeur 0..1 MS and
    codeCentre 0..1 MS and
    numeroCaisse 0..1 MS and
    grandRegime 0..1 MS and
    numeroOrganisme 0..1 MS and
    flagEclatement 0..1 MS and
    delaiPec 0..1 MS

* extension[typePayeur] ^short = "Type de payeur"
* extension[typePayeur] ^definition = "Type de payeur (organisme obligatoire, complémentaire, etc.)"
* extension[typePayeur].value[x] only string
* extension[typePayeur].valueString 1..1

* extension[codeCentre] ^short = "Code centre"
* extension[codeCentre] ^definition = "Code du centre de gestion"
* extension[codeCentre].value[x] only string
* extension[codeCentre].valueString 1..1

* extension[numeroCaisse] ^short = "Numéro de caisse"
* extension[numeroCaisse] ^definition = "Numéro d'identification de la caisse"
* extension[numeroCaisse].value[x] only string
* extension[numeroCaisse].valueString 1..1

* extension[grandRegime] ^short = "Grand régime"
* extension[grandRegime] ^definition = "Grand régime de Sécurité sociale (SS, MSA, RSI, etc.)"
* extension[grandRegime].value[x] only CodeableConcept
* extension[grandRegime].valueCodeableConcept 1..1
* extension[grandRegime].valueCodeableConcept from GrandRegimeVS (required)

* extension[numeroOrganisme] ^short = "Numéro organisme"
* extension[numeroOrganisme] ^definition = "Numéro d'identification de l'organisme"
* extension[numeroOrganisme].value[x] only string
* extension[numeroOrganisme].valueString 1..1

* extension[flagEclatement] ^short = "Flag éclatement"
* extension[flagEclatement] ^definition = "Flag pour la gestion des éclatements de saisie"
* extension[flagEclatement].value[x] only string
* extension[flagEclatement].valueString 1..1

* extension[delaiPec] ^short = "Délai de prise en charge"
* extension[delaiPec] ^definition = "Délai de prise en charge en jours"
* extension[delaiPec].value[x] only integer
* extension[delaiPec].valueInteger 1..1
