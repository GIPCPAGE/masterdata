// =============================================
// Profil Tiers Organization (basé sur FR Core)
// =============================================


Profile: TiersProfile
Parent: FRCoreOrganizationProfile
Id: tiers-profile
Title: "Tiers"
Description: """Profil du Tiers du Master Data (modèle de concept model_tiers), basé sur FR Core Organization.

Une Organization représente l'**établissement principal** du tiers : son SIRET, son adresse d'ordre 1 (`address`) et les contacts de cette adresse (`telecom`). Les adresses suivantes de l'établissement principal, avec leurs contacts, sont portées par `contact`. Les comptes bancaires sont portés par l'extension `bankAccount`. Les établissements secondaires sont des Organization de profil `TiersEtablissementSecondaireProfile`, rattachées à l'établissement principal par `partOf`. Le rôle du tiers (fournisseur, débiteur ou mixte) est obligatoire et unique. Les données de gouvernance (cycle de vie, statut d'harmonisation, liens source) ne sont pas exposées par ce profil."""

// FR Core 2.2.0 ne définit plus le slicing sur Organization.identifier
// On le redéfinit ici avec un discriminateur standard (system)

* obeys tiers-siret-siren and tiers-restriction-role

* identifier ^slicing.discriminator.type = #value
* identifier ^slicing.discriminator.path = "system"
* identifier ^slicing.rules = #open
* identifier ^slicing.description = "Identifiants du tiers : SIRET, SIREN, FINESS, TVA, NIR, hors UE, Tahiti, RIDET, identifiant interne"

* identifier 1..* MS
  * system 1..1 MS
  * value 1..1 MS

* identifier contains
    etierId 0..* MS and
    siret 0..1 MS and
    siren 0..1 MS and
    finess 0..1 MS and
    tva 0..1 MS and
    nir 0..1 MS and
    horsUE 0..1 MS and
    tahiti 0..1 MS and
    ridet 0..1 MS and
    frwf 0..1 MS and
    irep 0..1 MS and
    nfp 0..1 MS

// Identifiant interne
* identifier[etierId].type = $v2-0203#RI "Resource identifier"
* identifier[etierId].system = $id-etier (exactly)
* identifier[etierId].value 1..1
* identifier[etierId] ^short = "Identifiant interne du tiers"
* identifier[etierId] ^definition = "Identifiant interne unique du tiers."

// TVA intracommunautaire
* identifier[tva].type = $v2-0203#TAX "Tax ID number"
* identifier[tva].system = $id-tva (exactly)
* identifier[tva].value 1..1
* identifier[tva] ^short = "Numéro de TVA intracommunautaire"
* identifier[tva] ^definition = "Numéro de TVA intracommunautaire du tiers."

// NIR - Numéro Inscription Répertoire (Sécurité Sociale) - type 04
* identifier[nir] ^short = "NIR - Numéro Sécurité Sociale"
* identifier[nir] ^definition = "Numéro d'Inscription au Répertoire de la Sécurité Sociale (15 caractères). Type identifiant: 04"
* identifier[nir].type = TiersIdentifierTypeCS#04
* identifier[nir].system = "urn:oid:1.2.250.1.213.1.4.8" // OID officiel INS
* identifier[nir].value 1..1
* identifier[nir].extension contains TiersIdentifierType named gefType 0..1
* identifier[nir].extension[gefType].valueCodeableConcept = TiersIdentifierTypeCS#04

// Identifiant hors Union Européenne - type 06
* identifier[horsUE] ^short = "Identifiant hors UE"
* identifier[horsUE] ^definition = "Identifiant pour tiers hors Union Européenne. Type identifiant: 06"
* identifier[horsUE].type = TiersIdentifierTypeCS#06
* identifier[horsUE].system = "https://www.cpage.fr/ig/masterdata/common/NamingSystem/non-eu-identifier"
* identifier[horsUE].value 1..1
* identifier[horsUE].extension contains TiersIdentifierType named gefType 0..1
* identifier[horsUE].extension[gefType].valueCodeableConcept = TiersIdentifierTypeCS#06

// Numéro Tahiti (Polynésie française) - type 07
* identifier[tahiti] ^short = "Numéro Tahiti"
* identifier[tahiti] ^definition = "Numéro d'identification Tahiti - Polynésie française. Type identifiant: 07"
* identifier[tahiti].type = TiersIdentifierTypeCS#07
* identifier[tahiti].system = "https://www.cpage.fr/ig/masterdata/common/NamingSystem/tahiti-identifier" // À remplacer par OID officiel si disponible
* identifier[tahiti].value 1..1
* identifier[tahiti].extension contains TiersIdentifierType named gefType 0..1
* identifier[tahiti].extension[gefType].valueCodeableConcept = TiersIdentifierTypeCS#07

