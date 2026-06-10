// =============================================
// Profil : Centre de Responsabilité
// =============================================

Profile: CentreResponsabiliteProfile
Parent: StructureHospitaliereOrganizationProfile
Id: strh-centre-responsabilite-profile
Title: "Centre de Responsabilité"
Description: """
Profil représentant un centre de responsabilité budgétaire dans la structure hospitalière CPage.

Hérite de `StructureHospitaliereOrganizationProfile`.

Le centre de responsabilité est une entité de gestion budgétaire.
Peut être rattaché à un pôle ou directement à une entité géographique via `partOf`.

**Scope** : TENANT uniquement.
"""

// type = CENTRE-RESP
* type 1..* MS
* type ^slicing.discriminator.type = #value
* type ^slicing.discriminator.path = "coding.code"
* type ^slicing.rules = #open
* type contains crType 1..1 MS
* type[crType].coding.system = "https://hl7.fr/ig/fhir/core/CodeSystem/fr-core-cs-v2-3307" (exactly)
* type[crType].coding.code = #CENTRE-RESP (exactly)
* type[crType] ^short = "Type : Centre de responsabilité (CENTRE-RESP)"

// Rattachement : pôle ou entité géographique
* partOf only Reference(PoleProfile or EntiteGeographiqueProfile)
* partOf ^short = "Pôle ou entité géographique parente"
