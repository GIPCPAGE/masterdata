// =============================================
// Profil : Entité Juridique
// =============================================
// Entité légale d'un établissement hospitalier.
// Hérite de FRCoreOrganizationEtablissementProfile (FR Core 2.2.0).
// Source Oracle : entité juridique
//
// Colonnes Oracle → FHIR :
//   NUCHCH (PK)         → identifier[choCode]       Code interne CPage (2 chars)
//   LICHCH              → name                       Libellé complet
//   LRCHCH              → alias[0]                   Libellé réduit
//   LBTCCH              → alias[1]                   Libellé très court
//   NUFICH              → identifier[finess]         FINESS
//   SIRECH              → identifier[siret]          SIRET
//   TVAICH              → identifier[tva]            TVA intracommunautaire
//   FISICH              → identifier[finessHQ]       FINESS siège (si différent)
//   SCET_CAETCET        → fr-core-organization-sae-categorie
//   STATCH/LIBJCH       → extension[statutJuridique]
//   CAPECH              → extension[codeApe]
//   CPCMCH              → extension[codeCpcm]
//   CAPMCH              → extension[categoriePmsi]
//   AD1/2/3CCH          → address[0].line[0..2]
//   COP_NCPOPO          → address[0].postalCode
//   BUDCCH              → address[0].city
//   COCECH              → extension[codeCedex]
//   COCOCH              → address[0].extension:communeInsee (FR Core)
//   CDOMCH              → extension[localisationDomTom]
//   CREGCH              → address[0].extension:regionInsee (FR Core)
//   NROTCH              → telecom[0] phone
//   NFAXCH              → telecom[1] fax
//   WEBCCH              → telecom[2] url
//   NNETCH / NNECCH     → extension[numerosEmetteur]
//   ARROCH              → extension[indicateurArrondissement]
//
// Champs CPage-spécifiques → CPageEntiteJuridiqueProfile (ig-md-fhir-cpage)

Profile: EntiteJuridiqueProfile
Parent: FRCoreOrganizationEtablissementProfile
Id: strh-entite-juridique-profile
Title: "Entité Juridique"
Description: """
Profil FHIR R4 représentant l'entité légale d'un établissement hospitalier dans le Master Data CPage.

Hérite de `FRCoreOrganizationEtablissementProfile` (FR Core 2.2.0) qui porte déjà
les extensions SAE (catégorie établissement) et les contraintes hospitalo-centriques.

Source Oracle : table `entité juridique` — colonnes génériques (non CPage-spécifiques).

**Scope** : TENANT uniquement — propre à l'établissement propriétaire.
**Profil CPage** : `CPageEntiteJuridiqueProfile` (ig-md-fhir-cpage) — champs spécifiques
CPage : receveur comptable, numéros sociaux (URSSAF/CNRACL/IRCANTEC), TVA, TPG, M22.
"""

// ── Identifiants ──────────────────────────────────────────────────────────────
// Slicing déjà défini par le parent FRCoreOrganizationEtablissementProfile
// (discriminator pattern:system) — ne pas redéclarer, seulement ajouter des slices.

* identifier 1..* MS

* identifier contains
    strHId     1..1 MS and
    choCode    1..1 MS and
    finessHQ   0..1 MS and
    tva        0..1 MS

// UUID MDM interne
* identifier[strHId].system = "https://www.cpage.fr/ig/masterdata/common/identifiers/strh" (exactly)
* identifier[strHId].value 1..1 MS
* identifier[strHId] ^short = "Identifiant MDM interne (UUID)"

// Code CPage établissement
* identifier[choCode].system = "https://www.cpage.fr/ig/masterdata/common/identifiers/cho-code" (exactly)
* identifier[choCode].value 1..1 MS
* identifier[choCode] ^short = "Code centre hospitalier CPage"

// SIRET (SIRECH)
* identifier[siret].system = "https://sirene.fr" (exactly)
* identifier[siret].value 1..1
* identifier[siret] ^short = "Numéro SIRET (14 chiffres)"

// FINESS établissement (NUFICH)
* identifier[finess].system = "https://finess.esante.gouv.fr" (exactly)
* identifier[finess].value 1..1
* identifier[finess] ^short = "Numéro FINESS de l'établissement (NUFICH)"

// FINESS siège (FISICH — si différent du FINESS établissement)
* identifier[finessHQ].system = "https://finess.esante.gouv.fr/siege" (exactly)
* identifier[finessHQ].value 1..1
* identifier[finessHQ] ^short = "Numéro FINESS du siège (FISICH)"