// RIDET (Nouvelle-Calédonie) - type 08
* identifier[ridet] ^short = "RIDET Nouméa"
* identifier[ridet] ^definition = "RIDET - Répertoire d'Identification des Entreprises et des Établissements de Nouvelle-Calédonie. Type identifiant: 08"
* identifier[ridet].type = TiersIdentifierTypeCS#08
* identifier[ridet].system = "https://www.cpage.fr/ig/masterdata/common/NamingSystem/ridet-identifier" // À remplacer par OID officiel si disponible
* identifier[ridet].value 1..1
* identifier[ridet].extension contains TiersIdentifierType named gefType 0..1
* identifier[ridet].extension[gefType].valueCodeableConcept = TiersIdentifierTypeCS#08

// FRWF - Wallis-et-Futuna - type 10
* identifier[frwf] ^short = "Identifiant FRWF (Wallis-et-Futuna)"
* identifier[frwf] ^definition = "Identifiant spécifique aux entités de Wallis-et-Futuna. Type identifiant PESv2 : 10"
* identifier[frwf].type = TiersIdentifierTypeCS#10
* identifier[frwf].system = "https://www.cpage.fr/ig/masterdata/common/NamingSystem/frwf-identifier"
* identifier[frwf].value 1..1
* identifier[frwf].extension contains TiersIdentifierType named gefType 0..1
* identifier[frwf].extension[gefType].valueCodeableConcept = TiersIdentifierTypeCS#10

// IREP - Répertoire des Établissements Publics (Polynésie française) - type 11
* identifier[irep] ^short = "IREP (Polynésie française)"
* identifier[irep] ^definition = "Identifiant du Répertoire des Établissements Publics de Polynésie française. Type identifiant PESv2 : 11"
* identifier[irep].type = TiersIdentifierTypeCS#11
* identifier[irep].system = "https://www.cpage.fr/ig/masterdata/common/NamingSystem/irep-identifier"
* identifier[irep].value 1..1
* identifier[irep].extension contains TiersIdentifierType named gefType 0..1
* identifier[irep].extension[gefType].valueCodeableConcept = TiersIdentifierTypeCS#11

// NFP - Numéro de Fichier de Paie - type 12
* identifier[nfp] ^short = "NFP — Numéro de Fichier de Paie"
* identifier[nfp] ^definition = "Identifiant employéur utilisé dans les échanges de paie (PESv2 flux paye). Type identifiant PESv2 : 12"
* identifier[nfp].type = TiersIdentifierTypeCS#12
* identifier[nfp].system = "https://www.cpage.fr/ig/masterdata/common/NamingSystem/nfp-identifier"
* identifier[nfp].value 1..1
* identifier[nfp].extension contains TiersIdentifierType named gefType 0..1
* identifier[nfp].extension[gefType].valueCodeableConcept = TiersIdentifierTypeCS#12

// Nom / raison sociale
* name 1..1 MS
* name ^short = "Raison sociale / nom du tiers"
* name ^definition = "Nom officiel du tiers."

// Complément de nom : extension shortName de FR Core (libellé court de l'organisation)
* extension[shortName] MS
* extension[shortName] ^short = "Complément de nom"
* extension[shortName] ^definition = "Complément de la raison sociale du tiers, porté par l'extension FR Core shortName."

// Alias / noms commerciaux
* alias 0..* MS
* alias ^short = "Alias / nom commercial"
* alias ^definition = "Noms alternatifs ou commerciaux du tiers."

// Adresse d'ordre 1 de l'établissement principal (obligatoire dans le modèle)
* address 1..1 MS
* address ^short = "Adresse principale (ordre 1) de l'établissement principal"
* address ^definition = "Adresse d'ordre 1 de l'établissement principal. Les autres adresses de l'établissement principal sont portées par contact.address."
* insert TiersAdresse(address)

// Contacts de l'adresse d'ordre 1 (téléphone, email, télécopie, télex, site internet)
* telecom 0..* MS
* telecom ^short = "Contacts de l'adresse principale"
* telecom ^definition = "Contacts de l'adresse d'ordre 1 de l'établissement principal : téléphone (phone), email (email), télécopie (fax), télex (other, faute de système FHIR propre), site internet (url)."

// Adresses suivantes de l'établissement principal, avec leurs contacts (contacts sans purpose)
* contact 0..* MS
* contact obeys tiers-contact-adresse
* contact ^short = "Autres adresses de l'établissement principal, destinataire de l'adresse principale, et personne physique"
* contact ^definition = "Une entrée sans purpose par adresse d'ordre supérieur à 1 de l'établissement principal : contact.name porte le destinataire de l'adresse, contact.address l'adresse, contact.telecom ses contacts. Une entrée de purpose destinataire-adresse-principale porte le destinataire de l'adresse d'ordre 1 (address). Une entrée de purpose personne-physique porte l'identité du tiers personne physique."
* contact.address 0..1 MS
* insert TiersAdresse(contact.address)

* contact ^slicing.discriminator.type = #value
* contact ^slicing.discriminator.path = "purpose"
* contact ^slicing.rules = #open
* contact ^slicing.description = "Slices personnePhysique et destinataire identifiées par leur purpose ; les autres contacts sont des adresses."

