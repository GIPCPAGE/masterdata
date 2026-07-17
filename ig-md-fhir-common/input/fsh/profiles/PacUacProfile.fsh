// =============================================
// Profil : PAC / UAC (Poste / Unité d'Activité Complémentaire)
// =============================================
// ABSENT de CPage Oracle — pas de table source SIH.
// Créé et géré directement dans le Master Data pour compatibilité DPI / PMSI.
//
// Le PAC/UAC est l'unité élémentaire de facturation des activités de soins PMSI.
// Il associe une discipline de prestation à un tarif TNJP.
// Distinct du Centre d'Activité (CAC — analytique Oracle, voir CentreActiviteProfile).
//
// Hérite de FRCoreOrganizationUACProfile (FR Core 2.2.0).
// partOf → UF parente.

Profile: PacUacProfile
Parent: FRCoreOrganizationUACProfile
Id: strh-pac-uac-profile
Title: "PAC / UAC (Unité d'Activité Complémentaire)"
Description: """
Profil FHIR R4 représentant un Poste / Unité d'Activité Complémentaire (PAC/UAC).

Hérite de `FRCoreOrganizationUACProfile` (FR Core 2.2.0) qui impose `type.coding.code = UAC`.

**Origine** : concept absent de CPage Oracle, créé et géré directement dans
le Master Data pour assurer la compatibilité avec les DPI et le PMSI.

Le PAC/UAC est le niveau élémentaire de facturation des activités de soins PMSI :
il associe une discipline de prestation à un tarif de nuit journalier de prestation (TNJP).

Ne pas confondre avec le Centre d'Activité (`CentreActiviteProfile`) qui est lui
un concept Oracle CPage (CAC_NUACAC, analytique).

**Scope** : TENANT uniquement.
"""

// ── Identifiants ──────────────────────────────────────────────────────────────

* identifier ^slicing.discriminator.type = #value
* identifier ^slicing.discriminator.path = "system"
* identifier ^slicing.rules = #open

* identifier contains
    strHId  1..1 MS and
    uacCode 0..1 MS

* identifier[strHId].system = "https://www.cpage.fr/ig/masterdata/common/identifiers/strh" (exactly)
* identifier[strHId].value 1..1 MS
* identifier[strHId] ^short = "Identifiant MDM interne (UUID)"

* identifier[uacCode].system = "https://www.cpage.fr/ig/masterdata/common/identifiers/uac-code" (exactly)
* identifier[uacCode].value 1..1
* identifier[uacCode] ^short = "Code UAC/PAC"

// ── Dénomination ─────────────────────────────────────────────────────────────

* name 0..1 MS
* name ^short = "Libellé de l'UAC/PAC"

* active 0..1 MS

// ── Extensions FR Core héritées (Must Support) ────────────────────────────────
// FRCoreOrganizationUACProfile définit disciplinePrestation et tarif.

* extension[fr-core-organization-uac-discipline-prestation] MS
* extension[fr-core-organization-uac-discipline-prestation] ^short = "Discipline de prestation (Coding — FRCoreValueSetDisciplinePrestation)"

* extension[fr-core-organization-uac-tarif] MS
* extension[fr-core-organization-uac-tarif] ^short = "Tarif TNJP (Coding — FRCoreValueSetOrganizationCodeTarifTNJP)"

// ── Hiérarchie : rattachement à l'UF ─────────────────────────────────────────

* partOf 0..1 MS
* partOf only Reference(UFProfile)
* partOf ^short = "Unité Fonctionnelle parente"
