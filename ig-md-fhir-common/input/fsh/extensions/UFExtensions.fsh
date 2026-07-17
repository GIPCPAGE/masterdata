// =============================================
// Extensions : Unité Fonctionnelle (Common IG)
// =============================================
// Source Oracle : STR.UFO — champs génériques

// ── Période de validité (DATDUF / DATFUF) ─────────────────────────────────────

Extension: UFPeriodeValiditeExtension
Id: uf-periode-validite
Title: "Période de validité de l'UF"
Description: "Période de validité de l'UF (STR.UFO — PK composite NUUFUF+DATDUF)."
Context: Organization
* extension contains dateDebut 1..1 MS and dateFin 0..1 MS
* extension[dateDebut].value[x] only date
* extension[dateDebut] ^short = "Date de début de période (DATDUF)"
* extension[dateFin].value[x] only date
* extension[dateFin] ^short = "Date de fin de période (DATFUF)"

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

// ── Type UF médicale (TYPEUF) ─────────────────────────────────────────────────

Extension: UFTypeUFMedicaleExtension
Id: uf-type-uf-medicale
Title: "Type d'UF médicale"
Description: "Type d'UF médicale (TYPEUF : H=Hospitalisation / E=Externe / D=Divers / A=Autre)."
Context: Organization
* value[x] only code
* valueCode from UFTypeUFMedicaleVS (required)
* valueCode ^short = "Type UF médicale (TYPEUF)"

ValueSet: UFTypeUFMedicaleVS
Id: uf-type-uf-medicale-vs
Title: "Type d'UF médicale (TYPEUF)"
* ^meta.profile = "http://hl7.org/fhir/StructureDefinition/shareablevalueset"
* UFTypeUFMedicaleCS#H "Hospitalisation"
* UFTypeUFMedicaleCS#E "Externe"
* UFTypeUFMedicaleCS#D "Divers"
* UFTypeUFMedicaleCS#A "Autre"

CodeSystem: UFTypeUFMedicaleCS
Id: uf-type-uf-medicale-cs
Title: "Type d'UF médicale"
* ^meta.profile = "http://hl7.org/fhir/StructureDefinition/shareablecodesystem"
* #H "Hospitalisation"
* #E "Externe"
* #D "Divers"
* #A "Autre"

// ── Indicateur séances (SEANUF) ───────────────────────────────────────────────

Extension: UFIndicateurSeancesExtension
Id: uf-indicateur-seances
Title: "UF à séances"
Description: "Indique si l'UF traite des séances (SEANUF : O=true / N=false)."
Context: Organization
* value[x] only boolean
* valueBoolean ^short = "UF à séances (SEANUF)"

// ── Classe dominante (CLDOUF) ─────────────────────────────────────────────────

Extension: UFClasseDominanteExtension
Id: uf-classe-dominante
Title: "Classe dominante de l'UF médicale"
Description: "Code classe dominante de l'UF médicale (CLDOUF : L/M/P/S/A/C/V/U/O/E/B/T)."
Context: Organization
* value[x] only string
* valueString ^short = "Classe dominante (CLDOUF — 1 char)"

// ── Lits réservés urgence (LURGUF) ────────────────────────────────────────────

Extension: UFLitsUrgenceExtension
Id: uf-lits-urgence
Title: "Lits réservés pour l'urgence"
Description: "Indique si l'UF a des lits réservés pour l'urgence (LURGUF : O/N)."
Context: Organization
* value[x] only boolean
* valueBoolean ^short = "Lits urgence (LURGUF)"

// ── Activité libérale (ACLIUF) ────────────────────────────────────────────────

Extension: UFActiviteLiberaleExtension
Id: uf-activite-liberale
Title: "Activité libérale"
Description: "Indique si l'UF a une activité libérale (ACLIUF : O/N)."
Context: Organization
* value[x] only boolean
* valueBoolean ^short = "Activité libérale (ACLIUF)"

// ── UF maternité (UFMAUF) ─────────────────────────────────────────────────────

Extension: UFMaterniteExtension
Id: uf-materniteLits
Title: "UF où peuvent naître des bébés"
Description: "Indique si l'UF est une UF de maternité (UFMAUF : O/N)."
Context: Organization
* value[x] only boolean
* valueBoolean ^short = "UF maternité (UFMAUF)"

// ── Confidentialité (CONFUF) ──────────────────────────────────────────────────

Extension: UFConfidentialiteExtension
Id: uf-confidentialite
Title: "Confidentialité de l'UF"
Description: "Indique si l'UF est confidentielle (CONFUF : O/N)."
Context: Organization
* value[x] only boolean
* valueBoolean ^short = "Confidentialité (CONFUF)"

// ── UF de responsabilité (CURMUF) ─────────────────────────────────────────────

