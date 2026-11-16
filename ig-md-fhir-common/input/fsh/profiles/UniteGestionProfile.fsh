// =============================================
// Profil : Unité de gestion
// =============================================
// Hérite de StructureHospitaliereOrganizationProfile (parent FR Core : FRCoreOrganizationProfile).
//
// Niveau de gestion rattaché à une entité géographique et parent des unités fonctionnelles.
// Appartient à l'axe géographique. Notion absente de CPage (voisin : SETG, « établissement de
// gestion », sans concept Master Data dédié) : aucune colonne Oracle source.
//
// Attributs Master Data → FHIR (réutilisation maximale de FR Core) :
//   identifiant          → identifier[strHId]                (hérité du profil socle)
//   code_interne         → identifier[ugCode]
//   libelle              → name
//   libelle_reduit       → alias + extension[shortName]      (FR Core short-name)
//   date_debut/fin_validite → extension[usePeriod]           (organization-period, hérité de FR Core)
//   libelle_diffusion    → extension[libelleDiffusion]       (strh-libelle-diffusion, hérité du profil socle)
//   entite_geographique  → partOf                             (rattachement facultatif)
//   unités fonctionnelles rattachées → extension[membres]    (FR Core member)
//   non exposé : code de validité

Profile: UniteGestionProfile
Parent: StructureHospitaliereOrganizationProfile
Id: strh-unite-gestion-profile
Title: "Unité de gestion"
Description: """
Profil FHIR R4 représentant une unité de gestion : niveau de gestion de la structure hospitalière,
rattaché à une entité géographique et parent des unités fonctionnelles. Appartient à l'axe
géographique.

Type de structure activé par tenant : il ne fait pas partie du modèle minimal de la structure.
La notion n'existe pas en propre dans CPage.

**Scope** : TENANT uniquement.
"""

// ── Identifiants ──────────────────────────────────────────────────────────────
// Slicing déjà défini par le profil socle (discriminator value:system) — ne pas redéclarer.

* identifier contains
    ugCode 1..1 MS

* identifier[ugCode].system = "https://www.cpage.fr/ig/masterdata/common/identifiers/ug-code" (exactly)
* identifier[ugCode].value 1..1 MS
* identifier[ugCode] ^short = "Code interne de l'unité de gestion (20 caractères au plus)"

// ── Type organisationnel ──────────────────────────────────────────────────────
// Organization.type n'est pas slicé par FR Core : slicing déclaré ici.
// Code propre à CPage, absent du système FR Core fr-core-cs-v2-3307 (binding de type : example).

* type 1..* MS
* type ^slicing.discriminator.type = #value
* type ^slicing.discriminator.path = "coding.code"
* type ^slicing.rules = #open

* type contains uniteGestionType 1..1 MS
* type[uniteGestionType].coding.system = "https://hl7.fr/ig/fhir/core/CodeSystem/fr-core-cs-v2-3307" (exactly)
* type[uniteGestionType].coding.code = #UNITE-GESTION (exactly)
* type[uniteGestionType] ^short = "Type : unité de gestion (UNITE-GESTION)"

// ── Dénomination ─────────────────────────────────────────────────────────────

* name ^short = "Libellé de l'unité de gestion (40 caractères)"

* alias 0..1 MS
* alias ^short = "Libellé réduit (20 caractères)"

// Libellé réduit et période de validité : extensions FR Core héritées du parent
* extension[shortName] MS
* extension[shortName] ^short = "Libellé réduit, extension FR Core short-name"
* extension[usePeriod] MS
* extension[usePeriod] ^short = "Période de validité de l'unité de gestion (date de début et de fin)"

// ── Hiérarchie : entité géographique parente ──────────────────────────────────
// Rattachement facultatif : aucun niveau hiérarchique n'est imposé hors du modèle minimal.

* partOf 0..1 MS
* partOf only Reference(EntiteGeographiqueProfile)
* partOf ^short = "Entité géographique de rattachement"

// ── Membres : unités fonctionnelles rattachées ───────────────────────────────
// Rattachement horizontal (non principal) : porté par le parent, conformément à FR Core
// (extension member), comme pour les autres profils de la structure.

* extension contains fr-core-organization-member named membres 0..* MS
* extension[membres] ^short = "Unités fonctionnelles rattachées à l'unité de gestion"
