// =============================================
// Extensions CPage : UF — 3 modules (STR.UFO)
// =============================================
// Module UFM : patients/activité médicale (MAL)
// Module UFE : comptabilité/trésorerie (ECO)
// Module UFP : personnel/RH (PER)

// ── Module UFM : Patients / Activité médicale (MAL) ──────────────────────────

Extension: CPageUFModuleMalExtension
Id: cpage-uf-module-mal
Title: "Module MAL — Données patients et activité médicale"
Description: """
Paramètres du module CPage MAL (Patients) pour l'UF (table STR.UFO — champs UFM_*).
Lits, étiquettes, options cliniques, fermetures automatiques, PMSI.
"""
Context: Organization

* extension contains
    // Capacité et activité
    nbLitsInstalles      0..1 MS and
    nbLitsSeances        0..1 MS and
    dureeMoyennePassage  0..1 and
    // Indicateurs
    utiliseCPagePatients 0..1 MS and
    majorationActes      0..1 and
    valeurDefautNuit     0..1 and
    genEnAtCreation      0..1 and
    ufRefonctionnelle    0..1 and
    ufSSR                0..1 and
    // Hospitalisation et fermetures automatiques
    genAutoFinDP         0..1 and
    dureeDP              0..1 and
    genAutoFinSeance     0..1 and
    dureeSeance          0..1 and
    genAutoFinHJ         0..1 and
    dureeHJ              0..1 and
    genAutoFinHN         0..1 and
    dureeHN              0..1 and
    // Permissions et durée séjour
    dureeHabituellePerm  0..1 and
    nbJoursClotureE      0..1 and
    // Type hospitalisation par défaut
    typeHospitalisationDefaut 0..1 and
    codeParcoursSoin    0..1 and
    // Etiquettes
    etiquettes          0..1

* extension[nbLitsInstalles].value[x] only integer
* extension[nbLitsInstalles] ^short = "Nombre de lits installés (UFM_NTLIUF)"

* extension[nbLitsSeances].value[x] only integer
* extension[nbLitsSeances] ^short = "Nombre de lits de séances (UFM_NTSEUF)"

* extension[dureeMoyennePassage].value[x] only integer
* extension[dureeMoyennePassage] ^short = "Durée en minutes d'un passage (UFM_NBMNDH)"

* extension[utiliseCPagePatients].value[x] only boolean
* extension[utiliseCPagePatients] ^short = "UF utilisée par CPage Patients (UFM_FMALUF : O/N)"

* extension[majorationActes].value[x] only boolean
* extension[majorationActes] ^short = "Majoration actes (UFM_SMMAUF : O/N)"

* extension[valeurDefautNuit].value[x] only boolean
* extension[valeurDefautNuit] ^short = "Valeur défaut actes nuit (UFM_VNUIUF : O/N)"

* extension[genEnAtCreation].value[x] only boolean
* extension[genEnAtCreation] ^short = "Génération EN à la création du dossier (UFM_ENAUUF : O/N)"

* extension[ufRefonctionnelle].value[x] only boolean
* extension[ufRefonctionnelle] ^short = "UF activité rééducation fonctionnelle PMSI SSR (UFM_REFOUF : O/N)"

* extension[ufSSR].value[x] only string
* extension[ufSSR] ^short = "Type autorisation SSR (UFM_TSSRUF — 3 chars)"

* extension[genAutoFinDP].value[x] only boolean
* extension[genAutoFinDP] ^short = "Génération auto fin DP/FP (UFM_CAFPUF : O/N)"
* extension[dureeDP].value[x] only integer
* extension[dureeDP] ^short = "Durée en heures DP/FP (UFM_DUFPUF)"

* extension[genAutoFinSeance].value[x] only boolean
* extension[genAutoFinSeance] ^short = "Génération auto fin de séance (UFM_CAFSUF : O/N)"
* extension[dureeSeance].value[x] only integer
* extension[dureeSeance] ^short = "Durée en heures d'une séance (UFM_DUFSUF)"

* extension[genAutoFinHJ].value[x] only boolean
* extension[genAutoFinHJ] ^short = "Génération auto fin hospit de jour (UFM_CAFJUF : O/N)"
* extension[dureeHJ].value[x] only integer
* extension[dureeHJ] ^short = "Durée en heures hospit de jour (UFM_DUFJUF)"

* extension[genAutoFinHN].value[x] only boolean
* extension[genAutoFinHN] ^short = "Génération auto fin hospit de nuit (UFM_CAFNUF : O/N)"
* extension[dureeHN].value[x] only integer
* extension[dureeHN] ^short = "Durée en heures hospit de nuit (UFM_DUFNUF)"

