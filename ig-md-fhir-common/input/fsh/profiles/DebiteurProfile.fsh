// =============================================
// Profil Débiteur
// =============================================

Profile: DebiteurProfile
Parent: TiersProfile
Id: debiteur-profile
Title: "Débiteur"
Description: "Profil pour les organisations de type débiteur. Hérite du profil TiersProfile et ajoute les contraintes et extensions spécifiques aux débiteurs (organismes, établissements, personnes physiques)."

// Extension pour qualifier le type d'identifiant
* identifier.extension contains TiersIdentifierType named gefType 0..1 MS
* identifier.extension[gefType] ^short = "Type d'identifiant (codes 01-09)"
* identifier.extension[gefType] ^definition = "Qualifie le type d'identifiant du débiteur (SIRET, SIREN, FINESS, NIR, TVA, hors UE, Tahiti, RIDET, en cours d'immatriculation)."

// Raison sociale
* name ^short = "Raison sociale débiteur"
* name ^definition = "Nom du débiteur (38 caractères)."

// Type débiteur (Occasionnel/Normal)
// Note: porté par l'extension TiersDebtorAttributs (champ debtorType)

// Identifiants spécifiques débiteurs
* identifier[siret] ^short = "SIRET débiteur"
* identifier[siren] ^short = "SIREN débiteur"
* identifier[finess] ^short = "FINESS débiteur"
* identifier[nir] ^short = "NIR débiteur"
* identifier[tva] ^short = "TVA intracommunautaire"
* identifier[horsUE] ^short = "Identifiant hors UE"
* identifier[ridet] ^short = "RIDET Nouméa"

// Adresse
* address ^short = "Adresse débiteur"
* address ^definition = "Adresse complète avec service, rue, code postal, bureau distributeur, localisation géographique (France/Europe/Autre), code pays."

// Télécom
* telecom ^short = "Contacts débiteur"
* telecom ^definition = "Site internet, téléphone, télex (legacy), fax, email."

// Rôle tiers doit contenir au moins 'debtor'
* extension[tiersRole] ^comment = "Pour un débiteur, l'extension tiersRole doit contenir au moins le code 'debtor'."

// Domiciliation bancaire (RIB/IBAN)
* extension[bankAccount] 1..* MS
* extension[bankAccount] ^short = "RIB/IBAN débiteur (obligatoire)"
* extension[bankAccount] ^definition = "Coordonnées bancaires pour recettes. Code banque, code guichet, numéro compte, clé RIB, IBAN, BIC. Au moins un RIB ou IBAN requis."

// ========== Extensions métier spécifiques ==========

// Paramètres de gestion débiteur
* extension contains DebiteurParametresExtension named parametres 0..1 MS

// Attributs débiteur (type + indicateurs catégorie)
* extension contains TiersDebtorAttributsExtension named debtorAttributs 1..1 MS
* extension[debtorAttributs] ^short = "Attributs débiteur : type (occasionnel/normal) et indicateurs catégorie"
* extension[debtorAttributs] ^definition = "Indique le type du débiteur (occasionnel ou normal) et qualifie les catégories particulières (laboratoire, locataire, agent)."

// Attributs secteur public (compte contrepartie + code régie)
* extension contains TiersPublicSectorExtension named secteurPublic 0..1 MS
* extension[secteurPublic] ^short = "Attributs secteur public"
* extension[secteurPublic] ^definition = "Compte de contrepartie en comptabilité publique (code lettre + numéro de compte) et code régie. Spécifique aux débiteurs du secteur public."

// Type identifiant CHORUS
* identifier.extension contains ChorusIdentifierType named chorusType 0..1 MS
* identifier.extension[chorusType] ^short = "Type identifiant CHORUS (01-08, sans 09)"
* identifier.extension[chorusType] ^definition = "Type d'identifiant reconnu par CHORUS (système d'information financière de l'État). Identique au type d'identifiant tiers mais n'accepte pas le code 09 (En cours d'immatriculation)."

// Détails personne physique (civilité + prénom)
* extension contains TiersPersonDetails named personDetails 0..1 MS
* extension[personDetails] ^short = "Civilité et prénom - Obligatoire si catégorie personne physique"
* extension[personDetails] ^definition = "Informations sur la personne physique : civilité (M, MME, MLLE, METMME, MOUMME) et prénom (38 car max). Obligatoire si le débiteur est une personne physique."

// Localisation adresse (France/Europe/Autre)
* address.extension contains TiersAddressLocalization named localization 0..1 MS
* address.extension[localization] ^short = "Zone géographique : FRANCE, EUROPE, AUTRE"
* address.extension[localization] ^definition = "Zone géographique de l'adresse : France (métropole + DOM-TOM), Europe (UE + pays européens hors UE), ou Autre (reste du monde)."
