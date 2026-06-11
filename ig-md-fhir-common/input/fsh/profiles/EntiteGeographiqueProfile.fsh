// =============================================
// Profil : Entité Géographique (entité géographique)
// =============================================
// Site géographique d'un établissement hospitalier.
// Hérite de FRCoreOrganizationEtablissementProfile (FR Core 2.2.0).
//
// Colonnes Oracle entité géographique → FHIR :
//   entiteJuridique       → partOf (référence Entité Juridique)
//   NUETET (PK)      → identifier[etaCode]
//   DATDET/DATFET    → extension[periodValidite]  (modèle temporel)
//   INVAET (F/I/V)   → active + extension[codeValidite]
//   LIETET           → name
//   LRETET           → alias[0]
//   NUFIET           → identifier[finess]
//   SIREET           → identifier[siret]
//   SCET_CAETCET     → fr-core-organization-sae-categorie
//   SSSA_SESASSA     → extension[secteurSanitaire]
//   CNAFET           → extension[codeNaf]
//   EANGET           → identifier[eanGencod]
//   LILOET           → extension[libelleLocalisation]
//   AD1-3EET         → address.line[0..2]
//   COP_NCPOPO       → address.postalCode
//   BUDEET           → address.city
//   TELEET           → telecom.phone
//   TELCET           → telecom.fax
//   ADRESSE_MAIL     → telecom.email
//   HORAIRES_OUVERTURE → extension[horaires]
//   DSAEET           → extension[indicateurSae]
//   CGEOET           → extension[coefficientGeographiqueT2A]
//   CTRAET           → extension[coefficientTransitionT2A]
//
// Champs CPage-spécifiques → CPageEntiteGeographiqueProfile (ig-md-fhir-cpage) :
//   Dates T2A (DBM*/DBS*/DBP*/DBL*/DFM*/DFS*/DFP*/DFL*)
//   TVA (TVAIET/TVARET/TVASET/LTVAET/CTVAET/LTVIET/CTVIET)
//   Coefficients tarifaires (CPRUET/CMCOET/CFISCET/CSEGURET)

Profile: EntiteGeographiqueProfile
Parent: FRCoreOrganizationEtablissementProfile
Id: strh-entite-geographique-profile
Title: "Entité Géographique"
Description: """
Profil FHIR R4 représentant un site géographique d'un établissement hospitalier.

Hérite de `FRCoreOrganizationEtablissementProfile` (FR Core 2.2.0).

**Modèle temporel** : la table ETA utilise un PK composé.
Chaque instance représente UNE PÉRIODE de validité d'un site géographique.
La période est portée par `extension[periodValidite]` et le code de validité par `extension[codeValidite]`.

**Scope** : TENANT uniquement.
**Profil CPage** : `CPageEntiteGeographiqueProfile` (ig-md-fhir-cpage) — dates T2A, TVA, coefficients.
"""

// ── Identifiants ──────────────────────────────────────────────────────────────

* identifier ^slicing.discriminator.type = #value
* identifier ^slicing.discriminator.path = "system"
* identifier ^slicing.rules = #open

* identifier 1..* MS

* identifier contains
    strHId     1..1 MS and
    etaCode    1..1 MS and
    finess     0..1 MS and
    siret      0..1 MS and
    eanGencod  0..1 MS

// UUID MDM interne
* identifier[strHId].system = "https://www.cpage.fr/ig/masterdata/common/identifiers/strh" (exactly)
* identifier[strHId].value 1..1 MS
* identifier[strHId] ^short = "Identifiant MDM interne (UUID)"

// Code site géographique
* identifier[etaCode].system = "https://www.cpage.fr/ig/masterdata/common/identifiers/eta-code" (exactly)
* identifier[etaCode].value 1..1 MS
* identifier[etaCode] ^short = "Code site géographique CPage"

// FINESS (NUFIET)
* identifier[finess].system = "https://finess.esante.gouv.fr" (exactly)
* identifier[finess].value 1..1
* identifier[finess] ^short = "Numéro FINESS du site (NUFIET)"

// SIRET (SIREET)
* identifier[siret].system = "https://sirene.fr" (exactly)
* identifier[siret].value 1..1
* identifier[siret] ^short = "Numéro SIRET (SIREET)"

// Code EAN GENCOD (EANGET — 13 chars, format GS1)
* identifier[eanGencod].system = "https://www.gs1.org/gln" (exactly)
* identifier[eanGencod].value 1..1
* identifier[eanGencod] ^short = "Code EAN GENCOD (EANGET — 13 chars)"

