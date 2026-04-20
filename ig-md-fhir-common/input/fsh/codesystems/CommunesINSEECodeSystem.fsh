// =============================================
// CodeSystem: Communes françaises (INSEE)
// =============================================
// Référence vers la source officielle externe
// Source: INSEE - Code Officiel Géographique (COG)
// URL officielle: https://www.insee.fr/fr/information/6800675

CodeSystem: CommunesINSEECodeSystem
Id: communes-insee-cs
Title: "Communes françaises (Code Officiel Géographique INSEE)"
Description: """
Ce CodeSystem fait référence aux communes françaises officielles selon le Code Officiel Géographique de l'INSEE.

**Source officielle** : INSEE - Code Officiel Géographique (COG)  
**URL** : https://www.insee.fr/fr/information/6800675  
**Mise à jour** : Annuelle (généralement au 1er janvier)  
**Format** : 5 caractères (2 chiffres département + 3 chiffres commune)

**Structure du code** :
- Position 1-2 : Code département (01 à 95, 2A, 2B pour la Corse)
- Position 3-5 : Code commune dans le département
- Exemples : 75056 (Paris), 13055 (Marseille), 69123 (Lyon)

**Évolution** : Les communes évoluent dans le temps par fusion, création, suppression. L'historique complet est disponible dans le COG avec les dates de modification.

**Note** : Ce système de codes fait référence à une terminologie externe maintenue par l'INSEE. Les codes ne sont pas énumérés dans cet IG mais doivent être validés contre le COG officiel (~35 000 communes actives).
"""

* ^url = "https://www.cpage.fr/ig/masterdata/common/CodeSystem/communes-insee-cs"
* ^version = "2026.1.0"
* ^status = #active
* ^experimental = false
* ^date = "2026-03-17"
* ^caseSensitive = true
* ^content = #not-present
* ^publisher = "CPage"
* ^contact.telecom.system = #url
* ^contact.telecom.value = "https://www.cpage.fr"
* ^copyright = "Source: INSEE - Code Officiel Géographique (COG) 2026. Données publiques sous Licence Ouverte 2.0"
* ^purpose = "Identifier de manière unique les communes françaises dans les adresses et localisations. Permet la validation des codes commune INSEE, la normalisation des adresses et le suivi des modifications administratives (fusions, créations, suppressions)."

// =============================================
// Propriétés pour gestion historique et temporalité
// =============================================

* ^property[0].code = #status
* ^property[=].uri = "http://hl7.org/fhir/concept-properties#status"
* ^property[=].description = "Statut de la commune : active (existe actuellement), inactive (fusionnée ou transformée), deprecated (supprimée définitivement)"
* ^property[=].type = #code

* ^property[+].code = #effectiveDate
* ^property[=].uri = "http://hl7.org/fhir/concept-properties#effectiveDate"
* ^property[=].description = "Date d'entrée en vigueur de la commune (création ou modification). Format YYYY-MM-DD, généralement au 1er janvier"
* ^property[=].type = #dateTime

* ^property[+].code = #deprecationDate
* ^property[=].uri = "http://hl7.org/fhir/concept-properties#deprecationDate"
* ^property[=].description = "Date de suppression, fusion ou transformation de la commune. Format YYYY-MM-DD"
* ^property[=].type = #dateTime

* ^property[+].code = #replacedBy
* ^property[=].description = "Code INSEE de la commune de remplacement (en cas de fusion). Permet de suivre la continuité administrative"
* ^property[=].type = #code

* ^property[+].code = #parent
* ^property[=].uri = "http://hl7.org/fhir/concept-properties#parent"
* ^property[=].description = "Code département (2 ou 3 caractères : 01 à 95, 2A, 2B, 971 à 976)"
* ^property[=].type = #code

* ^property[+].code = #region
* ^property[=].description = "Code région INSEE (nouvelle région depuis 2016). Codes : 01 à 18 pour métropole, 01 à 06 pour DROM"
* ^property[=].type = #code

