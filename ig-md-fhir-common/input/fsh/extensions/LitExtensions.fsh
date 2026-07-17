// =============================================
// Extensions : Lit (Common IG)
// =============================================
// Source Oracle : PAT.LLI

Extension: LitPeriodeValiditeExtension
Id: lit-periode-validite
Title: "Période de validité du lit"
Description: "Période de validité du lit (PAT.LLI — PK composite ... + DAEFLL)."
Context: Location
* extension contains dateDebut 1..1 MS and dateFin 0..1 MS
* extension[dateDebut].value[x] only date
* extension[dateDebut] ^short = "Date de début de période (DAEFLL)"
* extension[dateFin].value[x] only date
* extension[dateFin] ^short = "Date de fin de période (DAFILL)"

Extension: LitCodeValiditeExtension
Id: lit-code-validite
Title: "Code de validité du lit"
Description: "Code de validité (VALILL : F=Fermé / I=Invalide / V=Valide)."
Context: Location
* value[x] only code
* valueCode from EGCodeValiditeVS (required)
* valueCode ^short = "Code validité (VALILL)"

Extension: LitTypeLitExtension
Id: lit-type-lit
Title: "Type de lit"
Description: """
Type de lit (CARALL — 2 chars).
Valeurs : A | B | H | I | P | S | U | C | R.
"""
Context: Location
* value[x] only code
* valueCode from LitTypeVS (required)
* valueCode ^short = "Type de lit (CARALL)"

ValueSet: LitTypeVS
Id: lit-type-vs
Title: "Type de lit (CARALL)"
Description: "Types de lit possibles selon le code CARALL : Standard, Bébé, Hospitalisation, Isolement, Pédiatrie, Soins, Urgences, Chirurgie, Rééducation."
* ^experimental = false
* ^meta.profile = "http://hl7.org/fhir/StructureDefinition/shareablevalueset"
* LitTypeCS#A "Standard (A)"
* LitTypeCS#B "Bébé (B)"
* LitTypeCS#H "Hospitalisation (H)"
* LitTypeCS#I "Isolement (I)"
* LitTypeCS#P "Pédiatrie (P)"
* LitTypeCS#S "Soins (S)"
* LitTypeCS#U "Urgences (U)"
* LitTypeCS#C "Chirurgie (C)"
* LitTypeCS#R "Rééducation (R)"

CodeSystem: LitTypeCS
Id: lit-type-cs
Title: "Type de lit (CARALL)"
Description: "Code de type de lit (CARALL) : A=Standard, B=Bébé, H=Hospitalisation, I=Isolement, P=Pédiatrie, S=Soins, U=Urgences, C=Chirurgie, R=Rééducation."
* ^experimental = false
* ^meta.profile = "http://hl7.org/fhir/StructureDefinition/shareablecodesystem"
* #A "Standard"
* #B "Bébé"
* #H "Hospitalisation"
* #I "Isolement"
* #P "Pédiatrie"
* #S "Soins"
* #U "Urgences"
* #C "Chirurgie"
* #R "Rééducation"

Extension: LitIndicateurSeancesExtension
Id: lit-indicateur-seances
Title: "Lit de séances"
Description: "Indique si le lit est dédié aux séances (LISELL : O=true / N=false)."
Context: Location
* value[x] only boolean
* valueBoolean ^short = "Lit de séances (LISELL)"

Extension: LitDateIndisponibiliteExtension
Id: lit-date-indisponibilite
Title: "Date d'indisponibilité du lit"
Description: "Date à partir de laquelle le lit est indisponible (DAINLL — optionnel)."
Context: Location
* value[x] only date
* valueDate ^short = "Date d'indisponibilité (DAINLL)"

Extension: LitTypeAutorisationExtension
Id: lit-type-autorisation
Title: "Type d'autorisation du lit"
Description: "Type d'autorisation associé au lit (REACLL — 3 chars)."
Context: Location
* value[x] only string
* valueString ^short = "Type autorisation (REACLL)"
