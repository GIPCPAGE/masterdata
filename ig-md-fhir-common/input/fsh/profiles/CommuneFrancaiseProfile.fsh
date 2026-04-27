// =============================================
// Profil : Commune française (COG INSEE)
// =============================================
// Basé sur la ressource FHIR Location.
//
// Chaque instance représente une commune française selon le Code Officiel
// Géographique (COG) de l'INSEE et transporte :
//   - le code INSEE (identifiant 5 chars) via identifier[codeInsee]
//   - le nom officiel de la commune via name
//   - un ou plusieurs codes postaux via address.postalCode + extension[codePostal]
//   - le type de territoire (commune / commune-nouvelle / commune-déléguée) via type
//   - les codes département et région INSEE via extensions
//   - pour les communes déléguées : la commune nouvelle parente via partOf
//
// Trois patrons d'utilisation (miroir du CodeSystem communes-fr-cs) :
//   Patron A — Commune historique inactive (fusionnée, status = inactive)
//   Patron B — Commune nouvelle active (status = active, type = commune-nouvelle)
//   Patron B'— Commune déléguée (status = active, type = commune-deleguee, partOf renseigné)

Profile: CommuneFrancaiseProfile
Parent: Location
Id: commune-francaise-profile
Title: "Commune française (COG INSEE)"
Description: """
Profil Location représentant une commune française selon le Code Officiel Géographique (COG) de l'INSEE.

Chaque instance porte :
- le **code INSEE** (5 caractères) comme identifiant principal (`identifier[codeInsee]`)
- le **nom officiel** de la commune (`name`)
- un ou plusieurs **codes postaux** (`address.postalCode` pour le code principal, `extension[codePostal]` pour la liste complète)
- le **type de territoire** : commune ordinaire, commune nouvelle ou commune déléguée (`type`)
- les **codes département** et **région** INSEE (extensions)
- pour les **communes déléguées** : une référence vers la commune nouvelle parente (`partOf`)

**Source** : INSEE — Code Officiel Géographique (COG). Licence Ouverte 2.0.  
**Mise à jour** : Annuelle (1er janvier).
"""

// =============================================
// Identifiant — Code INSEE (5 caractères)
// =============================================

* identifier ^slicing.discriminator.type = #value
* identifier ^slicing.discriminator.path = "system"
* identifier ^slicing.rules = #open
* identifier ^slicing.description = "Code INSEE de la commune"

* identifier 1..* MS
  * system 1..1 MS
  * value 1..1 MS

* identifier contains
    codeInsee 1..1 MS

* identifier[codeInsee].system = "https://www.cpage.fr/ig/masterdata/common/CodeSystem/communes-fr-cs" (exactly)
* identifier[codeInsee].value 1..1
* identifier[codeInsee] ^short = "Code INSEE de la commune (5 caractères)"
* identifier[codeInsee] ^definition = "Code commune du Code Officiel Géographique INSEE. Format : 5 caractères (2 département + 3 commune). Exemples : 75056 (Paris), 69264 (Belleville-en-Beaujolais), 13055 (Marseille)."

// =============================================
// Statut actif / inactif
// =============================================

* status 1..1 MS
* status ^short = "active | inactive"
* status ^definition = """
active = commune actuellement en vigueur (dans le COG courant) ;
inactive = commune historique : fusionnée dans une commune nouvelle, supprimée ou transformée en commune déléguée sans autonomie propre.

Note : une commune déléguée peut être active (elle conserve son existence administrative) même si elle n'est plus autonome.
"""

// =============================================
// Nom officiel
// =============================================

* name 1..1 MS
* name ^short = "Nom officiel de la commune"
* name ^definition = "Libellé officiel de la commune selon le COG INSEE."

// =============================================
// Type de territoire
// =============================================
// Utilise Location.type (CodeableConcept 0..*) avec binding required
// sur CommuneTypeTerritoireVS : commune | commune-nouvelle | commune-deleguee

* type 1..1 MS
* type from CommuneTypeTerritoireVS (required)
* type ^short = "Nature administrative : commune, commune-nouvelle ou commune-déléguée"
* type ^definition = "Qualifie le type de territoire selon la réforme des communes nouvelles (loi NOTRe 2015). Détermine la sémantique de partOf (communes déléguées) et le statut historique (communes nouvelles)."

