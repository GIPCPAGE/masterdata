// =============================================
// Profil : Bâtiment Ophélie
// =============================================
// Hérite de StructureHospitaliereSiteProfile (parent FR Core : FRCoreLocationProfile).
//
// Entité physique de la structure hospitalière, rattachée à une entité géographique et
// référencée par les unités fonctionnelles. Appartient à l'axe géographique.
// Notion absente de CPage : aucune colonne Oracle source.
//
// Attributs Master Data → FHIR (réutilisation maximale de FR Core et de FHIR natif) :
//   identifiant          → identifier[strHId]                (hérité du profil socle)
//   code_interne         → identifier[batimentOphelieCode]
//   libelle              → name
//   libelle_reduit       → alias                              (élément natif de Location)
//   date_debut/fin_validite → extension[periodeValidite]     (strh-periode-validite, hérité du profil socle)
//   libelle_diffusion    → extension[libelleDiffusion]       (strh-libelle-diffusion, hérité du profil socle)
//   entite_geographique  → managingOrganization               (rattachement facultatif)
//   non exposé : code de validité (l'état actif est porté par status)

Profile: BatimentOphelieProfile
Parent: StructureHospitaliereSiteProfile
Id: strh-batiment-ophelie-profile
Title: "Bâtiment Ophélie"
Description: """
Profil FHIR R4 représentant un bâtiment Ophélie : entité physique de la structure hospitalière,
rattachée à une entité géographique et référencée par les unités fonctionnelles. Appartient à
l'axe géographique.

Type de structure activé par tenant : il ne fait pas partie du modèle minimal de la structure.
La notion n'existe pas dans CPage.

**Scope** : TENANT uniquement.
"""

// ── Identifiants ──────────────────────────────────────────────────────────────
// Slicing déjà défini par le profil socle (discriminator value:system) — ne pas redéclarer.

* identifier contains
    batimentOphelieCode 1..1 MS

* identifier[batimentOphelieCode].system = "https://www.cpage.fr/ig/masterdata/common/identifiers/batiment-ophelie-code" (exactly)
* identifier[batimentOphelieCode].value 1..1 MS
* identifier[batimentOphelieCode] ^short = "Code interne du bâtiment Ophélie (20 caractères au plus)"

// ── Type Location ─────────────────────────────────────────────────────────────
// Le binding de Location.type est required dans FR Core (fr-core-vs-location-type) :
// le bâtiment utilise le code FR Core BAT, pas un code propre.

* type 1..* MS
* type ^slicing.discriminator.type = #value
* type ^slicing.discriminator.path = "coding.code"
* type ^slicing.rules = #open

* type contains batimentType 1..1 MS
* type[batimentType].coding.system = "https://hl7.fr/ig/fhir/core/CodeSystem/fr-core-cs-location-type" (exactly)
* type[batimentType].coding.code = #BAT (exactly)
* type[batimentType] ^short = "Type : bâtiment (BAT) — FR Core cs-location-type"

// ── Dénomination ─────────────────────────────────────────────────────────────

* name ^short = "Libellé du bâtiment Ophélie (40 caractères)"

* alias 0..1 MS
* alias ^short = "Libellé réduit (20 caractères)"

// ── Statut actif ──────────────────────────────────────────────────────────────

* status ^short = "active | inactive"

// ── Période de validité et libellé de diffusion : extensions héritées du socle ─

* extension[periodeValidite] ^short = "Période de validité du bâtiment (date de début et de fin)"
* extension[libelleDiffusion] ^short = "Libellé de diffusion"

// ── Hiérarchie : entité géographique de rattachement ──────────────────────────
// Rattachement facultatif : aucun niveau hiérarchique n'est imposé hors du modèle minimal.

* managingOrganization 0..1 MS
* managingOrganization only Reference(EntiteGeographiqueProfile)
* managingOrganization ^short = "Entité géographique de rattachement"
