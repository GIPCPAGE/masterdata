// =============================================
// Profil Tiers Organization (basé sur FR Core)
// =============================================


Profile: TiersProfile
Parent: FRCoreOrganizationProfile
Id: tiers-profile
Title: "Tiers"
Description: "Profil générique pour la notion de Tiers (commun débiteur/fournisseur), basé sur FR Core Organization. Conforme aux spécifications. Ce profil hérite des slices identifier déjà définis par FR Core (SIREN, SIRET, FINESS) et ajoute les identifiants (NIR, hors UE, Tahiti, RIDET) ainsi qu'un identifiant de TVA intracommunautaire."

// FR Core 2.2.0 ne définit plus le slicing sur Organization.identifier
// On le redéfinit ici avec un discriminateur standard (system)

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

// Complément de nom
* alias 0..* MS
* alias ^short = "Nom complémentaire"
* alias ^definition = "Nom complémentaire ou alternatif du tiers."

// Adresse du siège
* address 0..* MS
* address ^short = "Adresse du siège"

// Télécom
* telecom 0..* MS
* telecom ^short = "Contacts téléphoniques et emails"

// Actif / validité
* active 0..1 MS
* active ^short = "Tiers actif"
* active ^definition = "Indique si le tiers est actif."

// Rôles du tiers
* extension contains TiersRoleExtension named tiersRole 0..* MS
* extension[tiersRole] ^short = "Rôle(s) du tiers"
* extension[tiersRole] ^definition = "Rôle(s) du tiers : fournisseur (supplier), débiteur (debtor) ou payeur (payer)."

// Catégorie TG (codes 00-74)
* extension contains TiersCategory named tgCategory 0..1 MS
* extension[tgCategory] ^short = "Catégorie TG"
* extension[tgCategory] ^definition = "Catégorie du tiers selon nomenclature: État, collectivités, établissements publics, organismes sociaux, personne physique, etc. Codes 00-74."

// Nature juridique (codes 00-11)
* extension contains TiersLegalNature named legalNature 0..1 MS
* extension[legalNature] ^short = "Nature juridique"
* extension[legalNature] ^definition = "Nature juridique du tiers selon nomenclature: particulier, société, association, établissement public, collectivité territoriale, etc. Codes 00-11."

// Domiciliation bancaire (RIB/IBAN)
* extension contains TiersBankAccount named bankAccount 0..* MS
* extension[bankAccount] ^short = "Coordonnées bancaires RIB/IBAN"
* extension[bankAccount] ^definition = "Domiciliation bancaire du tiers (RIB français ou IBAN/BIC international)."

// Usage de la succursale (pour organisations rattachées via partOf)
* extension contains SuccursaleUsageExtension named succursaleUsage 0..* MS
* extension[succursaleUsage] ^short = "Usage de la succursale"
* extension[succursaleUsage] ^definition = "Qualifie l'usage d'une succursale rattachée au siège: point de livraison, facturation, ou siège social secondaire."

// Code interne (facultatif, pour fournisseur ou débiteur)
* extension contains TiersInternalCodeExtension named codeInterne 0..1 MS

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
