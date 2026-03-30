Instance: mdm-publication-server
InstanceOf: CapabilityStatement
Usage: #definition
Title: "CapabilityStatement Serveur - Operations de publication MDM"
Description: "Declaration de capacites du serveur FHIR pour les operations de publication Master Data."
* id = "mdm-publication-server"
* url = "https://www.cpage.fr/ig/masterdata/operations/CapabilityStatement/mdm-publication-server"
* name = "MdmPublicationServer"
* status = #active
* experimental = false
* date = "2026-03-30"
* publisher = "CPage"
* kind = #instance
* fhirVersion = #4.0.1
* format[+] = #json
* format[+] = #xml

* rest[+].mode = #server
* rest[=].documentation = "Serveur FHIR exposant les operations systeme de publication."
* rest[=].operation[+].name = "$publication-metadata"
* rest[=].operation[=].definition = Canonical(publication-metadata)
* rest[=].operation[+].name = "$publication-bundle"
* rest[=].operation[=].definition = Canonical(publication-bundle)
