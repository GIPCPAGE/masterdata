// =============================================
// ValueSet: Communes françaises actives
// =============================================
// Filtre les communes actives du CodeSystem communes-fr-cs :
//   inactive = false → communes actuellement en vigueur
//
// Inclut :
//   - communes ordinaires actives (typeTerritoire = commune)
//   - communes nouvelles actives (typeTerritoire = commune-nouvelle)
//   - communes déléguées actives (typeTerritoire = commune-deleguee)
//
// Usage recommandé :
//   - Saisie d'adresse (champ commune) dans un formulaire
//   - Validation du code commune INSEE dans une ressource FHIR

ValueSet: CommunesFrancaisesActivesValueSet
Id: communes-fr-actives-vs
Title: "Communes françaises actives (COG INSEE)"
Description: """
Ensemble des communes françaises actuellement actives selon le Code Officiel
Géographique (COG) de l'INSEE.

Ce ValueSet filtre les concepts dont la propriété `inactive` est `false`,
excluant ainsi les anciennes communes fusionnées ou supprimées.

Il inclut les communes ordinaires, les communes nouvelles et les communes déléguées actives.

**CodeSystem source** : `https://www.cpage.fr/ig/masterdata/common/CodeSystem/communes-fr-cs`
"""

* ^url = "https://www.cpage.fr/ig/masterdata/common/ValueSet/communes-fr-actives-vs"
* ^status = #active
* ^experimental = false
* ^date = "2026-01-01"
* ^publisher = "CPage"
* ^contact.telecom.system = #url
* ^contact.telecom.value = "https://www.cpage.fr"
* ^copyright = "Source : INSEE — Code Officiel Géographique (COG). Données publiques sous Licence Ouverte 2.0."
* ^immutable = false

* ^compose.include[+].system = "https://www.cpage.fr/ig/masterdata/common/CodeSystem/communes-fr-cs"
* ^compose.include[=].filter[+].property = #inactive
* ^compose.include[=].filter[=].op = #=
* ^compose.include[=].filter[=].value = "false"
