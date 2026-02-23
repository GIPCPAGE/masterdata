// =============================================
// Profil CPage Debtor Organization
// Hérite du profil GEF DebiteurProfile
// =============================================

Profile: CPageDebiteurProfile
Parent: DebiteurProfile
Id: cpage-debiteur-profile
Title: "Tiers Débiteur (CPage)"
Description: "Profil CPage pour un tiers débiteur. Hérite du profil DebiteurProfile (conforme GEF/KERD) et ajoute les extensions métier CPage issues de la table ECO.DBT (rôle débiteur)."

// Extensions CPage spécifiques
* extension contains
    CPageValidity named cpageValidity 0..1 MS and
    CPageEUZone named cpageEUZone 0..1 MS and
    CPageDebtorResidency named residency 0..1 MS and
    CPageDebtorAccount named debtorAccount 0..1 MS and
    CPageDebtorAsap named asap 0..1 MS and
    CPageDebtorExternalId named externalId 0..1 MS and
    CPageDebtorAssociatedSupplier named associatedSupplier 0..1

* extension[cpageValidity] ^short = "Validité du débiteur (INVADT)"
* extension[cpageEUZone] ^short = "Zone européenne (EUROTI)"
* extension[residency] ^short = "Résidence débiteur (RESIDT)"
* extension[debtorAccount] ^short = "Compte tiers débiteur"
* extension[asap] ^short = "Paramètres ASAP"
* extension[externalId] ^short = "Identifiant externe (IDEXDT)"
* extension[associatedSupplier] ^short = "Fournisseur associé (NUFODT)"

// Note: L'extension tiersRole (héritée) doit contenir au moins #debtor
* extension[tiersRole] ^comment = "Pour ce profil débiteur, l'extension tiersRole devrait contenir au moins le code 'debtor'."
