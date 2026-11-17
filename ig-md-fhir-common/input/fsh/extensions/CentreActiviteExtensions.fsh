// =============================================
// Extensions : Centre d'Activité (Common IG)
// =============================================
// La période de validité du centre d'activité est portée par l'extension standard
// organization-period (usePeriod), héritée de FR Core : pas d'extension propre.

// ── Code de validité (INVAAC) ─────────────────────────────────────────────────

Extension: CACCodeValiditeExtension
Id: cac-code-validite
Title: "Code de validité du centre d'activité"
Description: "Code de validité du centre d'activité (INVAAC : F=Fermé / I=Invalide / V=Valide)."
Context: Organization

* value[x] only code
// Réutilise le même ValueSet que EGCodeValiditeVS (F/I/V)
* valueCode from EGCodeValiditeVS (required)
* valueCode ^short = "Code validité (INVAAC)"
