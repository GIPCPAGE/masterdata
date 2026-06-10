// =============================================
// Profil CPage : Entité Géographique (STR.ETA)
// =============================================

Profile: CPageEntiteGeographiqueProfile
Parent: EntiteGeographiqueProfile
Id: cpage-entite-geographique-profile
Title: "Entité Géographique (CPage)"
Description: """
Profil CPage pour l'entité géographique hospitalière.

Hérite de `EntiteGeographiqueProfile` (ig-md-fhir-common) et ajoute :
- Dates d'activation T2A par type de séjour (MCO/SSR/PSY/Long séjour × Externe/Hospit × bases/facturation)
- Paramètres de TVA (mêmes colonnes que STR.CHO)
- Coefficients tarifaires CPage (prudentiel, MCO, CFISC, SEGUR)
"""

* extension contains
    CPageEGDatesActivationT2AExtension     named datesActivationT2A      0..1 MS and
    CPageEGParametresTvaExtension          named parametresTva            0..1 MS and
    CPageEGCoefficientsTarifairesExtension named coefficientsTarifaires  0..1 MS

* extension[datesActivationT2A]     ^short = "14 dates d'activation T2A par type/activité (DB*/DF*)"
* extension[parametresTva]          ^short = "Paramètres TVA (TVAIET/TVARET/TVASET/LTVAET/CTVAET/LTVIET/CTVIET)"
* extension[coefficientsTarifaires] ^short = "Coefficients tarifaires (CPRUET/CMCOET/CFISCET/CSEGURET)"
