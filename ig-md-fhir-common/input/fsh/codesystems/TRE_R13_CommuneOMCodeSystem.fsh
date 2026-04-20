// =============================================
// CodeSystem: Communes françaises (COG INSEE / TRE-R13)
// =============================================
// Modélisation de la terminologie officielle référencée par le SMT e-santé (ANS).
// Source officielle : https://smt.esante.gouv.fr/fhir/CodeSystem/TRE-R13-CommuneOM
// Référence INSEE    : Code Officiel Géographique (COG)
//
// Ce fichier définit la structure du CodeSystem (propriétés, hiérarchie)
// et fournit des exemples représentatifs de chaque patron de codage :
//
//   Patron A — Commune historique inactive (fusionnée)
//   Patron B — Commune nouvelle active avec communes déléguées imbriquées
//
// Le contenu exhaustif (~35 000 communes) est maintenu par l'INSEE/ANS.
// content = #fragment signifie que seuls les exemples sont publiés dans cet IG.

CodeSystem: TRE_R13_CommuneOM
Id: fr-commune-cog
Title: "Communes françaises (COG INSEE)"
Description: """
Code Officiel Géographique des communes françaises, incluant l'historique des fusions
et les communes déléguées.

**Source officielle** : INSEE via le Serveur Multi-Terminologies (SMT) de l'ANS.
**URL SMT** : https://smt.esante.gouv.fr/fhir/CodeSystem/TRE-R13-CommuneOM
**Mise à jour** : Annuelle (1er janvier).

### Hiérarchie (`hierarchyMeaning = part-of`)
Les communes déléguées sont imbriquées sous leur commune nouvelle parente.
Un `$lookup` sur la propriété `communeNouvelle` permet de remonter vers la commune
nouvelle active à partir d'un code de commune déléguée (code INSEE d'origine).

### Types de territoire (`typeTerritoire`)
| Valeur | Description |
|---|---|
| `commune` | Commune ordinaire (active ou historique) |
| `commune-nouvelle` | Commune issue d'une fusion depuis 2016 |
| `commune-deleguee` | Entité conservée dans une commune nouvelle |

### Usage sur `Address`
Utiliser l'extension `fr-core-address-insee-code` sur l'élément `_city` pour coder
le code commune INSEE, y compris le code de la commune déléguée (code d'origine conservé).
"""

* ^url = "https://smt.esante.gouv.fr/fhir/CodeSystem/TRE-R13-CommuneOM"
* ^version = "20250101"
* ^status = #active
* ^experimental = false
* ^date = "2025-01-01"
* ^publisher = "INSEE"
* ^contact.name = "INSEE"
* ^contact.telecom.system = #url
* ^contact.telecom.value = "https://www.insee.fr"
* ^copyright = "INSEE — données publiques"
* ^caseSensitive = false
* ^hierarchyMeaning = #part-of
* ^content = #fragment

// =============================================
// Déclaration des propriétés
// =============================================

* ^property[+].code = #typeTerritoire
* ^property[=].description = "Nature de l'entité administrative : commune | commune-nouvelle | commune-deleguee"
* ^property[=].type = #code

* ^property[+].code = #codePostal
* ^property[=].description = "Code postal rattaché à la commune (répétable si la commune couvre plusieurs codes postaux)"
* ^property[=].type = #string

* ^property[+].code = #codeDepartement
* ^property[=].description = "Code département INSEE (2 caractères : 01–95, 2A, 2B ; 3 caractères pour DROM : 971–976)"
* ^property[=].type = #code

* ^property[+].code = #codeRegion
* ^property[=].description = "Code région INSEE issu de la réforme territoriale de 2016 (ex : 84 pour Auvergne-Rhône-Alpes)"
* ^property[=].type = #code

* ^property[+].code = #dateCreation
* ^property[=].description = "Date d'entrée en vigueur du code. Antérieures au COG : conventionnellement 1943-01-01"
* ^property[=].type = #dateTime

* ^property[+].code = #dateSuppression
* ^property[=].description = "Date de suppression ou de fusion de la commune. Le concept est alors marqué inactif."
* ^property[=].type = #dateTime

* ^property[+].code = #successeur
* ^property[=].description = "Code COG de la commune qui a absorbé celle-ci lors d'une fusion"
* ^property[=].type = #code

* ^property[+].code = #predecesseur
* ^property[=].description = "Code COG d'une commune absorbée lors de la création d'une commune nouvelle (répétable)"
* ^property[=].type = #code

* ^property[+].code = #communeNouvelle
* ^property[=].description = "Code COG de la commune nouvelle parente. Positionné sur les communes déléguées pour permettre la résolution via $lookup."
* ^property[=].type = #code

