Instance: publication-list
InstanceOf: OperationDefinition
Usage: #definition
Title: "Operation de listage des lots publies dans un intervalle"
Description: "Retourne la liste des identifiants de lots publies compris dans un intervalle donne. Utilise pour le rattrapage (gap detection) : permet a un consommateur de detecter les lots qu'il aurait manques."
* id = "publication-list"
* url = "https://www.cpage.fr/ig/masterdata/operations/OperationDefinition/publication-list"
* name = "PublicationList"
* status = #active
* kind = #operation
* code = #publication-list
* system = true
* type = false
* instance = false
* affectsState = false

* parameter[+].name = #fromExclusiveBatchId
* parameter[=].use = #in
* parameter[=].min = 1
* parameter[=].max = "1"
* parameter[=].type = #string
* parameter[=].documentation = "Identifiant de lot borne basse exclusive (format PB-{id}). Les lots dont l'identifiant est strictement superieur a cette valeur seront retournes."

* parameter[+].name = #toInclusiveBatchId
* parameter[=].use = #in
* parameter[=].min = 0
* parameter[=].max = "1"
* parameter[=].type = #string
* parameter[=].documentation = "Identifiant de lot borne haute inclusive (format PB-{id}). Si absent, tous les lots au-dela de fromExclusiveBatchId sont retournes."

* parameter[+].name = #batchId
* parameter[=].use = #out
* parameter[=].min = 0
* parameter[=].max = "*"
* parameter[=].type = #string
* parameter[=].documentation = "Identifiant d'un lot publie compris dans l'intervalle (format PB-{id}). Les resultats sont tries par identifiant ascendant. Un parametre de ce nom est emis par lot trouve."
