// =============================================
// Exemples — Communes françaises (COG INSEE)
// =============================================
// Ces instances illustrent les trois patrons d'utilisation du CodeSystem
// communes-fr-cs dans les ressources FHIR de cet IG.
//
// Alias utile (le CodeSystem est externe, pas de profil à importer)
// Alias déjà déclaré dans aliases.fsh si besoin; on utilise l'URL directement.

// =============================================
// Exemple 1 : Patient — code INSEE de la commune de résidence
// =============================================
// Patron : adresse dont le code INSEE de la commune est porté par l'extension FR Core
//          fr-core-address-insee-code, valeur dans la nomenclature TRE_R13 (ANS).
//
// Extension utilisée : fr-core-address-insee-code (FR Core 2.2.0)
//   URL : https://hl7.fr/ig/fhir/core/StructureDefinition/fr-core-address-insee-code
//   Type valeur : Coding, liaison obligatoire au jeu de valeurs fr-core-vs-insee-code
//
// Les codes et libellés de cet exemple sont ceux de TRE_R13-CommuneOM : le validateur
// contrôle le libellé contre la terminologie de l'ANS.

Instance: ExemplePatientCommuneDeleguee
InstanceOf: Patient
Usage: #example
Title: "Patient — Code INSEE de la commune de résidence (Meyzieu / 69282)"
Description: """
Exemple d'un patient dont l'adresse porte le **code INSEE de sa commune de résidence**.

L'extension `fr-core-address-insee-code` posée sur l'adresse référence le code 69282
(Meyzieu) dans la nomenclature TRE_R13-CommuneOM de l'ANS.

Le cas d'une commune déléguée ou d'une commune fusionnée, avec résolution vers la commune
nouvelle par `$lookup`, est illustré avec le CodeSystem communes-fr-cs de l'IG (exemple 3).
"""

* name.family = "Durand"
* name.given = "Marc"
* name.use = #official

* birthDate = "1978-04-12"

* address.use = #home
* address.type = #physical
* address.city = "Meyzieu"
// Extension fr-core sur l'adresse → code INSEE de la commune de résidence
* address.extension[+].url = "https://hl7.fr/ig/fhir/core/StructureDefinition/fr-core-address-insee-code"
* address.extension[=].valueCoding.system = "https://mos.esante.gouv.fr/NOS/TRE_R13-CommuneOM/FHIR/TRE-R13-CommuneOM"
* address.extension[=].valueCoding.code = #69282
* address.extension[=].valueCoding.display = "Meyzieu"
* address.line = "14 Route des Vignes"
* address.postalCode = "69330"
* address.country = "FR"

// =============================================
// Exemple 2 : Organization — code INSEE de la commune d'implantation
// =============================================
// Patron : adresse d'une organisation avec le code INSEE de sa commune (nomenclature TRE_R13).

Instance: ExempleOrganisationCommuneNouvelle
InstanceOf: Organization
Usage: #example
Title: "Organisation — Code INSEE de la commune d'implantation (Villefranche-sur-Saône / 69264)"
Description: """
Exemple d'une organisation dont l'adresse référence le **code INSEE de sa commune
d'implantation** : Villefranche-sur-Saône (69264), dans la nomenclature TRE_R13-CommuneOM
de l'ANS.

Pour une commune nouvelle (fusion de communes) et la résolution de ses communes déléguées,
voir le CodeSystem communes-fr-cs de l'IG (exemples 3 et 4).
"""

* name = "Cabinet Médical Beaujolais"
* active = true

* address.use = #work
* address.type = #physical
* address.city = "Villefranche-sur-Saône"
// Extension fr-core sur l'adresse → code INSEE de la commune d'implantation
* address.extension[+].url = "https://hl7.fr/ig/fhir/core/StructureDefinition/fr-core-address-insee-code"
* address.extension[=].valueCoding.system = "https://mos.esante.gouv.fr/NOS/TRE_R13-CommuneOM/FHIR/TRE-R13-CommuneOM"
* address.extension[=].valueCoding.code = #69264
* address.extension[=].valueCoding.display = "Villefranche-sur-Saône"
* address.line = "3 Place de l'Église"
* address.postalCode = "69400"
* address.country = "FR"

// =============================================
// Exemple 3 : Paramètres de requête $lookup — résolution commune déléguée
// =============================================
// Patron : requête terminologique pour retrouver la commune nouvelle à partir
//          du code d'une commune déléguée ou d'une commune historique inactive.
//
// Représentation FSH d'un Parameters (corps de la réponse $lookup) :
//   Opération  : GET [base]/CodeSystem/$lookup
//   Paramètres : system, code, property
//
// → Cas A : commune déléguée 69282 → commune nouvelle 69264
// → Cas B : commune historique inactive 69282 → successeur 69264