// =============================================
// Type physique : juridiction administrative
// =============================================

* physicalType 0..1 MS
* physicalType = http://terminology.hl7.org/CodeSystem/location-physical-type#jdn "Jurisdiction"
* physicalType ^short = "Type physique : juridiction (division administrative française)"

// =============================================
// Adresse
// =============================================

* address 0..1 MS
* address.country = "FR" (exactly)
* address.country ^short = "Pays : France (FR) — valeur fixe"
* address.postalCode 0..1 MS
* address.postalCode ^short = "Code postal principal de la commune"
* address.postalCode ^definition = "Code postal principal rattaché à la commune. Pour les communes à codes postaux multiples, tous les codes sont portés par extension[codePostal]. Ce champ contient le code postal canonique (ou le seul code s'il est unique)."
* address.city 0..1 MS
* address.city ^short = "Nom de la commune (côté adresse)"
* address.state 0..1
* address.state ^short = "Nom du département (libellé, non structuré)"

// =============================================
// Extensions
// =============================================

* extension contains
    CommuneCodePostalExt named codePostal 0..* MS and
    CommuneCodeDepartementExt named codeDepartement 0..1 MS and
    CommuneCodeRegionExt named codeRegion 0..1 MS and
    CommuneDateDebutValiditeExt named dateDebutValidite 0..1 MS and
    CommuneDateFinValiditeExt named dateFinValidite 0..1 MS and
    CommuneDateMiseAJourExt named dateMiseAJour 0..1 MS

* extension[codePostal] ^short = "Code(s) postal(aux) de la commune"
* extension[codePostal] ^definition = "Liste complète des codes postaux rattachés à la commune. Répétable : une commune peut couvrir plusieurs codes postaux (grandes villes, communes géographiquement étendues, arrondissements). Correspond à la propriété répétable `codePostal` du CodeSystem communes-fr-cs."

* extension[codeDepartement] ^short = "Code département INSEE (2 ou 3 caractères)"
* extension[codeDepartement] ^definition = "Code département INSEE de la commune. Format : 2 chars (01–95, 2A, 2B) ou 3 chars pour les DROM (971–976)."

* extension[codeRegion] ^short = "Code région INSEE (réforme 2016)"
* extension[codeRegion] ^definition = "Code région INSEE issu de la réforme territoriale de 2016. Exemples : 84 = Auvergne-Rhône-Alpes, 11 = Île-de-France, 93 = PACA."

* extension[dateDebutValidite] ^short = "Date d'entrée en vigueur du code INSEE"
* extension[dateDebutValidite] ^definition = "Date à partir de laquelle la commune est reconnue par le COG INSEE. Correspond à `dateCreation` dans le CodeSystem communes-fr-cs. Pour les communes historiques : 1943-01-01 par convention."

* extension[dateFinValidite] ^short = "Date de fin de validité (communes inactives)"
* extension[dateFinValidite] ^definition = "Date à laquelle la commune a cessé d'exister de façon autonome (fusion, suppression). Renseignée uniquement quand `status = inactive`. Correspond à `dateSuppression` dans le CodeSystem communes-fr-cs."

* extension[dateMiseAJour] ^short = "Date de dernière mise à jour de la fiche"
* extension[dateMiseAJour] ^definition = "Horodatage de la dernière modification de l'enregistrement dans le référentiel CPage (correction de code postal, renommage, mise à jour COG annuelle…). Distinct de `dateDebutValidite` qui est la date COG officielle."

// =============================================
// Hiérarchie : commune déléguée → commune nouvelle
// =============================================
// Pour une commune déléguée (type = commune-deleguee), partOf référence
// la Location de la commune nouvelle parente.
// Équivaut à la propriété `communeNouvelle` du CodeSystem.

* partOf 0..1 MS
* partOf only Reference(CommuneFrancaiseProfile)
* partOf ^short = "Commune nouvelle parente (pour les communes déléguées)"
* partOf ^definition = "Pour une commune déléguée (type = commune-deleguee) : référence vers la Location représentant la commune nouvelle qui l'englobe. Équivaut à la propriété `communeNouvelle` du CodeSystem communes-fr-cs. Ce champ ne doit pas être renseigné pour les communes ordinaires et les communes nouvelles."