// Destinataire de l'adresse d'ordre 1 : name porte la raison sociale, et Address n'a pas d'élément nom
* contact contains destinataire 0..1 MS
* contact[destinataire] ^short = "Destinataire de l'adresse principale"
* contact[destinataire] ^definition = "Destinataire de l'adresse d'ordre 1 (address) de l'établissement principal, lorsqu'il diffère de la raison sociale (name), porté par name.text. L'adresse reste dans address et ses contacts dans telecom."
* contact[destinataire].purpose = TiersContactPurposeCS#destinataire-adresse-principale
* contact[destinataire].name 1..1 MS
* contact[destinataire].name.text 1..1 MS
* contact[destinataire].name.text ^short = "Destinataire"
* contact[destinataire].address 0..0
* contact[destinataire].telecom 0..0

// Personne physique : civilité, prénom et nom dans contact.name, date de naissance en extension
* contact contains personnePhysique 0..1 MS
* contact[personnePhysique] ^short = "Personne physique"
* contact[personnePhysique] ^definition = "Identité du tiers personne physique (catégorie TG = 01) : civilité (name.prefix), prénom (name.given), nom (name.family) et date de naissance (extension birthDate)."
* contact[personnePhysique].purpose = TiersContactPurposeCS#personne-physique
* contact[personnePhysique].name 1..1 MS
* contact[personnePhysique].name.family 1..1 MS
* contact[personnePhysique].name.family ^short = "Nom"
* contact[personnePhysique].name.given 0..1 MS
* contact[personnePhysique].name.given ^short = "Prénom (38 caractères max)"
* contact[personnePhysique].name.given ^maxLength = 38
* contact[personnePhysique].name.prefix 0..1 MS
* contact[personnePhysique].name.prefix from TiersCivilityVS (required)
* contact[personnePhysique].name.prefix ^short = "Civilité (M, MME, MLLE, METMME, MOUMME)"
* contact[personnePhysique].address 0..0
* contact[personnePhysique].extension contains TiersBirthDate named birthDate 0..1 MS

// Actif (désactivation logique, sans suppression physique)
* active 0..1 MS
* active ^short = "Tiers actif"
* active ^definition = "Statut actif ou inactif du tiers. Désactivation logique sans suppression physique."

// Rôle du tiers : un seul, obligatoire (supplier = F, debtor = D, mixed = M)
* extension contains TiersRoleExtension named tiersRole 1..1 MS
* extension[tiersRole] ^short = "Rôle du tiers"
* extension[tiersRole] ^definition = "Rôle unique du tiers : fournisseur (supplier, circuit dépense), débiteur (debtor, circuit recette) ou mixte (mixed, les deux). Correspond aux valeurs F, D et M du modèle."

// Spécificités (laboratoire, locataire, agent, débiteur mortuaire, hospitalier)
* extension contains TiersSpecificityExtension named specificite 0..* MS
* extension[specificite] ^short = "Spécificités du tiers"
* extension[specificite] ^definition = "Particularités du tiers cochées sur la fiche : laboratoire, locataire, agent, débiteur mortuaire, hospitalier."

// Catégorie TG (codes 00-74)
* extension contains TiersCategory named tgCategory 0..1 MS
* extension[tgCategory] ^short = "Catégorie TG"
* extension[tgCategory] ^definition = "Catégorie du tiers selon nomenclature: État, collectivités, établissements publics, organismes sociaux, personne physique, etc. Codes 00-74."

// Nature juridique (codes 00-11)
* extension contains TiersLegalNature named legalNature 0..1 MS
* extension[legalNature] ^short = "Nature juridique"
* extension[legalNature] ^definition = "Nature juridique du tiers selon nomenclature: particulier, société, association, établissement public, collectivité territoriale, etc. Codes 00-11."

// Comptes bancaires de l'établissement principal (IBAN maître ; compte commun à la société autorisé ici)
* extension contains TiersBankAccount named bankAccount 0..* MS
* extension[bankAccount] ^short = "Comptes bancaires"
* extension[bankAccount] ^definition = "Comptes bancaires de l'établissement principal. Un compte avec communSociete = true est utilisable par tous les établissements du tiers."

// Slices SIREN / SIRET / FINESS (redéfinis ici car FR Core 2.2.0 ne les expose plus)
* identifier[siret].system = "https://sirene.fr" (exactly)
* identifier[siret].value 1..1
* identifier[siret] ^short = "Numéro SIRET (14 chiffres)"

* identifier[siren].system = "https://sirene.fr/siren" (exactly)
* identifier[siren].value 1..1
* identifier[siren] ^short = "Numéro SIREN (9 chiffres)"

* identifier[finess].system = "http://finess.sante.gouv.fr" (exactly)
* identifier[finess].value 1..1
* identifier[finess] ^short = "Numéro FINESS"