Instance: ExempleParametersLookupCommuneNouvelle
InstanceOf: Parameters
Usage: #example
Title: "Parameters — Réponse $lookup : commune déléguée → commune nouvelle"
Description: """
Représentation du corps de réponse FHIR de l'opération `$lookup` appliquée sur le
CodeSystem communes-fr-cs pour le code **69282** (Saint-Jean-d'Ardières, déléguée).

La propriété `communeNouvelle` retournée contient **69264** (Belleville-en-Beaujolais),
permettant à tout système récepteur de résoudre automatiquement la commune parente
sans table de correspondance externe.

**Requête HTTP correspondante** :
```
GET [base]/CodeSystem/$lookup
  ?system=https://www.cpage.fr/ig/masterdata/common/CodeSystem/communes-fr-cs
  &code=69282
  &property=communeNouvelle
  &property=typeTerritoire
  &property=dateCreation
```
"""

// Champs identifiant le concept trouvé
* parameter[+].name = "name"
* parameter[=].valueString = "Communes françaises (COG INSEE)"

* parameter[+].name = "version"
* parameter[=].valueString = "20250101"

* parameter[+].name = "display"
* parameter[=].valueString = "Saint-Jean-d'Ardières (déléguée)"

* parameter[+].name = "abstract"
* parameter[=].valueBoolean = false

// Propriété typeTerritoire
* parameter[+].name = "property"
* parameter[=].part[+].name = "code"
* parameter[=].part[=].valueCode = #typeTerritoire
* parameter[=].part[+].name = "valueCode"
* parameter[=].part[=].valueCode = #commune-deleguee

// Propriété communeNouvelle → résultat principal de la résolution
* parameter[+].name = "property"
* parameter[=].part[+].name = "code"
* parameter[=].part[=].valueCode = #communeNouvelle
* parameter[=].part[+].name = "valueCode"
* parameter[=].part[=].valueCode = #69264
* parameter[=].part[+].name = "description"
* parameter[=].part[=].valueString = "Belleville-en-Beaujolais — commune nouvelle parente"

// Propriété dateCreation (commune déléguée créée lors de la fusion)
* parameter[+].name = "property"
* parameter[=].part[+].name = "code"
* parameter[=].part[=].valueCode = #dateCreation
* parameter[=].part[+].name = "valueDateTime"
* parameter[=].part[=].valueDateTime = "2019-01-01"

// =============================================
// Exemple 4 : Paramètres de requête $lookup — commune inactive → successeur
// =============================================
// Patron : retrouver le successeur d'une commune historique fusionnée.
//
// Requête HTTP :
//   GET [base]/CodeSystem/$lookup
//     ?system=https://www.cpage.fr/ig/masterdata/common/CodeSystem/communes-fr-cs
//     &code=69282
//     &property=successeur
//     &property=dateSuppression

Instance: ExempleParametersLookupSuccesseur
InstanceOf: Parameters
Usage: #example
Title: "Parameters — Réponse $lookup : commune inactive → successeur"
Description: """
Représentation du corps de réponse FHIR de l'opération `$lookup` appliquée sur le
CodeSystem communes-fr-cs pour le code racine inactif **69282**
(Saint-Jean-d'Ardières, commune historique fusionnée le 01/01/2019).

La propriété `successeur` retournée contient **69264** (Belleville-en-Beaujolais),
et `dateSuppression` indique quand la commune a cessé d'exister administrativement.

Ce patron permet de **rediriger automatiquement une adresse ancienne** vers la
commune active actuelle lors d'une migration de base de données d'adresses.

**Requête HTTP correspondante** :
```
GET [base]/CodeSystem/$lookup
  ?system=https://www.cpage.fr/ig/masterdata/common/CodeSystem/communes-fr-cs
  &code=69282
  &property=successeur
  &property=dateSuppression
  &property=inactive
```
"""

* parameter[+].name = "name"
* parameter[=].valueString = "Communes françaises (COG INSEE)"

* parameter[+].name = "version"
* parameter[=].valueString = "20250101"

* parameter[+].name = "display"
* parameter[=].valueString = "Saint-Jean-d'Ardières"

* parameter[+].name = "abstract"
* parameter[=].valueBoolean = false

// Propriété inactive → true car commune historique fusionnée
* parameter[+].name = "property"
* parameter[=].part[+].name = "code"
* parameter[=].part[=].valueCode = #inactive
* parameter[=].part[+].name = "valueBoolean"
* parameter[=].part[=].valueBoolean = true

// Propriété dateSuppression → date de la fusion
* parameter[+].name = "property"
* parameter[=].part[+].name = "code"
* parameter[=].part[=].valueCode = #dateSuppression
* parameter[=].part[+].name = "valueDateTime"
* parameter[=].part[=].valueDateTime = "2019-01-01"

// Propriété successeur → commune qui a absorbé celle-ci
* parameter[+].name = "property"
* parameter[=].part[+].name = "code"
* parameter[=].part[=].valueCode = #successeur
* parameter[=].part[+].name = "valueCode"
* parameter[=].part[=].valueCode = #69264
* parameter[=].part[+].name = "description"
* parameter[=].part[=].valueString = "Belleville-en-Beaujolais — commune successeure"
