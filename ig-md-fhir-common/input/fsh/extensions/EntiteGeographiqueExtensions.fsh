// =============================================
// Extensions : Entité Géographique (Common IG)
// =============================================
// Champs génériques issus de STR.ETA applicables à tout site hospitalier.

// ── Période de validité (DATDET / DATFET) ─────────────────────────────────────
// Le modèle ETA est temporel : chaque instance = une période de validité du site.

Extension: EGPeriodeValiditeExtension
Id: eg-periode-validite
Title: "Période de validité du site géographique"
Description: """
Période de validité de l'enregistrement du site géographique (table STR.ETA).
La PK Oracle est composite (NUETET + DATDET) — chaque version du site a sa propre période.
"""
Context: Organization

* extension contains
    dateDebut 1..1 MS and
    dateFin   0..1 MS

* extension[dateDebut].value[x] only date
* extension[dateDebut] ^short = "Date de début de période (DATDET)"
* extension[dateDebut] ^definition = "Date à partir de laquelle cet enregistrement est valide."

* extension[dateFin].value[x] only date
* extension[dateFin] ^short = "Date de fin de période (DATFET)"
* extension[dateFin] ^definition = "Date à partir de laquelle cet enregistrement n'est plus valide. Vide si indéfini."

// ── Code de validité (INVAET) ────────────────────────────────────────────────

Extension: EGCodeValiditeExtension
Id: eg-code-validite
Title: "Code de validité du site"
Description: "Code de validité du site géographique (INVAET : F=Fermé / I=Invalide / V=Valide)."
Context: Organization

* value[x] only code
* valueCode from EGCodeValiditeVS (required)
* valueCode ^short = "Code validité (INVAET)"

ValueSet: EGCodeValiditeVS
Id: eg-code-validite-vs
Title: "Code de validité (INVAET)"
Description: "Codes de validité d'un site géographique (INVAET) : Fermé, Invalide ou Valide."
* ^experimental = false
* ^meta.profile = "http://hl7.org/fhir/StructureDefinition/shareablevalueset"
* EGCodeValiditeCS#F "Fermé"
* EGCodeValiditeCS#I "Invalide"
* EGCodeValiditeCS#V "Valide"

CodeSystem: EGCodeValiditeCS
Id: eg-code-validite-cs
Title: "Code de validité du site"
Description: "Code de validité du site géographique (INVAET) : F=Fermé, I=Invalide, V=Valide."
* ^experimental = false
* ^meta.profile = "http://hl7.org/fhir/StructureDefinition/shareablecodesystem"
* #F "Fermé"
* #I "Invalide"
* #V "Valide"

// ── Secteur sanitaire (SSSA_SESASSA) ─────────────────────────────────────────

Extension: EGSecteurSanitaireExtension
Id: eg-secteur-sanitaire
Title: "Secteur sanitaire"
Description: "Code du secteur sanitaire auquel appartient le site (SSSA_SESASSA — FK table SSSA, 3 chars)."
Context: Organization

* value[x] only string
* valueString ^short = "Code secteur sanitaire (SSSA_SESASSA — 3 chars)"

// ── Code NAF (CNAFET) ────────────────────────────────────────────────────────

Extension: EGCodeNafExtension
Id: eg-code-naf
Title: "Code NAF du site"
Description: "Code NAF (Nomenclature des Activités Françaises) du site géographique (CNAFET — 6 chars)."
Context: Organization

* value[x] only string
* valueString ^short = "Code NAF (CNAFET)"

// ── Libellé de localisation (LILOET) ──────────────────────────────────────────

Extension: EGLibelleLocalisationExtension
Id: eg-libelle-localisation
Title: "Libellé de localisation"
Description: "Libellé descriptif de la localisation du site (LILOET — 40 chars)."
Context: Organization

* value[x] only string
* valueString ^short = "Libellé de localisation (LILOET)"

// ── Indicateur SAE (DSAEET) ───────────────────────────────────────────────────

Extension: EGIndicateurSaeExtension
Id: eg-indicateur-sae
Title: "Déclaration SAE séparée"
Description: "Indique si ce site doit être déclaré séparément dans la SAE (DSAEET : O=true / N=false)."
Context: Organization

* value[x] only boolean
* valueBoolean ^short = "Déclaration SAE séparée (DSAEET)"

// ── Horaires d'ouverture (HORAIRES_OUVERTURE) ─────────────────────────────────

Extension: EGHorairesExtension
Id: eg-horaires
Title: "Horaires d'ouverture"
Description: "Horaires d'ouverture du site géographique (HORAIRES_OUVERTURE — 38 chars)."
Context: Organization

* value[x] only string
* valueString ^short = "Horaires d'ouverture"

// ── Coefficient géographique T2A (CGEOET) ────────────────────────────────────

Extension: EGCoeffGeoT2AExtension
Id: eg-coeff-geo-t2a
Title: "Coefficient géographique T2A"
Description: """
Coefficient géographique utilisé dans le calcul des tarifs T2A (CGEOET — entre 1 et 2).
Applicable aux établissements MCO/SSR/PSY soumis à la tarification à l'activité.
"""
Context: Organization

* value[x] only decimal
* valueDecimal ^short = "Coefficient géographique T2A (CGEOET, entre 1,0000 et 2,0000)"

// ── Coefficient de transition T2A (CTRAET) ───────────────────────────────────

Extension: EGCoeffTransitionT2AExtension
Id: eg-coeff-transition-t2a
Title: "Coefficient de transition T2A"
Description: "Coefficient de transition utilisé dans le calcul des tarifs T2A (CTRAET — entre 0 et 2)."
Context: Organization

* value[x] only decimal
* valueDecimal ^short = "Coefficient de transition T2A (CTRAET, entre 0,0000 et 2,0000)"
