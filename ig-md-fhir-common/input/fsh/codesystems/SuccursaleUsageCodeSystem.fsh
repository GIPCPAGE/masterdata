// =============================================
// CodeSystem: Types d'usage de succursale
// =============================================

CodeSystem: SuccursaleUsageCS
Id: succursale-usage-cs
Title: "Types d'usage de succursale"
Description: "Types d'usage pour les succursales/filiales d'un tiers"
* ^url = "http://cpage.org/fhir/CodeSystem/succursale-usage-cs"
* ^version = "1.0.0"
* ^status = #active
* ^experimental = false
* ^caseSensitive = true
* ^content = #complete
* ^count = 3

* #POINT_LIVRAISON "Point de livraison" "Succursale utilisée comme point de livraison"
* #FACTURATION "Point de facturation" "Succursale utilisée pour la facturation"
* #SIEGE_SOCIAL "Siège social" "Succursale correspondant au siège social"
