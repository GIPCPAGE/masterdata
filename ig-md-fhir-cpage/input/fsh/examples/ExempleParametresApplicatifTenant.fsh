// =============================================
// Exemple Paramètres Applicatif — scope TENANT
// Cas réel : TI_TIMEOUT_448495, module CORE
// =============================================

Instance: ExempleParametresApplicatifTenant
InstanceOf: CPageParametresApplicatifProfile
Usage: #example
Title: "Exemple Paramètres Applicatif TENANT (TI_TIMEOUT_448495)"
Description: "Paramètre de timeout TENANT pour le module CORE, propre à l'établissement Beta."

* id = "exemple-parametres-applicatif-tenant"

* parameter[identifiant].name = "identifiant"
* parameter[identifiant].valueString = "TI_TIMEOUT_448495"

* parameter[libelle].name = "libelle"
* parameter[libelle].valueString = "Timeout Beta"

* parameter[valeur].name = "valeur"
* parameter[valeur].valueString = "60"

* parameter[typeDonnee].name = "typeDonnee"
* parameter[typeDonnee].valueCode = #I

* parameter[actif].name = "actif"
* parameter[actif].valueString = "true"

* parameter[typeParametre].name = "typeParametre"
* parameter[typeParametre].valueCode = #C

* parameter[module].name = "module"
* parameter[module].valueString = "COR"

* parameter[connecteur].name = "connecteur"
* parameter[connecteur].valueString = "HL7"

* parameter[commentaire].name = "commentaire"
* parameter[commentaire].valueString = "Commentaire Beta"

* parameter[controle_parametre].name = "controle_parametre"
* parameter[controle_parametre].valueString = "test"

* parameter[utilisateur].name = "utilisateur"
* parameter[utilisateur].valueString = "TOTO"

* parameter[mots_cle][0].name = "mots_cle"
* parameter[mots_cle][0].valueString = "timeout"
* parameter[mots_cle][1].name = "mots_cle"
* parameter[mots_cle][1].valueString = "session"
