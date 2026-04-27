// =============================================
// Extension: Détails Personne Physique
// =============================================

Extension: TiersPersonDetails
Id: tiers-person-details
Title: "Détails Personne Physique"
Description: "Extension pour les informations spécifiques aux personnes physiques : civilité, prénom, numéro de matricule et numéro de dossier patient. Correspond aux colonnes CIVITI, PRENTI, NOMATI, NOPATI de la table ETIER."
Context: Organization
* ^url = "https://www.cpage.fr/ig/masterdata/common/StructureDefinition/tiers-person-details"
* ^version = "1.0.0"
* ^status = #active
* ^context[0].type = #element
* ^context[0].expression = "Organization"

* extension contains
    civility 0..1 MS and
    firstName 0..1 MS and
    numeroMatricule 0..1 MS and
    numeroDossierPatient 0..1 MS

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

* extension[numeroMatricule] ^short = "Numéro de matricule (NOMATI)"
* extension[numeroMatricule] ^definition = "Numéro de matricule de la personne physique (20 caractères max). Correspond à la colonne NOMATI de la table ETIER."
* extension[numeroMatricule].value[x] only string
* extension[numeroMatricule].valueString 1..1 MS
* extension[numeroMatricule].valueString ^maxLength = 20

* extension[numeroDossierPatient] ^short = "Numéro de dossier patient (NOPATI)"
* extension[numeroDossierPatient] ^definition = "Numéro de dossier patient (20 caractères max). Utilisé pour les débiteurs de type patient hospitalisé. Correspond à la colonne NOPATI de la table ETIER."
* extension[numeroDossierPatient].value[x] only string
* extension[numeroDossierPatient].valueString 1..1 MS
* extension[numeroDossierPatient].valueString ^maxLength = 20