// =============================================
// MODÉLISATION DE L'HISTORIQUE DES COMMUNES
// =============================================
//
// Les communes françaises évoluent chaque année (fusions, créations, suppressions).
// L'INSEE maintient l'historique complet dans le COG.
//
// 1. COMMUNE ACTIVE (cas standard)
//    - status = #active
//    - effectiveDate = date de création
//    - parent = code département
//    - region = code région
//
//    Exemple: Paris (créée avant le COG, conventionnellement 1943-01-01)
//    {
//      "code": "75056",
//      "display": "Paris",
//      "property": [
//        {"code": "status", "valueCode": "active"},
//        {"code": "effectiveDate", "valueDateTime": "1943-01-01"},
//        {"code": "parent", "valueCode": "75"},
//        {"code": "region", "valueCode": "11"}
//      ]
//    }
//
// 2. COMMUNE CRÉÉE RÉCEMMENT
//    - status = #active
//    - effectiveDate = date de création effective
//
//    Exemple: Mouen (créée par fusion le 1er janvier 2024)
//    {
//      "code": "14472",
//      "display": "Mouen",
//      "property": [
//        {"code": "status", "valueCode": "active"},
//        {"code": "effectiveDate", "valueDateTime": "2024-01-01"},
//        {"code": "parent", "valueCode": "14"},
//        {"code": "region", "valueCode": "28"}
//      ]
//    }
//
// 3. COMMUNE FUSIONNÉE (devient inactive)
//    - status = #inactive
//    - effectiveDate = date de création originale
//    - deprecationDate = date de fusion
//    - replacedBy = code de la nouvelle commune
//
//    Exemple: Villepreux (fusionnée le 1er janvier 2019)
//    {
//      "code": "78674",
//      "display": "Villepreux (ancienne commune)",
//      "property": [
//        {"code": "status", "valueCode": "inactive"},
//        {"code": "effectiveDate", "valueDateTime": "1790-01-01"},
//        {"code": "deprecationDate", "valueDateTime": "2019-01-01"},
//        {"code": "replacedBy", "valueCode": "78640"},
//        {"code": "parent", "valueCode": "78"}
//      ]
//    }
//
// 4. COMMUNE NOUVELLE (issue de fusions)
//    - status = #active
//    - effectiveDate = date de création
//    - La nouvelle commune peut avoir un code existant ou nouveau
//
//    Exemple: Évry-Courcouronnes (fusion 2019)
//    {
//      "code": "91228",
//      "display": "Évry-Courcouronnes",
//      "property": [
//        {"code": "status", "valueCode": "active"},
//        {"code": "effectiveDate", "valueDateTime": "2019-01-01"},
//        {"code": "parent", "valueCode": "91"},
//        {"code": "region", "valueCode": "11"}
//      ]
//    }
//    Note: Les anciennes communes (91225-Courcouronnes, 91228-Évry) 
//    auront status=inactive et deprecationDate=2019-01-01
//
// =============================================
// VALIDATION TEMPORELLE
// =============================================
//
// Pour valider qu'une commune existe à une date donnée :
//
// RÈGLES :
// 1. date >= effectiveDate (la commune existait déjà)
// 2. ET (date < deprecationDate OU deprecationDate absent)
// 3. Si status = inactive, vérifier la date de fusion
//
// EXEMPLE DE VALIDATION :
//
// Question : Le code 78674 (Villepreux) est-il valide le 15/06/2018 ?
// Réponse : OUI
//   - effectiveDate (1790-01-01) <= 2018-06-15 ✓
//   - deprecationDate (2019-01-01) > 2018-06-15 ✓
//
// Question : Le code 78674 est-il valide le 15/06/2020 ?
// Réponse : NON
//   - deprecationDate (2019-01-01) <= 2020-06-15 ✗
//   - status = inactive
//   - Utiliser replacedBy (78640) à la place
//
// =============================================
// REQUÊTES FHIR POUR L'HISTORIQUE
// =============================================
//
// 1. Valider un code commune à une date :
//
// GET [base]/CodeSystem/$validate-code?
//     system=https://www.cpage.fr/ig/masterdata/geo/CodeSystem/communes-insee-cs
//     &code=75056
//     &date=2024-06-15
//
// 2. Rechercher une commune avec ses propriétés temporelles :
//
// GET [base]/CodeSystem/$lookup?
//     system=https://www.cpage.fr/ig/masterdata/geo/CodeSystem/communes-insee-cs
//     &code=75056
//     &property=effectiveDate
//     &property=deprecationDate
//     &property=status
//     &property=parent
//     &property=region
//
// Réponse :
// {
//   "parameter": [
//     {"name": "code", "valueCode": "75056"},
//     {"name": "display", "valueString": "Paris"},
//     {"name": "property", "part": [
//       {"name": "code", "valueCode": "status"},
//       {"name": "value", "valueCode": "active"}
//     ]},
//     {"name": "property", "part": [
//       {"name": "code", "valueCode": "effectiveDate"},
//       {"name": "value", "valueDateTime": "1943-01-01"}
//     ]}
//   ]
// }
//
// 3. Trouver les communes actives à une date :
//
// GET [base]/CodeSystem?
//     url=https://www.cpage.fr/ig/masterdata/geo/CodeSystem/communes-insee-cs
//     &_filter=status eq active
//
// 4. Suivre l'historique d'une fusion :
//
// GET [base]/CodeSystem/$lookup?code=78674&property=replacedBy
// → Retourne : replacedBy = 78640
//
// GET [base]/CodeSystem/$lookup?code=78640
// → Retourne : La nouvelle commune
//
// =============================================
// CODES RÉGION INSEE (depuis 2016)
// =============================================
//
// Métropole (13 régions) :
//   11 - Île-de-France
//   24 - Centre-Val de Loire
//   27 - Bourgogne-Franche-Comté
//   28 - Normandie
//   32 - Hauts-de-France
//   44 - Grand Est
//   52 - Pays de la Loire
//   53 - Bretagne
//   75 - Nouvelle-Aquitaine
//   76 - Occitanie
//   84 - Auvergne-Rhône-Alpes
//   93 - Provence-Alpes-Côte d'Azur
//   94 - Corse
//
// DROM (5 régions) :
//   01 - Guadeloupe
//   02 - Martinique
//   03 - Guyane
//   04 - La Réunion
//   06 - Mayotte
//
// =============================================
// EXEMPLES DE CODES (à titre indicatif)
// =============================================
//
// Grandes métropoles :
//   75056 - Paris
//   13055 - Marseille
//   69123 - Lyon
//   31555 - Toulouse
//   06088 - Nice
//   44109 - Nantes
//   67482 - Strasbourg
//   33063 - Bordeaux
//   59350 - Lille
//   35238 - Rennes
//
// Exemples de fusions récentes :
//   91228 - Évry-Courcouronnes (issue fusion 2019)
//   95127 - Cergy (créée 1971)
//   14472 - Mouen (créée 2024)
//
// Pour la liste complète (~35 000 communes) :
// https://www.insee.fr/fr/information/6800675
//
// =============================================
