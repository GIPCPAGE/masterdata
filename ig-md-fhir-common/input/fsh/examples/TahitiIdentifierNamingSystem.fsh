// =============================================
// NamingSystem: Identifiant Tahiti
// =============================================

Instance: tahiti-identifier-ns
InstanceOf: NamingSystem
Usage: #definition
Title: "Numéro Tahiti (Polynésie française)"
Description: "NamingSystem pour les identifiants Tahiti utilisés en Polynésie française. À remplacer par l'OID officiel si disponible auprès des autorités de Polynésie française (DGEN, ISPF)"
* name = "TahitiIdentifierNamingSystem"
* status = #active
* kind = #identifier
* date = "2026-02-23"
* publisher = "CPage"
* contact.name = "CPage"
* contact.telecom.system = #email
* contact.telecom.value = "contact@cpage.fr"
* description = "Système d'identification des entreprises et établissements en Polynésie française (Tahiti). Type identifiant: 07"
* jurisdiction = urn:iso:std:iso:3166#PF "Polynésie française"

* uniqueId[0].type = #uri
* uniqueId[0].value = "https://www.cpage.fr/ig/masterdata/common/NamingSystem/tahiti-identifier"
* uniqueId[0].preferred = true
* uniqueId[0].comment = "URI temporaire en attente d'OID officiel"

// Note: Remplacer par OID officiel quand disponible:
// * uniqueId[1].type = #oid
// * uniqueId[1].value = "2.16.840.1.113883.x.x.x.tahiti"
// * uniqueId[1].preferred = true
