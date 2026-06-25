// =============================================
// ValueSet Type fonctionnel — Paramètres Applicatif CPage
// =============================================

ValueSet: CPageParametresApplicatifTypeValueSet
Id: cpage-parametres-applicatif-type-valueset
Title: "Types fonctionnels d'un paramètre applicatif (CPage)"
Description: "Valeurs autorisées pour le champ typeParametre d'un paramètre applicatif CPage."
* ^status = #draft
* ^experimental = false
* ^meta.profile = "http://hl7.org/fhir/StructureDefinition/shareablevalueset"
* include codes from system CPageParametresApplicatifTypeCodeSystem
