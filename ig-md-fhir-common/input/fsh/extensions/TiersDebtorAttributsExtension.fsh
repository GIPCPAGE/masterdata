// =============================================
// Extension: Attributs Débiteur
// =============================================

Extension: TiersDebtorAttributsExtension
Id: tiers-debtor-attributs
Title: "Attributs Débiteur"
Description: "Attributs spécifiques d'un débiteur : type (occasionnel/normal) et indicateurs de catégorie particulière (laboratoire, locataire, agent, hospitalier). Correspond aux colonnes LABOTI, LOCATI, AGENTI, HOSPTI de la table ETIER."
* ^url = "https://www.cpage.fr/ig/masterdata/common/StructureDefinition/tiers-debtor-attributs"
* ^version = "1.0.0"
* ^status = #active
* ^context[0].type = #element
* ^context[0].expression = "Organization"

* extension contains
    debtorType 0..1 MS and
    isLaboratory 0..1 MS and
    isTenant 0..1 MS and
    isAgent 0..1 MS and
    isHospital 0..1 MS and
    agentRegistrationNumber 0..1 MS

* extension[debtorType] ^short = "Type débiteur : Occasionnel (O) ou Normal (N)"
* extension[debtorType] ^definition = "Indique si le débiteur est occasionnel (enregistrement ponctuel) ou normal/régulier (enregistrement permanent)"
* extension[debtorType].value[x] only code
* extension[debtorType].valueCode 1..1 MS
* extension[debtorType].valueCode from TiersDebtorTypeVS (required)

* extension[isLaboratory] ^short = "Est débiteur laboratoire (O/N)"
* extension[isLaboratory] ^definition = "Indique si le débiteur est un laboratoire d'analyses médicales"
* extension[isLaboratory].value[x] only boolean
* extension[isLaboratory].valueBoolean 1..1 MS

* extension[isTenant] ^short = "Est débiteur locataire (O/N)"
* extension[isTenant] ^definition = "Indique si le débiteur est un locataire"
* extension[isTenant].value[x] only boolean
* extension[isTenant].valueBoolean 1..1 MS

* extension[isAgent] ^short = "Est débiteur agent (O/N)"
* extension[isAgent] ^definition = "Indique si le débiteur est un agent de l'établissement"
* extension[isAgent].value[x] only boolean
* extension[isAgent].valueBoolean 1..1 MS

* extension[isHospital] ^short = "Est débiteur hospitalier (O/N) — HOSPTI"
* extension[isHospital] ^definition = "Indique si le débiteur est un patient hospitalier. Correspond à la colonne HOSPTI de la table ETIER."
* extension[isHospital].value[x] only boolean
* extension[isHospital].valueBoolean 1..1 MS

* extension[agentRegistrationNumber] ^short = "Numéro matricule agent"
* extension[agentRegistrationNumber] ^definition = "Numéro de matricule de l'agent (20 caractères max)"
* extension[agentRegistrationNumber].value[x] only string
* extension[agentRegistrationNumber].valueString 1..1 MS
* extension[agentRegistrationNumber].valueString ^maxLength = 20
