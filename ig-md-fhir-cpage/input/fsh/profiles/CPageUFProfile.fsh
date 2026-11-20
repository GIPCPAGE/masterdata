// =============================================
// Profil CPage : Unité Fonctionnelle (STR.UFO)
// =============================================

Profile: CPageUFProfile
Parent: UFProfile
Id: cpage-uf-profile
Title: "Unité Fonctionnelle (CPage)"
Description: """
Profil CPage pour l'UF hospitalière.

Hérite de `UFProfile` (ig-md-fhir-common) et porte tous les attributs de portée CPAGE
de l'UF, que l'IG common n'expose pas :
- Module MAL : lits, étiquettes, options patients, fermetures automatiques, PMSI
- Module ECO : TVA, magasin, prestataire, paramètres comptables
- Module PER : personnel/RH, indicateurs paie
- Extensions de l'UFO hors modules : type d'UF médicale, indicateurs (séances, lits d'urgence,
  activité libérale, maternité, confidentialité, UF de responsabilité), domaine d'activité,
  types d'autorisation (unité médicale, urgence), catégorie d'UF et regroupements.
"""

* extension contains
    CPageUFModuleMalExtension named moduleMal 0..1 MS and
    CPageUFModuleEcoExtension named moduleEco 0..1 MS and
    CPageUFModulePerExtension named modulePer 0..1 MS and
    UFTypeUFMedicaleExtension named typeUFMedicale 0..1 MS and
    UFIndicateurSeancesExtension named indicateurSeances 0..1 MS and
    UFLitsUrgenceExtension named litsUrgence 0..1 MS and
    UFActiviteLiberaleExtension named activiteLiberale 0..1 MS and
    UFMaterniteExtension named materniteLits 0..1 MS and
    UFConfidentialiteExtension named confidentialite 0..1 MS and
    UFResponsabiliteExtension named ufResponsabilite 0..1 MS and
    UFDomaineActiviteExtension named domaineActivite 0..1 MS and
    UFReacExtension named typeAutorisationUM 0..1 MS and
    UFAutorisationUrgenceExtension named typeAutorisationUrg 0..1 MS and
    UFCategorieCUFExtension named categorieUF 0..1 MS and
    UFRegroupementsExtension named regroupements 0..1 MS

* extension[typeUFMedicale]     ^short = "Type UF médicale (TYPEUF : H=Hosp / E=Externe / D=Divers / A=Autre)"
* extension[indicateurSeances]  ^short = "UF à séances (SEANUF : O/N)"
* extension[litsUrgence]        ^short = "Lits réservés urgence (LURGUF : O/N)"
* extension[activiteLiberale]   ^short = "Activité libérale (ACLIUF : O/N)"
* extension[materniteLits]      ^short = "UF où peuvent naître des bébés (UFMAUF : O/N)"
* extension[confidentialite]    ^short = "Confidentialité de l'UF (CONFUF : O/N)"
* extension[ufResponsabilite]   ^short = "UF de responsabilité (CURMUF : O/N)"
* extension[domaineActivite]    ^short = "Domaine d'activité (DOACUF : M/C/O/N/D/P/S)"
* extension[typeAutorisationUM] ^short = "Type autorisation unité médicale (REACUF — 3 chars)"
* extension[typeAutorisationUrg] ^short = "Type autorisation urgence (AUTOUF — 2 chars)"
* extension[categorieUF]        ^short = "Catégorie d'UF (SCUF_CATGCUF — FK SCUF)"
* extension[regroupements]      ^short = "Regroupements UF (RU1/RU2/URG) et codes analytiques"

* extension[moduleMal] ^short = "Module CPage MAL — données patients (UFM_*)"
* extension[moduleEco] ^short = "Module CPage ECO — comptabilité (UFE_*)"
* extension[modulePer] ^short = "Module CPage PER — personnel (UFP_*)"
