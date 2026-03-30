Instance: publication-bundle
InstanceOf: OperationDefinition
Usage: #definition
Title: "Operation de recuperation du contenu d'un lot publie"
Description: "Retourne le contenu publie d'un lot sous la forme d'un Bundle FHIR."
* id = "publication-bundle"
* url = "https://www.cpage.fr/ig/masterdata/operations/OperationDefinition/publication-bundle"
* name = "PublicationBundle"
* status = #active
* kind = #operation
* code = #publication-bundle
* system = true
* type = false
* instance = false
* affectsState = false

* parameter[+].name = #publicationBatchId
* parameter[=].use = #in
* parameter[=].min = 1
* parameter[=].max = "1"
* parameter[=].type = #string
* parameter[=].documentation = "Identifiant technique du lot publie."

* parameter[+].name = #targetTenant
* parameter[=].use = #in
* parameter[=].min = 0
* parameter[=].max = "1"
* parameter[=].type = #string
* parameter[=].documentation = "Tenant cible attendu pour controle de coherence."

* parameter[+].name = #publicationViewCode
* parameter[=].use = #in
* parameter[=].min = 0
* parameter[=].max = "1"
* parameter[=].type = #string
* parameter[=].documentation = "Vue de publication attendue pour controle de coherence."

* parameter[+].name = #return
* parameter[=].use = #out
* parameter[=].min = 1
* parameter[=].max = "1"
* parameter[=].type = #Bundle
* parameter[=].documentation = "Bundle FHIR correspondant au lot publie."