Extension: UFResponsabiliteExtension
Id: uf-responsabilite
Title: "UF de responsabilité"
Description: "Indique si l'UF est une UF de responsabilité (CURMUF : O/N)."
Context: Organization
* value[x] only boolean
* valueBoolean ^short = "UF responsabilité (CURMUF)"

// ── Lettre budgétaire (SBUD_CODEBUD) ─────────────────────────────────────────

Extension: UFLettreBudgetaireExtension
Id: uf-lettre-budgetaire
Title: "Lettre budgétaire de l'UF"
Description: "Lettre budgétaire du Centre de Responsabilité de l'UF (SBUD_CODEBUD — 1 char, obligatoire)."
Context: Organization
* value[x] only string
* valueString ^short = "Lettre budgétaire (SBUD_CODEBUD)"

// ── Domaine d'activité (DOACUF) ───────────────────────────────────────────────

Extension: UFDomaineActiviteExtension
Id: uf-domaine-activite
Title: "Domaine d'activité"
Description: "Domaine d'activité de l'UF (DOACUF : M/C/O/N/D/P/S)."
Context: Organization
* value[x] only string
* valueString ^short = "Domaine activité (DOACUF — 1 char)"

// ── Libellé très long (LITLUF) ────────────────────────────────────────────────

Extension: UFLibelleTresLongExtension
Id: uf-libelle-tres-long
Title: "Libellé très long de l'UF"
Description: "Libellé très long de l'UF (LITLUF — 80 chars)."
Context: Organization
* value[x] only string
* valueString ^short = "Libellé très long (LITLUF)"

// ── Type autorisation unité médicale (REACUF) ─────────────────────────────────

Extension: UFReacExtension
Id: uf-reac
Title: "Type d'autorisation de l'unité médicale"
Description: "Type d'autorisation de l'unité médicale (REACUF — 3 chars)."
Context: Organization
* value[x] only string
* valueString ^short = "Type autorisation UM (REACUF)"

// ── Type autorisation urgence (AUTOUF) ────────────────────────────────────────

Extension: UFAutorisationUrgenceExtension
Id: uf-autorisation-urgence
Title: "Type d'autorisation d'urgence"
Description: "Type d'autorisation d'urgence de l'UF (AUTOUF — 2 chars)."
Context: Organization
* value[x] only string
* valueString ^short = "Type autorisation urgence (AUTOUF)"

// ── Catégorie UF (SCUF_CATGCUF) ──────────────────────────────────────────────

Extension: UFCategorieCUFExtension
Id: uf-categorie-cuf
Title: "Catégorie d'UF"
Description: "Catégorie d'UF (SCUF_CATGCUF — 4 chars, FK table SCUF)."
Context: Organization
* value[x] only string
* valueString ^short = "Catégorie UF (SCUF_CATGCUF)"

// ── Regroupements UF (RU1 / RU2 / URG) ───────────────────────────────────────

Extension: UFRegroupementsExtension
Id: uf-regroupements
Title: "Regroupements UF et codes analytiques"
Description: """
Codes de regroupements UF et références analytiques (STR.UFO).
Utilisés pour les regroupements analytiques et les statistiques d'activité.
"""
Context: Organization
* extension contains
    regroupement1          0..1 and
    regroupement2          0..1 and
    regroupementUrgence    0..1 and
    codeCentreActivite     0..1 and
    codeDepartement        0..1 and
    codeSectionPrixRevient 0..1 and
    codeCompteAnalyse      0..1 and
    codeSectionImputation  0..1 and
    codeSousSection        0..1

* extension[regroupement1].value[x] only string
* extension[regroupement1] ^short = "Regroupement UF 1 (RU1_NURGR1 — 4 chars)"

* extension[regroupement2].value[x] only string
* extension[regroupement2] ^short = "Regroupement UF 2 (RU2_NURGR2 — 4 chars)"

* extension[regroupementUrgence].value[x] only string
* extension[regroupementUrgence] ^short = "Regroupement UF 3 / Urgence (URG_CDURUR — 4 chars)"

* extension[codeCentreActivite].value[x] only string
* extension[codeCentreActivite] ^short = "Code centre d'activité (CAC_NUACAC — 4 chars)"

* extension[codeDepartement].value[x] only string
* extension[codeDepartement] ^short = "Code département analytique (DEP_NUDTDT — 4 chars)"

* extension[codeSectionPrixRevient].value[x] only string
* extension[codeSectionPrixRevient] ^short = "Code section prix de revient (SEC_NUSESP — 4 chars)"

* extension[codeCompteAnalyse].value[x] only string
* extension[codeCompteAnalyse] ^short = "Code compte section d'analyse (SAN_C9E_NUECC9 — 10 chars)"

* extension[codeSectionImputation].value[x] only string
* extension[codeSectionImputation] ^short = "Code section d'imputation (SSSI_SSIM_SECTSIM — 1 char)"

* extension[codeSousSection].value[x] only string
* extension[codeSousSection] ^short = "Code sous-section d'imputation (SSSI_SSECSSI — 2 chars)"
