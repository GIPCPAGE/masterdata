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

