// =============================================
// Profil : Centre de Responsabilité (centre de responsabilité)
// =============================================
// Hérite de StructureHospitaliereOrganizationProfile (parent FR Core : FRCoreOrganizationProfile).
//
// Attributs Master Data → FHIR (réutilisation maximale de FR Core) :
//   identifiant          → identifier[strHId]                (hérité du profil socle)
//   code_interne         → identifier[creCode]               (CRE.NUCRCR — 5 chars au plus)
//   libelle              → name                              (CRE.LIBECR)
//   libelle_reduit       → alias + extension[shortName]      (CRE.LIBRCR ; FR Core short-name)
//   date_debut/fin_validite → extension[usePeriod]           (CRE.DATDCR/DATFCR ; organization-period, hérité de FR Core)
//   code_validite        → extension[codeValidite]           (CRE.INVACR ; I/V) ; active en est déduit
//   libelle_diffusion    → extension[libelleDiffusion]       (strh-libelle-diffusion, hérité du profil socle)
//   lettre_budgetaire    → extension[lettreBudgetaire]       (CRE.SBUD_CODEBUD)
//   matricule_responsable → contact[0].name.text             (CRE.SAGE_NUAGAGE)
//   nom_responsable      → contact[0].name.family            (attribut LOCAL)
//   parent_pole, parent_secteur_budgetaire, parent_direction_transversale
//                        → partOf pour le parent principal ; les codes des deux autres rattachements
//                          restent portés par extension[codeSecteurBudgetaire] (CRE.SSBU_NUSBSB)
//                          et extension[codeDirectionTransversale] (CRE.SDTR_NUDTSD)
//   code_entite_juridique → partOf quand l'entité juridique est le parent principal ; sinon
//                          l'entité juridique liste ce CR comme membre (FR Core member, STRU-1)
//   code_discipline_equipement → extension[disciplineEquipement] (FR Core discipline-equipement ; attribut LOCAL)
//   code_groupement_hospitalier → extension[codeGroupementHospitalier] (attribut LOCAL)
//
// Hiérarchie :
//   - partOf porte le rattachement principal, c'est-à-dire celui de l'axe principal du tenant :
//     pôle (axe médical), secteur budgétaire (axe budgétaire), direction transversale
//     (axe direction transversale), ou entité juridique à défaut.
//   - Conforme FR Core (structure_relations.html, STRU-1) : quand partOf ne pointe pas vers
//     l'entité juridique, le rattachement à l'EJ est exprimé côté EJ
//     (EntiteJuridiqueProfile.extension[membres]), pas par une extension sur ce CR.

Profile: CentreResponsabiliteProfile
Parent: StructureHospitaliereOrganizationProfile
Id: strh-centre-responsabilite-profile
Title: "Centre de Responsabilité"
Description: """
Profil FHIR R4 représentant un centre de responsabilité hospitalier : unité de gestion budgétaire
placée sous la responsabilité d'un agent.

Hérite de `StructureHospitaliereOrganizationProfile`.

La période de validité est portée par l'extension `usePeriod` (organization-period, héritée de
FR Core) et le code de validité par `extension[codeValidite]` (I/V).

**Hiérarchie** :
- `partOf` porte le rattachement principal : pôle, secteur budgétaire, direction transversale,
  ou entité juridique à défaut, selon l'axe principal du tenant
- les codes du secteur budgétaire et de la direction transversale restent portés par leurs
  extensions quand ils ne sont pas le parent principal
- Conforme FR Core (STRU-1) : quand `partOf` ne référence pas l'entité juridique, le rattachement
  à l'Entité Juridique est exprimé côté EJ (`extension[membres]` sur `EntiteJuridiqueProfile`),
  pas par une extension portée par ce CR.

**Scope** : TENANT uniquement.
"""

// ── Identifiants ──────────────────────────────────────────────────────────────
// Slicing déjà défini par le profil socle (discriminator value:system) — ne pas redéclarer.

* identifier contains
    creCode 1..1 MS

// Code CR
* identifier[creCode].system = "https://www.cpage.fr/ig/masterdata/common/identifiers/cre-code" (exactly)
* identifier[creCode].value 1..1 MS
* identifier[creCode] ^short = "Code centre de responsabilité (CRE.NUCRCR — 5 chars au plus)"

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

// Libellé réduit et période de validité : extensions FR Core héritées du parent
* extension[shortName] MS
* extension[shortName] ^short = "Libellé réduit (LIBRCR), extension FR Core short-name"
* extension[usePeriod] MS
* extension[usePeriod] ^short = "Période de validité du CR (DATDCR / DATFCR)"

// ── Statut ────────────────────────────────────────────────────────────────────

* active 0..1 MS
* active ^short = "CR actif — false si INVACR=F ou INVACR=I"

// ── Agent responsable → contact ───────────────────────────────────────────────

* contact 0..1 MS
* contact.name.text 0..1 MS
* contact.name.text ^short = "Matricule agent responsable (SAGE_NUAGAGE)"
* contact.name.family 0..1 MS
* contact.name.family ^short = "Nom du responsable (attribut LOCAL, 80 caractères au plus)"

// ── Extensions ────────────────────────────────────────────────────────────────

* extension contains
    CRECodeValiditeExtension             named codeValidite           0..1 MS and
    CRELettreBudgetaireExtension         named lettreBudgetaire       0..1 MS and
    CRECodeSecteurBudgetaireExtension    named codeSecteurBudgetaire  0..1 MS and
    CRECodeDirectionTransversaleExtension named codeDirectionTransversale 0..1 MS and
    fr-core-organization-discipline-equipement named disciplineEquipement 0..1 MS and
    StrHCodeGroupementHospitalierExtension named codeGroupementHospitalier 0..1 MS

* extension[codeValidite]              ^short = "Code validité (INVACR : I=Invalide / V=Valide)"
* extension[lettreBudgetaire]          ^short = "Lettre budgétaire (SBUD_CODEBUD — 1 char), autorisée pour l'entité juridique du CR ; obligatoire dans CPage"
* extension[codeSecteurBudgetaire]     ^short = "Code secteur budgétaire (SSBU_NUSBSB — 3 chars)"
* extension[codeDirectionTransversale] ^short = "Code direction transversale (SDTR_NUDTSD — 10 chars)"
* extension[disciplineEquipement]      ^short = "Discipline d'équipement (attribut LOCAL), extension FR Core discipline-equipement"
* extension[codeGroupementHospitalier] ^short = "Code du groupement hospitalier (attribut LOCAL, 2 caractères)"

// ── Hiérarchie : rattachement principal ───────────────────────────────────────

* partOf 0..1 MS
* partOf only Reference(PoleProfile or SecteurBudgetaireProfile or DirectionTransversaleProfile or EntiteJuridiqueProfile)
* partOf ^short = """
    Rattachement principal : pôle, secteur budgétaire, direction transversale,
    ou entité juridique à défaut, selon l'axe principal du tenant.
    Si partOf ne référence pas l'entité juridique, ce CR est aussi listé comme membre
    de son EJ (EntiteJuridiqueProfile.extension[membres] — conforme FR Core).
    """
