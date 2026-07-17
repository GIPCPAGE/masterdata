// =============================================
// Extensions : Pôle d'activité (Common IG)
// =============================================
// Le pôle partage le même modèle temporel (DATD*/DATF* + INV*) que l'entité géographique.
// Ces extensions sont déclarées ici car POA est un concept à part entière.

// ── Période de validité (DATDPA / DATFPA) ─────────────────────────────────────

Extension: POAPeriodeValiditeExtension
Id: poa-periode-validite
Title: "Période de validité du pôle"
Description: """
Période de validité de l'enregistrement du pôle (table STR.POA).
La PK Oracle est composite (NUPAPA + DATDPA).
"""
Context: Organization

* extension contains
    dateDebut 1..1 MS and
    dateFin   0..1 MS

* extension[dateDebut].value[x] only date
* extension[dateDebut] ^short = "Date de début de période (DATDPA)"

* extension[dateFin].value[x] only date
* extension[dateFin] ^short = "Date de fin de période (DATFPA)"

// ── Code de validité (INVAPA) ─────────────────────────────────────────────────

Extension: POACodeValiditeExtension
Id: poa-code-validite
Title: "Code de validité du pôle"
Description: "Code de validité du pôle (INVAPA : F=Fermé / I=Invalide / V=Valide)."
Context: Organization

* value[x] only code
// Réutilise le même ValueSet que EGCodeValiditeVS (F/I/V)
* valueCode from EGCodeValiditeVS (required)
* valueCode ^short = "Code validité (INVAPA)"
