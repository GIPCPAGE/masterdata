// =============================================
// CodeSystem: Catégories d'établissement (FINESS, TRE_R66 de l'ANS)
// =============================================
// Terminologie de référence externe dont l'IG n'énumère qu'un FRAGMENT représentatif :
// les catégories (codes à 3 chiffres, ouvertes et fermées) sont livrées avec Master Data
// et servies, en totalité, par l'API Master Data. Ressource en lecture seule.
//
// Source officielle : terminologie TRE_R66-CategorieEtablissement de l'Agence du Numérique
// en Santé (ANS), catégories d'établissement du fichier national FINESS.
//   https://mos.esante.gouv.fr/NOS/TRE_R66-CategorieEtablissement/FHIR/TRE-R66-CategorieEtablissement
//
// Le code est identique à celui de la TRE_R66 : aucun ConceptMap vers l'ANS.
// Même structure que communes-fr-cs (content = #fragment), voir CommunesFrancaisesCodeSystem.
// Décision PB-Q03 du Knowledge Graph (graph/resources/categorie_etablissement_decisions.ttl).
//
// Quatre exemples réels, un par patron :
//   Patron A — catégorie ouverte, avec agrégats et autorités            (101)
//   Patron B — catégorie fermée, couverte par le fichier FINESS 2021     (159)
//   Patron C — catégorie ouverte récente, sans agrégat connu             (606)
//   Patron D — catégorie fermée ancienne, hors du fichier FINESS 2021    (136)

CodeSystem: CategorieEtablissementCodeSystem
Id: categorie-etablissement-cs
Title: "Catégories d'établissement (FINESS, TRE_R66 de l'ANS)"
Description: """
Catégories d'établissement de santé, médico-sociaux et sociaux du fichier national FINESS,
telles que publiées par l'ANS dans la terminologie TRE_R66-CategorieEtablissement.

**Source officielle** : terminologie TRE_R66-CategorieEtablissement de l'ANS
(`https://mos.esante.gouv.fr/NOS/TRE_R66-CategorieEtablissement/FHIR/TRE-R66-CategorieEtablissement`)
**Format du code** : 3 chiffres (exemples : 101 centre hospitalier régional, 500 EHPAD)
**Display** : libellé long de la catégorie
**Catégories fermées** : une catégorie dépréciée par l'ANS reste dans la nomenclature, avec une date de fin de validité

**Propriétés** : libellé court, agrégats de niveaux 1 à 3 (hiérarchie déduite des codes : `niv2` est `niv3` tronqué
à 2 chiffres suivi de `00`, `niv1` est le premier chiffre de `niv3` suivi de `000`), autorités compétentes
(ARS, DRJSCS, DRIHL), possibilité d'antenne, dates de début et de fin de validité.

**Note** : ce CodeSystem n'énumère qu'un **fragment représentatif** (quatre catégories, une par patron).
La nomenclature complète est servie par l'API Master Data, qui la reçoit par livraison. Elle n'est pas modifiable par
les consommateurs.
"""

* ^status = #active
* ^meta.profile = Canonical(CategorieEtablissementCodeSystemProfile)
* ^experimental = false
* ^date = "2026-11-05"
* ^caseSensitive = true
* ^content = #fragment
* ^copyright = "Source : FINESS (DREES) et terminologie TRE_R66-CategorieEtablissement de l'Agence du Numérique en Santé (ANS)."
* ^purpose = "Qualifier la catégorie d'une entité juridique ou d'un établissement géographique par la nomenclature nationale des catégories d'établissement, avec l'historique des catégories fermées."

// =============================================
// Propriétés des concepts (servies par l'API Master Data)
// =============================================

* ^property[0].code = #libelle_court
* ^property[=].description = "Libellé abrégé de la catégorie (20 caractères au plus), pour les affichages étroits. Non unique : ne sert pas de clé."
* ^property[=].type = #string

* ^property[+].code = #niv1
* ^property[=].description = "Code de l'agrégat de niveau 1 (grand domaine d'activité), 4 chiffres se terminant par 000. Absent pour une catégorie sans agrégat connu."
* ^property[=].type = #string

* ^property[+].code = #niv2
* ^property[=].description = "Code de l'agrégat de niveau 2 (regroupement intermédiaire), 4 chiffres se terminant par 00. Absent pour une catégorie sans agrégat connu."
* ^property[=].type = #string

* ^property[+].code = #niv3
* ^property[=].description = "Code de l'agrégat de niveau 3 (regroupement le plus fin), 4 chiffres. Absent pour une catégorie sans agrégat connu."
* ^property[=].type = #string

* ^property[+].code = #ars
* ^property[=].description = "La catégorie relève de la compétence d'une Agence Régionale de Santé. Absent si l'information n'est pas connue."
* ^property[=].type = #boolean

