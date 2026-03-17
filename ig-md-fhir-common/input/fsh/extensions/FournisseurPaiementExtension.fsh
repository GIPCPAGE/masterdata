// =============================================
// Extension: Paramètres de paiement Fournisseur
// =============================================

Extension: FournisseurPaiementExtension
Id: fournisseur-paiement
Title: "Paramètres de paiement Fournisseur"
Description: "Paramètres de paiement pour un fournisseur (délais, montants, conditions)"
* ^url = "http://cpage.org/fhir/StructureDefinition/fournisseur-paiement"
* ^version = "1.0.0"
* ^status = #active
* ^context[0].type = #element
* ^context[0].expression = "Organization"

* extension contains
    delaiPaiement 0..1 MS and
    jourPaiement 0..1 MS and
    montantMinimum 0..1 MS and
    tauxTransitaire 0..1 MS and
    escomptable 0..1 MS

* extension[delaiPaiement] ^short = "Délai de paiement"
* extension[delaiPaiement] ^definition = "Délai de paiement convenu en jours (ex: 30, 60, 90)"
* extension[delaiPaiement].value[x] only integer
* extension[delaiPaiement].valueInteger 1..1

* extension[jourPaiement] ^short = "Jour de paiement"
* extension[jourPaiement] ^definition = "Jour du mois prévu pour le paiement (1-31)"
* extension[jourPaiement].value[x] only integer
* extension[jourPaiement].valueInteger 1..1

* extension[montantMinimum] ^short = "Montant minimum"
* extension[montantMinimum] ^definition = "Montant minimum de paiement en euros"
* extension[montantMinimum].value[x] only decimal
* extension[montantMinimum].valueDecimal 1..1

* extension[tauxTransitaire] ^short = "Taux transitaire"
* extension[tauxTransitaire] ^definition = "Taux transitaire en pourcentage"
* extension[tauxTransitaire].value[x] only decimal
* extension[tauxTransitaire].valueDecimal 1..1

* extension[escomptable] ^short = "Escomptable"
* extension[escomptable] ^definition = "Indique si le fournisseur peut bénéficier d'escompte"
* extension[escomptable].value[x] only boolean
* extension[escomptable].valueBoolean 1..1
