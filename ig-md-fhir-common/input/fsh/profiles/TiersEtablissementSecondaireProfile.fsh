// =============================================
// Profil Établissement secondaire d'un tiers
// =============================================

Profile: TiersEtablissementSecondaireProfile
Parent: FRCoreOrganizationProfile
Id: tiers-etablissement-secondaire-profile
Title: "Établissement secondaire d'un tiers"
Description: """Établissement secondaire d'un tiers du Master Data : un site distinct de l'établissement principal, avec son propre SIRET (facultatif), son adresse, ses contacts et ses comptes bancaires.

Il est rattaché à l'établissement principal (`TiersProfile`) par `partOf`. Il n'a pas de rôle propre : le rôle est porté par le tiers, c'est-à-dire par l'établissement principal. Un site utilise ses propres comptes bancaires et les comptes communs à la société portés par l'établissement principal.

Règle de contrôle : quand il est renseigné, les 9 premiers chiffres du SIRET de l'établissement correspondent au SIREN du tiers."""

* identifier ^slicing.discriminator.type = #value
* identifier ^slicing.discriminator.path = "system"
* identifier ^slicing.rules = #open
* identifier ^slicing.description = "Identifiants de l'établissement : identifiant Master Data, SIRET"

// Toujours au moins un identifiant : l'identifiant Master Data en publication, le SIRET ou l'identifiant de
// l'émetteur (slicing ouvert) en réception.
* identifier 1..* MS
  * system 1..1 MS
  * value 1..1 MS

* identifier contains etablissementId 0..1 MS and siret 0..1 MS

// Identifiant attribué par le Master Data, toujours publié
* identifier[etablissementId].type = $v2-0203#RI "Resource identifier"
* identifier[etablissementId].system = $id-etablissement (exactly)
* identifier[etablissementId].value 1..1
* identifier[etablissementId] ^short = "Identifiant de l'établissement dans le Master Data"
* identifier[etablissementId] ^definition = "Identifiant attribué par le Master Data à l'établissement. Toujours présent dans une publication du Master Data ; non attendu d'une application qui pousse un tiers, qui porte alors le SIRET ou son propre identifiant."

// SIRET facultatif : un établissement secondaire du modèle peut ne pas en avoir
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
* telecom ^definition = "Contacts de l'adresse d'ordre 1 de l'établissement : téléphone (phone), email (email), télécopie (fax), télex (other, faute de système FHIR propre), site internet (url)."

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
