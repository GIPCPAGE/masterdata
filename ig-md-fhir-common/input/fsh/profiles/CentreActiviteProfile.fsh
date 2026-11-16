// =============================================
// Profil : Centre d'Activité
// =============================================
// Hérite de StructureHospitaliereOrganizationProfile (parent FR Core : FRCoreOrganizationProfile).
// Correspond à CAC_NUACAC dans unité fonctionnelle (attribut des UF).
//
// Le Centre d'Activité est un regroupement analytique des UF, distinct du Pôle (structurel)
// et du CR (budgétaire). Entité propre à CPage (table CAC), sans équivalent STETHOS.
// Appartient à l'axe budgétaire ; son parent est le centre de responsabilité.
//
// Attributs Master Data → FHIR (réutilisation maximale de FR Core) :
//   identifiant          → identifier[strHId]                (hérité du profil socle)
//   code_interne         → identifier[cacCode]               (CAC.NUACAC)
//   libelle              → name                              (CAC.LIBEAC)
//   libelle_reduit       → alias + extension[shortName]      (CAC.LIBRAC ; FR Core short-name)
//   date_debut/fin_validite → extension[usePeriod]           (CAC.DATDAC/DATFAC ; organization-period, hérité de FR Core)
//   code_validite        → extension[codeValidite]           (CAC.INVAAC ; F/I/V) ; active en est déduit
//   libelle_diffusion    → extension[libelleDiffusion]       (strh-libelle-diffusion, hérité du profil socle)
//   parent_centre_responsabilite → partOf                     (CAC.CRE_NUCRCR)
//   unités fonctionnelles rattachées → extension[membres]    (FR Core member)
//
// Ne pas confondre avec PAC/UAC (Poste / Unité d'Activité Complémentaire, facturation PMSI) :
// voir PacUacProfile.

Profile: CentreActiviteProfile
Parent: StructureHospitaliereOrganizationProfile
Id: strh-centre-activite-profile
Title: "Centre d'Activité"
Description: """
Profil FHIR R4 représentant un Centre d'Activité hospitalier.

Hérite de `StructureHospitaliereOrganizationProfile`.

Le Centre d'Activité est un regroupement analytique d'UF, distinct du Pôle
(organisationnel) et du Centre de Responsabilité (budgétaire). Il est référencé dans les UF
via `CAC_NUACAC`. Entité propre à CPage : aucun équivalent STETHOS.

La période de validité est portée par l'extension `usePeriod` (organization-period, héritée de
FR Core) et le code de validité par `extension[codeValidite]` (F/I/V).

Ne pas confondre avec PAC/UAC (Poste / Unité d'Activité Complémentaire, facturation PMSI)
qui hérite de `FRCoreOrganizationUACProfile` → voir `PacUacProfile`.

**Scope** : TENANT uniquement.
"""

// ── Identifiants ──────────────────────────────────────────────────────────────
// Slicing déjà défini par le profil socle (discriminator value:system) — ne pas redéclarer.

* identifier contains
    cacCode 1..1 MS

* identifier[cacCode].system = "https://www.cpage.fr/ig/masterdata/common/identifiers/cac-code" (exactly)
* identifier[cacCode].value 1..1 MS
* identifier[cacCode] ^short = "Code centre d'activité (CAC.NUACAC)"

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

* name ^short = "Libellé du centre d'activité (CAC.LIBEAC — 40 caractères)"

* alias 0..1 MS
* alias ^short = "Libellé réduit (CAC.LIBRAC — 20 caractères)"

// Libellé réduit et période de validité : extensions FR Core héritées du parent
* extension[shortName] MS
* extension[shortName] ^short = "Libellé réduit (CAC.LIBRAC), extension FR Core short-name"
* extension[usePeriod] MS
* extension[usePeriod] ^short = "Période de validité du centre d'activité (CAC.DATDAC / DATFAC)"

// ── Statut et code de validité ───────────────────────────────────────────────

* active 0..1 MS
* active ^short = "Centre d'activité actif — false si INVAAC=F (Fermé) ou INVAAC=I (Invalide)"

* extension contains CACCodeValiditeExtension named codeValidite 0..1 MS
* extension[codeValidite] ^short = "Code validité (INVAAC : F=Fermé / I=Invalide / V=Valide)"

// ── Hiérarchie ────────────────────────────────────────────────────────────────

* partOf 0..1 MS
// Conforme centre d'activité.CRE_NUCRCR — le Centre d'Activité est sous un CR (pas sous EG).
// Facultatif dans le profil ; obligatoire en présence d'un module CPage.
* partOf only Reference(CentreResponsabiliteProfile)
* partOf ^short = "Centre de Responsabilité parent (obligatoire en présence d'un module CPage)"

// ── Membres : Unités Fonctionnelles ───────────────────────────────────────────
// Conforme FR Core structure_relations.html (STRU-1/STRU-6) : une UF peut être
// rattachée simultanément à un Service, un Centre d'Activité et un Pôle. L'extension
// FR Core member est portée par le PARENT (ici le Centre d'Activité), qui liste ses
// UF membres — jamais par l'UF elle-même (voir UFProfile).

* extension contains fr-core-organization-member named membres 0..* MS
* extension[membres] ^short = "Unités Fonctionnelles membres de ce centre d'activité (CAC_NUACAC)"
