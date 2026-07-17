// =============================================
// Profil : Lit (lit)
// =============================================
// Hérite de StructureHospitaliereSiteProfile.
//
// Colonnes Oracle lit → FHIR :
//   PIE_UFO_NUUFUF + PIE_NUPIPI → parentId (UUID de la chambre parente)
//   NULLLL (PK) → identifier[litCode]   (5 chars)
//   LIBCLL       → name
//   LIBRLL       → alias[0] (libelleReduit)
//   DAEFLL/DAFILL → extension[periodValidite]
//   VALILL (F/I/V) → status + extension[codeValidite]
//   DAINLL        → extension[dateIndisponibilite] (optionnel)
//   NUTELL        → telecom.phone
//   CARALL (A/B/H/I/P/S/U/C/R) → extension[typeLit]
//   LISELL (O/N) → extension[indicateurSeances]
//   REACLL (3 chars) → extension[typeAutorisation]
//
// Audit : DATECREA/USERCREA/DATEMODI/USERMODI → géré par instance_concept.
// PK composite : PIE_UFO_NUUFUF + PIE_NUPIPI + NULLLL + DAEFLL
//   → le lit appartient à une chambre identifiée par (UF + N° chambre).

Profile: LitProfile
Parent: StructureHospitaliereSiteProfile
Id: strh-lit-profile
Title: "Lit"
Description: """
Profil FHIR R4 représentant un lit d'hospitalisation.

Hérite de `StructureHospitaliereSiteProfile` (issu de `FRCoreLocationProfile`).

**Modèle temporel** : PK composite (PIE_UFO_NUUFUF + PIE_NUPIPI + NULLLL + DAEFLL).

**Hiérarchie** : le lit appartient à une chambre via `partOf`.

**Scope** : TENANT uniquement.
**Schéma source** : PAT (module patients).
"""

// ── Identifiants ──────────────────────────────────────────────────────────────

* identifier ^slicing.discriminator.type = #value
* identifier ^slicing.discriminator.path = "system"
* identifier ^slicing.rules = #open

* identifier contains
    litCode 1..1 MS

* identifier[strHId].system = "https://www.cpage.fr/ig/masterdata/common/identifiers/strh" (exactly)
* identifier[strHId].value 1..1 MS
* identifier[strHId] ^short = "Identifiant MDM interne (UUID)"

// Numéro de lit (NULLLL — 5 chars)
* identifier[litCode].system = "https://www.cpage.fr/ig/masterdata/common/identifiers/lit-code" (exactly)
* identifier[litCode].value 1..1 MS
* identifier[litCode] ^short = "Numéro de lit (NULLLL — 5 chars)"

// ── Type Location ─────────────────────────────────────────────────────────────

* type 1..* MS
* type ^slicing.discriminator.type = #value
* type ^slicing.discriminator.path = "coding.code"
* type ^slicing.rules = #open

* type contains litType 1..1 MS
* type[litType].coding.system = "https://hl7.fr/ig/fhir/core/CodeSystem/fr-core-cs-location-type" (exactly)
* type[litType].coding.code = #LIT (exactly)
* type[litType] ^short = "Type : Lit (LIT) — FR Core cs-location-type"

// ── Dénomination ─────────────────────────────────────────────────────────────

* name 1..1 MS
* name ^short = "Libellé complet du lit (LIBCLL — 40 chars)"

// ── Statut ────────────────────────────────────────────────────────────────────

* status 0..1 MS
* status ^short = "active si VALILL=V, inactive si VALILL=F ou VALILL=I"

// ── Télécom du lit ────────────────────────────────────────────────────────────

* telecom 0..1 MS
* telecom.system = #phone (exactly)
* telecom ^short = "Téléphone du lit (NUTELL — 20 chars)"

// ── Extensions ────────────────────────────────────────────────────────────────

* extension contains
    LitPeriodeValiditeExtension       named periodValidite        0..1 MS and
    LitCodeValiditeExtension          named codeValidite          0..1 MS and
    LitTypeLitExtension               named typeLit               0..1 MS and
    LitIndicateurSeancesExtension     named indicateurSeances     0..1 MS and
    LitDateIndisponibiliteExtension   named dateIndisponibilite   0..1 MS and
    LitTypeAutorisationExtension      named typeAutorisation      0..1 MS

* extension[periodValidite]      ^short = "Période de validité (DAEFLL / DAFILL)"
* extension[codeValidite]        ^short = "Code validité (VALILL : F=Fermé / I=Invalide / V=Valide)"
* extension[typeLit]             ^short = "Type de lit (CARALL : A/B/H/I/P/S/U/C/R)"
* extension[indicateurSeances]   ^short = "Lit de séances (LISELL : O/N)"
* extension[dateIndisponibilite] ^short = "Date d'indisponibilité (DAINLL)"
* extension[typeAutorisation]    ^short = "Type d'autorisation du lit (REACLL — 3 chars)"

// ── Hiérarchie : chambre parente ──────────────────────────────────────────────

* partOf 0..1 MS
* partOf only Reference(ChambreProfile)
* partOf ^short = "Chambre parente (PIE_UFO_NUUFUF + PIE_NUPIPI)"
