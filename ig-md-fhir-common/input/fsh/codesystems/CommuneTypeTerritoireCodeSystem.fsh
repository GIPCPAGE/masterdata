// =============================================
// CodeSystem: Type de territoire communal
// =============================================
// Décrit la nature administrative d'une commune selon la réforme
// des communes nouvelles introduite par la loi NOTRe (2015/2016).
//
// Trois catégories :
//   commune          — commune classique (régime ordinaire)
//   commune-nouvelle — issue d'une fusion de communes depuis 2016
//   commune-deleguee — ancienne commune conservée au sein d'une commune nouvelle

CodeSystem: CommuneTypeTerritoireCS
Id: commune-type-territoire-cs
Title: "Type de territoire communal"
Description: "Nature administrative d'une commune française selon la réforme des communes nouvelles (loi NOTRe 2015). Utilisé pour qualifier les instances Location CommuneFrancaise."
* ^url = "https://www.cpage.fr/ig/masterdata/common/CodeSystem/commune-type-territoire-cs"
* ^version = "1.0.0"
* ^status = #active
* ^experimental = false
* ^caseSensitive = true
* ^content = #complete
* ^count = 3
* ^publisher = "CPage"
* ^contact.telecom.system = #url
* ^contact.telecom.value = "https://www.cpage.fr"
* ^copyright = "Source : loi NOTRe 2015, décrets de création de communes nouvelles. Données publiques."

* #commune "Commune ordinaire"
    "Commune française classique n'ayant pas fusionné, ou issue d'une fusion antérieure à 2016."

* #commune-nouvelle "Commune nouvelle"
    "Entité résultant de la fusion d'au moins deux communes, créée par la loi NOTRe depuis le 1er janvier 2016. Elle porte un nouveau code INSEE et peut regrouper des communes déléguées."

* #commune-deleguee "Commune déléguée"
    "Ancienne commune conservée au sein d'une commune nouvelle, avec sa propre mairie annexe. Elle conserve son code INSEE d'origine et est rattachée à la commune nouvelle parente via Location.partOf."
