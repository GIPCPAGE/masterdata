// =============================================
// Profil Fournisseur
// =============================================

Profile: FournisseurProfile
Parent: TiersProfile
Id: fournisseur-profile
Title: "Fournisseur"
Description: "Profil pour les organisations de type fournisseur. Hérite du profil TiersProfile et ajoute les contraintes spécifiques aux fournisseurs."

// Extension pour qualifier le type d'identifiant
* identifier.extension contains TiersIdentifierType named gefType 0..1 MS
* identifier.extension[gefType] ^short = "Type d'identifiant (codes 01-09)"
* identifier.extension[gefType] ^definition = "Qualifie le type d'identifiant du fournisseur (SIRET, SIREN, FINESS, NIR, TVA, hors UE, Tahiti, RIDET, en cours d'immatriculation)."

// Identifiant interne du fournisseur
* identifier[etierId] ^short = "Identifiant interne fournisseur"
* identifier[etierId] ^definition = "Identifiant interne unique du fournisseur (14 caractères)."

// Nom du fournisseur
* name ^short = "Nom du fournisseur"
* name ^definition = "Nom du fournisseur (32 caractères)."

// Raison sociale
* alias ^short = "Raison sociale"
* alias ^definition = "Raison sociale légale du fournisseur (32 caractères)."

// Adresse
* address ^short = "Adresse fournisseur"
* address ^definition = "Adresse complète : rue (38 car), complément (38 car), code postal (5 car), bureau distributeur/ville (32 car)."

// Télécom
* telecom ^short = "Contacts fournisseur"
* telecom ^definition = "Téléphone et télécopie/fax du fournisseur."

// Identifiant SIRET
* identifier[siret] ^short = "Numéro SIRET fournisseur"

// Rôle tiers doit contenir au moins 'supplier'
* extension[tiersRole] ^comment = "Pour un fournisseur, l'extension tiersRole doit contenir au moins le code 'supplier'."

// Domiciliation bancaire (RIB)
* extension[bankAccount] ^short = "RIB fournisseur"
* extension[bankAccount] ^definition = "Coordonnées bancaires pour les paiements au fournisseur."

// Paramètres comptables fournisseur (lettres + numéros classe 2 et 6)
* extension contains FournisseurComptabiliteExtension named comptabilite 0..1 MS
* extension[comptabilite] ^short = "Comptes comptables (lettre + numéro, classe 2 et 6)"
* extension[comptabilite] ^definition = "Paramètres de comptabilisation : lettre budgétaire et numéro de compte pour la classe 2 (immobilisations) et la classe 6 (charges). Colonnes LBU2FO/CPT2FO et LBU6FO/CPT6FO."

// Conditions de paiement fournisseur
* extension contains FournisseurPaiementExtension named paiement 0..1 MS
* extension[paiement] ^short = "Conditions de paiement (délai, jour, montant minimum, taux transitaire, escompte)"

// Attributs métier fournisseur (type, priorité, catégorie, Chorus, RAFP, indicateurs)
* extension contains FournisseurAttributsExtension named attributs 0..1 MS
* extension[attributs] ^short = "Attributs fournisseur : type, priorité, Chorus, RAFP, indicateurs techniques"
* extension[attributs] ^definition = "Attributs métier et techniques du fournisseur : type (F/T/R/P), priorité, catégorie interne ECFO, références croisées (débiteur associé, numéro client), indicateurs réglementaires (marchés publics, Chorus, honoraires, UGAP, RAFP) et indicateurs de synchronisation (extraction, MAJ)."

// Commentaires libres fournisseur
* extension contains FournisseurCommentairesExtension named commentaires 0..1 MS
* extension[commentaires] ^short = "Commentaires libres (1 à 3) et option d'édition"

// Identifiant Chorus (type via extension, valeur portée par attributs.identifiantChorus)
* identifier.extension contains ChorusIdentifierType named chorusType 0..1 MS
* identifier.extension[chorusType] ^short = "Type identifiant Chorus (01-08)"
* identifier.extension[chorusType] ^definition = "Type d'identifiant reconnu par Chorus Pro. Correspond à TIDCFO (colonne FOU) quand l'identifiant est porté par un slice identifier."

// Attributs secteur public (régie, TG)
* extension contains TiersPublicSectorExtension named secteurPublic 0..1 MS
* extension[secteurPublic] ^short = "Attributs secteur public (code régie, identifiant TG)"
* extension[secteurPublic] ^definition = "Code régie (CREGFO) et identifiant Trésorerie Générale (IDTGFO)."

// Détails personne physique (civilité + prénom)
* extension contains TiersPersonDetails named personDetails 0..1 MS
* extension[personDetails] ^short = "Civilité et prénom - Obligatoire si catégorie personne physique"
* extension[personDetails] ^definition = "Informations personne physique : civilité (CIVIFO) et prénom (PRENFO)."
