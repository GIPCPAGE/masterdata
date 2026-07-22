// =============================================
// ValueSet : Pays (référentiel pivot complet)
// =============================================
// Expose l'ensemble complet du CodeSystem pivot PaysCodeSystem, pour permettre
// le binding depuis d'autres profils FR Core / IG custom (ex : Address.country).

ValueSet: PaysVS
Id: pays-vs
Title: "CPage — Pays (ValueSet)"
Description: "Ensemble complet des pays et territoires du référentiel pivot PaysCodeSystem (ISO 3166-1 / INSEE). Binding réutilisable par tout élément attendant un code pays (ex : Address.country)."
* ^url = "https://www.cpage.fr/ig/masterdata/common/ValueSet/pays-vs"
* ^version = "0.1.0"
* ^status = #active
* ^experimental = false
* include codes from system PaysCodeSystem
