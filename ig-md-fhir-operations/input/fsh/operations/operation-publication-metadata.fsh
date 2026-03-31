Instance: publication-metadata
InstanceOf: OperationDefinition
Usage: #definition
Title: "Operation de recuperation des metadonnees d'un lot publie"
Description: "Retourne les metadonnees d'un lot de publication identifie par publicationBatchId."
* id = "publication-metadata"
* url = "https://www.cpage.fr/ig/masterdata/operations/OperationDefinition/publication-metadata"
* name = "PublicationMetadata"
* status = #active
* kind = #operation
* code = #publication-metadata
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

* parameter[+].name = #publicationBatchId
* parameter[=].use = #out
* parameter[=].min = 1
* parameter[=].max = "1"
* parameter[=].type = #string
* parameter[=].documentation = "Identifiant technique du lot."

* parameter[+].name = #scope
* parameter[=].use = #out
* parameter[=].min = 1
* parameter[=].max = "1"
* parameter[=].type = #code
* parameter[=].documentation = "Scope du lot : GLOBAL ou CLIENT."
* parameter[=].binding.strength = #required
* parameter[=].binding.valueSet = "https://www.cpage.fr/ig/masterdata/operations/ValueSet/publication-scope"

* parameter[+].name = #targetTenant
* parameter[=].use = #out
* parameter[=].min = 0
* parameter[=].max = "1"
* parameter[=].type = #string
* parameter[=].documentation = "Tenant cible lorsque le lot est client-specifique."

* parameter[+].name = #bundleType
* parameter[=].use = #out
* parameter[=].min = 1
* parameter[=].max = "1"
* parameter[=].type = #code
* parameter[=].documentation = "Type du bundle expose : transaction ou batch."
* parameter[=].binding.strength = #required
* parameter[=].binding.valueSet = "https://www.cpage.fr/ig/masterdata/operations/ValueSet/bundle-type-publication"

* parameter[+].name = #publicationViewCode
* parameter[=].use = #out
* parameter[=].min = 0
* parameter[=].max = "1"
* parameter[=].type = #string
* parameter[=].documentation = "Code de la vue de publication utilisee."

* parameter[+].name = #sourceTransactionId
* parameter[=].use = #out
* parameter[=].min = 0
* parameter[=].max = "1"
* parameter[=].type = #string
* parameter[=].documentation = "Identifiant de la transaction metier source."

* parameter[+].name = #sourceVersionNum
* parameter[=].use = #out
* parameter[=].min = 0
* parameter[=].max = "1"
* parameter[=].type = #integer
* parameter[=].documentation = "Numero de version source."

* parameter[+].name = #resourceType
* parameter[=].use = #out
* parameter[=].min = 0
* parameter[=].max = "*"
* parameter[=].type = #string
* parameter[=].documentation = "Type de ressource present dans le lot."

* parameter[+].name = #status
* parameter[=].use = #out
* parameter[=].min = 1
* parameter[=].max = "1"
* parameter[=].type = #code
* parameter[=].documentation = "Statut du lot : READY, PROCESSING, FAILED, etc."
* parameter[=].binding.strength = #required
* parameter[=].binding.valueSet = "https://www.cpage.fr/ig/masterdata/operations/ValueSet/publication-batch-status"

* parameter[+].name = #createdAt
* parameter[=].use = #out
* parameter[=].min = 0
* parameter[=].max = "1"
* parameter[=].type = #dateTime
* parameter[=].documentation = "Date de creation du lot."
