// =============================================
// Profil : Centre d'Activité (UAC/PAC)
// =============================================
// Hérite de FRCoreOrganizationUACProfile (FR Core 2.2.0).
// Correspond à CAC_NUACAC dans unité fonctionnelle (attribut des UF).
//
// Le Centre d'Activité est un regroupement analytique des UF,
// distinct du Pôle (structurel) et du CR (budgétaire).
// FR Core définit FRCoreOrganizationUACProfile pour cette entité.
//
// Référence Oracle : unité fonctionnelle.CAC_NUACAC = 'Code Centre d activité'

Profile: CentreActiviteProfile
Parent: FRCoreOrganizationProfile
Id: strh-centre-activite-profile
Title: "Centre d'Activité"
Description: """
Profil FHIR R4 représentant un Centre d'Activité hospitalier.

Hérite de `FRCoreOrganizationProfile` (FR Core 2.2.0).

Le Centre d'Activité est un regroupement analytique d'UF, distinct du Pôle
(organisationnel) et du Centre de Responsabilité (budgétaire).
Il est référencé dans les UF via `CAC_NUACAC` (champ analytique `unité fonctionnelle`).

Ne pas confondre avec PAC/UAC (Poste / Unité d'Activité Complémentaire, facturation PMSI)
qui hérite de `FRCoreOrganizationUACProfile` → voir `PacUacProfile`.

**Scope** : TENANT uniquement.
"""

// ── Identifiants ──────────────────────────────────────────────────────────────

* identifier ^slicing.discriminator.type = #value
* identifier ^slicing.discriminator.path = "system"
* identifier ^slicing.rules = #open

* identifier contains
    strHId  1..1 MS and
    cacCode 1..1 MS

* identifier[strHId].system = "https://www.cpage.fr/ig/masterdata/common/identifiers/strh" (exactly)
* identifier[strHId].value 1..1 MS
* identifier[strHId] ^short = "Identifiant MDM interne (UUID)"

* identifier[cacCode].system = "https://www.cpage.fr/ig/masterdata/common/identifiers/cac-code" (exactly)
* identifier[cacCode].value 1..1 MS
* identifier[cacCode] ^short = "Code centre d'activité (CAC_NUACAC — 4 chars)"

// ── Type organisationnel ──────────────────────────────────────────────────────

* type 1..* MS
* type ^slicing.discriminator.type = #value
* type ^slicing.discriminator.path = "coding.code"
* type ^slicing.rules = #open

* type contains cacType 1..1 MS
* type[cacType].coding.system = "https://hl7.fr/ig/fhir/core/CodeSystem/fr-core-cs-v2-3307" (exactly)
* type[cacType].coding.code = #CENTRE-ACTIVITE (exactly)
* type[cacType] ^short = "Type : Centre d'Activité (CENTRE-ACTIVITE)"

// ── Dénomination ─────────────────────────────────────────────────────────────

* name 1..1 MS
* name ^short = "Libellé du centre d'activité"

* active 0..1 MS

// ── Code interne SIH ─────────────────────────────────────────────────────────

* extension contains StrHCodeInterneExtension named codeInterne 0..1 MS
* extension[codeInterne] ^short = "Code interne SIH (CAC_NUACAC)"

// ── Hiérarchie ────────────────────────────────────────────────────────────────

* partOf 0..1 MS
// Conforme centre d'activité.CRE_NUCRCR — le Centre d'Activité est sous un CR (pas sous EG)
* partOf only Reference(CentreResponsabiliteProfile)
* partOf ^short = "Centre de Responsabilité parent"

// ── Membres : Unités Fonctionnelles ───────────────────────────────────────────
// Conforme FR Core structure_relations.html (STRU-1/STRU-6) : une UF peut être
// rattachée simultanément à un Service, un Centre d'Activité et un Pôle. L'extension
// FR Core member est portée par le PARENT (ici le Centre d'Activité), qui liste ses
// UF membres — jamais par l'UF elle-même (voir UFProfile).

* extension contains fr-core-organization-member named membres 0..* MS
* extension[membres] ^short = "Unités Fonctionnelles membres de ce centre d'activité (CAC_NUACAC)"
