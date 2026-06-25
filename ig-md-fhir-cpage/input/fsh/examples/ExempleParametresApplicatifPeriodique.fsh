// =============================================
// Exemple Paramètres Applicatif — scope TENANT, typeParametre = D (Administrateur - Périodique)
// Cas : taux de TVA applicable sur deux périodes distinctes
// =============================================

Instance: ExempleParametresApplicatifPeriodique
InstanceOf: CPageParametresApplicatifProfile
Usage: #example
Title: "Exemple Paramètres Applicatif périodique TENANT (TAUX_TVA)"
Description: "Paramètre périodique TENANT définissant un taux de TVA avec deux plages de validité. typeParametre = #D (Administrateur - Périodique)."

* id = "exemple-parametres-applicatif-periodique"

* parameter[identifiant].name = "identifiant"
* parameter[identifiant].valueString = "GEF_TAUX_TVA"

* parameter[libelle].name = "libelle"
* parameter[libelle].valueString = "Taux de TVA applicable"

* parameter[valeur].name = "valeur"
* parameter[valeur].valueString = "20"

* parameter[typeDonnee].name = "typeDonnee"
* parameter[typeDonnee].valueCode = #F

* parameter[actif].name = "actif"
* parameter[actif].valueString = "true"

* parameter[typeParametre].name = "typeParametre"
* parameter[typeParametre].valueCode = #D

* parameter[module].name = "module"
* parameter[module].valueString = "GEF"

* parameter[commentaire].name = "commentaire"
* parameter[commentaire].valueString = "Taux de TVA révisé chaque année civile."

* parameter[utilisateur].name = "utilisateur"
* parameter[utilisateur].valueString = "ADMIN_LOCAL"

* parameter[mots_cle][0].name = "mots_cle"
* parameter[mots_cle][0].valueString = "TVA"
* parameter[mots_cle][1].name = "mots_cle"
* parameter[mots_cle][1].valueString = "taxe"

* parameter[periodes][0].name = "periodes"
* parameter[periodes][0].part[date_debut].name = "date_debut"
* parameter[periodes][0].part[date_debut].valueDate = "2024-01-01"
* parameter[periodes][0].part[date_fin].name = "date_fin"
* parameter[periodes][0].part[date_fin].valueDate = "2024-12-31"
* parameter[periodes][0].part[valeur].name = "valeur"
* parameter[periodes][0].part[valeur].valueString = "20"

* parameter[periodes][1].name = "periodes"
* parameter[periodes][1].part[date_debut].name = "date_debut"
* parameter[periodes][1].part[date_debut].valueDate = "2025-01-01"
* parameter[periodes][1].part[valeur].name = "valeur"
* parameter[periodes][1].part[valeur].valueString = "21"
