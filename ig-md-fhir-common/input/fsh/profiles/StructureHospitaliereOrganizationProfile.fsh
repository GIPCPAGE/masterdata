// =============================================
// Profil base : Structure Hospitalière — Organization
// =============================================
// Profil socle pour toutes les entités organisationnelles
// de la structure hospitalière : Pôle, Centre de responsabilité,
// Unité médicale.
// Hérite de FRCoreOrganizationProfile (FR Core 2.2.0).
//
// Entité Juridique et Entité Géographique héritent directement de
// FRCoreOrganizationEtablissementProfile (profil dédié FR Core).
// UF hérite de FRCoreOrganizationUFProfile (profil dédié FR Core).

Profile: StructureHospitaliereOrganizationProfile
Parent: FRCoreOrganizationProfile
Id: strh-organization-profile
Title: "Structure Hospitalière — Organization (base)"
Description: """
Profil socle pour les entités organisationnelles de la structure hospitalière d'un établissement GHT CPage.

**Règles de gouvernance** :
- scope_type = TENANT uniquement — chaque structure est propre à son établissement
- Pas de doublon / harmonisation / golden record (REFERENTIEL_ORGANISATIONNEL)
- Hiérarchie via `Organization.partOf`

**Profils dérivés** : PoleProfile, CentreResponsabiliteProfile, UniteMedicaleProfile.
"""

// Identifiant obligatoire
* identifier 1..* MS
* identifier ^slicing.discriminator.type = #value
* identifier ^slicing.discriminator.path = "system"
* identifier ^slicing.rules = #open

* identifier contains
    strHId 1..1 MS

* identifier[strHId].system = "https://www.cpage.fr/ig/masterdata/common/identifiers/strh" (exactly)
* identifier[strHId].value 1..1
* identifier[strHId] ^short = "Identifiant MDM interne"
* identifier[strHId] ^definition = "UUID de l'instance dans le Master Data (instance_concept.id)."

// Nom obligatoire
* name 1..1 MS
* name ^short = "Libellé de l'entité"

// Actif
* active 0..1 MS
* active ^short = "Entité active (false = suppression logique)"

// Code interne SIH
* extension contains StrHCodeInterneExtension named codeInterne 0..1 MS
* extension[codeInterne] ^short = "Code interne dans le SIH source"

// Hiérarchie : référence vers l'entité parente
* partOf 0..1 MS
* partOf ^short = "Entité parente dans la hiérarchie hospitalière"
* partOf ^definition = "Référence vers l'entité Organisation parente (ex : Pôle → Entité Géographique). Matérialise la hiérarchie organisationnelle."
