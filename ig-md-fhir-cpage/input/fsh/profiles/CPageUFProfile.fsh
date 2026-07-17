// =============================================
// Profil CPage : Unité Fonctionnelle (STR.UFO)
// =============================================

Profile: CPageUFProfile
Parent: UFProfile
Id: cpage-uf-profile
Title: "Unité Fonctionnelle (CPage)"
Description: """
Profil CPage pour l'UF hospitalière.

Hérite de `UFProfile` (ig-md-fhir-common) et ajoute les 3 modules CPage :
- Module MAL : lits, étiquettes, options patients, fermetures automatiques, PMSI
- Module ECO : TVA, magasin, prestataire, paramètres comptables
- Module PER : personnel/RH, indicateurs paie
"""

* extension contains
    CPageUFModuleMalExtension named moduleMal 0..1 MS and
    CPageUFModuleEcoExtension named moduleEco 0..1 MS and
    CPageUFModulePerExtension named modulePer 0..1 MS

* extension[moduleMal] ^short = "Module CPage MAL — données patients (UFM_*)"
* extension[moduleEco] ^short = "Module CPage ECO — comptabilité (UFE_*)"
* extension[modulePer] ^short = "Module CPage PER — personnel (UFP_*)"
