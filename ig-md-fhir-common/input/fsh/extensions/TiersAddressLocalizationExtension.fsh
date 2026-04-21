// =============================================
// Extension: Localisation Adresse
// =============================================

Extension: TiersAddressLocalization
Id: tiers-address-localization
Title: "Localisation Adresse"
Description: "Extension pour la localisation géographique de l'adresse selon la nomenclature. Correspond au champ KERD 'Localisation' de l'adresse. Permet de qualifier si l'adresse se situe en France (métropole + DOM-TOM), en Europe (UE et pays européens hors UE), ou dans le reste du monde."
Context: Address
* ^url = "https://www.cpage.fr/ig/masterdata/common/StructureDefinition/tiers-address-localization"
* ^version = "1.0.0"
* ^status = #active
* ^context[0].type = #element
* ^context[0].expression = "Address"

* value[x] only code
* valueCode 1..1 MS
* valueCode from TiersAddressLocalizationVS (required)
* valueCode ^short = "Localisation : FRANCE, EUROPE, ou AUTRE"
* valueCode ^definition = "Code indiquant la zone géographique de l'adresse : France (métropole + outre-mer), Europe (UE et hors UE), ou Autre (reste du monde)"
