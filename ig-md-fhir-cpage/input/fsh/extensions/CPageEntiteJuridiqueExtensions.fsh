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

// ── Attributs de portée CPAGE hors modules ─────────────────────────────────────────
// Déplacés depuis l'IG common : les attributs de portée CPAGE ne sont exposés que par l'IG CPage.

// =============================================
// Extensions : Entité Juridique (Common IG)
// =============================================
// Extensions génériques applicables à toute entité juridique hospitalière.
// Champs spécifiques CPage (receveur, URSSAF, TVA...) → ig-md-fhir-cpage.
// Source Oracle : STR.CHO

// ── Statut juridique (STATCH / LIBJCH) ───────────────────────────────────────

Extension: EJStatutJuridiqueExtension
Id: ej-statut-juridique
Title: "Statut juridique de l'entité"
Description: "Code et libellé du statut juridique de l'établissement (STATCH / LIBJCH)."
Context: Organization

* extension contains
    code    0..1 MS and
    libelle 0..1 MS

* extension[code].value[x] only string
* extension[code] ^short = "Code statut juridique (STATCH — 6 chars)"

* extension[libelle].value[x] only string
* extension[libelle] ^short = "Libellé du statut juridique (LIBJCH — 30 chars)"

// ── Numéro CPCM (CPCMCH) ─────────────────────────────────────────────────────

Extension: EJCodeCpcmExtension
Id: ej-code-cpcm
Title: "Numéro CPCM"
Description: "Numéro CPCM de l'établissement (CPCMCH — 13 chars)."
Context: Organization

* value[x] only string
* valueString ^short = "Numéro CPCM (CPCMCH)"

// ── Catégorie PMSI (CAPMCH) ───────────────────────────────────────────────────

Extension: EJCategoriePmsiExtension
Id: ej-categorie-pmsi
Title: "Catégorie PMSI"
Description: """
Catégorie d'établissement PMSI (CAPMCH — 2 chars).
Valeurs autorisées : 10 | 20 | 21 | 22 | 30 | 40.
"""
Context: Organization

* value[x] only code
* valueCode from EJCategoriePmsiVS (required)
* valueCode ^short = "Catégorie PMSI (CAPMCH)"

ValueSet: EJCategoriePmsiVS
Id: ej-categorie-pmsi-vs
Title: "Catégorie PMSI"
Description: "Catégories d'établissement PMSI (CAPMCH)."
* ^experimental = false
* ^meta.profile = "http://hl7.org/fhir/StructureDefinition/shareablevalueset"
* EJCategoriePmsiCS#10 "MCO public"
* EJCategoriePmsiCS#20 "Psychiatrie publique"
* EJCategoriePmsiCS#21 "Psychiatrie privée"
* EJCategoriePmsiCS#22 "MCO privé"
* EJCategoriePmsiCS#30 "SSR public"
* EJCategoriePmsiCS#40 "SSR privé"

CodeSystem: EJCategoriePmsiCS
Id: ej-categorie-pmsi-cs
Title: "Catégorie PMSI"
Description: "Catégories d'établissement PMSI (CAPMCH) : MCO public, Psychiatrie publique, Psychiatrie privée, MCO privé, SSR public, SSR privé."
* ^experimental = false
* ^caseSensitive = true
* ^meta.profile = "http://hl7.org/fhir/StructureDefinition/shareablecodesystem"
* #10 "MCO public"
* #20 "Psychiatrie publique"
* #21 "Psychiatrie privée"
* #22 "MCO privé"
* #30 "SSR public"
* #40 "SSR privé"

// ── Code CEDEX (COCECH) ───────────────────────────────────────────────────────

Extension: EJCodeCedexExtension
Id: ej-code-cedex
Title: "Code CEDEX"
Description: "Code CEDEX de l'adresse du siège (COCECH — 5 chars)."
Context: Organization

* value[x] only string
* valueString ^short = "Code CEDEX (COCECH)"

// ── Localisation DOM/TOM (CDOMCH) ─────────────────────────────────────────────

Extension: EJLocalisationDomTomExtension
Id: ej-localisation-dom-tom
Title: "Localisation DOM/TOM"
Description: """
Localisation de l'établissement dans les Départements et Régions d'Outre-Mer (CDOMCH).
Valeurs : 970 (Métropole) | 971 (Guadeloupe) | 972 (Martinique) | 973 (Guyane) | 974 (Réunion).
"""
Context: Organization

* value[x] only code
* valueCode from EJLocalisationDomTomVS (required)
* valueCode ^short = "Code localisation DOM/TOM (CDOMCH)"

ValueSet: EJLocalisationDomTomVS
Id: ej-localisation-dom-tom-vs
Title: "Localisation DOM/TOM"
Description: "Localisation de l'établissement en métropole ou dans un département/région d'outre-mer (CDOMCH) : Métropole, Guadeloupe, Martinique, Guyane ou La Réunion."
* ^experimental = false
* ^meta.profile = "http://hl7.org/fhir/StructureDefinition/shareablevalueset"
* EJLocalisationDomTomCS#970 "Métropole"
* EJLocalisationDomTomCS#971 "Guadeloupe"
* EJLocalisationDomTomCS#972 "Martinique"
* EJLocalisationDomTomCS#973 "Guyane"
* EJLocalisationDomTomCS#974 "La Réunion"

CodeSystem: EJLocalisationDomTomCS
Id: ej-localisation-dom-tom-cs
Title: "Localisation DOM/TOM"
Description: "Code de localisation de l'établissement en métropole ou dans un département/région d'outre-mer (CDOMCH) : 970=Métropole, 971=Guadeloupe, 972=Martinique, 973=Guyane, 974=La Réunion."
* ^experimental = false
* ^caseSensitive = true
* ^meta.profile = "http://hl7.org/fhir/StructureDefinition/shareablecodesystem"
* #970 "Métropole"
* #971 "Guadeloupe"
* #972 "Martinique"
* #973 "Guyane"
* #974 "La Réunion"

// ── Numéros émetteur (NNETCH / NNECCH) ────────────────────────────────────────

Extension: EJNumerosEmetteurExtension
Id: ej-numeros-emetteur
Title: "Numéros émetteur EH"
Description: "Numéros émetteur de l'établissement hospitalier (NNETCH / NNECCH)."
Context: Organization

* extension contains
    emetteurEH      0..1 MS and
    emetteurCommun  0..1 MS

* extension[emetteurEH].value[x] only string
* extension[emetteurEH] ^short = "Numéro émetteur de l'EH (NNETCH — 6 chars)"

* extension[emetteurCommun].value[x] only integer
* extension[emetteurCommun] ^short = "Numéro émetteur commun à tous les EH (NNECCH)"

// ── Indicateur arrondissement (ARROCH) ────────────────────────────────────────

Extension: EJIndicateurArrondissementExtension
Id: ej-indicateur-arrondissement
Title: "Indicateur arrondissement"
Description: "Indique si l'établissement est dans un arrondissement (ARROCH : O=Oui / N=Non)."
Context: Organization

* value[x] only boolean
* valueBoolean ^short = "Arrondissement (ARROCH : O→true / N→false)"
