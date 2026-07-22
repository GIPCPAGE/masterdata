// =============================================
// CodeSystem : Type d'entité géopolitique (INSEE)
// =============================================
// Classification INSEE des entités dans le référentiel des pays étrangers.
// Valeurs : pays | territoire | collectivite_francaise (modèle de données).
// Terminologie interne CPage — aucun équivalent ANS/HL7 identifié.

CodeSystem: PaysTypeEntiteCS
Id: pays-type-entite-cs
Title: "CPage — Type d'entité géopolitique (CodeSystem)"
Description: """
Classification INSEE des entités géopolitiques dans le référentiel des pays et
territoires étrangers. Terminologie interne CPage — aucun équivalent ANS/HL7 identifié.

Correspond au champ `type_entite` (NOT NULL) du modèle de données.
"""
* ^url = "https://www.cpage.fr/ig/masterdata/common/CodeSystem/pays-type-entite-cs"
* ^version = "1.0.0"
* ^status = #active
* ^caseSensitive = false
* ^content = #complete
* ^experimental = false

* #pays "Pays souverain" "Entité géopolitique disposant d'une pleine souveraineté au sens du droit international. Exemples : France (FR), Allemagne (DE), Japon (JP)."
* #territoire "Territoire non souverain" "Entité géographique dépendant d'un pays souverain sans être souveraine elle-même. Exemples : îles Féroé (FO, Danemark), Groenland (GL, Danemark), Bermudes (BM, Royaume-Uni)."
* #collectivite-francaise "Collectivité française" "Collectivité française d'outre-mer dotée d'un statut particulier dans le référentiel INSEE. Exemples : Polynésie française (PF), Nouvelle-Calédonie (NC), Wallis-et-Futuna (WF)."
