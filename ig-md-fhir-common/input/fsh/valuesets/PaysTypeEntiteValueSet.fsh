// =============================================
// ValueSet : Type d'entité géopolitique
// =============================================

ValueSet: PaysTypeEntiteVS
Id: pays-type-entite-vs
Title: "CPage — Type d'entité géopolitique (ValueSet)"
Description: "Ensemble des types d'entités géopolitiques reconnus par le référentiel INSEE des pays étrangers. Binding required sur PaysProfile.type."
* ^url = "https://www.cpage.fr/ig/masterdata/common/ValueSet/pays-type-entite-vs"
* ^version = "1.0.0"
* ^status = #active
* ^experimental = false
* include codes from system PaysTypeEntiteCS
