// =============================================
// Profil : Service (service)
// =============================================
// Hérite de StructureHospitaliereOrganizationProfile (parent FR Core : FRCoreOrganizationProfile).
//
// Le SERVICE est une structure parallèle au POLE (hiérarchie historique). Il fait partie du
// modèle minimal CPage. Les UFs lui sont rattachées via SER_COSESE (attribut serviceId sur UFProfile).
//
// Attributs Master Data → FHIR (réutilisation maximale de FR Core) :
//   identifiant          → identifier[strHId]                (hérité du profil socle)
//   code_interne         → identifier[serCode]               (SER.COSESE)
//   libelle              → name                              (SER.LIBESE)
//   libelle_reduit       → alias + extension[shortName]      (SER.LIBRSE ; FR Core short-name)
//   date_debut/fin_validite → extension[usePeriod]           (SER.DATDSE/DATFSE ; organization-period, hérité de FR Core)
//   code_validite        → extension[codeValidite]           (SER.INVASE ; I/V) ; active en est déduit
//   libelle_diffusion    → extension[libelleDiffusion]       (strh-libelle-diffusion, hérité du profil socle)
//   sigle                → extension[sigle]                  (SER.SIGLSE)
//   type_service         → extension[typeService]            (SER.TYPESE ; D/S)
//   telecopie            → telecom (fax)                     (SER.TELCSE)
//   matricule_chef_service → contact[0].name.text            (SER.SAGE_NUAGAGE)
//   parent_eg            → partOf                             (SER.ETA_NUETET)
//   parent_pole          → lien horizontal : le pôle liste le service par FR Core member
//   attributs LOCAL      → extension[disciplinesEquipement] (FR Core discipline-equipement, plusieurs
//                          disciplines simultanées), extension[chefAdjoint], extension[dateCme],
//                          extension[siteInternet]
//   unités fonctionnelles rattachées → extension[membres]    (FR Core member)

Profile: ServiceProfile
Parent: StructureHospitaliereOrganizationProfile
Id: strh-service-profile
Title: "Service"
Description: """
Profil FHIR R4 représentant un service hospitalier : il regroupe des unités fonctionnelles autour
d'une même activité médicale.

Hérite de `StructureHospitaliereOrganizationProfile`.

La période de validité est portée par l'extension `usePeriod` (organization-period, héritée de
FR Core) et le code de validité par `extension[codeValidite]` (I/V).

**Position dans la hiérarchie** : directement sous l'Entité Géographique.
Structure parallèle au Pôle (historique) : un pôle peut lister le service parmi ses membres,
et les UF sont rattachées au service via `serviceId`.

**Scope** : TENANT uniquement.
"""

// ── Identifiants ──────────────────────────────────────────────────────────────
// Slicing déjà défini par le profil socle (discriminator value:system) — ne pas redéclarer.

* identifier contains
    serCode 1..1 MS

* identifier[serCode].system = "https://www.cpage.fr/ig/masterdata/common/identifiers/ser-code" (exactly)
* identifier[serCode].value 1..1 MS
* identifier[serCode] ^short = "Code service (SER.COSESE)"

// ── Type organisationnel ──────────────────────────────────────────────────────
// SERVICE est un code du système FR Core fr-core-cs-v2-3307 : pas de code propre.

* type 1..* MS
* type ^slicing.discriminator.type = #value
* type ^slicing.discriminator.path = "coding.code"
* type ^slicing.rules = #open

* type contains serviceType 1..1 MS
* type[serviceType].coding.system = "https://hl7.fr/ig/fhir/core/CodeSystem/fr-core-cs-v2-3307" (exactly)
* type[serviceType].coding.code = #SERVICE (exactly)
* type[serviceType] ^short = "Type : Service (SERVICE)"

// ── Dénomination ─────────────────────────────────────────────────────────────

* name 1..1 MS
* name ^short = "Libellé complet du service (LIBESE — 40 chars)"

* alias 0..1 MS
* alias ^short = "Libellé réduit (LIBRSE — 20 chars)"

// Libellé réduit et période de validité : extensions FR Core héritées du parent
* extension[shortName] MS
* extension[shortName] ^short = "Libellé réduit (LIBRSE), extension FR Core short-name"
* extension[usePeriod] MS
* extension[usePeriod] ^short = "Période de validité du service (DATDSE / DATFSE)"

// ── Statut ────────────────────────────────────────────────────────────────────

* active 0..1 MS
* active ^short = "Service actif — false si INVASE=F ou INVASE=I"

// ── Télécom ───────────────────────────────────────────────────────────────────

* telecom 0..1 MS
* telecom.system = #fax (exactly)
* telecom ^short = "Télécopie (TELCSE — 20 chars)"

// ── Contact : chef de service ─────────────────────────────────────────────────

* contact 0..1 MS
* contact.name.text 0..1 MS
* contact.name.text ^short = "Matricule chef de service (SAGE_NUAGAGE)"

// ── Extensions ────────────────────────────────────────────────────────────────

* extension contains
    SERCodeValiditeExtension          named codeValidite         0..1 MS and
    SERSigleExtension                 named sigle                0..1 MS and
    SERTypeServiceExtension           named typeService          0..1 MS and
    fr-core-organization-discipline-equipement named disciplinesEquipement 0..* MS and
    SERChefAdjointExtension           named chefAdjoint          0..1 MS and
    StrHDateCmeExtension              named dateCme              0..1 MS and
    SERSiteInternetExtension          named siteInternet         0..1 MS

* extension[codeValidite]         ^short = "Code validité (INVASE : I=Invalide / V=Valide)"
* extension[sigle]                ^short = "Sigle du service"
* extension[typeService]          ^short = "Type service (TYPESE : D=Direction / S=Service)"
* extension[disciplinesEquipement] ^short = "Disciplines d'équipement du service, plusieurs simultanément (attribut LOCAL), extension FR Core discipline-equipement"
* extension[chefAdjoint]          ^short = "Matricule du chef de service adjoint, un seul par service (attribut LOCAL)"
* extension[dateCme]              ^short = "Date de la commission médicale d'établissement (attribut LOCAL)"
* extension[siteInternet]         ^short = "Service visible sur le site internet (attribut LOCAL)"

// ── Hiérarchie : Entité Géographique ─────────────────────────────────────────

* partOf 0..1 MS
* partOf only Reference(EntiteGeographiqueProfile)
* partOf ^short = "Entité Géographique parente"

// ── Membres : Unités Fonctionnelles ───────────────────────────────────────────
// Conforme FR Core structure_relations.html (STRU-1/STRU-6) : une UF peut être
// rattachée simultanément à un Service, un Centre d'Activité et un Pôle. L'extension
// FR Core member est portée par le PARENT (ici le Service), qui liste ses UF
// membres — jamais par l'UF elle-même (voir UFProfile).

* extension contains fr-core-organization-member named membres 0..* MS
* extension[membres] ^short = "Unités Fonctionnelles membres de ce service (SER_COSESE)"
