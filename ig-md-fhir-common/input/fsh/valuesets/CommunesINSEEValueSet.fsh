// =============================================
// ValueSet: Communes françaises (INSEE)
// =============================================

ValueSet: CommunesINSEEValueSet
Id: communes-insee-vs
Title: "Communes françaises (Code INSEE)"
Description: "Ensemble des communes françaises selon le Code Officiel Géographique de l'INSEE. Inclut toutes les communes de France métropolitaine et DROM-COM."

* ^url = "https://www.cpage.fr/ig/masterdata/common/ValueSet/communes-insee-vs"
* ^status = #active
* ^experimental = false
* ^publisher = "CPage"
* ^contact.telecom.system = #url
* ^contact.telecom.value = "https://www.cpage.fr"
* ^copyright = "Source: INSEE - Code Officiel Géographique"
* ^immutable = false
* ^compose.include.system = "https://www.cpage.fr/ig/masterdata/common/CodeSystem/communes-insee-cs"
