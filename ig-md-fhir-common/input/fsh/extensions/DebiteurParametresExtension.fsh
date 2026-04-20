// =============================================
// Extension: Paramètres Débiteur
// =============================================

Extension: DebiteurParametresExtension
Id: debiteur-parametres
Title: "Paramètres Débiteur"
Description: "Paramètres de gestion pour un débiteur/client"
* ^url = "https://www.cpage.fr/ig/masterdata/common/StructureDefinition/debiteur-parametres"
* ^version = "1.0.0"
* ^status = #active
* ^context[0].type = #element
* ^context[0].expression = "Organization"

* extension contains
    compteLettre 0..1 MS and
    typeResident 0..1 MS and
    typeDebiteur 0..1 MS and
    assuAutorise 0..1 MS and
    forceImpressionCoh 0..1 MS

* extension[compteLettre] ^short = "Compte lettre"
* extension[compteLettre] ^definition = "Compte comptable du débiteur"
* extension[compteLettre].value[x] only string
* extension[compteLettre].valueString 1..1

* extension[typeResident] ^short = "Type de résident"
* extension[typeResident] ^definition = "Type de résident (R=résident, NR=non résident)"
* extension[typeResident].value[x] only code
* extension[typeResident].valueCode 1..1
* extension[typeResident].valueCode from TypeResidentVS (required)

* extension[typeDebiteur] ^short = "Type de débiteur"
* extension[typeDebiteur] ^definition = "Type de débiteur selon classification interne"
* extension[typeDebiteur].value[x] only string
* extension[typeDebiteur].valueString 1..1

* extension[assuAutorise] ^short = "Assurance autorisée"
* extension[assuAutorise] ^definition = "Débiteur autorisé pour les opérations d'assurance"
* extension[assuAutorise].value[x] only boolean
* extension[assuAutorise].valueBoolean 1..1

* extension[forceImpressionCoh] ^short = "Force impression cohérente"
* extension[forceImpressionCoh] ^definition = "Force l'impression cohérente des documents"
* extension[forceImpressionCoh].value[x] only boolean
* extension[forceImpressionCoh].valueBoolean 1..1
