// =============================================
// Profil : Entité Géographique
// =============================================
// Site géographique d'un établissement hospitalier.
// Hérite de FRCoreOrganizationEtablissementProfile (FR Core 2.2.0).
// Identifiée par son numéro SIRET (14 chiffres).

Profile: EntiteGeographiqueProfile
Parent: FRCoreOrganizationEtablissementProfile
Id: strh-entite-geographique-profile
Title: "Entité Géographique"
Description: """
Profil représentant un site géographique d'un établissement hospitalier dans le Master Data CPage.

Hérite de `FRCoreOrganizationEtablissementProfile` (FR Core 2.2.0).

L'entité géographique est identifiée par son **numéro SIRET** (14 chiffres). Elle est rattachée à une entité juridique via `partOf`.

**Scope** : TENANT uniquement.
"""

// Identifiants
* identifier ^slicing.discriminator.type = #value
* identifier ^slicing.discriminator.path = "system"
* identifier ^slicing.rules = #open

* identifier contains
    strHId 1..1 MS and
    siret 0..1 MS and
    finess 0..1 MS

* identifier[strHId].system = "https://www.cpage.fr/ig/masterdata/common/identifiers/strh" (exactly)
* identifier[strHId].value 1..1
* identifier[strHId] ^short = "Identifiant MDM interne"

// SIRET obligatoire pour entité géographique
* identifier[siret].system = "https://sirene.fr" (exactly)
* identifier[siret].value 1..1
* identifier[siret] ^short = "Numéro SIRET (14 chiffres)"

// FINESS optionnel
* identifier[finess].system = "https://finess.esante.gouv.fr" (exactly)
* identifier[finess].value 1..1
* identifier[finess] ^short = "Numéro FINESS"

// type = GEOGRAPHICAL-ENTITY
* type 1..* MS
* type ^slicing.discriminator.type = #value
* type ^slicing.discriminator.path = "coding.code"
* type ^slicing.rules = #open
* type contains geoEntityType 1..1 MS
* type[geoEntityType].coding.system = "https://hl7.fr/ig/fhir/core/CodeSystem/fr-core-cs-v2-3307" (exactly)
* type[geoEntityType].coding.code = #GEOGRAPHICAL-ENTITY (exactly)
* type[geoEntityType] ^short = "Type : Entité géographique (GEOGRAPHICAL-ENTITY)"

* name 1..1 MS
* name ^short = "Nom du site géographique"

* active 0..1 MS

// Adresse du site
* address 0..1 MS
* address.country = "FR" (exactly)

// Extension code interne
* extension contains StrHCodeInterneExtension named codeInterne 0..1 MS

// Rattachement à l'entité juridique
* partOf 0..1 MS
* partOf only Reference(EntiteJuridiqueProfile)
* partOf ^short = "Entité juridique parente"
