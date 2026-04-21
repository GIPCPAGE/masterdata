// =============================================
// NamingSystem: RIDET (Nouvelle-Calédonie)
// =============================================

Instance: ridet-identifier-ns
InstanceOf: NamingSystem
Usage: #definition
Title: "RIDET (Nouvelle-Calédonie)"
Description: "NamingSystem pour le RIDET (Répertoire d'IDEntification des Entreprises et des Établissements de Nouvelle-Calédonie). À remplacer par l'OID officiel si disponible auprès de RIDET NC (https://www.ridet.nc/)"
* name = "RIDETIdentifierNamingSystem"
* status = #active
* kind = #identifier
* date = "2026-02-23"
* publisher = "CPage"
* contact.name = "CPage"
* contact.telecom.system = #email
* contact.telecom.value = "contact@cpage.fr"
* description = "RIDET - Répertoire d'IDEntification des Entreprises et des Établissements de Nouvelle-Calédonie. Équivalent du SIRET français pour la Nouvelle-Calédonie. Type identifiant: 08"
* jurisdiction = urn:iso:std:iso:3166#NC "Nouvelle-Calédonie"

* uniqueId[0].type = #uri
* uniqueId[0].value = "https://www.cpage.fr/ig/masterdata/common/NamingSystem/ridet-identifier"
* uniqueId[0].preferred = true
* uniqueId[0].comment = "URI temporaire en attente d'OID officiel"

// Note: Remplacer par OID officiel quand disponible:
// * uniqueId[1].type = #oid
// * uniqueId[1].value = "2.16.840.1.113883.x.x.x.ridet"
// * uniqueId[1].preferred = true

// Référence: https://www.ridet.nc/
