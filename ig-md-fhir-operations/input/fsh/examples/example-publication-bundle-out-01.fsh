Instance: publication-bundle-out-01
InstanceOf: Bundle
Usage: #example
Title: "Exemple de sortie de l'operation $publication-bundle"
Description: "Exemple de Bundle transaction retourne par l'operation $publication-bundle."
* type = #transaction
* timestamp = "2026-03-30T09:15:02Z"

* entry[+].resource = publication-bundle-org-01
* entry[=].request.method = #PUT
* entry[=].request.url = "Organization/ORG-GHT21-4589"

* entry[+].resource = publication-bundle-loc-01
* entry[=].request.method = #PUT
* entry[=].request.url = "Location/LOC-GHT21-775"
