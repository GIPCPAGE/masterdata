// =============================================
// CodeSystem: Codes Postaux franÃ§ais (La Poste)
// =============================================
// RÃ©fÃ©rence vers la source officielle externe
// Source: La Poste - Base HEXASIMAL
// URL officielle: https://datanova.laposte.fr/datasets/laposte-hexasmal

CodeSystem: CodesPostauxCodeSystem
Id: codes-postaux-cs
Title: "Codes Postaux franÃ§ais (La Poste)"
Description: """
Ce CodeSystem fait rÃ©fÃ©rence aux codes postaux franÃ§ais officiels de La Poste.

**Source officielle** : La Poste - Base HEXASIMAL  
**URL** : https://datanova.laposte.fr/datasets/laposte-hexasmal  
**Mise Ã  jour** : Mensuelle  
**Format** : 5 chiffres (exemples: 75001, 13055, 69001)

**Utilisation** : Un code postal peut couvrir plusieurs communes (code postal partagÃ©), et une grande commune peut avoir plusieurs codes postaux (arrondissements, secteurs).

**Note** : Ce systÃ¨me de codes fait rÃ©fÃ©rence Ã  une terminologie externe maintenue par La Poste. Les codes ne sont pas Ã©numÃ©rÃ©s dans cet IG mais doivent Ãªtre validÃ©s contre la source officielle.
"""

* ^url = "https://www.cpage.fr/ig/masterdata/geo/CodeSystem/codes-postaux-cs"
* ^version = "2026.1.0"
* ^status = #active
* ^experimental = false
* ^date = "2026-03-17"
* ^caseSensitive = true
* ^content = #not-present
* ^publisher = "CPage"
* ^contact.telecom.system = #url
* ^contact.telecom.value = "https://www.cpage.fr"
* ^copyright = "Source: La Poste - Base Officielle HEXASIMAL. DonnÃ©es publiques sous Licence Ouverte 2.0"
* ^purpose = "Valider et normaliser les codes postaux dans les adresses. Permet la vÃ©rification de cohÃ©rence entre code postal et commune."

// =============================================
// PropriÃ©tÃ©s pour gestion historique et temporalitÃ©
// =============================================

* ^property[0].code = #status
* ^property[=].uri = "http://hl7.org/fhir/concept-properties#status"
* ^property[=].description = "Statut du code postal : active (en service), inactive (temporairement dÃ©sactivÃ©), deprecated (supprimÃ© dÃ©finitivement)"
* ^property[=].type = #code

* ^property[+].code = #effectiveDate
* ^property[=].uri = "http://hl7.org/fhir/concept-properties#effectiveDate"
* ^property[=].description = "Date de mise en service du code postal (format YYYY-MM-DD)"
* ^property[=].type = #dateTime

* ^property[+].code = #deprecationDate
* ^property[=].uri = "http://hl7.org/fhir/concept-properties#deprecationDate"
* ^property[=].description = "Date de suppression du code postal (format YYYY-MM-DD)"
* ^property[=].type = #dateTime

* ^property[+].code = #replacedBy
* ^property[=].description = "Code postal de remplacement en cas de modification"
* ^property[=].type = #code

* ^property[+].code = #communeInsee
* ^property[=].description = "Code INSEE de la commune principale desservie (5 caractÃ¨res)"
* ^property[=].type = #string

// =============================================
// MODÃ‰LISATION DE L'HISTORIQUE
// =============================================
//
// Les codes postaux Ã©voluent dans le temps. Pour gÃ©rer l'historique :
//
// 1. NOUVEAU CODE POSTAL
//    - status = #active
//    - effectiveDate = date de mise en service
//
//    Exemple: Code postal 91080 crÃ©Ã© le 2019-01-01
//    {
//      "code": "91080",
//      "display": "Ã‰VRY-COURCOURONNES",
//      "property": [
//        {"code": "status", "valueCode": "active"},
//        {"code": "effectiveDate", "valueDateTime": "2019-01-01"},
//        {"code": "communeInsee", "valueString": "91228"}
//      ]
//    }
//
// 2. CODE POSTAL SUPPRIMÃ‰
//    - status = #deprecated
//    - effectiveDate = date de crÃ©ation
//    - deprecationDate = date de suppression
//    - replacedBy = nouveau code (optionnel)
//
//    Exemple: Code postal 91080 (ancien Ã‰vry) supprimÃ© le 2019-01-01
//    {
//      "code": "91080",
//      "display": "Ã‰VRY (ancien)",
//      "property": [
//        {"code": "status", "valueCode": "deprecated"},
//        {"code": "effectiveDate", "valueDateTime": "1950-01-01"},
//        {"code": "deprecationDate", "valueDateTime": "2019-01-01"},
//        {"code": "replacedBy", "valueCode": "91000"}
//      ]
//    }
//
// 3. VALIDATION TEMPORELLE
//
//    Pour valider un code postal Ã  une date donnÃ©e :
//    - VÃ©rifier que (date >= effectiveDate)
//    - VÃ©rifier que (date < deprecationDate) OU (deprecationDate absent)
//    - Si status = deprecated, le code n'est plus valide
//
//    Exemple de requÃªte FHIR :
//    GET [base]/CodeSystem/$validate-code?
//        system=https://www.cpage.fr/ig/masterdata/geo/CodeSystem/codes-postaux-cs
//        &code=75001
//        &date=2024-06-15
//
// 4. RECHERCHE DE CODES Ã€ UNE DATE
//
//    Pour trouver les codes valides Ã  une date :
//    GET [base]/CodeSystem/$lookup?
//        system=https://www.cpage.fr/ig/masterdata/geo/CodeSystem/codes-postaux-cs
//        &property=effectiveDate
//        &property=deprecationDate
//        &property=status
//
//    Filtrer oÃ¹ :
//    - status = active
//    - effectiveDate <= date_recherche
//    - (deprecationDate > date_recherche OU deprecationDate absent)
//
// =============================================
// EXEMPLES DE CODES (Ã  titre indicatif)
// =============================================
//
// Codes postaux Paris (arrondissements) :
//   75001 - PARIS 01
//   75002 - PARIS 02
//   ...
//   75020 - PARIS 20
//
// Codes postaux Marseille (arrondissements) :
//   13001 - MARSEILLE 01
//   13002 - MARSEILLE 02
//   ...
//   13016 - MARSEILLE 16
//
// Codes postaux Lyon (arrondissements) :
//   69001 - LYON 01
//   69002 - LYON 02
//   ...
//   69009 - LYON 09
