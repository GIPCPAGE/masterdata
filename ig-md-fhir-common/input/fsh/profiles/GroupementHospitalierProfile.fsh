// =============================================
// Profil : Groupement hospitalier
// =============================================
// Hérite de StructureHospitaliereOrganizationProfile (parent FR Core : FRCoreOrganizationProfile).
//
// Niveau intermédiaire entre l'entité juridique et ses établissements : il regroupe des entités
// géographiques (établissements de gestion) d'une entité juridique et porte des secteurs
// budgétaires. Niveau propre aux très grands établissements multi-sites, désactivé par défaut.
// Notion absente de CPage (équivalent : ETA + SETG) : aucune colonne Oracle source.
//
// Attributs Master Data → FHIR (réutilisation maximale de FR Core) :
//   identifiant          → identifier[strHId]                (hérité du profil socle)
//   code_interne         → identifier[ghCode]
//   libelle              → name
//   libelle_reduit       → alias + extension[shortName]      (FR Core short-name)
//   date_debut/fin_validite → extension[usePeriod]           (organization-period, hérité de FR Core)
//   entite_juridique     → partOf                             (rattachement obligatoire)
//   adresse (lignes, commune, code postal) → address         (fr-core-address)
//   entités géographiques et secteurs budgétaires rattachés → extension[membres] (FR Core member)
//   non exposés : code de validité, libellé de diffusion, bureau distributeur

Profile: GroupementHospitalierProfile
Parent: StructureHospitaliereOrganizationProfile
Id: strh-groupement-hospitalier-profile
Title: "Groupement hospitalier"
Description: """
Profil FHIR R4 représentant un groupement hospitalier : niveau intermédiaire entre l'entité
juridique et ses établissements, qui regroupe des entités géographiques et porte des secteurs
budgétaires. Distinct du GHT.

Niveau propre aux très grands établissements multi-sites, activé par tenant (désactivé par défaut).
La notion n'existe pas en propre dans CPage.

**Scope** : TENANT uniquement.
"""

// ── Identifiants ──────────────────────────────────────────────────────────────
// Slicing déjà défini par le profil socle (discriminator value:system) — ne pas redéclarer.

* identifier contains
    ghCode 1..1 MS

* identifier[ghCode].system = "https://www.cpage.fr/ig/masterdata/common/identifiers/gh-code" (exactly)
* identifier[ghCode].value 1..1 MS
* identifier[ghCode] ^short = "Code interne du groupement hospitalier (2 caractères)"

// ── Type organisationnel ──────────────────────────────────────────────────────
// Organization.type n'est pas slicé par FR Core : slicing déclaré ici.

* type 1..* MS
* type ^slicing.discriminator.type = #value
* type ^slicing.discriminator.path = "coding.code"
* type ^slicing.rules = #open

* type contains groupementType 1..1 MS
* type[groupementType].coding.system = "https://hl7.fr/ig/fhir/core/CodeSystem/fr-core-cs-v2-3307" (exactly)
* type[groupementType].coding.code = #GROUP (exactly)
* type[groupementType] ^short = "Type : groupement (GROUP)"

// ── Dénomination ─────────────────────────────────────────────────────────────

* name ^short = "Libellé du groupement hospitalier (40 caractères)"

* alias 0..1 MS
* alias ^short = "Libellé réduit (20 caractères)"

// Libellé réduit et période de validité : extensions FR Core héritées du parent
* extension[shortName] MS
* extension[shortName] ^short = "Libellé réduit, extension FR Core short-name"
* extension[usePeriod] MS
* extension[usePeriod] ^short = "Période de validité du groupement (date de début et de fin)"

// ── Adresse (attributs LOCAL, actifs selon le tenant) ─────────────────────────

* address 0..1 MS
* address.line 0..2 MS
* address.line ^short = "Adresse, lignes 1 et 2"
* address.city 0..1 MS
* address.city ^short = "Commune"
* address.postalCode 0..1 MS
* address.postalCode ^short = "Code postal (5 chiffres)"

// ── Hiérarchie : entité juridique parente (obligatoire) ───────────────────────

* partOf 1..1 MS
* partOf only Reference(EntiteJuridiqueProfile)
* partOf ^short = "Entité juridique parente (rattachement obligatoire)"

// ── Membres : entités géographiques et secteurs budgétaires rattachés ────────
// Rattachement horizontal (non principal) : porté par le parent, conformément à FR Core
// (extension member), comme pour les autres profils de la structure.

* extension contains fr-core-organization-member named membres 0..* MS
* extension[membres] ^short = "Entités géographiques et secteurs budgétaires rattachés au groupement"
