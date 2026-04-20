// =============================================
// Profil Tiers Organization (basé sur FR Core)
// Profil de base pour interopérabilité
// =============================================

Profile: TiersProfile
Parent: FRCoreOrganizationProfile
Id: tiers-profile
Title: "Tiers"
Description: "Profil générique pour la notion de Tiers (commun débiteur/fournisseur), basé sur FR Core Organization. Conforme aux spécifications. Ce profil hérite des slices identifier déjà définis par FR Core (SIREN, SIRET, FINESS) et ajoute les identifiants (NIR, hors UE, Tahiti, RIDET) ainsi qu'un identifiant de TVA intracommunautaire."

// FR Core définit déjà le slicing sur Organization.identifier + slices SIREN/SIRET/FINESS
// On ajoute uniquement nos slices supplémentaires

* identifier 1..* MS
  * system 1..1 MS
  * value 1..1 MS

* identifier contains
    etierId 0..* MS and
    tva 0..1 MS and
    nir 0..1 MS and
    horsUE 0..1 MS and
    tahiti 0..1 MS and
    ridet 0..1 MS

// Identifiant interne ETIER (identifiant interne)
* identifier[etierId].type = $v2-0203#RI "Resource identifier"
* identifier[etierId].system = $id-etier (exactly)
* identifier[etierId].value 1..1
* identifier[etierId] ^short = "Identifiant interne du tiers (IDTITI)"
* identifier[etierId] ^definition = "Identifiant unique interne du tiers issu de la table ETIER (champ IDTITI)."

// TVA intracommunautaire (TVA intracommunautaire)
* identifier[tva].type = $v2-0203#TAX "Tax ID number"
* identifier[tva].system = $id-tva (exactly)
* identifier[tva].value 1..1
* identifier[tva] ^short = "Numéro de TVA intracommunautaire"
* identifier[tva] ^definition = "Numéro de TVA intracommunautaire du tiers (champ TVAITI)."

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

// Nom / raison sociale (NORSTI)
* name 1..1 MS
* name ^short = "Raison sociale / nom du tiers"
* name ^definition = "Nom officiel du tiers (nom du tiers)."

// Complément de nom (COMPTI)
* alias 0..* MS
* alias ^short = "Nom complémentaire"
* alias ^definition = "Nom complémentaire ou alternatif du tiers (nom complementaire)."

// Adresse siège (AL1STI, AL2STI, AL3STI, CPOSTI, BDISTI, PAYSTI)
* address 0..* MS
* address ^short = "Adresse du siège"

// Télécom (TELETI, MAILTI, SITETI)
* telecom 0..* MS
* telecom ^short = "Contacts téléphoniques et emails"

// Actif / validité (VALITI)
* active 0..1 MS
* active ^short = "Tiers actif"
* active ^definition = "Indique si le tiers est actif. Peut être mappé depuis indicateur actif (V=true, I=false)."

// Rôles génériques du tiers (debtor/supplier)
* extension contains TiersRoleExtension named tiersRole 0..* MS
* extension[tiersRole] ^short = "Rôle(s) du tiers"
* extension[tiersRole] ^definition = "Rôle(s) générique(s) du tiers : fournisseur (supplier) si présent dans table fournisseurs, débiteur (debtor) si présent dans table debiteurs."

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
* extension[bankAccount] ^definition = "Domiciliation bancaire du tiers (RIB français ou IBAN/BIC international). Conforme aux formats."

// Usage de la succursale (pour organisations rattachées via partOf)
* extension contains SuccursaleUsageExtension named succursaleUsage 0..* MS
* extension[succursaleUsage] ^short = "Usage de la succursale"
* extension[succursaleUsage] ^definition = "Qualifie l'usage d'une succursale rattachée au siège: point de livraison, facturation, ou siège social secondaire."

// Extensions spécifiques Fournisseur (optionnelles, utilisées si le tiers a le rôle supplier)
* extension contains FournisseurCodeExtension named codeFournisseur 0..1 MS
* extension contains FournisseurComptabiliteExtension named comptabilite 0..1 MS
* extension contains FournisseurPaiementExtension named paiement 0..1 MS

// Extensions spécifiques Débiteur (optionnelles, utilisées si le tiers a le rôle debtor)
* extension contains DebiteurCodeExtension named codeDebiteur 0..1 MS
* extension contains DebiteurParametresExtension named parametres 0..1 MS
* extension contains TiersDebtorType named debtorType 0..1 MS

// Extensions spécifiques Payeur Santé (optionnelles, utilisées si le tiers a le rôle payer)
* extension contains PayeurSanteExtension named payeurSante 0..1 MS

// Note: FR Core Organization hérite déjà des contraintes suivantes :
// - identifier[siren] : SIREN (9 chiffres) - system = https://sirene.fr
// - identifier[siret] : SIRET (14 chiffres) - system = https://sirene.fr
// - identifier[finess] : FINESS - system = http://finess.sante.gouv.fr
// Ces slices sont automatiquement disponibles et ne doivent pas être redéfinis ici.

// On retire les slices hérités non souhaités
* identifier[adeliRang] 0..0
* identifier[rppsRang] 0..0
