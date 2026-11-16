// =============================================
// Profil : Section d'analyse
// =============================================
// Hérite de StructureHospitaliereOrganizationProfile (parent FR Core : FRCoreOrganizationProfile).
//
// Dimension de comptabilité analytique d'un centre de responsabilité. Appartient à l'axe
// budgétaire. Dans CPage (table SAN), la section d'analyse est un compte de classe 9, sans lien
// avec un centre de responsabilité ; dans Master Data, son code porte le compte analytique et
// elle peut être rattachée à un centre de responsabilité.
//
// Attributs Master Data → FHIR (réutilisation maximale de FR Core) :
//   identifiant          → identifier[strHId]                (hérité du profil socle)
//   code_interne         → identifier[saCode]                (SAN.C9E_NUECC9)
//   libelle              → name                              (SAN.LIBESA)
//   libelle_reduit       → alias + extension[shortName]      (SAN.LIBRSA ; FR Core short-name)
//   date_debut/fin_validite → extension[usePeriod]           (SAN.DTDBSA/DTFISA ; organization-period, hérité de FR Core)
//   libelle_diffusion    → extension[libelleDiffusion]       (strh-libelle-diffusion, hérité du profil socle)
//   parent_centre_responsabilite → partOf                     (attribut LOCAL)
//   code_compte_analytique → extension[compteAnalytique]     (attribut LOCAL)
//   code_groupement_hospitalier → extension[codeGroupementHospitalier] (attribut LOCAL)
//   non exposé : code de validité (SAN.INVASA)

Profile: SectionAnalyseProfile
Parent: StructureHospitaliereOrganizationProfile
Id: strh-section-analyse-profile
Title: "Section d'analyse"
Description: """
Profil FHIR R4 représentant une section d'analyse : dimension de comptabilité analytique d'un
centre de responsabilité. Appartient à l'axe budgétaire. Les unités fonctionnelles et les unités
médicales la référencent à titre indicatif.

Le code interne n'est pas unique à lui seul : un même compte existe sous plusieurs centres de
responsabilité.

Type de structure activé par tenant : il ne fait pas partie du modèle minimal de la structure.

**Scope** : TENANT uniquement.
"""

// ── Identifiants ──────────────────────────────────────────────────────────────
// Slicing déjà défini par le profil socle (discriminator value:system) — ne pas redéclarer.

* identifier contains
    saCode 1..1 MS

* identifier[saCode].system = "https://www.cpage.fr/ig/masterdata/common/identifiers/sa-code" (exactly)
* identifier[saCode].value 1..1 MS
* identifier[saCode] ^short = "Code interne de la section d'analyse (SAN.C9E_NUECC9) ; non unique à lui seul"

// ── Type organisationnel ──────────────────────────────────────────────────────
// Organization.type n'est pas slicé par FR Core : slicing déclaré ici.
// Code propre à CPage, absent du système FR Core fr-core-cs-v2-3307 (binding de type : example).

* type 1..* MS
* type ^slicing.discriminator.type = #value
* type ^slicing.discriminator.path = "coding.code"
* type ^slicing.rules = #open

* type contains sectionAnalyseType 1..1 MS
* type[sectionAnalyseType].coding.system = "https://hl7.fr/ig/fhir/core/CodeSystem/fr-core-cs-v2-3307" (exactly)
* type[sectionAnalyseType].coding.code = #SECTION-ANALYSE (exactly)
* type[sectionAnalyseType] ^short = "Type : section d'analyse (SECTION-ANALYSE)"

// ── Dénomination ─────────────────────────────────────────────────────────────

* name ^short = "Libellé de la section d'analyse (40 caractères)"

* alias 0..1 MS
* alias ^short = "Libellé réduit (20 caractères)"

// Libellé réduit et période de validité : extensions FR Core héritées du parent
* extension[shortName] MS
* extension[shortName] ^short = "Libellé réduit, extension FR Core short-name"
* extension[usePeriod] MS
* extension[usePeriod] ^short = "Période de validité de la section d'analyse (date de début et de fin)"

// ── Extensions propres à la section d'analyse (attributs LOCAL) ──────────────

* extension contains
    SACompteAnalytiqueExtension             named compteAnalytique          0..1 MS and
    StrHCodeGroupementHospitalierExtension  named codeGroupementHospitalier 0..1 MS

* extension[compteAnalytique] ^short = "Compte analytique (attribut LOCAL, nomenclature propre au tenant)"
* extension[codeGroupementHospitalier] ^short = "Code du groupement hospitalier (attribut LOCAL, 2 caractères)"

// ── Hiérarchie : centre de responsabilité de rattachement ─────────────────────
// Rattachement facultatif (attribut LOCAL) : dans CPage, la section d'analyse n'a pas de lien
// avec un centre de responsabilité.

* partOf 0..1 MS
* partOf only Reference(CentreResponsabiliteProfile)
* partOf ^short = "Centre de responsabilité de rattachement (facultatif)"
