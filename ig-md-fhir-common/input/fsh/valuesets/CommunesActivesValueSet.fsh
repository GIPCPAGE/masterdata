// =============================================
// ValueSet: Communes françaises actives (COG INSEE / TRE-R13)
// =============================================
// Filtre les communes actives (non fusionnées, non supprimées) du CodeSystem
// TRE-R13-CommuneOM référencé par le SMT e-santé.
//
// Usage recommandé :
//   - Saisie d'adresse (champ commune) dans un formulaire
//   - Validation du code commune INSEE d'un patient ou d'un établissement
//
// Pour un formulaire de saisie simplifié (sans les communes déléguées),
// combiner ce filtre avec typeTerritoire != commune-deleguee.

ValueSet: CommunesActivesValueSet
Id: fr-communes-actives
Title: "Communes françaises actives (COG INSEE)"
Description: """
Ensemble des communes françaises actuellement actives selon le Code Officiel
Géographique (COG) de l'INSEE, tel qu'exposé par le SMT e-santé.

Ce ValueSet filtre les concepts dont la propriété `inactive` est `false`,
excluant ainsi les anciennes communes historiques devenues inactives lors de
fusions ou suppressions administratives.

Il inclut les communes nouvelles et les communes déléguées actives.
Pour n'inclure que les communes et communes nouvelles (interface de saisie),
filtrer également sur `typeTerritoire` ≠ `commune-deleguee`.

**CodeSystem source** : https://smt.esante.gouv.fr/fhir/CodeSystem/TRE-R13-CommuneOM
"""

* ^url = "https://smt.esante.gouv.fr/fhir/ValueSet/fr-communes-actives"
* ^status = #active
* ^experimental = false
* ^date = "2025-01-01"
* ^publisher = "INSEE"
* ^contact.name = "INSEE"
* ^contact.telecom.system = #url
* ^contact.telecom.value = "https://www.insee.fr"
* ^copyright = "INSEE — données publiques"
* ^immutable = false

* ^compose.include[+].system = "https://smt.esante.gouv.fr/fhir/CodeSystem/TRE-R13-CommuneOM"
* ^compose.include[=].filter[+].property = #inactive
* ^compose.include[=].filter[=].op = #=
* ^compose.include[=].filter[=].value = "false"
