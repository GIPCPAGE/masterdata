// =============================================
// Extension: Paramètres comptables Fournisseur
// =============================================

Extension: FournisseurComptabiliteExtension
Id: fournisseur-comptabilite
Title: "Paramètres comptables Fournisseur"
Description: "Paramètres de comptabilisation pour un fournisseur (comptes classe 2 et 6)"
* ^url = "https://www.cpage.fr/ig/masterdata/common/StructureDefinition/fournisseur-comptabilite"
* ^version = "1.0.0"
* ^status = #active
* ^context[0].type = #element
* ^context[0].expression = "Organization"

* extension contains
    compteLettreClasse2 0..1 MS and
    compteNumeroClasse2 0..1 MS and
    compteLettreClasse6 0..1 MS and
    compteNumeroClasse6 0..1 MS

* extension[compteLettreClasse2] ^short = "Lettre budgétaire classe 2 (LBU2FO)"
* extension[compteLettreClasse2] ^definition = "Code lettre budgétaire associé au compte de tiers classe 2 (immobilisations) — 1 caractère. Correspond à la colonne LBU2FO de la table FOU."
* extension[compteLettreClasse2].value[x] only string
* extension[compteLettreClasse2].valueString 1..1
* extension[compteLettreClasse2].valueString ^maxLength = 1

* extension[compteNumeroClasse2] ^short = "Numéro de compte tiers classe 2 (CPT2FO)"
* extension[compteNumeroClasse2] ^definition = "Numéro du compte de tiers de classe 2 (immobilisations), 10 caractères. Doit commencer par 1-5. Correspond à la colonne CPT2FO de la table FOU."
* extension[compteNumeroClasse2].value[x] only string
* extension[compteNumeroClasse2].valueString 1..1
* extension[compteNumeroClasse2].valueString ^maxLength = 10

* extension[compteLettreClasse6] ^short = "Lettre budgétaire classe 6 (LBU6FO)"
* extension[compteLettreClasse6] ^definition = "Code lettre budgétaire associé au compte de tiers classe 6 (charges) — 1 caractère. Correspond à la colonne LBU6FO de la table FOU."
* extension[compteLettreClasse6].value[x] only string
* extension[compteLettreClasse6].valueString 1..1
* extension[compteLettreClasse6].valueString ^maxLength = 1

* extension[compteNumeroClasse6] ^short = "Numéro de compte tiers classe 6 (CPT6FO)"
* extension[compteNumeroClasse6] ^definition = "Numéro du compte de tiers de classe 6 (charges), 10 caractères. Doit commencer par 1-5. Correspond à la colonne CPT6FO de la table FOU."
* extension[compteNumeroClasse6].value[x] only string
* extension[compteNumeroClasse6].valueString 1..1
* extension[compteNumeroClasse6].valueString ^maxLength = 10
