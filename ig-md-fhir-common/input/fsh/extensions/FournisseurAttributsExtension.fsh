// =============================================
// Extension: Attributs Fournisseur
// =============================================

Extension: FournisseurAttributsExtension
Id: fournisseur-attributs
Title: "Attributs Fournisseur"
Description: "Attributs métier spécifiques d'un fournisseur : type, priorité, catégorie interne, références croisées, indicateurs réglementaires (marchés publics, Chorus, RAFP, honoraires), indicateurs techniques (extraction, MAJ) et date d'intégration. Correspond aux colonnes TYFOFO, COPRFO, CATEFO, NUCLFO, MUNHFO, NUDBFO, NOTEFO, NOAGFO, IDFAFO, RAFPFO, TCMPFO, GACHFO, HONOFO, CHORFO, TIDCFO, IDCHFO, EXTRFO, MAJ_FO, DINTFO de la table FOU."
* ^url = "https://www.cpage.fr/ig/masterdata/common/StructureDefinition/fournisseur-attributs"
* ^version = "1.0.0"
* ^status = #active
* ^context[0].type = #element
* ^context[0].expression = "Organization"

* extension contains
    // --- Qualification du fournisseur ---
    typeFournisseur 0..1 MS and
    codePriorite 0..1 MS and
    categorieInterne 0..1 MS and
    // --- Références croisées ---
    numeroClient 0..1 MS and
    codeMutuelleNH 0..1 MS and
    debiteurAssocie 0..1 MS and
    // --- Informations complémentaires ---
    note 0..1 MS and
    numeroAgrement 0..1 MS and
    idFournisseurFAC 0..1 MS and
    modeleRAFP 0..1 MS and
    // --- Indicateurs réglementaires ---
    assujettCodeMarchePublic 0..1 MS and
    groupementAchatUGAP 0..1 MS and
    fournisseurHonoraire 0..1 MS and
    // --- Chorus ---
    assujettChorus 0..1 MS and
    typeIdentifiantChorus 0..1 MS and
    identifiantChorus 0..1 MS and
    // --- Indicateurs techniques (synchronisation) ---
    aExtraire 0..1 MS and
    modifieDepuisExtraction 0..1 MS and
    // --- Date ---
    dateIntegration 0..1 MS

// --- Qualification du fournisseur ---

* extension[typeFournisseur] ^short = "Type de fournisseur (TYFOFO)"
* extension[typeFournisseur] ^definition = "Type de fournisseur : F=fournisseur régulier, T=transitaire, R=régie, P=prestataire/PA. Contrainte : valeur IN ('F','T','R','P'). Correspond à la colonne TYFOFO de la table FOU."
* extension[typeFournisseur].value[x] only code
* extension[typeFournisseur].valueCode 1..1 MS
* extension[typeFournisseur].valueCode ^short = "F | T | R | P"

* extension[codePriorite] ^short = "Code priorité de règlement (COPRFO)"
* extension[codePriorite] ^definition = "Code identifiant la priorité de règlement du fournisseur (1 caractère, FK vers table EURG). Correspond à la colonne COPRFO de la table FOU."
* extension[codePriorite].value[x] only string
* extension[codePriorite].valueString 1..1 MS
* extension[codePriorite].valueString ^maxLength = 1

* extension[categorieInterne] ^short = "Catégorie interne fournisseur (CATEFO)"
* extension[categorieInterne] ^definition = "Catégorie interne du fournisseur selon la table des catégories ECFO (2 caractères). Distinct de la catégorie TG (CATGFO). Correspond à la colonne CATEFO de la table FOU."
* extension[categorieInterne].value[x] only string
* extension[categorieInterne].valueString 1..1 MS
* extension[categorieInterne].valueString ^maxLength = 2

// --- Références croisées ---

* extension[numeroClient] ^short = "Numéro de client chez le fournisseur (NUCLFO)"
* extension[numeroClient] ^definition = "Numéro que ce fournisseur nous attribue en tant que client dans son propre système (12 caractères). Utilisé dans les échanges EDI. Correspond à la colonne NUCLFO de la table FOU."
* extension[numeroClient].value[x] only string
* extension[numeroClient].valueString 1..1 MS
* extension[numeroClient].valueString ^maxLength = 12

* extension[codeMutuelleNH] ^short = "Code Mutuelle Nationale des Hospitaliers (MUNHFO)"
* extension[codeMutuelleNH] ^definition = "Code identifiant ce fournisseur dans le référentiel de la Mutuelle Nationale des Hospitaliers (16 caractères). Correspond à la colonne MUNHFO de la table FOU."
* extension[codeMutuelleNH].value[x] only string
* extension[codeMutuelleNH].valueString 1..1 MS
* extension[codeMutuelleNH].valueString ^maxLength = 16

* extension[debiteurAssocie] ^short = "Code du débiteur associé (NUDBFO)"
* extension[debiteurAssocie] ^definition = "Code interne (6 caractères) du débiteur lié à ce fournisseur. Lien symétrique avec la colonne NUFODT de la table DBT. Correspond à la colonne NUDBFO de la table FOU."
* extension[debiteurAssocie].value[x] only string
* extension[debiteurAssocie].valueString 1..1 MS
* extension[debiteurAssocie].valueString ^maxLength = 6

// --- Informations complémentaires ---

* extension[note] ^short = "Note du fournisseur (NOTEFO)"
* extension[note] ^definition = "Note d'évaluation du fournisseur sur 4 chiffres avec 2 décimales (ex: 99.99). Correspond à la colonne NOTEFO de la table FOU."
* extension[note].value[x] only decimal
* extension[note].valueDecimal 1..1 MS

