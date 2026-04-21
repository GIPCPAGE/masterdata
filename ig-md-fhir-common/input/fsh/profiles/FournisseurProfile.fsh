// =============================================
// Profil Fournisseur
// Conforme au interface fournisseurs des interfaces
// =============================================

Profile: FournisseurProfile
Parent: TiersProfile
Id: fournisseur-profile
Title: "Fournisseur"
Description: "Profil fournisseur conforme au interface fournisseurs (Extraction Fournisseurs) des interfaces. Hérite du profil TiersProfile et ajoute les contraintes spécifiques aux fournisseurs."

// Extension pour qualifier le type d'identifiant selon
* identifier.extension contains TiersIdentifierType named gefType 0..1 MS
* identifier.extension[gefType] ^short = "Type d'identifiant selon (codes 01-09)"
* identifier.extension[gefType] ^definition = "Qualifie le type d'identifiant (SIRET, SIREN, FINESS, NIR, TVA, hors UE, Tahiti, RIDET, en cours). Correspond au champ 'Type identifiant fournisseur' position 239-5 du interface fournisseurs."

// Numéro fournisseur (position 4-14 EFOU) - mappé sur etierId du parent
* identifier[etierId] ^short = "Numéro fournisseur (EFOU position 4-14)"
* identifier[etierId] ^definition = "Numéro fournisseur interne (14 caractères, cadenassé à gauche, 6 utilisés). Correspond au champ EFOU position 4-14."

// Nom du fournisseur (position 18-32 EFOU)
* name ^short = "Nom du fournisseur (EFOU position 18-32)"
* name ^definition = "Nom du fournisseur (32 caractères). Correspond au champ EFOU position 18-32."

// Raison sociale (position 50-32 EFOU)
* alias ^short = "Raison sociale (EFOU position 50-32)"
* alias ^definition = "Raison sociale légale du fournisseur (32 caractères). Correspond au champ EFOU position 50-32."

// Adresse (positions 82-146 EFOU: rue, complément, code postal, ville)
* address ^short = "Adresse fournisseur (EFOU positions 82-146)"
* address ^definition = "Adresse complète: rue (38 car), complément (38 car), code postal (5 car), bureau distributeur/ville (32 car)."

// Télécom (positions 183-220 EFOU: téléphone, fax)
* telecom ^short = "Contacts (EFOU positions 183-220)"
* telecom ^definition = "Téléphone (20 car) et télécopie/fax (20 car). Positions 183-203 et 203-223."

// Code SIRET (position 223-14 EFOU) - mappé sur identifier[siret] hérité de FR Core
* identifier[siret] ^short = "Code SIRET (EFOU position 223-14)"

// Rôle tiers doit contenir au moins 'supplier'
* extension[tiersRole] ^comment = "Pour un fournisseur, l'extension tiersRole doit contenir au moins le code 'supplier'."

// Domiciliation bancaire (RIB) - via extension héritée, utilisée dans EMAF
* extension[bankAccount] ^short = "RIB fournisseur (EMAF)"
* extension[bankAccount] ^definition = "Coordonnées bancaires pour paiements fournisseurs. Utilisé dans interface bancaire (Marchés Fournisseurs)."
