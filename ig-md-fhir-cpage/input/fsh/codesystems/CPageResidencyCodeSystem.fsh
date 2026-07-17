// =============================================
// CodeSystem Résidence CPage (Débiteur)
// =============================================

CodeSystem: CPageResidencyCodeSystem
Id: cpage-residency-codesystem
Title: "Résidence (CPage - Débiteur)"
Description: "Codes de résidence du débiteur selon la codification CPage (RESIDT)."
* ^status = #active
* ^content = #complete
* ^caseSensitive = true
* ^meta.profile = "http://hl7.org/fhir/StructureDefinition/shareablecodesystem"
* #R "Résident" "Débiteur résident"
* #N "Non-résident" "Débiteur non-résident"
* #E "Étranger" "Débiteur étranger"