* extension[numeroAgrement] ^short = "Numéro d'agrément (NOAGFO)"
* extension[numeroAgrement] ^definition = "Numéro d'agrément ou d'autorisation administrative du fournisseur (17 caractères). Correspond à la colonne NOAGFO de la table FOU."
* extension[numeroAgrement].value[x] only string
* extension[numeroAgrement].valueString 1..1 MS
* extension[numeroAgrement].valueString ^maxLength = 17

* extension[idFournisseurFAC] ^short = "Identifiant fournisseur FAC (IDFAFO)"
* extension[idFournisseurFAC] ^definition = "Numéro identifiant le fournisseur dans le système de Facturation (FAC), 20 caractères. Correspond à la colonne IDFAFO de la table FOU."
* extension[idFournisseurFAC].value[x] only string
* extension[idFournisseurFAC].valueString 1..1 MS
* extension[idFournisseurFAC].valueString ^maxLength = 20

* extension[modeleRAFP] ^short = "Modèle RAFP (RAFPFO)"
* extension[modeleRAFP] ^definition = "Référence du modèle utilisé pour les échanges RAFP (Retraite Additionnelle de la Fonction Publique), 80 caractères. Correspond à la colonne RAFPFO de la table FOU."
* extension[modeleRAFP].value[x] only string
* extension[modeleRAFP].valueString 1..1 MS
* extension[modeleRAFP].valueString ^maxLength = 80

// --- Indicateurs réglementaires ---

* extension[assujettCodeMarchePublic] ^short = "Assujetti au Code des Marchés Publics (TCMPFO)"
* extension[assujettCodeMarchePublic] ^definition = "Indique si ce fournisseur est assujetti au Code des Marchés Publics (O/N). Correspond à la colonne TCMPFO de la table FOU."
* extension[assujettCodeMarchePublic].value[x] only boolean
* extension[assujettCodeMarchePublic].valueBoolean 1..1 MS

* extension[groupementAchatUGAP] ^short = "Groupement d'achat UGAP (GACHFO)"
* extension[groupementAchatUGAP] ^definition = "Indique si ce fournisseur est référencé dans un groupement d'achat UGAP (O/N). Correspond à la colonne GACHFO de la table FOU."
* extension[groupementAchatUGAP].value[x] only boolean
* extension[groupementAchatUGAP].valueBoolean 1..1 MS

* extension[fournisseurHonoraire] ^short = "Fournisseur à honoraires (HONOFO)"
* extension[fournisseurHonoraire] ^definition = "Indique si ce fournisseur est rémunéré à l'honoraire (O/N). Correspond à la colonne HONOFO de la table FOU."
* extension[fournisseurHonoraire].value[x] only boolean
* extension[fournisseurHonoraire].valueBoolean 1..1 MS

// --- Chorus ---

* extension[assujettChorus] ^short = "Assujetti à Chorus (CHORFO)"
* extension[assujettChorus] ^definition = "Indique si ce fournisseur est soumis à la facturation via Chorus Pro (O/N). Correspond à la colonne CHORFO de la table FOU."
* extension[assujettChorus].value[x] only boolean
* extension[assujettChorus].valueBoolean 1..1 MS

* extension[typeIdentifiantChorus] ^short = "Type d'identifiant Chorus (TIDCFO)"
* extension[typeIdentifiantChorus] ^definition = "Code du type d'identifiant utilisé dans Chorus Pro pour ce fournisseur (2 caractères). Correspond à la colonne TIDCFO de la table FOU."
* extension[typeIdentifiantChorus].value[x] only string
* extension[typeIdentifiantChorus].valueString 1..1 MS
* extension[typeIdentifiantChorus].valueString ^maxLength = 2

* extension[identifiantChorus] ^short = "Identifiant Chorus (IDCHFO)"
* extension[identifiantChorus] ^definition = "Identifiant de ce fournisseur dans Chorus Pro (18 caractères). Correspond à la colonne IDCHFO de la table FOU."
* extension[identifiantChorus].value[x] only string
* extension[identifiantChorus].valueString 1..1 MS
* extension[identifiantChorus].valueString ^maxLength = 18

// --- Indicateurs techniques (synchronisation) ---

* extension[aExtraire] ^short = "À extraire (EXTRFO)"
* extension[aExtraire] ^definition = "Indique si ce fournisseur doit être inclus dans la prochaine extraction vers les systèmes externes (O/N). Correspond à la colonne EXTRFO de la table FOU."
* extension[aExtraire].value[x] only boolean
* extension[aExtraire].valueBoolean 1..1 MS

* extension[modifieDepuisExtraction] ^short = "Modifié depuis la dernière extraction (MAJ_FO)"
* extension[modifieDepuisExtraction] ^definition = "Indique si ce fournisseur a été créé ou modifié depuis la dernière extraction (O/N). Remis à N après extraction. Correspond à la colonne MAJ_FO de la table FOU."
* extension[modifieDepuisExtraction].value[x] only boolean
* extension[modifieDepuisExtraction].valueBoolean 1..1 MS

// --- Date ---

* extension[dateIntegration] ^short = "Date d'intégration du fournisseur externe (DINTFO)"
* extension[dateIntegration] ^definition = "Date à laquelle ce fournisseur a été intégré depuis un système externe. Correspond à la colonne DINTFO de la table FOU."
* extension[dateIntegration].value[x] only date
* extension[dateIntegration].valueDate 1..1 MS
