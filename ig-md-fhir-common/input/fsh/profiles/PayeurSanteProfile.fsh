// =============================================
// Profil Payeur Santé (Assurance Maladie, Mutuelles)
// Conforme aux spécifications payeurs santé
// =============================================

Profile: PayeurSanteProfile
Parent: TiersProfile
Id: payeur-sante-profile
Title: "Payeur Santé"
Description: "Profil pour les payeurs d'assurance maladie (régime obligatoire et complémentaire). Hérite du profil TiersProfile et ajoute les contraintes spécifiques aux organismes payeurs: CPAM, MSA, RSI, mutuelles, etc."

// Rôle tiers doit être 'payer'
* extension[tiersRole] 1..1 MS
* extension[tiersRole] ^comment = "Pour un payeur santé, l'extension tiersRole doit contenir le code 'payer'."

// Extension payeur santé REQUISE
* extension[payeurSante] 1..1 MS
* extension[payeurSante] ^short = "Paramètres payeur santé (type, régime, caisse)"
* extension[payeurSante] ^definition = "Extension contenant le type de payeur (obligatoire/complémentaire), le grand régime (SS/MSA/RSI/CNAV/Mutuelle), le code centre, le numéro de caisse, le numéro d'organisme, et les paramètres de gestion (éclatement factures, délai PEC)."

// Identifiants spécifiques payeurs santé
* identifier[etierId] ^short = "Code payeur interne"
* identifier[etierId] ^definition = "Code interne unique du payeur santé dans le système de gestion."

// Nom du payeur (ex: CPAM de Paris, Mutuelle des Fonctionnaires)
* name 1..1 MS
* name ^short = "Nom de l'organisme payeur"
* name ^definition = "Désignation officielle du payeur: CPAM + ville, MSA + département, nom de la mutuelle, etc."

// Type d'organisation doit refléter la nature du payeur
* type ^short = "Type d'organisme (Assurance maladie, Mutuelle, etc.)"
* type ^definition = "Type d'organisme selon TG Category: Assurance maladie (codes 60-64), Autres organismes de protection sociale."
* type ^comment = "Codes TRE_R66 pour organismes payeurs: #60 (Ass. maladie - Gén.), #61 (CPAM), #62 (Caisse spéciale), #63 (Mutuelle), #64 (Autre org. protection)."

// Adresse du siège de l'organisme payeur
* address ^short = "Adresse siège organisme payeur"
* address ^definition = "Coordonnées du siège de l'organisme payeur (CPAM, caisse régionale, siège mutuelle)."

// Contacts du service de facturation
* telecom ^short = "Contacts service facturation"
* telecom ^definition = "Téléphone, email, site web du service de facturation pour les créances."

// Domiciliation bancaire héritée (non applicable pour la plupart des payeurs)
* extension[bankAccount] 0..0
* extension[bankAccount] ^comment = "Les payeurs santé ne fournissent généralement pas leur RIB, ce sont eux qui payent les établissements."

// Extensions fournisseur/débiteur non utilisées
* extension[codeFournisseur] 0..0
* extension[comptabilite] 0..0
* extension[paiement] 0..0
* extension[codeDebiteur] 0..0
* extension[parametres] 0..0
* extension[debtorType] 0..0
* extension[codeFournisseur] ^comment = "Un payeur santé n'a pas de paramètres fournisseur."
* extension[codeDebiteur] ^comment = "Un payeur santé n'a pas de paramètres débiteur."
