// =============================================
// Profil : Unité Fonctionnelle (UF)
// =============================================
// Hérite de FRCoreOrganizationUFProfile (FR Core 2.2.0)
// qui définit déjà les extensions UF spécifiques :
//   - fr-core-organization-discipline-equipement
//   - fr-core-organization-type-activite (required)
//   - fr-core-organization-champ-activite (MCO/HAD/PSY)
//   - fr-core-organization-place-hebergement-theorique
//   - fr-core-organization-uf-externe
//   - fr-core-organization-uf-indicateur (HEB/SOIN/ADMIN/MED/TECH/MEDICOTECH/MAG)
//   - fr-core-organization-demandeuse-acte
//   - fr-core-organization-executante-acte

Profile: UFProfile
Parent: FRCoreOrganizationUFProfile
Id: strh-uf-profile
Title: "Unité Fonctionnelle (UF)"
Description: """
Profil représentant une Unité Fonctionnelle (UF) dans la structure hospitalière CPage.

Hérite de `FRCoreOrganizationUFProfile` (FR Core 2.2.0) qui porte déjà les extensions UF :
champ d'activité (MCO/HAD/PSY), indicateur UF (HEB/SOIN/ADMIN/MED/TECH), capacité en lits, etc.

CPage ajoute uniquement :
- L'identifiant MDM interne (`strHId`)
- Le code interne SIH (`codeInterne`)

**Scope** : TENANT uniquement.
"""

// Identifiant MDM interne
* identifier ^slicing.discriminator.type = #value
* identifier ^slicing.discriminator.path = "system"
* identifier ^slicing.rules = #open

* identifier contains
    strHId 1..1 MS

* identifier[strHId].system = "https://www.cpage.fr/ig/masterdata/common/identifiers/strh" (exactly)
* identifier[strHId].value 1..1
* identifier[strHId] ^short = "Identifiant MDM interne"

* name 1..1 MS
* name ^short = "Libellé de l'UF"

* active 0..1 MS

// Code interne SIH
* extension contains StrHCodeInterneExtension named codeInterne 0..1 MS
* extension[codeInterne] ^short = "Code UF dans le SIH source"

// Hiérarchie : UF → Pôle ou Centre de responsabilité
* partOf 0..1 MS
* partOf only Reference(PoleProfile or CentreResponsabiliteProfile)
* partOf ^short = "Pôle ou Centre de responsabilité parent"
