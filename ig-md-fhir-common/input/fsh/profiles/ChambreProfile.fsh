// =============================================
// Profil : Chambre (PAT.PIE)
// =============================================
// Hérite de StructureHospitaliereSiteProfile.
//
// Colonnes Oracle PAT.PIE → FHIR :
//   UFO_NUUFUF (FK) → managingOrganization (UF parente — obligatoire)
//   NUPIPI (PK)     → identifier[chambreCode]  (4 chars)
//   LIBCPI          → name
//   LIBRPI          → alias[0] (via extension StrHCodeInterneExtension.codeInterne)
//   DAEFPI/DAFIPI   → extension[periodValidite]
//   VALIPI (F/I/V)  → status + extension[codeValidite]
//   INDIVIDUELLE    → extension[indicateurIndividuelle] (boolean)
//
// Audit (DATECREA/USERCREA/DATEMODI/USERMODI) : déjà géré par instance_concept.
// VERSION : concurrence Oracle — pas de mapping FHIR.
//
// Note : schéma source PAT (module patients), pas STR (structure).
//        La chambre appartient directement à une UF (pas de niveau intermédiaire).

Profile: ChambreProfile
Parent: StructureHospitaliereSiteProfile
Id: strh-chambre-profile
Title: "Chambre"
Description: """
Profil FHIR R4 représentant une chambre d'hospitalisation (table Oracle `PAT.PIE`).

Hérite de `StructureHospitaliereSiteProfile` (issu de `FRCoreLocationProfile`).

**Modèle temporel** : PK composite (UFO_NUUFUF + NUPIPI + DAEFPI).

**Champ spécifique** : `INDIVIDUELLE` — indique si la chambre est individuelle.

**Scope** : TENANT uniquement.
**Schéma source** : PAT (module patients), pas STR.
"""

// ── Identifiants ──────────────────────────────────────────────────────────────

* identifier ^slicing.discriminator.type = #value
* identifier ^slicing.discriminator.path = "system"
* identifier ^slicing.rules = #open

* identifier contains
    strHId     1..1 MS and
    chambreCode 1..1 MS

* identifier[strHId].system = "https://www.cpage.fr/ig/masterdata/common/identifiers/strh" (exactly)
* identifier[strHId].value 1..1 MS
* identifier[strHId] ^short = "Identifiant MDM interne (UUID)"

// Numéro de chambre (NUPIPI — 4 chars)
* identifier[chambreCode].system = "https://www.cpage.fr/ig/masterdata/common/identifiers/chambre-code" (exactly)
* identifier[chambreCode].value 1..1 MS
* identifier[chambreCode] ^short = "Numéro de chambre (NUPIPI — 4 chars)"

// ── Type Location ─────────────────────────────────────────────────────────────

* type 1..* MS
* type ^slicing.discriminator.type = #value
* type ^slicing.discriminator.path = "coding.code"
* type ^slicing.rules = #open

* type contains chambreType 1..1 MS
* type[chambreType].coding.system = "http://terminology.hl7.org/CodeSystem/v3-RoleCode" (exactly)
* type[chambreType].coding.code = #CHAMB (exactly)
* type[chambreType] ^short = "Type : Chambre (CHAMB)"

// ── Dénomination ─────────────────────────────────────────────────────────────

* name 1..1 MS
* name ^short = "Libellé complet de la chambre (LIBCPI — 40 chars)"

// ── Statut actif ──────────────────────────────────────────────────────────────

* status 0..1 MS
* status ^short = "active si VALIPI=V, inactive si VALIPI=F ou VALIPI=I"

// ── Extensions ────────────────────────────────────────────────────────────────

* extension contains
    ChambrePeriodeValiditeExtension      named periodValidite         0..1 MS and
    ChambreCodeValiditeExtension         named codeValidite           0..1 MS and
    ChambreIndividuelleExtension         named indicateurIndividuelle 0..1 MS

* extension[periodValidite]          ^short = "Période de validité (DAEFPI / DAFIPI)"
* extension[codeValidite]            ^short = "Code validité (VALIPI : F=Fermée / I=Invalide / V=Valide)"
* extension[indicateurIndividuelle]  ^short = "Chambre individuelle (INDIVIDUELLE : 1=true / 0=false)"

// ── Libellé réduit → StrHCodeInterneExtension ────────────────────────────────

* extension[codeInterne] ^short = "Libellé réduit (LIBRPI — 20 chars)"

// ── Hiérarchie : UF responsable ──────────────────────────────────────────────

* managingOrganization 0..1 MS
* managingOrganization only Reference(UFProfile)
* managingOrganization ^short = "UF parente (UFO_NUUFUF — obligatoire)"
