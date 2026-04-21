// =============================================
// NamingSystem: Code Officiel Géographique communes (INSEE)
// =============================================
// Déclare formellement l'autorité de l'INSEE sur les codes communes
// et enregistre les identifiants canoniques du système COG :
//   - URI canonique (exposition SMT e-santé / ANS)
//   - OID (1.2.250.1.213.2.12) pour les échanges CDA / HL7 v2

Instance: insee-cog-commune
InstanceOf: NamingSystem
Usage: #definition
Title: "Code Officiel Géographique — Communes (INSEE)"
Description: """
NamingSystem déclarant l'autorité de l'INSEE sur le Code Officiel Géographique (COG)
des communes françaises.

Ce NamingSystem associe :
- l'URI canonique exposée par le SMT e-santé (ANS), utilisée dans les ressources FHIR ;
- l'OID officiel `1.2.250.1.213.2.12`, utilisé dans les échanges CDA et HL7 v2.

Il permet aux systèmes FHIR d'identifier sans ambiguïté l'autorité émettrice des codes
communes INSEE, et de faire le lien avec les anciens identifiants OID des flux legacy.
"""

* name = "CPageCodeOfficielGeographiqueCommune"
* status = #active
* kind = #codesystem
* date = "2026-01-01"
* publisher = "CPage"
* contact.name = "CPage"
* contact.telecom.system = #url
* contact.telecom.value = "https://www.cpage.fr"
* responsible = "Institut national de la statistique et des études économiques"
* description = "Code Officiel Géographique (COG) des communes françaises maintenu par l'INSEE, exposé dans cet IG via le CodeSystem CPage. Environ 35 000 communes actives, mis à jour chaque 1er janvier."
* jurisdiction = urn:iso:std:iso:3166#FR "France"

// URI canonique CPage — à utiliser dans les ressources FHIR de cet IG
* uniqueId[+].type = #uri
* uniqueId[=].value = "https://www.cpage.fr/ig/masterdata/common/CodeSystem/communes-fr-cs"
* uniqueId[=].preferred = true
* uniqueId[=].comment = "URI canonique du CodeSystem CPage pour les communes COG INSEE."

// OID officiel INSEE — interopérabilité CDA / HL7 v2 / flux legacy
* uniqueId[+].type = #oid
* uniqueId[=].value = "1.2.250.1.213.2.12"
* uniqueId[=].preferred = false
* uniqueId[=].comment = "OID officiel INSEE pour le COG communes. À utiliser dans les échanges CDA et HL7 v2."
