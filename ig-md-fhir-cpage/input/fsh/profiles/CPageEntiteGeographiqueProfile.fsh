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
Porte aussi les extensions des autres attributs de portée CPAGE de l'entité, définies ici et non dans l'IG common.
"""

* extension contains
    CPageEGDatesActivationT2AExtension     named datesActivationT2A      0..1 MS and
    CPageEGParametresTvaExtension          named parametresTva            0..1 MS and
    CPageEGCoefficientsTarifairesExtension named coefficientsTarifaires  0..1 MS and
    EGSecteurSanitaireExtension          named secteurSanitaire           0..1 MS and
    EGCodeNafExtension                   named codeNaf                    0..1 MS and
    EGLibelleLocalisationExtension       named libelleLocalisation        0..1 MS and
    EGIndicateurSaeExtension             named indicateurSae              0..1 MS and
    EGHorairesExtension                  named horaires                   0..1 MS and
    EGCoeffGeoT2AExtension               named coefficientGeoT2A          0..1 MS and
    EGCoeffTransitionT2AExtension        named coefficientTransitionT2A   0..1 MS

* extension[datesActivationT2A]     ^short = "14 dates d'activation T2A par type/activité (DB*/DF*)"
* extension[parametresTva]          ^short = "Paramètres TVA (TVAIET/TVARET/TVASET/LTVAET/CTVAET/LTVIET/CTVIET)"
* extension[coefficientsTarifaires] ^short = "Coefficients tarifaires (CPRUET/CMCOET/CFISCET/CSEGURET)"
* extension[secteurSanitaire] ^short = "Secteur sanitaire (SSSA_SESASSA — FK SSSA)"
* extension[codeNaf] ^short = "Code NAF (CNAFET — 6 chars)"
* extension[libelleLocalisation] ^short = "Libellé de localisation (LILOET — 40 chars)"
* extension[indicateurSae] ^short = "Déclarer séparément dans la SAE (DSAEET : O/N)"
* extension[horaires] ^short = "Horaires d'ouverture (HORAIRES_OUVERTURE — 38 chars)"
* extension[coefficientGeoT2A] ^short = "Coefficient géographique T2A (CGEOET — entre 1 et 2)"
* extension[coefficientTransitionT2A] ^short = "Coefficient de transition T2A (CTRAET — entre 0 et 2)"
