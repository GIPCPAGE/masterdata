// =============================================
// Extensions : Section d'analyse (Common IG)
// =============================================
// Champs de portée LOCAL de la section d'analyse sans équivalent FR Core ni HL7.
// Le code du groupement hospitalier réutilise l'extension commune
// strh-code-groupement-hospitalier (StrHCodeGroupementHospitalierExtension.fsh).

// ── Compte analytique ────────────────────────────────────────────────────────

Extension: SACompteAnalytiqueExtension
Id: sa-compte-analytique
Title: "Compte analytique de la section d'analyse"
Description: "Compte analytique de la section d'analyse : code d'une nomenclature de comptes analytiques propre à chaque tenant. Attribut de portée LOCAL, actif selon le tenant."
Context: Organization

* value[x] only string
* valueString ^short = "Code du compte analytique (nomenclature propre au tenant)"
