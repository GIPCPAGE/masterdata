// =============================================
// ValueSet Zone Europe CPage
// =============================================

ValueSet: CPageEUZoneValueSet
Id: cpage-euzone-valueset
Title: "ValueSet Zone Europe CPage"
Description: "Codes EUROTI : F (France), O (Europe hors France), A (Autre)."
* ^status = #active
* ^meta.profile = "http://hl7.org/fhir/StructureDefinition/shareablevalueset"
* include codes from system CPageEUZoneCodeSystem
