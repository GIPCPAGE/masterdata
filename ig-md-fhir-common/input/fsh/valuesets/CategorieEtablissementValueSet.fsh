// =============================================
// ValueSet: Catégories d'établissement (FINESS, TRE_R66 de l'ANS)
// =============================================
// Toutes les catégories du CodeSystem categorie-etablissement-cs, ouvertes et fermées.
// Usage : lier l'attribut « catégorie » d'une entité juridique ou d'un établissement géographique.
// Décision PB-Q03 du Knowledge Graph (graph/resources/categorie_etablissement_decisions.ttl).

ValueSet: CategorieEtablissementValueSet
Id: categorie-etablissement-vs
Title: "Catégories d'établissement (FINESS, TRE_R66 de l'ANS)"
Description: """
Ensemble des catégories d'établissement de la nomenclature nationale FINESS (terminologie TRE_R66 de l'ANS),
catégories ouvertes et catégories fermées. Une catégorie fermée porte une date de fin de validité
(propriété `date_fin_validite`).

**CodeSystem source** : `CategorieEtablissementCodeSystem` (`categorie-etablissement-cs`), dont l'IG n'énumère qu'un
fragment représentatif : l'ensemble des concepts est servi par l'API Master Data.
"""

* ^status = #active
* ^experimental = false
* ^immutable = false
// Pas de meta.profile shareablevalueset : ce profil exige version, publisher et contact,
// que ce ValueSet ne pose pas (non hérités de sushi-config.yaml, voir fhir-ig-piege-07).
// Le CodeSystem est un fragment (comme communes-fr-cs) : le publisher ne valide pas les concepts sans
// serveur de terminologie, ce qu'il signale en information.

* include codes from system CategorieEtablissementCodeSystem
