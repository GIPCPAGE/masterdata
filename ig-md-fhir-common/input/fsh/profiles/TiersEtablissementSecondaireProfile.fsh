// =============================================
// Profil Établissement secondaire d'un tiers
// =============================================

Profile: TiersEtablissementSecondaireProfile
Parent: FRCoreOrganizationProfile
Id: tiers-etablissement-secondaire-profile
Title: "Établissement secondaire d'un tiers"
Description: """Établissement secondaire d'un tiers du Master Data : un site distinct de l'établissement principal, avec son propre SIRET, son adresse, ses contacts et ses comptes bancaires.

Il est rattaché à l'établissement principal (`TiersProfile`) par `partOf`. Il n'a pas de rôle propre : le rôle est porté par le tiers, c'est-à-dire par l'établissement principal. Un site utilise ses propres comptes bancaires et les comptes communs à la société portés par l'établissement principal.

Règle de contrôle : les 9 premiers chiffres du SIRET de l'établissement correspondent au SIREN du tiers."""

* identifier ^slicing.discriminator.type = #value
* identifier ^slicing.discriminator.path = "system"
* identifier ^slicing.rules = #open
* identifier ^slicing.description = "Identifiants de l'établissement : SIRET"

* identifier 1..* MS
  * system 1..1 MS
  * value 1..1 MS

* identifier contains siret 1..1 MS
* identifier[siret].system = "https://sirene.fr" (exactly)
* identifier[siret].value 1..1
* identifier[siret] ^short = "SIRET de l'établissement (14 chiffres)"
* identifier[siret] ^definition = "Numéro SIRET de l'établissement secondaire. Les 9 premiers chiffres sont le SIREN du tiers."

* name 1..1 MS
* name ^short = "Nom de l'établissement"

* active 0..1 MS
* active ^short = "Établissement actif"

* partOf 1..1 MS
* partOf only Reference(TiersProfile)
* partOf ^short = "Établissement principal du tiers"
* partOf ^definition = "Établissement principal du tiers auquel ce site est rattaché."

* address 1..1 MS
* address ^short = "Adresse d'ordre 1 de l'établissement"
* insert TiersAdresse(address)

* telecom 0..* MS
* telecom ^short = "Contacts de l'adresse d'ordre 1"
* telecom ^definition = "Contacts de l'adresse d'ordre 1 de l'établissement : téléphone, email, télécopie, télex, site internet."

* contact 0..* MS
* contact ^short = "Autres adresses de l'établissement"
* contact ^definition = "Une entrée par adresse d'ordre supérieur à 1 : contact.name porte le destinataire de l'adresse (si différent de la raison sociale), contact.address l'adresse, contact.telecom ses contacts."
* contact.address 1..1 MS
* insert TiersAdresse(contact.address)

// Comptes bancaires propres au site. Le drapeau « commun à la société » est réservé à l'établissement principal.
* extension contains TiersBankAccount named bankAccount 0..* MS
* extension[bankAccount] ^short = "Comptes bancaires propres au site"
* extension[bankAccount] ^definition = "Comptes bancaires de ce site. communSociete est interdit sur un établissement secondaire."
* extension[bankAccount].extension[communSociete] 0..0
