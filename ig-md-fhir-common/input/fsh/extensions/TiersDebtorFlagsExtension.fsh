// =============================================
// Extension: Attributs Spécifiques Débiteur
// =============================================

Extension: TiersDebtorFlags
Id: tiers-debtor-flags
Title: "Attributs Spécifiques Débiteur"
Description: "Extension pour les attributs spécifiques des débiteurs. Correspond aux champs KERD positions 21-23 (Est débiteur laboratoire O/N, Est débiteur locataire O/N, Est débiteur agent O/N, Numéro matricule agent). Ces attributs permettent d'identifier des catégories particulières de débiteurs nécessitant un traitement comptable ou administratif spécifique."
Context: Organization
* ^url = "https://www.cpage.fr/ig/masterdata/common/StructureDefinition/tiers-debtor-flags"
* ^version = "1.0.0"
* ^status = #active
* ^context[0].type = #element
* ^context[0].expression = "Organization"

* extension contains
    isLaboratory 0..1 MS and
    isTenant 0..1 MS and
    isAgent 0..1 MS and
    agentRegistrationNumber 0..1 MS

* extension[isLaboratory] ^short = "Est débiteur laboratoire (O/N)"
* extension[isLaboratory] ^definition = "Indique si le débiteur est un laboratoire d'analyses médicales (nécessite des règles de facturation spécifiques)"
* extension[isLaboratory].value[x] only boolean
* extension[isLaboratory].valueBoolean 1..1 MS

* extension[isTenant] ^short = "Est débiteur locataire (O/N)"
* extension[isTenant] ^definition = "Indique si le débiteur est un locataire (loyers, charges locatives)"
* extension[isTenant].value[x] only boolean
* extension[isTenant].valueBoolean 1..1 MS

* extension[isAgent] ^short = "Est débiteur agent (O/N)"
* extension[isAgent] ^definition = "Indique si le débiteur est un agent de l'établissement (personnel, salaires, avances)"
* extension[isAgent].value[x] only boolean
* extension[isAgent].valueBoolean 1..1 MS

* extension[agentRegistrationNumber] ^short = "Numéro matricule agent"
* extension[agentRegistrationNumber] ^definition = "Numéro de matricule de l'agent si le débiteur est un agent (20 caractères max)"
* extension[agentRegistrationNumber].value[x] only string
* extension[agentRegistrationNumber].valueString 1..1 MS
* extension[agentRegistrationNumber].valueString ^maxLength = 20
