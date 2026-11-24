// =============================================
// Extensions : Direction transversale (Common IG)
// =============================================
// Source Oracle : SDTR

// La période de validité de la direction transversale est portée par l'extension standard
// organization-period (usePeriod), héritée de FR Core : pas d'extension propre.

// ── Code de validité (INVASD) ─────────────────────────────────────────────────
// Master Data ne publie que V et I (MS-636) ; même ValueSet que les autres types de structure.

Extension: DTCodeValiditeExtension
Id: dt-code-validite
Title: "Code de validité de la direction transversale"
Description: "Code de validité de la direction transversale (INVASD : I=Invalide / V=Valide)."
Context: Organization

* value[x] only code
* valueCode from EGCodeValiditeVS (required)
* valueCode ^short = "Code validité (INVASD)"
