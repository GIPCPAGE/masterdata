// =============================================
// Extension: Paramètres comptables Fournisseur
// =============================================

Extension: FournisseurComptabiliteExtension
Id: fournisseur-comptabilite
Title: "Paramètres comptables Fournisseur"
Description: "Paramètres de comptabilisation pour un fournisseur (comptes classe 2 et 6)"
* ^url = "http://cpage.org/fhir/StructureDefinition/fournisseur-comptabilite"
* ^version = "1.0.0"
* ^status = #active
* ^context[0].type = #element
* ^context[0].expression = "Organization"

* extension contains
    compteLettreClasse2 0..1 MS and
    compteLettreClasse6 0..1 MS

* extension[compteLettreClasse2] ^short = "Compte lettre classe 2"
* extension[compteLettreClasse2] ^definition = "Compte comptable de classe 2 (immobilisations)"
* extension[compteLettreClasse2].value[x] only string
* extension[compteLettreClasse2].valueString 1..1

* extension[compteLettreClasse6] ^short = "Compte lettre classe 6"
* extension[compteLettreClasse6] ^definition = "Compte comptable de classe 6 (charges)"
* extension[compteLettreClasse6].value[x] only string
* extension[compteLettreClasse6].valueString 1..1
