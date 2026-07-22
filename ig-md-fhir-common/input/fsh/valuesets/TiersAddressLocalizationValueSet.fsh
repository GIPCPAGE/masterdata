// =============================================
// ValueSet: Localisation Adresse
// =============================================

ValueSet: TiersAddressLocalizationVS
Id: tiers-address-localization-vs
Title: "Localisation Adresse"
Description: "ValueSet des codes de localisation géographique (FRANCE, EUROPE, AUTRE)"
* ^version = "1.0.0"
* ^status = #active
* ^experimental = false
* ^meta.profile = "http://hl7.org/fhir/StructureDefinition/shareablevalueset"
* include codes from system TiersAddressLocalizationCS