* extension[dureeHabituellePerm].value[x] only integer
* extension[dureeHabituellePerm] ^short = "Durée habituelle permissions en heures (UFM_DUSPUF)"

* extension[nbJoursClotureE].value[x] only integer
* extension[nbJoursClotureE] ^short = "Nb jours avant clôture dossier Externe (UFM_NBJCUF)"

* extension[typeHospitalisationDefaut].value[x] only string
* extension[typeHospitalisationDefaut] ^short = "Type hospit par défaut (UFM_CODETHO — 1 char)"

* extension[codeParcoursSoin].value[x] only string
* extension[codeParcoursSoin] ^short = "Code parcours de soin B2 défaut (UFM_CODEPSC — 3 chars)"

* extension[etiquettes].extension contains
    typeEtiqHospit  0..1 and nbEtiqHospit  0..1 and
    typeEtiqExterne 0..1 and nbEtiqExterne 0..1 and
    typeEtiqUrgence 0..1 and nbEtiqUrgence 0..1 and
    typeEtiqBebe    0..1 and nbEtiqBebe    0..1
* extension[etiquettes].extension[typeEtiqHospit].value[x] only string
* extension[etiquettes].extension[typeEtiqHospit] ^short = "Type étiquette hospitalisé (UFM_ETQHUF)"
* extension[etiquettes].extension[nbEtiqHospit].value[x] only integer
* extension[etiquettes].extension[nbEtiqHospit] ^short = "Nb étiquettes hospitalisé (UFM_NBEHUF)"
* extension[etiquettes].extension[typeEtiqExterne].value[x] only string
* extension[etiquettes].extension[typeEtiqExterne] ^short = "Type étiquette externe (UFM_ETQEUF)"
* extension[etiquettes].extension[nbEtiqExterne].value[x] only integer
* extension[etiquettes].extension[nbEtiqExterne] ^short = "Nb étiquettes externe (UFM_NBEEUF)"
* extension[etiquettes].extension[typeEtiqUrgence].value[x] only string
* extension[etiquettes].extension[typeEtiqUrgence] ^short = "Type étiquette urgence (UFM_ETQUUF)"
* extension[etiquettes].extension[nbEtiqUrgence].value[x] only integer
* extension[etiquettes].extension[nbEtiqUrgence] ^short = "Nb étiquettes urgence (UFM_NBEUUF)"
* extension[etiquettes].extension[typeEtiqBebe].value[x] only string
* extension[etiquettes].extension[typeEtiqBebe] ^short = "Type étiquette bébé (UFM_ETQBUF)"
* extension[etiquettes].extension[nbEtiqBebe].value[x] only integer
* extension[etiquettes].extension[nbEtiqBebe] ^short = "Nb étiquettes bébé (UFM_NBEBUF)"
* extension[etiquettes] ^short = "Paramètres étiquettes (hospitalisé/externe/urgence/bébé)"

// ── Module UFE : Comptabilité / Trésorerie (ECO) ──────────────────────────────

Extension: CPageUFModuleEcoExtension
Id: cpage-uf-module-eco
Title: "Module ECO — Données comptabilité et trésorerie"
Description: """
Paramètres du module CPage ECO (Comptabilité) pour l'UF (table STR.UFO — champs UFE_*).
TVA, magasin, UF prestataire, paramètres comptables.
"""
Context: Organization

* extension contains
    libelleLong          0..1 MS and
    libelleReduit        0..1 MS and
    utiliseCPageEco      0..1 MS and
    autoriseeConsommer   0..1 and
    magasin              0..1 and
    prestataire          0..1 and
    ufSubstitution       0..1 and
    tva                  0..1 and
    ufBoni               0..1 and
    ufMali               0..1 and
    magasinAutoRecep     0..1

* extension[libelleLong].value[x] only string
* extension[libelleLong] ^short = "Libellé long ECO (UFE_LIBCUE — 40 chars)"

* extension[libelleReduit].value[x] only string
* extension[libelleReduit] ^short = "Libellé réduit ECO (UFE_LIBRUE — 20 chars)"

* extension[utiliseCPageEco].value[x] only boolean
* extension[utiliseCPageEco] ^short = "UF utilisée par CPage ECO (UFE_FECOUF : O/N)"

* extension[autoriseeConsommer].value[x] only boolean
* extension[autoriseeConsommer] ^short = "UF autorisée à consommer ECO (UFE_AUTOUE : O/N)"

* extension[magasin].value[x] only string
* extension[magasin] ^short = "Magasin ECO (UFE_MAGAUE : M/N)"

* extension[prestataire].value[x] only boolean
* extension[prestataire] ^short = "UF prestataire ECO (UFE_PRESUE : O/N)"

