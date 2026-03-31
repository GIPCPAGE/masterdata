Logical: PublicationBatchItem
Id: PublicationBatchItem
Title: "Modele logique - Item d'un lot de publication"
Description: "Represente une ressource individuelle appartenant a un lot de publication MDM. Chaque item correspond a un objet FHIR inclus dans le Bundle retourne par l'operation $publication-bundle. Les items sont ordonnes par sortOrder pour garantir l'ordre d'application cote consommateur dans une logique de type transaction."

* publicationBatchId 1..1 string "Identifiant du lot de publication auquel appartient cet item" "Cle de rattachement a l'entite PublicationBatch."
* resourceType 1..1 string "Type de ressource FHIR" "Exemple : Organization, Location, CodeSystem, ValueSet, Practitioner."
* logicalId 1..1 string "Identifiant logique de la ressource FHIR" "Correspond au champ id de la ressource FHIR dans le lot."
* rootInstanceId 0..1 string "Identifiant de l'instance racine dans le referentiel metier" "Peut etre distinct du logicalId FHIR lorsque l'identifiant metier et l'identifiant FHIR different."
* eventType 1..1 code "Type d'evenement a l'origine de cet item" "Indique la nature de la modification : creation, mise a jour ou suppression logique."
* eventType from http://hl7.org/fhir/ValueSet/audit-event-action (required)
* sortOrder 1..1 integer "Ordre d'application dans le lot" "Entier positif. Les items d'un Bundle transaction doivent etre appliques dans l'ordre croissant de sortOrder par le consommateur."
