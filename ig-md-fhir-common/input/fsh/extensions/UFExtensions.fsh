// =============================================
// Extensions : Unité Fonctionnelle (Common IG)
// =============================================
// Source Oracle : STR.UFO — champs génériques

// La période de validité de l'UF est portée par l'extension standard organization-period
// (usePeriod), héritée de FR Core : pas d'extension propre.

// ── Code de validité (INVAUF) ─────────────────────────────────────────────────

Extension: UFCodeValiditeExtension
Id: uf-code-validite
Title: "Code de validité de l'UF"
Description: "Code de validité (INVAUF : F=Fermé / I=Invalide / V=Valide)."
Context: Organization
* value[x] only code
* valueCode from EGCodeValiditeVS (required)
* valueCode ^short = "Code validité (INVAUF)"

// ── Site de localisation (ETA_NUETET) ─────────────────────────────────────────
// Distinct du parent hiérarchique (CRE) — indique où l'UF est physiquement.

Extension: UFSiteLocalisationExtension
Id: uf-site-localisation
Title: "Site géographique de localisation de l'UF"
Description: """
Entité géographique (site) où l'UF est physiquement localisée (ETA_NUETET).
Distinct du parent hiérarchique Centre de Responsabilité (CRE_NUCRCR → partOf).
"""
Context: Organization
* value[x] only Reference(EntiteGeographiqueProfile)
* valueReference ^short = "Site de localisation (ETA_NUETET)"

// ── Pôle d'activité optionnel (POA_NUPAPA) ───────────────────────────────────

Extension: UFPoleExtension
Id: uf-pole
Title: "Pôle d'activité de l'UF"
Description: "Pôle d'activité optionnel auquel l'UF est rattachée (POA_NUPAPA)."
Context: Organization
* value[x] only Reference(PoleProfile)
* valueReference ^short = "Pôle d'activité (POA_NUPAPA)"

// ── Classe dominante (CLDOUF) ─────────────────────────────────────────────────

Extension: UFClasseDominanteExtension
Id: uf-classe-dominante
Title: "Classe dominante de l'UF médicale"
Description: "Code classe dominante de l'UF médicale (CLDOUF : L/M/P/S/A/C/V/U/O/E/B/T)."
Context: Organization
* value[x] only string
* valueString ^short = "Classe dominante (CLDOUF — 1 char)"

// ── Lettre budgétaire (SBUD_CODEBUD) ─────────────────────────────────────────

Extension: UFLettreBudgetaireExtension
Id: uf-lettre-budgetaire
Title: "Lettre budgétaire de l'UF"
Description: "Lettre budgétaire du Centre de Responsabilité de l'UF (SBUD_CODEBUD — 1 char, obligatoire)."
Context: Organization
* value[x] only string
* valueString ^short = "Lettre budgétaire (SBUD_CODEBUD)"

// ── Libellé très long (LITLUF) ────────────────────────────────────────────────

Extension: UFLibelleTresLongExtension
Id: uf-libelle-tres-long
Title: "Libellé très long de l'UF"
Description: "Libellé très long de l'UF (LITLUF — 80 chars)."
Context: Organization
* value[x] only string
* valueString ^short = "Libellé très long (LITLUF)"
