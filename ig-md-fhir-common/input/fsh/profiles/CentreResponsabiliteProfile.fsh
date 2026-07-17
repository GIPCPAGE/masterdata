// =============================================
// Profil : Centre de Responsabilité (centre de responsabilité)
// =============================================
// Hérite de StructureHospitaliereOrganizationProfile.
//
// Colonnes Oracle centre de responsabilité → FHIR :
//   entiteJuridique    → conforme FR Core (member porté par le parent) : quand
//                         partOf référence un Pôle plutôt que l'EJ directement,
//                         c'est EntiteJuridiqueProfile qui liste ce CR comme membre
//                         (extension[membres]) — pas ce profil qui référence l'EJ.
//   NUCRCR (PK)   → identifier[creCode]  (4 chars)
//   LIBECR        → name
//   LIBRCR        → alias[0]
//   DATDCR/DATFCR → extension[periodValidite]
//   INVACR (F/I/V)→ active + extension[codeValidite]
//   SBUD_CODEBUD  → extension[lettreBudgetaire]  (obligatoire, 1 char, FK SBUD)
//   SAGE_NUAGAGE  → contact[0].name.text (matricule agent responsable)
//   SSBU_NUSBSB   → extension[codeSecteurBudgetaire] (optionnel, FK SSBU)
//   SDTR_NUDTSD   → extension[codeDirectionTransversale] (optionnel, FK SDTR)
//   POA_NUPAPA    → partOf → PoleProfile (si renseigné)
//                   sinon partOf → EntiteJuridiqueProfile
//
// Hiérarchie :
//   - Si pôle parent renseigné  : partOf = Pôle
//   - Sinon                    : partOf = Entité Juridique
//   - Conforme FR Core (structure_relations.html, STRU-1) : quand partOf pointe
//     vers un Pôle, le rattachement concurrent à l'EJ est exprimé côté EJ
//     (EntiteJuridiqueProfile.extension[membres]), pas par une extension sur ce CR.

Profile: CentreResponsabiliteProfile
Parent: StructureHospitaliereOrganizationProfile
Id: strh-centre-responsabilite-profile
Title: "Centre de Responsabilité"
Description: """
Profil FHIR R4 représentant un centre de responsabilité hospitalier.

Hérite de `StructureHospitaliereOrganizationProfile`.

**Modèle temporel** : PK composite.

**Hiérarchie** :
- Si un pôle parent est renseigné → `partOf` référence le pôle parent (`PoleProfile`)
- Sinon → `partOf` référence l'entité juridique (`EntiteJuridiqueProfile`)
- Conforme FR Core (STRU-1) : quand `partOf` référence un pôle, le rattachement
  concurrent à l'Entité Juridique est exprimé côté EJ (`extension[membres]` sur
  `EntiteJuridiqueProfile`), pas par une extension portée par ce CR.

**Scope** : TENANT uniquement.
"""

// ── Identifiants ──────────────────────────────────────────────────────────────

* identifier ^slicing.discriminator.type = #value
* identifier ^slicing.discriminator.path = "system"
* identifier ^slicing.rules = #open

* identifier contains
    creCode 1..1 MS

* identifier[strHId].system = "https://www.cpage.fr/ig/masterdata/common/identifiers/strh" (exactly)
* identifier[strHId].value 1..1 MS
* identifier[strHId] ^short = "Identifiant MDM interne (UUID)"

// Code CR
* identifier[creCode].system = "https://www.cpage.fr/ig/masterdata/common/identifiers/cre-code" (exactly)
* identifier[creCode].value 1..1 MS
* identifier[creCode] ^short = "Code centre de responsabilité"

// ── Type organisationnel ──────────────────────────────────────────────────────

* type 1..* MS
* type ^slicing.discriminator.type = #value
* type ^slicing.discriminator.path = "coding.code"
* type ^slicing.rules = #open

* type contains crType 1..1 MS
* type[crType].coding.system = "https://hl7.fr/ig/fhir/core/CodeSystem/fr-core-cs-v2-3307" (exactly)
* type[crType].coding.code = #CENTRE-RESP (exactly)
* type[crType] ^short = "Type : Centre de responsabilité (CENTRE-RESP)"

// ── Dénomination ─────────────────────────────────────────────────────────────

* name 1..1 MS
* name ^short = "Libellé complet du CR (LIBECR — 40 chars)"

* alias 0..1 MS
* alias ^short = "Libellé réduit (LIBRCR — 20 chars)"

// ── Statut ────────────────────────────────────────────────────────────────────

* active 0..1 MS
* active ^short = "CR actif — false si INVACR=F ou INVACR=I"

// ── Agent responsable → contact ───────────────────────────────────────────────

* contact 0..1 MS
* contact.name.text 0..1 MS
* contact.name.text ^short = "Matricule agent responsable (SAGE_NUAGAGE — 9 chars)"

// ── Extensions ────────────────────────────────────────────────────────────────

* extension contains
    CREPeriodeValiditeExtension          named periodValidite         0..1 MS and
    CRECodeValiditeExtension             named codeValidite           0..1 MS and
    CRELettreBudgetaireExtension         named lettreBudgetaire       1..1 MS and
    CRECodeSecteurBudgetaireExtension    named codeSecteurBudgetaire  0..1 MS and
    CRECodeDirectionTransversaleExtension named codeDirectionTransversale 0..1 MS

* extension[periodValidite]            ^short = "Période de validité (DATDCR / DATFCR)"
* extension[codeValidite]              ^short = "Code validité (INVACR : F=Fermé / I=Invalide / V=Valide)"
* extension[lettreBudgetaire]          ^short = "Lettre budgétaire (SBUD_CODEBUD — 1 char, obligatoire)"
* extension[codeSecteurBudgetaire]     ^short = "Code secteur budgétaire (SSBU_NUSBSB — 3 chars)"
* extension[codeDirectionTransversale] ^short = "Code direction transversale (SDTR_NUDTSD — 10 chars)"

// ── Hiérarchie : Pôle (si renseigné) sinon Entité Juridique ──────────────────

* partOf 0..1 MS
* partOf only Reference(PoleProfile or EntiteJuridiqueProfile)
* partOf ^short = """
    Pôle parent si pôle parent renseigné (PoleProfile),
    sinon Entité Juridique (EntiteJuridiqueProfile).
    Si partOf référence un Pôle, ce CR est aussi listé comme membre
    de son EJ (EntiteJuridiqueProfile.extension[membres] — conforme FR Core).
    """
