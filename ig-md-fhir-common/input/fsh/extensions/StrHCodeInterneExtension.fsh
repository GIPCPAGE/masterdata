// =============================================
// Extension : Code interne structure hospitalière
// =============================================
// Code interne utilisé dans le SIH source de l'établissement.
// Applicable à toutes les entités de la structure hospitalière
// (Organisation et Location).

Extension: StrHCodeInterneExtension
Id: strh-code-interne
Title: "Code interne structure hospitalière"
Description: "Code interne de l'entité dans le système d'information hospitalier (SIH) source de l'établissement propriétaire."
Context: Organization, Location

* value[x] only string
* valueString ^short = "Code interne SIH"
* valueString ^definition = "Code identifiant l'entité dans le SIH source (ex : code UF, code pôle, numéro de chambre interne). Propre à chaque établissement."