* extension[ufSubstitution].value[x] only string
* extension[ufSubstitution] ^short = "UF de substitution — clôture (UFE_UFSBUF — 7 chars)"

* extension[tva].extension contains
    tauxExploitationCours   0..1 and tauxExploitationSuivant 0..1 and
    lettreExploitation      0..1 and compteExploitation       0..1 and
    tauxInvestCours         0..1 and tauxInvestSuivant         0..1 and
    lettreInvest            0..1 and compteInvest               0..1
* extension[tva].extension[tauxExploitationCours].value[x] only decimal
* extension[tva].extension[tauxExploitationCours] ^short = "Taux TVA exploitation cours (UFE_PTVAUE)"
* extension[tva].extension[tauxExploitationSuivant].value[x] only decimal
* extension[tva].extension[tauxExploitationSuivant] ^short = "Taux TVA exploitation suivant (UFE_PTSAUE)"
* extension[tva].extension[lettreExploitation].value[x] only string
* extension[tva].extension[lettreExploitation] ^short = "Lettre budg TVA exploitation (UFE_LTVAUE)"
* extension[tva].extension[compteExploitation].value[x] only string
* extension[tva].extension[compteExploitation] ^short = "Compte TVA exploitation (UFE_CTVAUE)"
* extension[tva].extension[tauxInvestCours].value[x] only decimal
* extension[tva].extension[tauxInvestCours] ^short = "Taux TVA investissement cours (UFE_PTVIUE)"
* extension[tva].extension[tauxInvestSuivant].value[x] only decimal
* extension[tva].extension[tauxInvestSuivant] ^short = "Taux TVA investissement suivant (UFE_PTSIUE)"
* extension[tva].extension[lettreInvest].value[x] only string
* extension[tva].extension[lettreInvest] ^short = "Lettre budg TVA investissement (UFE_LTVIUE)"
* extension[tva].extension[compteInvest].value[x] only string
* extension[tva].extension[compteInvest] ^short = "Compte TVA investissement (UFE_CTVIUE)"
* extension[tva] ^short = "Paramètres TVA ECO (exploitation/investissement)"

* extension[ufBoni].value[x] only string
* extension[ufBoni] ^short = "UF Boni ECO (UFE_BONIUE — 7 chars)"

* extension[ufMali].value[x] only string
* extension[ufMali] ^short = "UF Mali ECO (UFE_MALIUE — 7 chars)"

* extension[magasinAutoRecep].value[x] only boolean
* extension[magasinAutoRecep] ^short = "Magasin autorisé réception écran CPage (UFE_ASMAUE : O/N)"

// ── Module UFP : Personnel / RH (PER) ────────────────────────────────────────

Extension: CPageUFModulePerExtension
Id: cpage-uf-module-per
Title: "Module PER — Données personnel et RH"
Description: """
Paramètres du module CPage PER (Ressources Humaines) pour l'UF (table STR.UFO — champs UFP_*).
"""
Context: Organization

* extension contains
    libelleLong         0..1 MS and
    libelleReduit       0..1 MS and
    utiliseCPageRH      0..1 MS and
    travauxIntensifNuit 0..1 and
    indicateurSag       0..1 and
    bureauVote          0..1 and
    tauxTransportPatron 0..1 and
    pourcentIndResidence 0..1

* extension[libelleLong].value[x] only string
* extension[libelleLong] ^short = "Libellé long RH (UFP_LIBPUF — 40 chars)"

* extension[libelleReduit].value[x] only string
* extension[libelleReduit] ^short = "Libellé réduit RH (UFP_LBRPUF — 20 chars)"

* extension[utiliseCPageRH].value[x] only boolean
* extension[utiliseCPageRH] ^short = "UF utilisée par CPage RH (UFP_FPERUF : O/N)"

* extension[travauxIntensifNuit].value[x] only boolean
* extension[travauxIntensifNuit] ^short = "Travaux intensifs de nuit (UFP_TINUUF : O/N)"

* extension[indicateurSag].value[x] only boolean
* extension[indicateurSag] ^short = "Indicateur SAG temps choisi (UFP_SAGGUF : O/N)"

* extension[bureauVote].value[x] only string
* extension[bureauVote] ^short = "Bureau de vote (UFP_BUVOUF — 2 chars)"

* extension[tauxTransportPatron].value[x] only string
* extension[tauxTransportPatron] ^short = "Taux SS transport patronal déplafonné (UFP_TSTPUF — 6 chars)"

* extension[pourcentIndResidence].value[x] only string
* extension[pourcentIndResidence] ^short = "Pourcentage indemnité résidence (UFP_PCIRUF — 6 chars)"
