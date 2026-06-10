// =============================================
// Profil : Pôle d'activité (STR.POA)
// =============================================
// Hérite de StructureHospitaliereOrganizationProfile.
//
// Colonnes Oracle STR.POA → FHIR :
//   CHO_NUCHCH  → partOf (référence Entité Juridique — direct, pas via EG)
//   NUPAPA (PK) → identifier[poaCode]
//   LIBEPA      → name
//   LIBRPA      → alias[0]
//   DATDPA/DATFPA → extension[periodValidite]
//   INVAPA (F/I/V) → active + extension[codeValidite]
//   SAGE_NUAGAGE → contact[0].name.text (matricule agent responsable)

Profile: PoleProfile
Parent: StructureHospitaliereOrganizationProfile
Id: strh-pole-profile
Title: "Pôle d'activité"
Description: """
Profil FHIR R4 représentant un pôle d'activité hospitalier (table Oracle `STR.POA`).

Hérite de `StructureHospitaliereOrganizationProfile`.

**Modèle temporel** : PK composite (NUPAPA + DATDPA).
La période de validité est portée par `extension[periodValidite]`,
le code de validité par `extension[codeValidite]` (F/I/V).

**Important** : le pôle est rattaché directement à l'**Entité Juridique** (CHO_NUCHCH),
pas à l'Entité Géographique.

**Scope** : TENANT uniquement.
"""

// ── Identifiants ──────────────────────────────────────────────────────────────

* identifier ^slicing.discriminator.type = #value
* identifier ^slicing.discriminator.path = "system"
* identifier ^slicing.rules = #open

* identifier contains
    strHId  1..1 MS and
    poaCode 1..1 MS

* identifier[strHId].system = "https://www.cpage.fr/ig/masterdata/common/identifiers/strh" (exactly)
* identifier[strHId].value 1..1 MS
* identifier[strHId] ^short = "Identifiant MDM interne (UUID)"

// Code pôle (NUPAPA — 10 chars)
* identifier[poaCode].system = "https://www.cpage.fr/ig/masterdata/common/identifiers/poa-code" (exactly)
* identifier[poaCode].value 1..1 MS
* identifier[poaCode] ^short = "Code pôle d'activité (NUPAPA — 10 chars)"

// ── Type organisationnel ──────────────────────────────────────────────────────

* type 1..* MS
* type ^slicing.discriminator.type = #value
* type ^slicing.discriminator.path = "coding.code"
* type ^slicing.rules = #open

* type contains poleType 1..1 MS
* type[poleType].coding.system = "https://hl7.fr/ig/fhir/core/CodeSystem/fr-core-cs-v2-3307" (exactly)
* type[poleType].coding.code = #POLE (exactly)
* type[poleType] ^short = "Type : Pôle (POLE)"

// ── Dénomination ─────────────────────────────────────────────────────────────

* name 1..1 MS
* name ^short = "Libellé complet du pôle (LIBEPA — 40 chars)"

* alias 0..1 MS
* alias ^short = "Libellé réduit (LIBRPA — 20 chars)"

// ── Statut ────────────────────────────────────────────────────────────────────

* active 0..1 MS
* active ^short = "Pôle actif — false si INVAPA=F (Fermé) ou INVAPA=I (Invalide)"

// ── Extensions ────────────────────────────────────────────────────────────────

* extension contains
    POAPeriodeValiditeExtension    named periodValidite  0..1 MS and
    POACodeValiditeExtension       named codeValidite    0..1 MS

* extension[periodValidite]  ^short = "Période de validité (DATDPA / DATFPA)"
* extension[codeValidite]    ^short = "Code validité (INVAPA : F=Fermé / I=Invalide / V=Valide)"

// ── Agent responsable → contact ───────────────────────────────────────────────
// Le matricule SAGE_NUAGAGE est stocké comme contact[0].name.text

* contact 0..1 MS
* contact.name.text 0..1 MS
* contact.name.text ^short = "Matricule de l'agent responsable (SAGE_NUAGAGE — 9 chars)"

// ── Hiérarchie : rattachement à l'Entité Géographique ───────────────────────
// Conforme FR Core : le pôle est rattaché à l'EG (site géographique), pas directement à l'EJ.
// La table POA contient CHO_NUCHCH (FK vers EJ) mais c'est une référence de traçabilité ;
// la hiérarchie FHIR exprime le lien organisationnel via l'EG.

* partOf 0..1 MS
* partOf only Reference(EntiteGeographiqueProfile)
* partOf ^short = "Entité Géographique parente (site où est localisé le pôle)"
