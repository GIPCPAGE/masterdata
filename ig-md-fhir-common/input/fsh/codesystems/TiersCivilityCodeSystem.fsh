// =============================================
// CodeSystem: Civilité
// =============================================

CodeSystem: TiersCivilityCS
Id: tiers-civility-cs
Title: "Civilité"
Description: "Codes de civilité selon la nomenclature. Utilisé dans les messages KERD (position 10) pour les débiteurs de Catégorie TG = 01 (Personne physique). Obligatoire si le débiteur est une personne physique."
* ^url = "https://www.cpage.fr/ig/masterdata/common/CodeSystem/tiers-civility-cs"
* ^version = "1.0.0"
* ^status = #active
* ^experimental = false
* ^caseSensitive = true
* ^content = #complete
* ^count = 5

* #M "Monsieur" "Monsieur"
* #MME "Madame" "Madame"
* #MLLE "Mademoiselle" "Mademoiselle"
* #METMME "Monsieur et Madame" "Monsieur et Madame (couple)"
* #MOUMME "Monsieur ou Madame" "Monsieur ou Madame (indéterminé)"
