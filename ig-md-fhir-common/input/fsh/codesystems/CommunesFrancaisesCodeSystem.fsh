// =============================================
// CodeSystem: Communes françaises (COG INSEE)
// =============================================
// Source officielle : INSEE — Code Officiel Géographique (COG)
// https://www.insee.fr/fr/information/6800675
//
// Ce CodeSystem est maintenu par CPage. Il expose un fragment représentatif
// illustrant les trois patrons du COG :
//   Patron A — Commune historique inactive (fusionnée)
//   Patron B — Commune nouvelle active
//   Patron B' — Commune déléguée (sous-concept d'une commune nouvelle)
//
// Propriétés disponibles :
//   inactive         — statut inactif (FHIR standard)
//   dateCreation     — date de création ou d'entrée en vigueur du code
//   dateSuppression  — date de fusion ou suppression (concepts inactifs)
//   successeur       — code INSEE de la commune absorbante (fusion)
//   predecesseur     — code(s) INSEE absorbé(s) lors d'une fusion (répétable)
//   codePostal       — code(s) postal(aux) rattaché(s) à la commune (répétable)
//   typeTerritoire   — commune | commune-nouvelle | commune-deleguee
//   codeDepartement  — code département INSEE (2 ou 3 chars)
//   codeRegion       — code région INSEE (réforme 2016)
//   communeNouvelle  — sur les communes déléguées : code de la commune nouvelle parente

CodeSystem: CommunesFrancaisesCodeSystem
Id: communes-fr-cs
Title: "Communes françaises (COG INSEE)"
Description: """
Code Officiel Géographique (COG) des communes françaises, maintenu par l'INSEE
et mis à jour chaque 1er janvier.

**Source officielle** : https://www.insee.fr/fr/information/6800675  
**Mise à jour** : Annuelle (1er janvier)

### Structure du code

Le code est un identifiant de **5 caractères** :
- Positions 1-2 : code département (01–95, 2A, 2B pour la Corse ; 971–976 pour DROM)
- Positions 3-5 : numéro de commune dans le département

Exemples : `75056` (Paris), `13055` (Marseille), `69123` (Lyon)

### Gestion de l'historique

Les communes évoluent par **fusion** (commune nouvelle), **création** ou **suppression**.
Les propriétés `dateCreation`, `dateSuppression`, `successeur` et `predecesseur` permettent
de tracer les changements administratifs.

### Communes nouvelles et déléguées

Depuis 2016, des communes fusionnent pour former des **communes nouvelles**.
Les anciennes communes ne disparaissent pas : elles deviennent des **communes déléguées**,
conservent leur code INSEE d'origine, et sont imbriquées sous la commune nouvelle
(hiérarchie `part-of`).

La propriété `communeNouvelle`, posée sur une commune déléguée, permet de remonter
vers la commune nouvelle parente via un `$lookup`.
"""

* ^url = "https://www.cpage.fr/ig/masterdata/common/CodeSystem/communes-fr-cs"
* ^version = "2026.1.0"
* ^status = #active
* ^experimental = false
* ^date = "2026-01-01"
* ^caseSensitive = false
* ^hierarchyMeaning = #part-of
* ^content = #fragment
* ^publisher = "CPage"
* ^contact.telecom.system = #url
* ^contact.telecom.value = "https://www.cpage.fr"
* ^copyright = "Source : INSEE — Code Officiel Géographique (COG). Données publiques sous Licence Ouverte 2.0."
* ^purpose = "Identifier et valider les communes françaises dans les adresses. Gérer l'historique des fusions et des créations administratives."

// =============================================
// Déclaration des propriétés
// =============================================

* ^property[+].code = #inactive
* ^property[=].uri = "http://hl7.org/fhir/concept-properties#inactive"
* ^property[=].description = "Indique si la commune est inactive (fusionnée, supprimée ou transformée en commune déléguée). true = code ne doit plus être utilisé comme adresse courante."
* ^property[=].type = #boolean

* ^property[+].code = #dateCreation
* ^property[=].description = "Date d'entrée en vigueur du code INSEE. Pour les communes antérieures au COG numérique : conventionnellement 1943-01-01."
* ^property[=].type = #dateTime

* ^property[+].code = #dateSuppression
* ^property[=].description = "Date à laquelle la commune a été fusionnée ou supprimée. Le concept est alors marqué inactive = true."
* ^property[=].type = #dateTime

* ^property[+].code = #successeur
* ^property[=].description = "Code INSEE de la commune qui a absorbé celle-ci lors d'une fusion (commune nouvelle ou absorption simple)."
* ^property[=].type = #code

* ^property[+].code = #predecesseur
* ^property[=].description = "Code INSEE d'une commune absorbée lors de la création d'une commune nouvelle. Propriété répétable (une commune nouvelle peut regrouper plusieurs communes)."
* ^property[=].type = #code

