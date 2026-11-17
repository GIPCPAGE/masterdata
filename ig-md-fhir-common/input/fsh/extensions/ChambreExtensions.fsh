// =============================================
// Extensions : Chambre (Common IG)
// =============================================
// Source Oracle : PAT.PIE

// La période de validité de la chambre est portée par l'extension commune aux entités physiques
// strh-periode-validite (StrHPeriodeValiditeExtension.fsh) : pas d'extension propre.

// ── Code de validité (VALIPI) ─────────────────────────────────────────────────

Extension: ChambreCodeValiditeExtension
Id: chambre-code-validite
Title: "Code de validité de la chambre"
Description: "Code de validité de la chambre (VALIPI : F=Fermée / I=Invalide / V=Valide)."
Context: Location
* value[x] only code
* valueCode from EGCodeValiditeVS (required)
* valueCode ^short = "Code validité (VALIPI)"

// ── Indicateur chambre individuelle (INDIVIDUELLE) ────────────────────────────

Extension: ChambreIndividuelleExtension
Id: chambre-individuelle
Title: "Chambre individuelle"
Description: "Indique si la chambre est individuelle (INDIVIDUELLE : 1=true / 0=false)."
Context: Location
* value[x] only boolean
* valueBoolean ^short = "Chambre individuelle (INDIVIDUELLE)"
