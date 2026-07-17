// =============================================
// Exemple Paramètres Applicatif — scope GLOBAL
// Cas : durée de session, module CORE, GHT complet
// =============================================

Instance: ExempleParametresApplicatifGlobal
InstanceOf: CPageParametresApplicatifProfile
Usage: #example
Title: "Exemple Paramètres Applicatif GLOBAL (SESSION_EXPIRATION_MINUTES)"
Description: "Paramètre de durée de session partagé à l'ensemble du GHT. Aucun tenantId — golden record."

* id = "exemple-parametres-applicatif-global"

* parameter[identifiant].name = "identifiant"
* parameter[identifiant].valueString = "CORE_SESSION_EXP_480"

* parameter[libelle].name = "libelle"
* parameter[libelle].valueString = "Durée d'expiration de session (minutes)"

* parameter[valeur].name = "valeur"
* parameter[valeur].valueString = "480"

* parameter[typeDonnee].name = "typeDonnee"
* parameter[typeDonnee].valueCode = #I

* parameter[actif].name = "actif"
* parameter[actif].valueString = "true"

* parameter[typeParametre].name = "typeParametre"
* parameter[typeParametre].valueCode = #S

* parameter[module].name = "module"
* parameter[module].valueString = "COR"

* parameter[commentaire].name = "commentaire"
* parameter[commentaire].valueString = "Durée de validité d'une session utilisateur en minutes — valeur commune à l'ensemble du GHT."

* parameter[utilisateur].name = "utilisateur"
* parameter[utilisateur].valueString = "ADMIN_GHT"
