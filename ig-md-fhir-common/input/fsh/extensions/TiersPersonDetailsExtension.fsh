// =============================================
// Extension: Détails Personne Physique
// =============================================

Extension: TiersPersonDetails
Id: tiers-person-details
Title: "Détails Personne Physique"
Description: "Extension pour les informations spécifiques aux personnes physiques (débiteurs de Catégorie TG = 01). Correspond aux champs KERD positions 10-11 (Civilité, Prénom). Ces informations sont OBLIGATOIRES pour les débiteurs de type 'Personne physique' selon les règles métier."
Context: Organization
* ^url = "https://www.cpage.fr/ig/masterdata/common/StructureDefinition/tiers-person-details"
* ^version = "1.0.0"
* ^status = #active
* ^context[0].type = #element
* ^context[0].expression = "Organization"

* extension contains
    civility 0..1 MS and
    firstName 0..1 MS

* extension[civility] ^short = "Civilité (M, MME, MLLE, METMME, MOUMME)"
* extension[civility] ^definition = "Civilité de la personne physique selon la nomenclature. Obligatoire si Catégorie TG = 01 (Personne physique)."
* extension[civility].value[x] only code
* extension[civility].valueCode 1..1 MS
* extension[civility].valueCode from TiersCivilityVS (required)

* extension[firstName] ^short = "Prénom (38 caractères max)"
* extension[firstName] ^definition = "Prénom de la personne physique. Obligatoire si Catégorie TG = 01 (Personne physique)."
* extension[firstName].value[x] only string
* extension[firstName].valueString 1..1 MS
* extension[firstName].valueString ^maxLength = 38
