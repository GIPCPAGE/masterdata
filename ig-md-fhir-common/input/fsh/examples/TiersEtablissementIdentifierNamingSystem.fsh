// =============================================
// NamingSystem: Identifiant d'un établissement de tiers dans le Master Data
// =============================================

Instance: tiers-etablissement-identifier-ns
InstanceOf: NamingSystem
Usage: #definition
Title: "Identifiant d'un établissement de tiers (Master Data)"
Description: "NamingSystem de l'identifiant attribué par le Master Data à chaque établissement d'un tiers. Porté par tout établissement secondaire publié, qu'il ait ou non un SIRET."
* name = "TiersEtablissementIdentifierNamingSystem"
* status = #active
* kind = #identifier
* date = "2026-10-30"
* publisher = "CPage"
* contact.name = "CPage"
* contact.telecom.system = #email
* contact.telecom.value = "contact@cpage.fr"
* description = "Identifiant interne, attribué par le Master Data, d'un établissement de tiers. Stable pour la vie de l'établissement ; il n'est pas attribué par une application qui pousse un tiers."

* uniqueId[0].type = #uri
* uniqueId[0].value = "https://www.cpage.fr/ig/masterdata/common/NamingSystem/tiers-etablissement-identifier"
* uniqueId[0].preferred = true
