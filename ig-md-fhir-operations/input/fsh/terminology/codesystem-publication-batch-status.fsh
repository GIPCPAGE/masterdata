CodeSystem: PublicationBatchStatus
Id: publication-batch-status
Title: "Code System - Statut d'un lot de publication"
Description: "Decrit le cycle de vie d'un lot de publication MDM, depuis sa creation jusqu'a sa disponibilite ou son echec."
* ^url = "https://www.cpage.fr/ig/masterdata/operations/CodeSystem/publication-batch-status"
* ^version = "0.1.0"
* ^status = #active
* ^experimental = false
* ^publisher = "CPage"
* ^contact[+].name = "CPage"
* ^contact[=].telecom[+].system = #email
* ^contact[=].telecom[=].value = "contact@cpage.fr"
* ^caseSensitive = true
* ^content = #complete

* #READY "Pret" "Le lot est disponible et consultable par les consommateurs via les operations FHIR."
* #PROCESSING "En cours de traitement" "Le lot est en cours de generation ou de consolidation. Il n'est pas encore disponible a la consultation."
* #FAILED "En echec" "La generation ou la publication du lot a echoue. Un nouveau lot de reprise sera publie avec un nouvel identifiant."
* #EXPIRED "Expire" "Le lot n'est plus disponible a la consultation (supprime ou archive selon la politique de retention)."
