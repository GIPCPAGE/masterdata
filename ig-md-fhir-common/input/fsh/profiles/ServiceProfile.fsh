// =============================================
// Profil : Service (service)
// =============================================
// Hérite de StructureHospitaliereOrganizationProfile.
//
// Le SERVICE est une structure parallèle au POLE (hiérarchie historique).
// Les UFs lui sont rattachées via SER_COSESE (attribut serviceId sur UFProfile).
//
// Colonnes Oracle service → FHIR :
//   COSESE (PK)    → identifier[serCode]  (4 chars)
//   LIBESE         → name
//   LIBRSE         → alias[0]
//   SIGLSE         → extension[sigle]     (10 chars, unique à ce concept)
//   DATDSE/DATFSE  → extension[periodValidite]
//   INVASE (F/I/V) → active + extension[codeValidite]
//   TYPESE (D/S)   → extension[typeService]
//   ETA_NUETET     → partOf → EntiteGeographiqueProfile
//   SAGE_NUAGAGE   → contact[0].name.text (chef de service)
//   TELCSE         → telecom.fax

Profile: ServiceProfile
Parent: StructureHospitaliereOrganizationProfile
Id: strh-service-profile
Title: "Service"
Description: """
Profil FHIR R4 représentant un service hospitalier.

Hérite de `StructureHospitaliereOrganizationProfile`.

**Modèle temporel** : PK composite (COSESE + DATDSE).

**Position dans la hiérarchie** : directement sous l'Entité Géographique.
Structure parallèle au Pôle (historique) — les UF lui sont rattachées via `serviceId`.

**Scope** : TENANT uniquement.
"""

// ── Identifiants ──────────────────────────────────────────────────────────────

* identifier ^slicing.discriminator.type = #value
* identifier ^slicing.discriminator.path = "system"
* identifier ^slicing.rules = #open

* identifier contains
    strHId  1..1 MS and
    serCode 1..1 MS

* identifier[strHId].system = "https://www.cpage.fr/ig/masterdata/common/identifiers/strh" (exactly)
* identifier[strHId].value 1..1 MS
* identifier[strHId] ^short = "Identifiant MDM interne (UUID)"

* identifier[serCode].system = "https://www.cpage.fr/ig/masterdata/common/identifiers/ser-code" (exactly)
* identifier[serCode].value 1..1 MS
* identifier[serCode] ^short = "Code service (COSESE — 4 chars)"

// ── Type organisationnel ──────────────────────────────────────────────────────

* type 1..* MS
* type ^slicing.discriminator.type = #value
* type ^slicing.discriminator.path = "coding.code"
* type ^slicing.rules = #open

* type contains serviceType 1..1 MS
* type[serviceType].coding.system = "https://www.cpage.fr/ig/masterdata/common/CodeSystem/strh-organization-type-cs" (exactly)
* type[serviceType].coding.code = #SERVICE (exactly)
* type[serviceType] ^short = "Type : Service hospitalier (SERVICE)"

// ── Dénomination ─────────────────────────────────────────────────────────────

* name 1..1 MS
* name ^short = "Libellé complet du service (LIBESE — 40 chars)"

* alias 0..1 MS
* alias ^short = "Libellé réduit (LIBRSE — 20 chars)"

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
* contact.name.text ^short = "Matricule chef de service (SAGE_NUAGAGE — 9 chars)"

// ── Extensions ────────────────────────────────────────────────────────────────

* extension contains
    SERPeriodeValiditeExtension  named periodValidite  0..1 MS and
    SERCodeValiditeExtension     named codeValidite    0..1 MS and
    SERSigleExtension            named sigle           0..1 MS and
    SERTypeServiceExtension      named typeService     0..1 MS

* extension[periodValidite] ^short = "Période de validité (DATDSE / DATFSE)"
* extension[codeValidite]   ^short = "Code validité (INVASE : F=Fermé / I=Invalide / V=Valide)"
* extension[sigle]          ^short = "Sigle du service"
* extension[typeService]    ^short = "Type service (TYPESE : D=Direction / S=Service)"

// ── Hiérarchie : Entité Géographique ─────────────────────────────────────────

* partOf 0..1 MS
* partOf only Reference(EntiteGeographiqueProfile)
* partOf ^short = "Entité Géographique parente "
