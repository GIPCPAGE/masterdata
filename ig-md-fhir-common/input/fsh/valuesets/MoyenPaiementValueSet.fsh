// =============================================
// ValueSet: Types de moyen de paiement
// =============================================

ValueSet: MoyenPaiementVS
Id: moyen-paiement-vs
Title: "ValueSet Types de moyen de paiement"
Description: "ValueSet pour les types de moyens de paiement"
* ^url = "https://www.cpage.fr/ig/masterdata/common/ValueSet/moyen-paiement-vs"
* ^version = "1.0.0"
* ^status = #active
* ^experimental = false
* ^meta.profile = "http://hl7.org/fhir/StructureDefinition/shareablevalueset"
* include codes from system MoyenPaiementCS