// ── Type organisationnel ──────────────────────────────────────────────────────

* type 1..* MS
* type ^slicing.discriminator.type = #value
* type ^slicing.discriminator.path = "coding.code"
* type ^slicing.rules = #open

* type contains geoEntityType 1..1 MS
* type[geoEntityType].coding.system = "https://hl7.fr/ig/fhir/core/CodeSystem/fr-core-cs-v2-3307" (exactly)
* type[geoEntityType].coding.code = #GEOGRAPHICAL-ENTITY (exactly)
* type[geoEntityType] ^short = "Type : Entité géographique (GEOGRAPHICAL-ENTITY)"

// ── Dénomination ─────────────────────────────────────────────────────────────

* name 1..1 MS
* name ^short = "Libellé complet du site (LIETET — 40 chars)"

* alias 0..1 MS
* alias ^short = "Libellé réduit (LRETET — 20 chars)"

// ── Statut actif ──────────────────────────────────────────────────────────────

* active 0..1 MS
* active ^short = "Site actif — false si INVAET=F (Fermé) ou INVAET=I (Invalide)"

// ── Adresse ───────────────────────────────────────────────────────────────────

* address 0..1 MS
* address.line 0..3 MS
* address.line ^short = "Lignes adresse 1-3 (AD1EET/AD2EET/AD3EET)"
* address.postalCode 0..1 MS
* address.postalCode ^short = "Code postal (COP_NCPOPO)"
* address.city 0..1 MS
* address.city ^short = "Ville (BUDEET)"
* address.country = "FR" (exactly)

// ── Télécoms ──────────────────────────────────────────────────────────────────

* telecom 0..* MS
* telecom ^slicing.discriminator.type = #value
* telecom ^slicing.discriminator.path = "system"
* telecom ^slicing.rules = #open

* telecom contains
    telephone 0..1 MS and
    fax       0..1 MS and
    email     0..1 MS

* telecom[telephone].system = #phone (exactly)
* telecom[telephone] ^short = "Téléphone (TELEET)"

* telecom[fax].system = #fax (exactly)
* telecom[fax] ^short = "Télécopie (TELCET)"

* telecom[email].system = #email (exactly)
* telecom[email] ^short = "Adresse mail (ADRESSE_MAIL)"

// ── Extensions spécifiques (Common IG) ───────────────────────────────────────

* extension contains
    EGPeriodeValiditeExtension       named periodValidite         0..1 MS and
    EGCodeValiditeExtension          named codeValidite           0..1 MS and
    EGSecteurSanitaireExtension      named secteurSanitaire       0..1 MS and
    EGCodeNafExtension               named codeNaf                0..1 MS and
    EGLibelleLocalisationExtension   named libelleLocalisation    0..1 MS and
    EGIndicateurSaeExtension         named indicateurSae          0..1 MS and
    EGHorairesExtension              named horaires               0..1 MS and
    EGCoeffGeoT2AExtension           named coefficientGeoT2A      0..1 MS and
    EGCoeffTransitionT2AExtension    named coefficientTransitionT2A 0..1 MS

* extension[periodValidite]          ^short = "Période de validité (DATDET/DATFET)"
* extension[codeValidite]            ^short = "Code validité (INVAET : F=Fermé / I=Invalide / V=Valide)"
* extension[secteurSanitaire]        ^short = "Secteur sanitaire (SSSA_SESASSA — FK SSSA)"
* extension[codeNaf]                 ^short = "Code NAF (CNAFET — 6 chars)"
* extension[libelleLocalisation]     ^short = "Libellé de localisation (LILOET — 40 chars)"
* extension[indicateurSae]           ^short = "Déclarer séparément dans la SAE (DSAEET : O/N)"
* extension[horaires]                ^short = "Horaires d'ouverture (HORAIRES_OUVERTURE — 38 chars)"
* extension[coefficientGeoT2A]       ^short = "Coefficient géographique T2A (CGEOET — entre 1 et 2)"
* extension[coefficientTransitionT2A] ^short = "Coefficient de transition T2A (CTRAET — entre 0 et 2)"

// ── Hiérarchie : rattachement à l'Entité Juridique ────────────────────────────

* partOf 0..1 MS
* partOf only Reference(EntiteJuridiqueProfile)
* partOf ^short = "Entité Juridique parente "
