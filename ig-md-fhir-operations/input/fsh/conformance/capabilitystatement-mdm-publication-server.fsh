Instance: mdm-publication-server
InstanceOf: CapabilityStatement
Usage: #definition
Title: "CapabilityStatement Serveur - Operations de publication MDM"
Description: "Declaration de capacites du serveur FHIR pour les operations de publication Master Data. Ce serveur expose les operations systeme $publication-metadata et $publication-bundle. L'acces est securise par Bearer token OAuth2. Les deux modes de reponse (synchrone et asynchrone Prefer: respond-async) sont supportes."
* id = "mdm-publication-server"
* url = "https://www.cpage.fr/ig/masterdata/operations/CapabilityStatement/mdm-publication-server"
* name = "MdmPublicationServer"
* status = #active
* experimental = false
* date = "2026-03-30"
* publisher = "CPage"
* contact[+].name = "CPage"
* contact[=].telecom[+].system = #email
* contact[=].telecom[=].value = "contact@cpage.fr"
* kind = #instance
* software.name = "CPage MasterData FHIR Publication Server"
* software.version = "0.1.0"
* implementationGuide = "https://www.cpage.fr/ig/masterdata/operations"
* fhirVersion = #4.0.1
* format[+] = #json
* format[+] = #xml

* rest[+].mode = #server
* rest[=].documentation = "Serveur FHIR exposant les operations systeme de publication MDM. Les operations sont accessibles en HTTP POST sur l'endpoint systeme /fhir/$operation. L'authentification est requise via un Bearer token OAuth2 pour toutes les operations."
* rest[=].security.cors = false
* rest[=].security.service[+].coding[+].system = "http://terminology.hl7.org/CodeSystem/restful-security-service"
* rest[=].security.service[=].coding[=].code = #SMART-on-FHIR
* rest[=].security.service[=].coding[=].display = "SMART-on-FHIR"
* rest[=].security.description = "Authentification par Bearer token (OAuth2 / OpenID Connect). Le serveur exige un jeton valide pour toutes les operations de consultation. Le champ targetTenant peut etre controle en fonction des droits du jeton."
* rest[=].operation[+].name = "$publication-metadata"
* rest[=].operation[=].definition = Canonical(publication-metadata)
* rest[=].operation[=].documentation = "Recupere les metadonnees d'un lot publie : scope (GLOBAL/CLIENT), tenant cible, type de bundle, liste des types de ressources, statut (READY/PROCESSING/FAILED) et identifiant de la transaction source."
* rest[=].operation[+].name = "$publication-bundle"
* rest[=].operation[=].definition = Canonical(publication-bundle)
* rest[=].operation[=].documentation = "Recupere le contenu publie d'un lot sous forme de Bundle FHIR (transaction ou batch). Supporte le mode asynchrone : si l'en-tete Prefer: respond-async est present, retourne 202 Accepted + Content-Location pour polling."
