// =============================================
// Extensions CPage : Entité Juridique (STR.CHO)
// =============================================
// Extensions spécifiques CPage pour le profil CPageEntiteJuridiqueProfile.

// ── Receveur comptable ────────────────────────────────────────────────────────
// Bloc complet du receveur comptable de l'établissement.

Extension: CPageEJReceveurExtension
Id: cpage-ej-receveur
Title: "Receveur comptable de l'établissement"
Description: """
Informations du receveur comptable de l'établissement hospitalier (table STR.CHO).
Contient les coordonnées postales, le RIB/IBAN et les contacts du receveur.
"""
Context: Organization

* extension contains
    raisonSociale  0..1 MS and
    adresse        0..1 MS and
    rib            0..1 MS and
    bicIban        0..1 MS and
    posteComptable 0..1 MS and
    telephone      0..1 MS and
    telephoneCompl 0..1 MS

// Raison sociale (RAISCH)
* extension[raisonSociale].value[x] only string
* extension[raisonSociale] ^short = "Raison sociale du receveur (RAISCH — 40 chars)"

// Adresse (AD1RCH/AD2RCH/AD3RCH/BUDRCH/COP_NCPOPO2)
* extension[adresse].value[x] only Address
* extension[adresse].valueAddress.line 0..3
* extension[adresse].valueAddress.line ^short = "Lignes adresse (AD1RCH/AD2RCH/AD3RCH)"
* extension[adresse].valueAddress.city 0..1
* extension[adresse].valueAddress.city ^short = "Ville (BUDRCH)"
* extension[adresse].valueAddress.postalCode 0..1
* extension[adresse].valueAddress.postalCode ^short = "Code postal (COP_NCPOPO2)"
* extension[adresse].valueAddress.country = "FR"
* extension[adresse] ^short = "Adresse postale du receveur"

// RIB (CBARCH/CGURCH/CCBRCH/CCIRCH/CCPRCH)
* extension[rib].extension contains
    codeBanque  0..1 MS and
    codeGuichet 0..1 MS and
    numCompte   0..1 MS and
    cleRib      0..1 MS and
    centreCcp   0..1 MS
* extension[rib].extension[codeBanque].value[x] only string
* extension[rib].extension[codeBanque] ^short = "Code banque (CBARCH — 5 chars)"
* extension[rib].extension[codeGuichet].value[x] only string
* extension[rib].extension[codeGuichet] ^short = "Code guichet (CGURCH — 5 chars)"
* extension[rib].extension[numCompte].value[x] only string
* extension[rib].extension[numCompte] ^short = "Numéro de compte (CCBRCH — 11 chars)"
* extension[rib].extension[cleRib].value[x] only string
* extension[rib].extension[cleRib] ^short = "Clé RIB (CCIRCH — 2 chars)"
* extension[rib].extension[centreCcp].value[x] only string
* extension[rib].extension[centreCcp] ^short = "Centre CCP (CCPRCH — 15 chars)"
* extension[rib] ^short = "Coordonnées bancaires RIB du receveur"

// BIC/IBAN (CBICCH/CIBACH)
* extension[bicIban].extension contains
    bic  0..1 MS and
    iban 0..1 MS
* extension[bicIban].extension[bic].value[x] only string
* extension[bicIban].extension[bic] ^short = "Code BIC (CBICCH — 11 chars)"
* extension[bicIban].extension[iban].value[x] only string
* extension[bicIban].extension[iban] ^short = "Code IBAN (CIBACH — 34 chars)"
* extension[bicIban] ^short = "BIC / IBAN du receveur"

// Poste comptable (POSCCH)
* extension[posteComptable].value[x] only string
* extension[posteComptable] ^short = "Poste comptable du receveur (POSCCH — 6 chars)"

// Téléphones (TELRCH / TELCCH)
* extension[telephone].value[x] only string
* extension[telephone] ^short = "Téléphone du receveur (TELRCH — 20 chars)"

* extension[telephoneCompl].value[x] only string
* extension[telephoneCompl] ^short = "Téléphone complémentaire du receveur (TELCCH — 20 chars)"

// ── Numéros organismes patronaux ──────────────────────────────────────────────

Extension: CPageEJOrganismesPatronauxExtension
Id: cpage-ej-organismes-patronaux
Title: "Numéros d'organismes patronaux"
Description: """
Numéros d'identification auprès des organismes sociaux et patronaux
(table STR.CHO — CACTCH, CRECCH, CNAVCH, IRCACH, CAMACH, CNRACH, URNOCH/URCOCH/URLICH).
"""
Context: Organization