* ^property[+].code = #drjscs
* ^property[=].description = "La catégorie relève de la compétence de la Direction Régionale de la Jeunesse, des Sports et de la Cohésion Sociale. Absent si l'information n'est pas connue."
* ^property[=].type = #boolean

* ^property[+].code = #drihl
* ^property[=].description = "La catégorie relève de la compétence de la Direction Régionale et Interdépartementale de l'Hébergement et du Logement (Île-de-France). Absent si l'information n'est pas connue."
* ^property[=].type = #boolean

* ^property[+].code = #antenne_possible
* ^property[=].description = "Un établissement de la catégorie peut avoir des antennes (emplacements sans autonomie de gestion ni budget). Absent si l'information n'est pas connue."
* ^property[=].type = #boolean

* ^property[+].code = #date_debut_validite
* ^property[=].description = "Date de début de validité de la catégorie (YYYY-MM-DD), reprise de la TRE_R66. L'ANS utilise 1901-01-01 et 1979-01-01 quand le début est inconnu."
* ^property[=].type = #dateTime

* ^property[+].code = #date_fin_validite
* ^property[=].description = "Date de fin de validité d'une catégorie fermée (YYYY-MM-DD), égale à sa date de dépréciation dans la TRE_R66. Absente pour une catégorie ouverte."
* ^property[=].type = #dateTime

// =============================================
// Fragment représentatif (données de la livraison, extraites le 2026-11-05)
// =============================================

// Patron A — catégorie ouverte, avec agrégats et autorités
* #101 "Centre Hospitalier Régional (C.H.R.)"
* #101 ^property[0].code = #libelle_court
* #101 ^property[=].valueString = "C.H.R."
* #101 ^property[+].code = #niv1
* #101 ^property[=].valueString = "1000"
* #101 ^property[+].code = #niv2
* #101 ^property[=].valueString = "1100"
* #101 ^property[+].code = #niv3
* #101 ^property[=].valueString = "1101"
* #101 ^property[+].code = #ars
* #101 ^property[=].valueBoolean = true
* #101 ^property[+].code = #drjscs
* #101 ^property[=].valueBoolean = false
* #101 ^property[+].code = #drihl
* #101 ^property[=].valueBoolean = false
* #101 ^property[+].code = #antenne_possible
* #101 ^property[=].valueBoolean = false
* #101 ^property[+].code = #date_debut_validite
* #101 ^property[=].valueDateTime = "1979-01-01"

// Patron B — catégorie fermée, couverte par le fichier FINESS 2021 (agrégats et autorités connus)
* #159 "Centre Parental"
* #159 ^property[0].code = #libelle_court
* #159 ^property[=].valueString = "Centre parental"
* #159 ^property[+].code = #niv1
* #159 ^property[=].valueString = "4000"
* #159 ^property[+].code = #niv2
* #159 ^property[=].valueString = "4500"
* #159 ^property[+].code = #niv3
* #159 ^property[=].valueString = "4501"
* #159 ^property[+].code = #ars
* #159 ^property[=].valueBoolean = false
* #159 ^property[+].code = #drjscs
* #159 ^property[=].valueBoolean = true
* #159 ^property[+].code = #drihl
* #159 ^property[=].valueBoolean = false
* #159 ^property[+].code = #antenne_possible
* #159 ^property[=].valueBoolean = false
* #159 ^property[+].code = #date_debut_validite
* #159 ^property[=].valueDateTime = "2020-06-26"
* #159 ^property[+].code = #date_fin_validite
* #159 ^property[=].valueDateTime = "2026-05-05"

// Patron C — catégorie ouverte récente : aucune source ne donne ses agrégats ni ses autorités
* #606 "Dispositif d'appui à la coordination (DAC)"
* #606 ^property[0].code = #libelle_court
* #606 ^property[=].valueString = "D.A.C"
* #606 ^property[+].code = #date_debut_validite
* #606 ^property[=].valueDateTime = "2022-01-28"

// Patron D — catégorie fermée ancienne, hors du fichier FINESS 2021 : pas d'agrégat, autorités à faux
* #136 "Banque de Sperme"
* #136 ^property[0].code = #libelle_court
* #136 ^property[=].valueString = "Banque de Sperme"
* #136 ^property[+].code = #ars
* #136 ^property[=].valueBoolean = false
* #136 ^property[+].code = #drjscs
* #136 ^property[=].valueBoolean = false
* #136 ^property[+].code = #drihl
* #136 ^property[=].valueBoolean = false
* #136 ^property[+].code = #antenne_possible
* #136 ^property[=].valueBoolean = false
* #136 ^property[+].code = #date_debut_validite
* #136 ^property[=].valueDateTime = "1979-01-01"
* #136 ^property[+].code = #date_fin_validite
* #136 ^property[=].valueDateTime = "1999-09-15"
