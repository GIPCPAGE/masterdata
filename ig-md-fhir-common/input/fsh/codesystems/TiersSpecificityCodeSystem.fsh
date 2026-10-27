// =============================================
// CodeSystem Spécificités Tiers
// =============================================

CodeSystem: TiersSpecificityCodeSystem
Id: tiers-specificity-cs
Title: "Spécificités Tiers"
Description: "Particularités d'un tiers cochées sur la fiche : laboratoire, locataire, agent, débiteur mortuaire, hospitalier."
* ^status = #active
* ^experimental = false
* ^content = #complete
* ^caseSensitive = true
* ^meta.profile = "http://hl7.org/fhir/StructureDefinition/shareablecodesystem"
* #LABORATOIRE "Laboratoire" "Le tiers est un laboratoire"
* #LOCATAIRE "Locataire" "Le tiers est un locataire"
* #AGENT "Agent" "Le tiers est un agent"
* #MORTUAIRE "Débiteur mortuaire" "Le tiers est un débiteur mortuaire"
* #HOSPITALIER "Hospitalier" "Le tiers est un établissement hospitalier"
