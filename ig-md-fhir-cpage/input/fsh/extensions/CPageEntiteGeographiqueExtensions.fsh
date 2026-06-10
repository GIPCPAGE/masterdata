// =============================================
// Extensions CPage : Entité Géographique (STR.ETA)
// =============================================
// Champs spécifiques CPage : dates d'activation T2A, TVA, coefficients tarifaires.

// ── Dates d'activation T2A par type de séjour ────────────────────────────────
// 14 dates regroupées en un bloc structuré.
// DB** = Date de mise en application des Bases de Remboursement distinctes
// DF** = Date de mise en application de la Facturation Individuelle
// *E = Externe / *H = Hospitalisation

Extension: CPageEGDatesActivationT2AExtension
Id: cpage-eg-dates-activation-t2a
Title: "Dates d'activation T2A par type de séjour"
Description: """
Dates de mise en application des calculs T2A pour chaque type d'activité
de l'établissement (table STR.ETA — colonnes DBM*/DBS*/DBP*/DBL*/DFM*/DFS*/DFP*/DFL*).

DB** = bases de remboursements distinctes / DF** = facturation individuelle.
*E = Externe / *H = Hospitalisation.
"""
Context: Organization

* extension contains
    // MCO/HAD - Bases remboursement
    dbMcoHadExterne      0..1 and
    dbMcoHadHospit       0..1 and
    // SSR - Bases remboursement
    dbSsrExterne         0..1 and
    dbSsrHospit          0..1 and
    // PSY - Bases remboursement
    dbPsyExterne         0..1 and
    dbPsyHospit          0..1 and
    // Long Séjour - Bases remboursement
    dbLongSejour         0..1 and
    // MCO/HAD - Facturation individuelle
    dfMcoHadExterne      0..1 and
    dfMcoHadHospit       0..1 and
    // SSR - Facturation individuelle
    dfSsrExterne         0..1 and
    dfSsrHospit          0..1 and
    // PSY - Facturation individuelle
    dfPsyExterne         0..1 and
    dfPsyHospit          0..1 and
    // Long Séjour - Facturation individuelle
    dfLongSejour         0..1

* extension[dbMcoHadExterne].value[x] only date
* extension[dbMcoHadExterne] ^short = "Bases remboursement MCO/HAD — Externe (DBMEET)"
* extension[dbMcoHadHospit].value[x] only date
* extension[dbMcoHadHospit] ^short = "Bases remboursement MCO/HAD — Hospit (DBMHET)"

* extension[dbSsrExterne].value[x] only date
* extension[dbSsrExterne] ^short = "Bases remboursement SSR — Externe (DBSEET)"
* extension[dbSsrHospit].value[x] only date
* extension[dbSsrHospit] ^short = "Bases remboursement SSR — Hospit (DBSHET)"

* extension[dbPsyExterne].value[x] only date
* extension[dbPsyExterne] ^short = "Bases remboursement PSY — Externe (DBPEET)"
* extension[dbPsyHospit].value[x] only date
* extension[dbPsyHospit] ^short = "Bases remboursement PSY — Hospit (DBPHET)"

* extension[dbLongSejour].value[x] only date
* extension[dbLongSejour] ^short = "Bases remboursement Long Séjour — Hospit (DBLHET)"

* extension[dfMcoHadExterne].value[x] only date
* extension[dfMcoHadExterne] ^short = "Facturation individuelle MCO/HAD — Externe (DFMEET)"
* extension[dfMcoHadHospit].value[x] only date
* extension[dfMcoHadHospit] ^short = "Facturation individuelle MCO/HAD — Hospit (DFMHET)"

* extension[dfSsrExterne].value[x] only date
* extension[dfSsrExterne] ^short = "Facturation individuelle SSR — Externe (DFSEET)"
* extension[dfSsrHospit].value[x] only date
* extension[dfSsrHospit] ^short = "Facturation individuelle SSR — Hospit (DFSHET)"

* extension[dfPsyExterne].value[x] only date
* extension[dfPsyExterne] ^short = "Facturation individuelle PSY — Externe (DFPEET)"
* extension[dfPsyHospit].value[x] only date
* extension[dfPsyHospit] ^short = "Facturation individuelle PSY — Hospit (DFPHET)"

* extension[dfLongSejour].value[x] only date
* extension[dfLongSejour] ^short = "Facturation individuelle Long Séjour (DFLHET)"

// ── Coefficients tarifaires CPage (CPRUET / CMCOET / CFISCET / CSEGURET) ─────

Extension: CPageEGCoefficientsTarifairesExtension
Id: cpage-eg-coefficients-tarifaires
Title: "Coefficients tarifaires CPage"
Description: """
Coefficients tarifaires spécifiques CPage utilisés dans les calculs de facturation
(table STR.ETA — CPRUET, CMCOET, CFISCET, CSEGURET).
"""
Context: Organization

* extension contains
    prudentiel 0..1 MS and
    mco        0..1 MS and
    cfisc      0..1 MS and
    segur      0..1 MS

* extension[prudentiel].value[x] only decimal
* extension[prudentiel] ^short = "Coefficient prudentiel (CPRUET)"

* extension[mco].value[x] only decimal
* extension[mco] ^short = "Coefficient MCO (CMCOET)"

* extension[cfisc].value[x] only decimal
* extension[cfisc] ^short = "Coefficient CFISC (CFISCET)"

* extension[segur].value[x] only decimal
* extension[segur] ^short = "Coefficient SEGUR (CSEGURET)"

// ── Paramètres TVA (même structure que CHO) ───────────────────────────────────
// Réutilise le même modèle que CPageEJParametresTvaExtension (ETA a les mêmes colonnes)

Extension: CPageEGParametresTvaExtension
Id: cpage-eg-parametres-tva
Title: "Paramètres de TVA du site géographique"
Description: """
Paramètres de TVA du site géographique (table STR.ETA).
Même structure que pour l'entité juridique (STR.CHO).
"""
Context: Organization

* extension contains
    tauxRecuperableEnCours  0..1 MS and
    tauxRecuperableSuivant  0..1 MS and
    exploitationLettre      0..1 MS and
    exploitationCompte      0..1 MS and
    investissementLettre    0..1 MS and
    investissementCompte    0..1 MS

* extension[tauxRecuperableEnCours].value[x] only decimal
* extension[tauxRecuperableEnCours] ^short = "Taux TVA récupérable exercice en cours (TVARET)"
* extension[tauxRecuperableSuivant].value[x] only decimal
* extension[tauxRecuperableSuivant] ^short = "Taux TVA récupérable exercice suivant (TVASET)"
* extension[exploitationLettre].value[x] only string
* extension[exploitationLettre] ^short = "Lettre budgétaire TVA exploitation (LTVAET)"
* extension[exploitationCompte].value[x] only string
* extension[exploitationCompte] ^short = "Compte TVA exploitation (CTVAET)"
* extension[investissementLettre].value[x] only string
* extension[investissementLettre] ^short = "Lettre budgétaire TVA investissement (LTVIET)"
* extension[investissementCompte].value[x] only string
* extension[investissementCompte] ^short = "Compte TVA investissement (CTVIET)"
