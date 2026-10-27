// =============================================
// CodeSystem Rôles Tiers (Générique)
// =============================================

CodeSystem: TiersRoleCodeSystem
Id: tiers-role-cs
Title: "Rôles Tiers (Générique)"
Description: "Rôle d'un tiers : fournisseur (F), débiteur (D) ou mixte (M, les deux). Le rôle payeur n'existe pas."
* ^status = #active
* ^experimental = false
* ^content = #complete
* ^caseSensitive = true
* ^meta.profile = "http://hl7.org/fhir/StructureDefinition/shareablecodesystem"
* #supplier "Fournisseur" "Le tiers est un fournisseur"
* #debtor "Débiteur" "Le tiers est un débiteur"
* #mixed "Mixte" "Le tiers est à la fois fournisseur et débiteur"
