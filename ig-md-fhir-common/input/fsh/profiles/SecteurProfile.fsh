// =============================================
// Profil : Secteur (secteur psychiatrique)
// =============================================
// ABSENT de CPage Oracle — pas de table source SIH connue à ce jour.
// Créé et géré directement dans le Master Data, sans données réelles CPage
// pour l'instant (aucun établissement psychiatrique par secteur actuellement
// géré) — ajouté pour couvrir le type FR Core `SECTEUR` (fr-core-cs-v2-3307)
// et anticiper un futur besoin plutôt que de laisser un trou de modélisation.
//
// Cadre réglementaire : Code de la santé publique, articles R3221-1 (définition
// des secteurs de psychiatrie générale, infanto-juvénile et en milieu
// pénitentiaire), R3221-4 (autorité du secteur, psychiatres hospitaliers),
// R3221-5 (rattachement du secteur de psychiatrie en milieu pénitentiaire).
//
// Hiérarchie : hypothèse de conception faute de donnée Oracle réelle — rattaché
// à l'Entité Géographique comme Pôle/Service (zone géographique et démographique
// définie, FR Core structure_entites.html), à revoir si un cas réel CPage émerge.
// FR Core n'a pas de profil dédié — type = SECTEUR (fr-core-cs-v2-3307).

Profile: SecteurProfile
Parent: StructureHospitaliereOrganizationProfile
Id: strh-secteur-profile
Title: "Secteur (psychiatrique)"
Description: """
Profil FHIR R4 représentant un secteur psychiatrique.

Hérite de `StructureHospitaliereOrganizationProfile`.

**Origine** : concept absent de CPage Oracle à ce jour (aucun établissement
psychiatrique sectorisé actuellement géré) — ajouté pour la conformité au
modèle FR Core (type `SECTEUR`, `fr-core-cs-v2-3307`) et pour couvrir le cadre
réglementaire (CSP art. R3221-1, R3221-4, R3221-5) sans attendre un premier cas
d'usage réel.

**Scope** : TENANT uniquement.
"""

// ── Identifiants ──────────────────────────────────────────────────────────────

* identifier contains
    secteurCode 0..1 MS

* identifier[secteurCode].system = "https://www.cpage.fr/ig/masterdata/common/identifiers/secteur-code" (exactly)
* identifier[secteurCode].value 1..1
* identifier[secteurCode] ^short = "Code secteur (absent d'Oracle — à définir si un cas réel émerge)"

// ── Type organisationnel ──────────────────────────────────────────────────────

* type 1..* MS
* type ^slicing.discriminator.type = #value
* type ^slicing.discriminator.path = "coding.code"
* type ^slicing.rules = #open
* type contains secteurType 1..1 MS
* type[secteurType].coding.system = "https://hl7.fr/ig/fhir/core/CodeSystem/fr-core-cs-v2-3307" (exactly)
* type[secteurType].coding.code = #SECTEUR (exactly)
* type[secteurType] ^short = "Type : Secteur psychiatrique (SECTEUR — fr-core-cs-v2-3307)"

// ── Dénomination ─────────────────────────────────────────────────────────────

* name 1..1 MS
* name ^short = "Libellé du secteur"

// ── Responsable (CSP art. R3221-4 : autorité du secteur) ──────────────────────
// Conforme FR Core structure_contraintes.html (STRU-4) : le secteur a 1 responsable,
// comme les structures internes, services, UF et pôles.

* contact 0..1 MS
* contact.name.text 0..1 MS
* contact.name.text ^short = "Responsable du secteur (psychiatre hospitalier, CSP art. R3221-4)"

// ── Hiérarchie ────────────────────────────────────────────────────────────────

* partOf 0..1 MS
* partOf only Reference(EntiteGeographiqueProfile)
* partOf ^short = "Entité Géographique parente (hypothèse de conception, aucune donnée Oracle réelle)"

// ── Membres : Unités Fonctionnelles ───────────────────────────────────────────
// Conforme FR Core structure_relations.html (STRU-1) : une UF peut être
// rattachée simultanément à un secteur et à un autre parent (Service, Pôle,
// Centre d'Activité). Porté par le PARENT (ici le Secteur), pas par l'UF.

* extension contains fr-core-organization-member named membres 0..* MS
* extension[membres] ^short = "Unités Fonctionnelles membres de ce secteur"
