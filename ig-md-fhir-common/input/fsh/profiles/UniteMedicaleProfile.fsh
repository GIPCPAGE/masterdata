// =============================================
// Profil : Unité Médicale
// =============================================
// ABSENT de CPage Oracle — pas de table source SIH.
// Créé et géré directement dans le Master Data pour compatibilité DPI / PMSI.
// L'UM n'est pas un sous-niveau de l'UF : dans le MOS/DGOS, l'UF est la plus
// petite unité de production médicale homogène.

Profile: UniteMedicaleProfile
Parent: StructureHospitaliereOrganizationProfile
Id: strh-unite-medicale-profile
Title: "Unité Médicale"
Description: """
Profil FHIR R4 représentant une unité médicale.

Hérite de `StructureHospitaliereOrganizationProfile`.

**Origine** : concept absent de CPage Oracle, créé et géré directement dans
le Master Data pour assurer la compatibilité avec les DPI et le PMSI qui
référencent les unités médicales.

Dans le MOS et l'organisation hospitalière française (DGOS), l'UF est la
plus petite unité de production médicale homogène. L'UM n'est pas un
sous-niveau de l'UF — la relation UM/UF dépend du cadre de référence utilisé.

FR Core n'a pas de profil dédié — type = UM (fr-core-cs-v2-3307).

**Scope** : TENANT uniquement.
"""

// type = UM
* type 1..* MS
* type ^slicing.discriminator.type = #value
* type ^slicing.discriminator.path = "coding.code"
* type ^slicing.rules = #open
* type contains umType 1..1 MS
* type[umType].coding.system = "https://hl7.fr/ig/fhir/core/CodeSystem/fr-core-cs-v2-3307" (exactly)
* type[umType].coding.code = #UM (exactly)
* type[umType] ^short = "Type : Unité médicale (UM)"

// ── Identifiants ──────────────────────────────────────────────────────────────
// Slicing déjà défini par le profil socle (discriminator value:system) — ne pas redéclarer.

* identifier contains
    umCode 1..1 MS

* identifier[umCode].system = "https://www.cpage.fr/ig/masterdata/common/identifiers/um-code" (exactly)
* identifier[umCode].value 1..1 MS
* identifier[umCode] ^short = "Code interne de l'unité médicale (20 caractères au plus)"

// ── Dénomination ─────────────────────────────────────────────────────────────

* alias 0..1 MS
* alias ^short = "Libellé réduit (20 caractères)"

// Libellé réduit et période de validité : extensions FR Core héritées du parent
* extension[shortName] MS
* extension[shortName] ^short = "Libellé réduit, extension FR Core short-name"
* extension[usePeriod] MS
* extension[usePeriod] ^short = "Période de validité de l'unité médicale (date de début et de fin)"

// ── Statut et attributs PMSI et d'autorisation ───────────────────────────────

* active 0..1 MS

* extension contains
    UMCodeValiditeExtension        named codeValidite        0..1 MS and
    UMCategoriePmsiExtension       named categoriePmsi       0..1 MS and
    UMModeHospitalisationExtension named modeHospitalisation 0..1 MS and
    UMTypeAutorisationExtension    named typeAutorisation    0..1 MS and
    UMCodeCpmExtension             named codeCpm             0..1 MS and
    UMCodePmsiExtension            named codePmsi            0..1 MS and
    UMDateAutorisationExtension    named dateAutorisation    0..1 MS and
    UMSoinsPalliatifsExtension     named soinsPalliatifs     0..1 MS and
    UMNombreLitsAutorisesExtension named nombreLitsAutorises 0..1 MS and
    UMCompteAnalytiqueExtension    named compteAnalytique    0..1 MS and
    UMSectionAnalyseExtension      named sectionAnalyse      0..1 MS

* extension[codeValidite]        ^short = "Code validité (I=Invalide / V=Valide)"
* extension[categoriePmsi]       ^short = "Catégorie PMSI (nomenclature CATEGORIE_PMSI_UM)"
* extension[modeHospitalisation] ^short = "Mode d'hospitalisation (nomenclature MODE_HOSPITALISATION)"
* extension[typeAutorisation]    ^short = "Type d'autorisation (nomenclature TYPE_AUTORISATION_UM)"
* extension[codeCpm]             ^short = "Code CPM (attribut LOCAL)"
* extension[codePmsi]            ^short = "Code PMSI (attribut LOCAL)"
* extension[dateAutorisation]    ^short = "Date d'autorisation (attribut LOCAL)"
* extension[soinsPalliatifs]     ^short = "Lits de soins palliatifs (attribut LOCAL)"
* extension[nombreLitsAutorises] ^short = "Nombre de lits autorisés (attribut LOCAL)"
* extension[compteAnalytique]    ^short = "Compte analytique (attribut LOCAL)"
* extension[sectionAnalyse]      ^short = "Section d'analyse, à titre indicatif (attribut LOCAL)"

// ── Hiérarchie : centre de responsabilité ou entité géographique ─────────────
// L'UM n'existe pas dans CPage. Elle se rattache à un centre de responsabilité ou à une entité
// géographique, l'un ou l'autre (attributs LOCAL). Ne pas contraindre à UFProfile : la relation
// UM/UF n'est pas une simple hiérarchie.

* partOf 0..1 MS
* partOf only Reference(CentreResponsabiliteProfile or EntiteGeographiqueProfile)
* partOf ^short = "Centre de responsabilité ou entité géographique de rattachement, l'un ou l'autre"

// Membres : unités fonctionnelles rattachées à l'unité médicale. Lien horizontal porté par le
// parent, conformément à FR Core (extension member).

* extension contains fr-core-organization-member named membres 0..* MS
* extension[membres] ^short = "Unités fonctionnelles rattachées à l'unité médicale"
