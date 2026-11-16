// =============================================
// Profil : Pôle d'activité (pôle)
// =============================================
// Hérite de StructureHospitaliereOrganizationProfile (parent FR Core : FRCoreOrganizationProfile).
//
// Attributs Master Data → FHIR (réutilisation maximale de FR Core) :
//   identifiant          → identifier[strHId]                (hérité du profil socle)
//   code_interne         → identifier[poaCode]               (POA.NUPAPA)
//   libelle              → name                              (POA.LIBEPA)
//   libelle_reduit       → alias + extension[shortName]      (POA.LIBRPA ; FR Core short-name)
//   date_debut/fin_validite → extension[usePeriod]           (POA.DATDPA/DATFPA ; organization-period, hérité de FR Core)
//   code_validite        → extension[codeValidite]           (POA.INVAPA ; F/I/V) ; active en est déduit
//   libelle_diffusion    → extension[libelleDiffusion]       (strh-libelle-diffusion, hérité du profil socle)
//   matricule_responsable → contact[0].name.text             (POA.SAGE_NUAGAGE)
//   parent_entite_juridique → partOf                          (POA.CHO_NUCHCH)
//   date_cme             → extension[dateCme]                (attribut LOCAL)
//   rattachement_menu    → extension[medecinCoordonnateur]   (attribut LOCAL)
//   unités fonctionnelles rattachées → extension[membres]    (FR Core member)

Profile: PoleProfile
Parent: StructureHospitaliereOrganizationProfile
Id: strh-pole-profile
Title: "Pôle d'activité"
Description: """
Profil FHIR R4 représentant un pôle d'activité hospitalier : il regroupe des services, des
départements, des unités fonctionnelles et des centres de responsabilité sous une même
responsabilité médicale. Appartient à l'axe médical.

Hérite de `StructureHospitaliereOrganizationProfile`.

La période de validité est portée par l'extension `usePeriod` (organization-period, héritée de
FR Core) et le code de validité par `extension[codeValidite]` (F/I/V).

Le pôle dépend d'une **entité juridique** ; un tenant peut aussi autoriser le rattachement à une
entité géographique.

**Scope** : TENANT uniquement.
"""

// ── Identifiants ──────────────────────────────────────────────────────────────
// Slicing déjà défini par le profil socle (discriminator value:system) — ne pas redéclarer.

* identifier contains
    poaCode 1..1 MS

// Code pôle
* identifier[poaCode].system = "https://www.cpage.fr/ig/masterdata/common/identifiers/poa-code" (exactly)
* identifier[poaCode].value 1..1 MS
* identifier[poaCode] ^short = "Code pôle d'activité (POA.NUPAPA)"

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

// Libellé réduit et période de validité : extensions FR Core héritées du parent
* extension[shortName] MS
* extension[shortName] ^short = "Libellé réduit (LIBRPA), extension FR Core short-name"
* extension[usePeriod] MS
* extension[usePeriod] ^short = "Période de validité du pôle (DATDPA / DATFPA)"

// ── Statut ────────────────────────────────────────────────────────────────────

* active 0..1 MS
* active ^short = "Pôle actif — false si INVAPA=F (Fermé) ou INVAPA=I (Invalide)"

// ── Extensions ────────────────────────────────────────────────────────────────

* extension contains
    POACodeValiditeExtension          named codeValidite          0..1 MS and
    POADateCmeExtension               named dateCme               0..1 MS and
    POAMedecinCoordonnateurExtension  named medecinCoordonnateur  0..1 MS

* extension[codeValidite]         ^short = "Code validité (INVAPA : F=Fermé / I=Invalide / V=Valide)"
* extension[dateCme]              ^short = "Date de la commission médicale d'établissement (attribut LOCAL)"
* extension[medecinCoordonnateur] ^short = "Médecin coordonnateur du pôle (attribut LOCAL, texte libre)"

// ── Agent responsable → contact ───────────────────────────────────────────────
// Le matricule SAGE_NUAGAGE est stocké comme contact[0].name.text

* contact 0..1 MS
* contact.name.text 0..1 MS
* contact.name.text ^short = "Matricule de l'agent responsable (SAGE_NUAGAGE)"

// ── Hiérarchie : entité juridique de rattachement ─────────────────────────────
// Le pôle dépend d'une entité juridique (POA.CHO_NUCHCH) : rattachement obligatoire en
// présence d'un module CPage. Les liens autorisés étant paramétrables par tenant, un tenant
// peut rattacher le pôle à une entité géographique.

* partOf 0..1 MS
* partOf only Reference(EntiteJuridiqueProfile or EntiteGeographiqueProfile)
* partOf ^short = "Entité juridique de rattachement (ou entité géographique, selon les liens autorisés du tenant)"

// ── Membres : Unités Fonctionnelles ───────────────────────────────────────────
// Conforme FR Core structure_relations.html (STRU-1/STRU-6) : une UF peut être
// rattachée simultanément à un Service, un Centre d'Activité et un Pôle (POA_NUPAPA,
// optionnel). L'extension FR Core member est portée par le PARENT (ici le Pôle),
// qui liste ses UF membres — jamais par l'UF elle-même (voir UFProfile).

* extension contains fr-core-organization-member named membres 0..* MS
* extension[membres] ^short = "Unités Fonctionnelles membres de ce pôle (POA_NUPAPA)"
