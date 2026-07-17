// =============================================
// Extensions : Chambre (Common IG)
// =============================================
// Source Oracle : PAT.PIE

// ── Période de validité (DAEFPI / DAFIPI) ─────────────────────────────────────

Extension: ChambrePeriodeValiditeExtension
Id: chambre-periode-validite
Title: "Période de validité de la chambre"
Description: "Période de validité de la chambre (PAT.PIE — PK composite UFO_NUUFUF+NUPIPI+DAEFPI)."
Context: Location
* extension contains dateDebut 1..1 MS and dateFin 0..1 MS
* extension[dateDebut].value[x] only date
* extension[dateDebut] ^short = "Date de début de période (DAEFPI)"
* extension[dateFin].value[x] only date
* extension[dateFin] ^short = "Date de fin de période (DAFIPI)"

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
