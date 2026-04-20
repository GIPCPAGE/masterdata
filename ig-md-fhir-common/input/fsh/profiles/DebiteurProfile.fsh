// =============================================
// Profil Débiteur
// Conforme au interface debiteurs des interfaces
// =============================================

Profile: DebiteurProfile
Parent: TiersProfile
Id: debiteur-profile
Title: "Débiteur"
Description: "Profil débiteur conforme au interface debiteurs (Intégration Débiteurs) des interfaces - format CSV. Hérite du profil TiersProfile et ajoute les contraintes et extensions spécifiques aux débiteurs (établissements acheteurs, débiteurs de recettes)."

// Extension pour qualifier le type d'identifiant selon
* identifier.extension contains TiersIdentifierType named gefType 0..1 MS
* identifier.extension[gefType] ^short = "Type d'identifiant selon (codes 01-09)"
* identifier.extension[gefType] ^definition = "Qualifie le type d'identifiant (SIRET, SIREN, FINESS, NIR, TVA, hors UE, Tahiti, RIDET). Correspond au champ 'Identifiant TG' du interface debiteurs."

// Raison sociale (KERD)
* name ^short = "Raison sociale débiteur (KERD)"
* name ^definition = "Nom du débiteur (38 caractères). Champ 'Raison sociale' du interface debiteurs."

// Type débiteur (KERD: O=Occasionnel, N=Normal) - nécessite extension
// Note: Sera ajouté en Phase 2 avec extension TiersDebtorType

// Identifiants spécifiques débiteurs
* identifier[siret] ^short = "SIRET débiteur (KERD)"
* identifier[siren] ^short = "SIREN débiteur (KERD)"
* identifier[finess] ^short = "FINESS débiteur (KERD)"
* identifier[nir] ^short = "NIR débiteur (KERD)"
* identifier[tva] ^short = "TVA intracommunautaire (KERD)"
* identifier[horsUE] ^short = "Identifiant hors UE (KERD)"
* identifier[ridet] ^short = "RIDET Nouméa (KERD)"

// Adresse enrichie (KERD: avec localisation France/Europe/Autre)
* address ^short = "Adresse débiteur (KERD)"
* address ^definition = "Adresse complète avec service, rue, code postal, bureau distributeur, localisation géographique (France/Europe/Autre), code pays."

// Télécom (KERD: site internet, téléphone, télex, fax, email)
* telecom ^short = "Contacts débiteur (KERD)"
* telecom ^definition = "Site internet, téléphone, télex (legacy), fax, email."

// Rôle tiers doit contenir au moins 'debtor'
* extension[tiersRole] ^comment = "Pour un débiteur, l'extension tiersRole doit contenir au moins le code 'debtor'."

// Domiciliation bancaire (RIB/IBAN) - obligatoire pour recettes
* extension[bankAccount] 1..* MS
* extension[bankAccount] ^short = "RIB/IBAN débiteur (KERD - obligatoire)"
* extension[bankAccount] ^definition = "Coordonnées bancaires pour recettes. Champs KERD: Code banque, Code guichet, Numéro compte, Clé RIB, IBAN, BIC. Au moins un RIB ou IBAN requis."

// ========== Extensions métier spécifiques KERD (Phase 2) ==========

// Extension 1: Type débiteur (O=Occasionnel, N=Normal) - Hérité de TiersProfile, rendu obligatoire
* extension[debtorType] 1..1 MS
* extension[debtorType] ^short = "Type débiteur : O (Occasionnel) ou N (Normal) - KERD position 2"
* extension[debtorType] ^definition = "Indique si le débiteur est occasionnel (enregistrement ponctuel) ou normal/régulier (enregistrement permanent). Champ obligatoire dans KERD."

// Extension 2: Compte contrepartie comptabilité publique
* extension contains TiersPublicAccountingCounterpart named counterpart 0..1 MS
* extension[counterpart] ^short = "Compte contrepartie comptabilité publique - KERD positions 3-4"
* extension[counterpart] ^definition = "Code lettre (1 car) et numéro de compte (10 car) de contrepartie en comptabilité publique. Obligatoire pour les débiteurs du secteur public."

// Extension 3: Code régie
* extension contains TiersRegieCode named regieCode 0..1 MS
* extension[regieCode] ^short = "Code régie - KERD position 7"
* extension[regieCode] ^definition = "Code identifiant une régie d'avance ou de recettes du secteur public (10 caractères max). Spécifique aux établissements publics ayant des régies."

// Extension 4: Type identifiant CHORUS (système comptabilité publique)
* identifier.extension contains ChorusIdentifierType named chorusType 0..1 MS
* identifier.extension[chorusType] ^short = "Type identifiant CHORUS (01-08, sans 09) - KERD"
* identifier.extension[chorusType] ^definition = "Type d'identifiant reconnu par CHORUS (système d'information financière de l'État). Identique à 'Identifiant TG' mais n'accepte pas le code 09 (En cours d'immatriculation)."

// Extension 5: Attributs spécifiques débiteur (laboratoire, locataire, agent)
* extension contains TiersDebtorFlags named debtorFlags 0..1 MS
* extension[debtorFlags] ^short = "Attributs spécifiques : laboratoire O/N, locataire O/N, agent O/N + matricule - KERD positions 21-23"
* extension[debtorFlags] ^definition = "Indicateurs booléens pour catégories spéciales de débiteurs nécessitant traitement particulier : laboratoire d'analyses, locataire (loyers), agent de l'établissement (salaires). Si agent=true, le matricule (20 car) est requis."

// Extension 6: Détails personne physique (civilité + prénom)
* extension contains TiersPersonDetails named personDetails 0..1 MS
* extension[personDetails] ^short = "Civilité + Prénom - KERD positions 10-11 - OBLIGATOIRE si Catégorie TG = 01"
* extension[personDetails] ^definition = "Informations sur la personne physique : civilité (M, MME, MLLE, METMME, MOUMME) et prénom (38 car max). Ces champs sont OBLIGATOIRES selon les règles métier si le débiteur est de Catégorie TG = 01 (Personne physique)."

// Extension 7: Localisation adresse (France/Europe/Autre)
* address.extension contains TiersAddressLocalization named localization 0..1 MS
* address.extension[localization] ^short = "Localisation géographique : FRANCE, EUROPE, AUTRE - KERD"
* address.extension[localization] ^definition = "Zone géographique de l'adresse selon : France (métropole + DOM-TOM), Europe (UE + pays européens hors UE), ou Autre (reste du monde). Utilisé pour qualifications réglementaires ou fiscales."
