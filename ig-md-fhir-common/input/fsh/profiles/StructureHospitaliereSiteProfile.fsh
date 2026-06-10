// =============================================
// Profil base : Structure Hospitalière — Location (site physique)
// =============================================
// Profil socle pour les entités physiques (Chambre, Lit).
// Hérite de FRCoreLocationProfile (FR Core 2.2.0).

Profile: StructureHospitaliereSiteProfile
Parent: FRCoreLocationProfile
Id: strh-site-profile
Title: "Structure Hospitalière — Location (base)"
Description: """
Profil socle pour les entités physiques de la structure hospitalière : Chambre, Lit.

Hérite de `FRCoreLocationProfile` (FR Core 2.2.0).

**Profils dérivés** : ChambreProfile, LitProfile.
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

// Nom du site
* name 1..1 MS
* name ^short = "Libellé du site (ex : Chambre 201)"

// Statut
* status 0..1 MS
* status ^short = "active | inactive"

// Code interne SIH
* extension contains StrHCodeInterneExtension named codeInterne 0..1 MS
* extension[codeInterne] ^short = "Code interne dans le SIH source"
