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

// ── Code APE / NAF (CAPECH) ───────────────────────────────────────────────────

Extension: EJCodeApeExtension
Id: ej-code-ape
Title: "Code APE (Activité Principale Exercée)"
Description: "Code APE ou NAF de l'établissement selon la nomenclature INSEE (CAPECH — 5 chars)."
Context: Organization

* value[x] only string
* valueString ^short = "Code APE (CAPECH)"

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
