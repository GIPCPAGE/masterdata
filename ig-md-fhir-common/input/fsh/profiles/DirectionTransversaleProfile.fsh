// =============================================
// Profil : Direction transversale
// =============================================
// Hérite de StructureHospitaliereOrganizationProfile (parent FR Core : FRCoreOrganizationProfile).
//
// Direction fonctionnelle qui traverse les pôles (pharmacie stérilisation, systèmes
// d'information, direction des soins...) et regroupe des centres de responsabilité.
// Appartient à l'axe « direction transversale » ; dépend d'une entité juridique.
// Source Oracle : SDTR.
//
// Attributs Master Data → FHIR (réutilisation maximale de FR Core) :
//   identifiant          → identifier[strHId]                (hérité du profil socle)
//   code_interne         → identifier[dtCode]                (SDTR.NUDTSD)
//   libelle              → name                              (SDTR.LIBESD)
//   libelle_reduit       → alias + extension[shortName]      (SDTR.LIBRSD ; FR Core short-name)
//   date_debut/fin_validite → extension[usePeriod]           (SDTR.DATDSD/DATFSD ; organization-period, hérité de FR Core)
//   libelle_diffusion    → extension[libelleDiffusion]       (strh-libelle-diffusion, hérité du profil socle)
//   parent_entite_juridique → partOf                          (SDTR.CHO_NUCHCH)
//   code_validite        → extension[codeValidite]           (SDTR.INVASD ; V/I, obligatoire) ; active ne reflète que la période
//   centres de responsabilité rattachés → extension[membres] (FR Core member)

Profile: DirectionTransversaleProfile
Parent: StructureHospitaliereOrganizationProfile
Id: strh-direction-transversale-profile
Title: "Direction transversale"
Description: """
Profil FHIR R4 représentant une direction transversale : direction fonctionnelle qui traverse
les pôles (pharmacie stérilisation, systèmes d'information, direction des soins...) et regroupe
des centres de responsabilité. Appartient à l'axe « direction transversale » et dépend d'une
entité juridique.

Type de structure activé par tenant : il ne fait pas partie du modèle minimal de la structure.

Le code de validité, obligatoire, est porté par `extension[codeValidite]` (V ou I). `active` ne
reflète que la période de validité, pas le code de validité.

**Scope** : TENANT uniquement.
"""

// ── Identifiants ──────────────────────────────────────────────────────────────
// Slicing déjà défini par le profil socle (discriminator value:system) — ne pas redéclarer.

* identifier contains
    dtCode 1..1 MS

* identifier[dtCode].system = "https://www.cpage.fr/ig/masterdata/common/identifiers/dt-code" (exactly)
* identifier[dtCode].value 1..1 MS
* identifier[dtCode] ^short = "Code interne de la direction transversale (SDTR.NUDTSD)"

// ── Type organisationnel ──────────────────────────────────────────────────────
// Organization.type n'est pas slicé par FR Core : slicing déclaré ici.
// Code propre à CPage, absent du système FR Core fr-core-cs-v2-3307 (binding de type : example).

* type 1..* MS
* type ^slicing.discriminator.type = #value
* type ^slicing.discriminator.path = "coding.code"
* type ^slicing.rules = #open

* type contains directionTransversaleType 1..1 MS
* type[directionTransversaleType].coding.system = "https://hl7.fr/ig/fhir/core/CodeSystem/fr-core-cs-v2-3307" (exactly)
* type[directionTransversaleType].coding.code = #DIRECTION-TRANSVERSALE (exactly)
* type[directionTransversaleType] ^short = "Type : direction transversale (DIRECTION-TRANSVERSALE)"

// ── Dénomination ─────────────────────────────────────────────────────────────

* name ^short = "Libellé de la direction transversale (40 caractères)"

* alias 0..1 MS
* alias ^short = "Libellé réduit (20 caractères)"

// Libellé réduit et période de validité : extensions FR Core héritées du parent
* extension[shortName] MS
* extension[shortName] ^short = "Libellé réduit, extension FR Core short-name"
* extension[usePeriod] MS
* extension[usePeriod] ^short = "Période de validité de la direction transversale (date de début et de fin)"

// ── Code de validité ──────────────────────────────────────────────────────────

* extension contains DTCodeValiditeExtension named codeValidite 1..1 MS
* extension[codeValidite] ^short = "Code validité, obligatoire (INVASD : V=Valide / I=Invalide)"

// ── Hiérarchie : entité juridique de rattachement ─────────────────────────────
// Facultatif dans le profil ; obligatoire en présence d'un module CPage (hiérarchie
// minimale de la structure).

* partOf 0..1 MS
* partOf only Reference(EntiteJuridiqueProfile)
* partOf ^short = "Entité juridique de rattachement (obligatoire en présence d'un module CPage)"

// ── Membres : centres de responsabilité rattachés ────────────────────────────
// Rattachement horizontal (non principal) : porté par le parent, conformément à FR Core
// (extension member), comme pour les autres profils de la structure.

* extension contains fr-core-organization-member named membres 0..* MS
* extension[membres] ^short = "Centres de responsabilité rattachés à la direction transversale"
