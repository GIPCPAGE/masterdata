// =============================================
// Profil : Entité Juridique
// =============================================
// Entité légale d'un établissement hospitalier.
// Hérite de FRCoreOrganizationEtablissementProfile (FR Core 2.2.0).
// Identifiée par son numéro SIREN (9 chiffres).

Profile: EntiteJuridiqueProfile
Parent: FRCoreOrganizationEtablissementProfile
Id: strh-entite-juridique-profile
Title: "Entité Juridique"
Description: """
Profil représentant l'entité légale d'un établissement hospitalier dans le Master Data CPage.

Hérite de `FRCoreOrganizationEtablissementProfile` (FR Core 2.2.0) qui porte les extensions SAE obligatoires.

L'entité juridique est identifiée par son **numéro SIREN** (9 chiffres). Elle peut regrouper plusieurs entités géographiques (sites).

**Scope** : TENANT uniquement — propre à l'établissement propriétaire.
"""

// Identifiant MDM interne obligatoire
* identifier ^slicing.discriminator.type = #value
* identifier ^slicing.discriminator.path = "system"
* identifier ^slicing.rules = #open

* identifier contains
    strHId 1..1 MS and
    siren 0..1 MS

* identifier[strHId].system = "https://www.cpage.fr/ig/masterdata/common/identifiers/strh" (exactly)
* identifier[strHId].value 1..1
* identifier[strHId] ^short = "Identifiant MDM interne"

// SIREN obligatoire pour entité juridique
* identifier[siren].system = "https://sirene.fr/siren" (exactly)
* identifier[siren].value 1..1
* identifier[siren] ^short = "Numéro SIREN (9 chiffres)"
* identifier[siren] ^definition = "Numéro SIREN identifiant l'entité légale auprès de l'INSEE."

// type Organisation = LEGAL-ENTITY
* type 1..* MS
* type ^slicing.discriminator.type = #value
* type ^slicing.discriminator.path = "coding.code"
* type ^slicing.rules = #open
* type contains legalEntityType 1..1 MS
* type[legalEntityType].coding.system = "https://hl7.fr/ig/fhir/core/CodeSystem/fr-core-cs-v2-3307" (exactly)
* type[legalEntityType].coding.code = #LEGAL-ENTITY (exactly)
* type[legalEntityType] ^short = "Type : Entité légale (LEGAL-ENTITY)"

// Nom obligatoire
* name 1..1 MS
* name ^short = "Raison sociale de l'entité juridique"

// Actif
* active 0..1 MS

// Code interne SIH
* extension contains StrHCodeInterneExtension named codeInterne 0..1 MS
* extension[codeInterne] ^short = "Code interne dans le SIH source"
