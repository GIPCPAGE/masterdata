// =============================================
// Profil CPage Paramètres Applicatif
// Concept MDM : PARAMETRES_APPLICATIF (TY-04)
// Ressource   : Parameters (FHIR R4)
// =============================================

Profile: CPageParametresApplicatifProfile
Parent: Parameters
Id: cpage-parametres-applicatif-profile
Title: "Paramètres Applicatif (CPage)"
Description: "Profil CPage pour un paramètre de configuration fonctionnelle d'un module CPage, centralisé dans le Master Data pour garantir la cohérence inter-établissements du GHT."

* parameter ^slicing.discriminator.type = #value
* parameter ^slicing.discriminator.path = "name"
* parameter ^slicing.rules = #open

* parameter contains
    identifiant        1..1 and
    libelle            1..1 and
    valeur             1..1 and
    typeDonnee         1..1 and
    actif              1..1 and
    typeParametre      1..1 and
    module             0..1 and
    connecteur         0..1 and
    commentaire        1..1 and
    controle_parametre 0..1 and
    utilisateur        0..1 and
    mots_cle           0..* and
    periodes           0..*

* parameter[identifiant].name = "identifiant"
* parameter[identifiant].name ^short = "Clé fonctionnelle stable (ex : TI_TIMEOUT_448495)"
* parameter[identifiant].value[x] 1..1
* parameter[identifiant].value[x] only string
* parameter[identifiant].value[x] ^maxLength = 20

* parameter[libelle].name = "libelle"
* parameter[libelle].name ^short = "Libellé affiché dans l'IHM"
* parameter[libelle].value[x] 1..1
* parameter[libelle].value[x] only string
* parameter[libelle].value[x] ^maxLength = 255

* parameter[valeur].name = "valeur"
* parameter[valeur].name ^short = "Valeur sérialisée en string — type indiqué par typeDonnee"
* parameter[valeur].value[x] 1..1
* parameter[valeur].value[x] only string
* parameter[valeur].value[x] ^maxLength = 255

* parameter[typeDonnee].name = "typeDonnee"
* parameter[typeDonnee].name ^short = "Type de la valeur : B D I S F C"
* parameter[typeDonnee].value[x] 1..1
* parameter[typeDonnee].value[x] only code
* parameter[typeDonnee].valueCode from CPageParametresApplicatifTypeDonneeValueSet (required)

* parameter[actif].name = "actif"
* parameter[actif].name ^short = "\"true\" = actif | \"false\" = désactivé (désactivation logique)"
* parameter[actif].value[x] 1..1
* parameter[actif].value[x] only string

* parameter[typeParametre].name = "typeParametre"
* parameter[typeParametre].name ^short = "Catégorie fonctionnelle : A S U C D P"
* parameter[typeParametre].value[x] 1..1
* parameter[typeParametre].value[x] only code
* parameter[typeParametre].valueCode from CPageParametresApplicatifTypeValueSet (required)

* parameter[module].name = "module"
* parameter[module].name ^short = "Module CPage propriétaire (ex : CORE, GAP, GEF)"
* parameter[module].value[x] 0..1
* parameter[module].value[x] only string
* parameter[module].value[x] ^maxLength = 3

* parameter[connecteur].name = "connecteur"
* parameter[connecteur].name ^short = "Identifiant du connecteur concerné (ex : HL7, DMP, CARDIO) — requis si typeParametre = #C"
* parameter[connecteur].value[x] only string
* parameter[connecteur].value[x] ^maxLength = 255

* parameter[commentaire].name = "commentaire"
* parameter[commentaire].value[x] 1..1
* parameter[commentaire].value[x] only string
* parameter[commentaire].value[x] ^maxLength = 4000

* parameter[controle_parametre].name = "controle_parametre"
* parameter[controle_parametre].name ^short = "Règle de contrôle de la valeur (ex : regex, plage)"
* parameter[controle_parametre].value[x] only string
* parameter[controle_parametre].value[x] ^maxLength = 255

* parameter[utilisateur].name = "utilisateur"
* parameter[utilisateur].name ^short = "Identifiant du dernier modificateur (login ou UUID Keycloak)"
* parameter[utilisateur].value[x] only string
* parameter[utilisateur].value[x] ^maxLength = 255

* parameter[mots_cle].name = "mots_cle"
* parameter[mots_cle].name ^short = "Mot-clé de recherche/classification (répétable)"
* parameter[mots_cle].value[x] 1..1
* parameter[mots_cle].value[x] only string
* parameter[mots_cle].value[x] ^maxLength = 255

* parameter[periodes].name = "periodes"
* parameter[periodes].name ^short = "Période de validité d'une valeur — typeParametre = #D ou #P uniquement"
* parameter[periodes].part ^slicing.discriminator.type = #value
* parameter[periodes].part ^slicing.discriminator.path = "name"
* parameter[periodes].part ^slicing.rules = #open
* parameter[periodes].part contains
    date_debut 1..1 and
    date_fin   0..1 and
    valeur     1..1
* parameter[periodes].part[date_debut].name = "date_debut"
* parameter[periodes].part[date_debut].value[x] only date
* parameter[periodes].part[date_fin].name = "date_fin"
* parameter[periodes].part[date_fin].value[x] only date
* parameter[periodes].part[valeur].name = "valeur"
* parameter[periodes].part[valeur].value[x] only string
* parameter[periodes].part[valeur].value[x] ^maxLength = 255