* ^property[+].code = #inactive
* ^property[=].uri = "http://hl7.org/fhir/concept-properties#inactive"
* ^property[=].description = "Indique si la commune est inactive (fusionnée, supprimée ou transformée). true = inactif."
* ^property[=].type = #boolean

// =============================================
// Exemples de concepts
// =============================================
//
// PATRON A — Commune historique devenue inactive
//   69282 : Saint-Jean-d'Ardières
//           Fusionnée dans 69264 au 01/01/2019
//           inactive = true  |  successeur = 69264
//
// PATRON B — Commune nouvelle active avec communes déléguées imbriquées
//   69264 : Belleville-en-Beaujolais (commune nouvelle, créée le 01/01/2019)
//     ├─ 69282 : Saint-Jean-d'Ardières (déléguée) — réutilise son code d'origine
//     └─ 69019 : Belleville-sur-Saône   (déléguée)
//
// Note sur le code 69282 dupliqué :
//   Il apparaît deux fois dans ce CodeSystem :
//   • au niveau racine          → commune historique INACTIVE
//   • sous-concept de 69264     → commune déléguée ACTIVE
//   Cette structure permet à un système de recevoir l'ancien code 69282 et de retrouver
//   la commune nouvelle 69264 via la propriété communeNouvelle, sans ambiguïté.

// -------------------------------------------------------
// Patron A : Commune historique inactive (niveau racine)
// Code 69282 — Saint-Jean-d'Ardières, fusionnée le 01/01/2019 dans 69264.
//
// ⚠ Contrainte FSH : un code ne peut apparaître qu'une seule fois dans un CodeSystem FSH.
// Dans le COG complet (SMT), 69282 apparaît AUSSI comme sous-concept (commune déléguée)
// de 69264. Ce fragment montre uniquement la représentation racine inactive.
// Pour illustrer le patron "commune déléguée", voir le code 69019 sous 69264 (Patron B).
// -------------------------------------------------------
* #69282 "Saint-Jean-d'Ardières" "Ancienne commune du Rhône (département 69), fusionnée dans la commune nouvelle Belleville-en-Beaujolais (69264) au 01/01/2019. Dans le COG complet, ce code apparaît également comme commune déléguée (sous-concept de 69264)."
  * ^property[0].code = #inactive
  * ^property[0].valueBoolean = true
  * ^property[1].code = #typeTerritoire
  * ^property[1].valueCode = #commune
  * ^property[2].code = #codePostal
  * ^property[2].valueString = "69220"
  * ^property[3].code = #codeDepartement
  * ^property[3].valueCode = #69
  * ^property[4].code = #codeRegion
  * ^property[4].valueCode = #84
  * ^property[5].code = #dateCreation
  * ^property[5].valueDateTime = "1943-01-01"
  * ^property[6].code = #dateSuppression
  * ^property[6].valueDateTime = "2019-01-01"
  * ^property[7].code = #successeur
  * ^property[7].valueCode = #69264

// -------------------------------------------------------
// Patron B : Commune nouvelle active avec commune déléguée imbriquée
// Code 69264 — absorbe 69282 et 69019.
// Sous-concept illustré : 69019 (Belleville-sur-Saône, commune déléguée).
// Note : codePostal et predecesseur sont répétables dans le COG complet.
//        Ce fragment montre un seul exemplaire par propriété répétable.
// -------------------------------------------------------
* #69264 "Belleville-en-Beaujolais" "Commune nouvelle du Rhône, créée au 01/01/2019 par fusion de Belleville-sur-Saône (69019) et Saint-Jean-d'Ardières (69282)."
  * ^property[0].code = #typeTerritoire
  * ^property[0].valueCode = #commune-nouvelle
  * ^property[1].code = #codePostal
  * ^property[1].valueString = "69220"
  * ^property[2].code = #codeDepartement
  * ^property[2].valueCode = #69
  * ^property[3].code = #codeRegion
  * ^property[3].valueCode = #84
  * ^property[4].code = #dateCreation
  * ^property[4].valueDateTime = "2019-01-01"
  * ^property[5].code = #predecesseur
  * ^property[5].valueCode = #69282
  * #69019 "Belleville-sur-Saône (déléguée)" "Commune déléguée de Belleville-en-Beaujolais. Ancienne ville-centre avant la fusion, conserve son code INSEE d'origine (69019). La propriété communeNouvelle permet de remonter vers 69264 via $lookup."
    * ^property[0].code = #typeTerritoire
    * ^property[0].valueCode = #commune-deleguee
    * ^property[1].code = #codePostal
    * ^property[1].valueString = "69220"
    * ^property[2].code = #communeNouvelle
    * ^property[2].valueCode = #69264
    * ^property[3].code = #dateCreation
    * ^property[3].valueDateTime = "2019-01-01"
