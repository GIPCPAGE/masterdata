// =============================================
// CodeSystem: Localisation Adresse
// =============================================

CodeSystem: TiersAddressLocalizationCS
Id: tiers-address-localization-cs
Title: "Localisation Adresse"
Description: "Codes de localisation géographique pour les adresses selon la nomenclature. Permet de qualifier la zone géographique : France métropolitaine/DOM-TOM, Europe, ou Autre monde."
* ^url = "https://www.cpage.fr/ig/masterdata/common/CodeSystem/tiers-address-localization-cs"
* ^version = "1.0.0"
* ^status = #active
* ^experimental = false
* ^caseSensitive = true
* ^content = #complete
* ^count = 3

* #FRANCE "France" "France métropolitaine et départements/territoires d'outre-mer"
* #EUROPE "Europe" "Union Européenne (hors France) et pays européens hors UE"
* #AUTRE "Autre" "Reste du monde (hors France et Europe)"
