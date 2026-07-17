// =============================================
// Extensions : Centre de Responsabilité (Common IG)
// =============================================
// Source Oracle : STR.CRE

// ── Période de validité (DATDCR / DATFCR) ─────────────────────────────────────

Extension: CREPeriodeValiditeExtension
Id: cre-periode-validite
Title: "Période de validité du CR"
Description: "Période de validité du centre de responsabilité (STR.CRE — PK composite NUCRCR+DATDCR)."
Context: Organization

* extension contains
    dateDebut 1..1 MS and
    dateFin   0..1 MS

* extension[dateDebut].value[x] only date
* extension[dateDebut] ^short = "Date de début de période (DATDCR)"

* extension[dateFin].value[x] only date
* extension[dateFin] ^short = "Date de fin de période (DATFCR)"

// ── Code de validité (INVACR) ─────────────────────────────────────────────────

Extension: CRECodeValiditeExtension
Id: cre-code-validite
Title: "Code de validité du CR"
Description: "Code de validité du CR (INVACR : F=Fermé / I=Invalide / V=Valide)."
Context: Organization

* value[x] only code
* valueCode from EGCodeValiditeVS (required)
* valueCode ^short = "Code validité (INVACR)"

// ── Lettre budgétaire (SBUD_CODEBUD) ─────────────────────────────────────────
// Obligatoire — 1 char — FK table SBUD

Extension: CRELettreBudgetaireExtension
Id: cre-lettre-budgetaire
Title: "Lettre budgétaire du CR"
Description: """
Lettre budgétaire associée au centre de responsabilité (SBUD_CODEBUD — 1 char, obligatoire).
Référence la table SBUD (budget hospitalier M21/M22).
"""
Context: Organization

* value[x] only string
* valueString ^short = "Lettre budgétaire (SBUD_CODEBUD — 1 char)"

// ── Code secteur budgétaire (SSBU_NUSBSB) ────────────────────────────────────

Extension: CRECodeSecteurBudgetaireExtension
Id: cre-code-secteur-budgetaire
Title: "Code secteur budgétaire"
Description: "Code du secteur budgétaire du CR (SSBU_NUSBSB — 3 chars, FK SSBU)."
Context: Organization

* value[x] only string
* valueString ^short = "Code secteur budgétaire (SSBU_NUSBSB — 3 chars)"

// ── Code direction transversale (SDTR_NUDTSD) ────────────────────────────────

Extension: CRECodeDirectionTransversaleExtension
Id: cre-code-direction-transversale
Title: "Code direction transversale"
Description: "Code de la direction transversale rattachée au CR (SDTR_NUDTSD — 10 chars, FK SDTR)."
Context: Organization

* value[x] only string
* valueString ^short = "Code direction transversale (SDTR_NUDTSD — 10 chars)"

// Note : le rattachement à l'entité juridique parente quand partOf référence un
// Pôle n'est plus porté par une extension sur ce profil — conforme FR Core
// (structure_relations.html, STRU-1), c'est EntiteJuridiqueProfile qui liste ce
// CR comme membre via extension[membres] (fr-core-organization-member).