* extension contains
    accidentTravail       0..1 MS and
    retraiteComplementaire 0..1 MS and
    cnavts                0..1 MS and
    ircantec              0..1 MS and
    camarca               0..1 MS and
    cnracl                0..1 MS and
    urssaf                0..1 MS

* extension[accidentTravail].value[x] only string
* extension[accidentTravail] ^short = "N° caisse accident du travail (CACTCH — 7 chars)"

* extension[retraiteComplementaire].value[x] only string
* extension[retraiteComplementaire] ^short = "N° retraite complémentaire (CRECCH — 6 chars)"

* extension[cnavts].value[x] only string
* extension[cnavts] ^short = "N° section CNAVTS (CNAVCH — 10 chars)"

* extension[ircantec].value[x] only string
* extension[ircantec] ^short = "N° IRCANTEC (IRCACH — 13 chars)"

* extension[camarca].value[x] only string
* extension[camarca] ^short = "N° CAMARCA (CAMACH — 12 chars)"

* extension[cnracl].value[x] only string
* extension[cnracl] ^short = "N° CNRACL (CNRACH — 6 chars)"

* extension[urssaf].extension contains
    numero  0..1 MS and
    code    0..1 MS and
    libelle 0..1 MS
* extension[urssaf].extension[numero].value[x] only string
* extension[urssaf].extension[numero] ^short = "N° URSSAF (URNOCH — 15 chars)"
* extension[urssaf].extension[code].value[x] only string
* extension[urssaf].extension[code] ^short = "Code URSSAF (URCOCH — 4 chars)"
* extension[urssaf].extension[libelle].value[x] only string
* extension[urssaf].extension[libelle] ^short = "Libellé URSSAF (URLICH — 15 chars)"
* extension[urssaf] ^short = "URSSAF (numéro / code / libellé)"

// ── Paramètres TVA ────────────────────────────────────────────────────────────

Extension: CPageEJParametresTvaExtension
Id: cpage-ej-parametres-tva
Title: "Paramètres de TVA"
Description: """
Paramètres de TVA de l'établissement (table STR.CHO).
Taux récupérables exercice en cours et suivant, comptes budgétaires exploitation et investissement.
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
* extension[tauxRecuperableEnCours] ^short = "Taux TVA récupérable exercice en cours % (TVARCH)"

* extension[tauxRecuperableSuivant].value[x] only decimal
* extension[tauxRecuperableSuivant] ^short = "Taux TVA récupérable exercice suivant % (TVASCH)"

* extension[exploitationLettre].value[x] only string
* extension[exploitationLettre] ^short = "Lettre budgétaire TVA exploitation (LTVACH — 1 char)"

* extension[exploitationCompte].value[x] only string
* extension[exploitationCompte] ^short = "Compte TVA exploitation (CTVACH — 10 chars)"

* extension[investissementLettre].value[x] only string
* extension[investissementLettre] ^short = "Lettre budgétaire TVA investissement (LTVICH — 1 char)"

* extension[investissementCompte].value[x] only string
* extension[investissementCompte] ^short = "Compte TVA investissement (CTVICH — 10 chars)"

// ── Indicateur BIC (TBICCH) ───────────────────────────────────────────────────

Extension: CPageEJIndicateurBicExtension
Id: cpage-ej-indicateur-bic
Title: "Indicateur de traitement BIC"
Description: "Indicateur de traitement du code BIC (TBICCH — 1 char)."
Context: Organization

* value[x] only string
* valueString ^short = "Indicateur BIC (TBICCH)"

// ── Comptabilité M22 (CM22CH) ─────────────────────────────────────────────────

Extension: CPageEJComptabiliteM22Extension
Id: cpage-ej-comptabilite-m22
Title: "Comptabilité M22 activée"
Description: "Indique si l'établissement utilise la comptabilité M22 (CM22CH : O=true / N=false)."
Context: Organization

* value[x] only boolean
* valueBoolean ^short = "Comptabilité M22 (CM22CH)"

// ── Identifiant TPG (ITPGCH) ──────────────────────────────────────────────────

Extension: CPageEJIdentifiantTpgExtension
Id: cpage-ej-identifiant-tpg
Title: "Identifiant TPG"
Description: "Identifiant de la Trésorerie de Paiement et de Gestion (ITPGCH — 6 chars)."
Context: Organization

* value[x] only string
* valueString ^short = "Identifiant TPG (ITPGCH)"