// TVA intracommunautaire (TVAICH)
* identifier[tva].system = "urn:oid:1.2.250.1.69.1.1011" (exactly)
* identifier[tva].value 1..1
* identifier[tva] ^short = "Numéro TVA intracommunautaire (TVAICH)"

// ── Type organisationnel ──────────────────────────────────────────────────────

// Slicing déjà défini par le parent FRCoreOrganizationEtablissementProfile
// (discriminator value:$this) — ne pas redéclarer.
* type 1..* MS

* type contains legalEntityType 1..1 MS
* type[legalEntityType].coding.system = "https://hl7.fr/ig/fhir/core/CodeSystem/fr-core-cs-v2-3307" (exactly)
* type[legalEntityType].coding.code = #LEGAL-ENTITY (exactly)
* type[legalEntityType] ^short = "Type : Entité légale (LEGAL-ENTITY)"

// ── Dénomination ─────────────────────────────────────────────────────────────

* name 1..1 MS
* name ^short = "Libellé complet de l'établissement (LICHCH)"
* name ^definition = "Libellé officiel complet de l'établissement."

* alias 0..2 MS
* alias ^short = "Libellé réduit (LRCHCH) et libellé très court (LBTCCH)"
* alias ^definition = "alias[0] = LRCHCH (libellé réduit 20 chars), alias[1] = LBTCCH (libellé très court 15 chars)."

// ── Statut actif ──────────────────────────────────────────────────────────────

* active 0..1 MS
* active ^short = "Établissement actif"

// ── Adresse siège ─────────────────────────────────────────────────────────────

* address 0..1 MS
* address.line 0..3 MS
* address.line ^short = "Adresse lignes 1-3 (AD1CCH / AD2CCH / AD3CCH)"
* address.postalCode 0..1 MS
* address.postalCode ^short = "Code postal (COP_NCPOPO)"
* address.city 0..1 MS
* address.city ^short = "Ville / bureau distributeur (BUDCCH)"
* address.country = "FR" (exactly)
* address.district 0..1 MS
* address.district ^short = "Code commune INSEE (COCOCH)"

// ── Télécoms ──────────────────────────────────────────────────────────────────

* telecom 0..* MS
* telecom ^slicing.discriminator.type = #value
* telecom ^slicing.discriminator.path = "system"
* telecom ^slicing.rules = #open

* telecom contains
    telephone 0..1 MS and
    fax       0..1 MS and
    web       0..1 MS

* telecom[telephone].system = #phone (exactly)
* telecom[telephone].value 1..1
* telecom[telephone] ^short = "Téléphone principal (NROTCH)"

* telecom[fax].system = #fax (exactly)
* telecom[fax].value 1..1
* telecom[fax] ^short = "Numéro de fax (NFAXCH)"

* telecom[web].system = #url (exactly)
* telecom[web].value 1..1
* telecom[web] ^short = "Adresse internet (WEBCCH)"

// ── Extensions spécifiques entité juridique (Common IG) ──────────────────────

* extension contains
    EJStatutJuridiqueExtension       named statutJuridique       0..1 MS and
    EJCodeApeExtension               named codeApe               0..1 MS and
    EJCodeCpcmExtension              named codeCpcm              0..1 MS and
    EJCategoriePmsiExtension         named categoriePmsi         0..1 MS and
    EJCodeCedexExtension             named codeCedex             0..1 MS and
    EJLocalisationDomTomExtension    named localisationDomTom    0..1 MS and
    EJNumerosEmetteurExtension       named numerosEmetteur       0..1 MS and
    EJIndicateurArrondissementExtension named indicateurArrondissement 0..1 MS

* extension[statutJuridique]        ^short = "Statut juridique (STATCH/LIBJCH)"
* extension[codeApe]                ^short = "Code APE / NAF (CAPECH)"
* extension[codeCpcm]               ^short = "Numéro CPCM (CPCMCH)"
* extension[categoriePmsi]          ^short = "Catégorie PMSI (CAPMCH : 10/20/21/22/30/40)"
* extension[codeCedex]              ^short = "Code CEDEX (COCECH)"
* extension[localisationDomTom]     ^short = "Localisation DOM/TOM 970-974 (CDOMCH)"
* extension[numerosEmetteur]        ^short = "Numéros émetteur EH (NNETCH/NNECCH)"
* extension[indicateurArrondissement] ^short = "Indicateur arrondissement O/N (ARROCH)"

// ── Hiérarchie : GHT parent ──────────────────────────────────────────────────
// Conforme FR Core structure_entites.html : l'EJ est membre d'un GHT.

* partOf 0..1 MS
* partOf only Reference(GHTProfile)
* partOf ^short = "GHT parent — groupement hospitalier de territoire (GHTProfile)"
