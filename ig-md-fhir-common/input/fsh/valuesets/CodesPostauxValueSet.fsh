// =============================================
// ValueSet: Codes Postaux français (La Poste)
// =============================================

ValueSet: CodesPostauxValueSet
Id: codes-postaux-vs
Title: "Codes Postaux français"
Description: "Ensemble des codes postaux français. Permet la validation des codes postaux dans les adresses."

* ^url = "https://www.cpage.fr/ig/masterdata/geo/ValueSet/codes-postaux-vs"
* ^status = #active
* ^experimental = false
* ^publisher = "CPage"
* ^contact.telecom.system = #url
* ^contact.telecom.value = "https://www.cpage.fr"
* ^copyright = "Source: La Poste - Base Officielle des Codes Postaux"
* ^immutable = false
* ^compose.include.system = "https://www.cpage.fr/ig/masterdata/geo/CodeSystem/codes-postaux-cs"
