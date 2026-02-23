// =============================================
// Profil CPage Supplier Organization
// Hérite du profil GEF FournisseurProfile
// =============================================

Profile: CPageFournisseurProfile
Parent: FournisseurProfile
Id: cpage-fournisseur-profile
Title: "Tiers Fournisseur (CPage)"
Description: "Profil CPage pour un tiers fournisseur. Hérite du profil FournisseurProfile (conforme GEF/EFOU) et ajoute les extensions métier CPage issues de la table ECO.FOU (rôle fournisseur)."

// Extensions CPage spécifiques
* extension contains
    CPageValidity named cpageValidity 0..1 MS and
    CPageEUZone named cpageEUZone 0..1 MS and
    CPageSupplierAccountingClass6 named accountingClass6 0..1 MS and
    CPageSupplierAccountingClass2 named accountingClass2 0..1 MS and
    CPageSupplierPaymentTerms named paymentTerms 0..1 MS and
    CPageSupplierPublicProcurement named procurement 0..1 MS and
    CPageSupplierChorus named chorus 0..1 MS and
    CPageSupplierInternalFlags named internalFlags 0..1

* extension[cpageValidity] ^short = "Validité du fournisseur (VALIFO)"
* extension[cpageEUZone] ^short = "Zone européenne (EUROTI)"
* extension[accountingClass6] ^short = "Comptabilité classe 6"
* extension[accountingClass2] ^short = "Comptabilité classe 2"
* extension[paymentTerms] ^short = "Conditions de paiement"
* extension[procurement] ^short = "Informations marchés publics"
* extension[chorus] ^short = "Informations Chorus"
* extension[internalFlags] ^short = "Flags internes système"

// Note: L'extension tiersRole (héritée) doit contenir au moins #supplier
// Mais FHIRPath constraint sur extensions parent non supporté partout, donc documenté uniquement
* extension[tiersRole] ^comment = "Pour ce profil fournisseur, l'extension tiersRole devrait contenir au moins le code 'supplier'."
