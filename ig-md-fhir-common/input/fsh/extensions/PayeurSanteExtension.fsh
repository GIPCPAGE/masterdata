// =============================================
// Extension: Paramètres Payeur Santé
// =============================================

Extension: PayeurSanteExtension
Id: payeur-sante
Title: "Paramètres Payeur Santé"
Description: "Paramètres de gestion pour un organisme payeur dans le secteur de la santé (Sécurité sociale, mutuelles, etc.)"
* ^url = "https://www.cpage.fr/ig/masterdata/common/StructureDefinition/payeur-sante"
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
    delaiPec 0..1 MS and
    participationROC 0..1 MS and
    roc 0..* MS

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

// ── ROC (Référentiel des Organismes Complémentaires) — AMC uniquement ──

* extension[participationROC] ^short = "Indicateur de participation au dispositif ROC"
* extension[participationROC] ^definition = "Indique si l'AMC est référencée et active dans le Référentiel des Organismes Complémentaires (ROC). true = l'AMC participe au tiers payant intégral."
* extension[participationROC].value[x] only boolean
* extension[participationROC].valueBoolean 1..1

// Triplet ROC répétable : un par contexte de facturation (ex: hospitalisation, externe)
* extension[roc] ^short = "Référencement ROC de l'AMC"
* extension[roc] ^definition = "Triplet d'identification ROC pour un contexte de facturation donné (hospitalisation, externe, etc.). Répétable car une AMC peut avoir plusieurs contrats ROC selon le secteur."
* extension[roc].extension contains
    numeroAMC 1..1 MS and
    codeCSR 1..1 MS and
    convention 0..1 MS

* extension[roc].extension[numeroAMC] ^short = "Numéro AMC (ROC)"
* extension[roc].extension[numeroAMC] ^definition = "Numéro de l'organisme complémentaire dans le Référentiel ROC, attribué par la CNAM (9 caractères)."
* extension[roc].extension[numeroAMC].value[x] only string
* extension[roc].extension[numeroAMC].valueString 1..1
* extension[roc].extension[numeroAMC].valueString ^maxLength = 9

* extension[roc].extension[codeCSR] ^short = "Code CSR"
* extension[roc].extension[codeCSR] ^definition = "Code du Centre de Service ROC (CSR) rattaché à l'AMC pour ce contexte de facturation."
* extension[roc].extension[codeCSR].value[x] only string
* extension[roc].extension[codeCSR].valueString 1..1

* extension[roc].extension[convention] ^short = "Convention / contexte de facturation"
* extension[roc].extension[convention] ^definition = "Type de convention ROC identifiant le contexte de facturation : hospitalisation (H), soins externes (E), ou autre contrat spécifique."
* extension[roc].extension[convention].value[x] only code
* extension[roc].extension[convention].valueCode 1..1