* ^property[+].code = #codePostal
* ^property[=].description = "Code postal rattaché à la commune. Propriété répétable : une commune peut avoir plusieurs codes postaux (grandes villes, communes étendues)."
* ^property[=].type = #string

* ^property[+].code = #typeTerritoire
* ^property[=].description = "Nature administrative de l'entité : commune (ordinaire), commune-nouvelle (issue d'une fusion depuis 2016), commune-deleguee (conservée dans une commune nouvelle)."
* ^property[=].type = #code

* ^property[+].code = #codeDepartement
* ^property[=].description = "Code département INSEE : 2 caractères (01–95, 2A, 2B) ou 3 caractères pour les DROM (971–976)."
* ^property[=].type = #code

* ^property[+].code = #codeRegion
* ^property[=].description = "Code région INSEE issu de la réforme territoriale de 2016. Ex : 84 = Auvergne-Rhône-Alpes, 11 = Île-de-France."
* ^property[=].type = #code

* ^property[+].code = #communeNouvelle
* ^property[=].description = "Sur une commune déléguée : code INSEE de la commune nouvelle qui l'englobe. Permet la résolution via $lookup sans table de jointure externe."
* ^property[=].type = #code

// =============================================
// Exemples de concepts (fragment représentatif)
// =============================================
//
// PATRON A — Commune historique inactive (fusionnée)
//   69282 : Saint-Jean-d'Ardières
//           Fusionnée dans Belleville-en-Beaujolais (69264) au 01/01/2019
//           inactive = true | dateSuppression = 2019-01-01 | successeur = 69264
//
// PATRON B — Commune nouvelle active
//   69264 : Belleville-en-Beaujolais (créée le 01/01/2019)
//           predecesseur contient les codes de toutes les communes absorbées
//
// PATRON B' — Commune déléguée (sous-concept imbriqué)
//   69019 : Belleville-sur-Saône (déléguée sous 69264)
//           communeNouvelle = 69264 → résolution via $lookup

// -------------------------------------------------------
// Patron A : Commune historique inactive
// -------------------------------------------------------
* #69282 "Saint-Jean-d'Ardières" "Ancienne commune du Rhône, fusionnée dans Belleville-en-Beaujolais (69264) au 01/01/2019."
  * ^property[+].code = #inactive
  * ^property[=].valueBoolean = true
  * ^property[+].code = #typeTerritoire
  * ^property[=].valueCode = #commune
  * ^property[+].code = #codePostal
  * ^property[=].valueString = "69220"
  * ^property[+].code = #codeDepartement
  * ^property[=].valueCode = #69
  * ^property[+].code = #codeRegion
  * ^property[=].valueCode = #84
  * ^property[+].code = #dateCreation
  * ^property[=].valueDateTime = "1943-01-01"
  * ^property[+].code = #dateSuppression
  * ^property[=].valueDateTime = "2019-01-01"
  * ^property[+].code = #successeur
  * ^property[=].valueCode = #69264

// -------------------------------------------------------
// Patron B : Commune nouvelle active avec commune déléguée imbriquée
// -------------------------------------------------------
* #69264 "Belleville-en-Beaujolais" "Commune nouvelle du Rhône créée au 01/01/2019, regroupant Belleville-sur-Saône (69019) et Saint-Jean-d'Ardières (69282)."
  * ^property[+].code = #typeTerritoire
  * ^property[=].valueCode = #commune-nouvelle
  * ^property[+].code = #codePostal
  * ^property[=].valueString = "69220"
  * ^property[+].code = #codePostal
  * ^property[=].valueString = "69430"
  * ^property[+].code = #codeDepartement
  * ^property[=].valueCode = #69
  * ^property[+].code = #codeRegion
  * ^property[=].valueCode = #84
  * ^property[+].code = #dateCreation
  * ^property[=].valueDateTime = "2019-01-01"
  * ^property[+].code = #predecesseur
  * ^property[=].valueCode = #69019
  * ^property[+].code = #predecesseur
  * ^property[=].valueCode = #69282
  // Patron B' : commune déléguée imbriquée sous la commune nouvelle
  * #69019 "Belleville-sur-Saône (déléguée)" "Commune déléguée de Belleville-en-Beaujolais. Ancienne ville-centre, conserve son code INSEE d'origine. La propriété communeNouvelle permet de remonter vers 69264 via $lookup."
    * ^property[+].code = #typeTerritoire
    * ^property[=].valueCode = #commune-deleguee
    * ^property[+].code = #codePostal
    * ^property[=].valueString = "69220"
    * ^property[+].code = #codeDepartement
    * ^property[=].valueCode = #69
    * ^property[+].code = #codeRegion
    * ^property[=].valueCode = #84
    * ^property[+].code = #dateCreation
    * ^property[=].valueDateTime = "2019-01-01"
    * ^property[+].code = #communeNouvelle
    * ^property[=].valueCode = #69264
