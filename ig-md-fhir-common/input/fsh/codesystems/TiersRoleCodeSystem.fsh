// =============================================
// CodeSystem Rôles Tiers (Générique)
// =============================================

CodeSystem: TiersRoleCodeSystem
Id: tiers-role-cs
Title: "Rôles Tiers (Générique)"
Description: "Rôles génériques d'un tiers (débiteur, fournisseur, payeur)."
* ^status = #active
* ^content = #complete
* ^caseSensitive = true
* #supplier "Fournisseur" "Le tiers est un fournisseur"
* #debtor "Débiteur" "Le tiers est un débiteur"
* #payer "Payeur" "Le tiers est un organisme payeur (Sécurité sociale, mutuelle, etc.)"
