// =============================================
// Exemples — Communes françaises (COG INSEE / TRE-R13)
// =============================================
// Ces instances illustrent les trois patrons d'utilisation du CodeSystem
// TRE-R13-CommuneOM dans les ressources FHIR de cet IG.
//
// Alias utile (le CodeSystem est externe, pas de profil à importer)
// Alias déjà déclaré dans aliases.fsh si besoin; on utilise l'URL directement.

// =============================================
// Exemple 1 : Patient résidant dans une commune déléguée
// =============================================
// Patron : Adresse avec code de commune déléguée sur _city
//
// Contexte : M. Durand habite à Saint-Jean-d'Ardières, quartier historique
// maintenant intégré à la commune nouvelle Belleville-en-Beaujolais (2019).
//
// Le code 69282 dans l'extension est celui de la commune DÉLÉGUÉE.
// Un $lookup sur la propriété `communeNouvelle` remonte immédiatement 69264.
//
// Extension utilisée : fr-core-address-insee-code (FR Core 2.1.0)
//   URL : https://hl7.fr/ig/fhir/core/StructureDefinition/fr-core-address-insee-code
//   Type valeur : Coding

Instance: ExemplePatientCommuneDeleguee
InstanceOf: Patient
Usage: #example
Title: "Patient — Commune déléguée (Saint-Jean-d'Ardières / 69282)"
Description: """
Exemple d'un patient dont l'adresse est dans une **commune déléguée**.

Le champ `city` contient le nom de la commune nouvelle (Belleville-en-Beaujolais).
L'extension `fr-core-address-insee-code` posée sur `_city` référence le code INSEE
de la **commune déléguée** (69282 — Saint-Jean-d'Ardières), soit le périmètre
géographique réel du patient.

Un `$lookup` sur le CodeSystem TRE-R13 avec `code=69282&property=communeNouvelle`
retourne immédiatement `69264`, sans ambiguïté et sans table de jointure externe.
"""

* name.family = "Durand"
* name.given = "Marc"
* name.use = #official

* birthDate = "1978-04-12"

* address.use = #home
* address.type = #physical
// Nom de la commune nouvelle (affichage utilisateur)
* address.city = "Belleville-en-Beaujolais"
// Extension fr-core sur l'adresse → code INSEE de la COMMUNE DÉLÉGUÉE
* address.extension[+].url = "https://hl7.fr/ig/fhir/core/StructureDefinition/fr-core-address-insee-code"
* address.extension[=].valueCoding.system = "https://smt.esante.gouv.fr/fhir/CodeSystem/TRE-R13-CommuneOM"
* address.extension[=].valueCoding.code = #69282
* address.extension[=].valueCoding.display = "Saint-Jean-d'Ardières"
* address.line = "14 Route des Vignes"
* address.postalCode = "69220"
* address.country = "FR"

// =============================================
// Exemple 2 : Organization localisée dans une commune nouvelle active
// =============================================
// Patron : Adresse avec code de commune nouvelle (cas standard post-fusion)
//
// Contexte : Établissement de santé créé après la fusion de 2019,
// enregistré directement sous le code de la commune nouvelle 69264.

Instance: ExempleOrganisationCommuneNouvelle
InstanceOf: Organization
Usage: #example
Title: "Organisation — Commune nouvelle active (Belleville-en-Beaujolais / 69264)"
Description: """
Exemple d'une organisation dont l'adresse référence directement la **commune nouvelle**
Belleville-en-Beaujolais (code INSEE 69264), créée au 01/01/2019.

Ce patron est utilisé lorsque l'entité a été créée ou mise à jour après la fusion :
le code 69264 est actif, valide dans le ValueSet `fr-communes-actives`, et ne
nécessite aucune résolution de commune déléguée.
"""

* name = "Cabinet Médical Beaujolais"
* active = true

* address.use = #work
* address.type = #physical
* address.city = "Belleville-en-Beaujolais"
// Extension fr-core sur l'adresse → code INSEE de la commune NOUVELLE
* address.extension[+].url = "https://hl7.fr/ig/fhir/core/StructureDefinition/fr-core-address-insee-code"
* address.extension[=].valueCoding.system = "https://smt.esante.gouv.fr/fhir/CodeSystem/TRE-R13-CommuneOM"
* address.extension[=].valueCoding.code = #69264
* address.extension[=].valueCoding.display = "Belleville-en-Beaujolais"
* address.line = "3 Place de l'Église"
* address.postalCode = "69220"
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
CodeSystem TRE-R13-CommuneOM pour le code **69282** (Saint-Jean-d'Ardières, déléguée).

La propriété `communeNouvelle` retournée contient **69264** (Belleville-en-Beaujolais),
permettant à tout système récepteur de résoudre automatiquement la commune parente
sans table de correspondance externe.

**Requête HTTP correspondante** :
```
GET [base]/CodeSystem/$lookup
  ?system=https://smt.esante.gouv.fr/fhir/CodeSystem/TRE-R13-CommuneOM
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
//     ?system=https://smt.esante.gouv.fr/fhir/CodeSystem/TRE-R13-CommuneOM
//     &code=69282
//     &property=successeur
//     &property=dateSuppression

Instance: ExempleParametersLookupSuccesseur
InstanceOf: Parameters
Usage: #example
Title: "Parameters — Réponse $lookup : commune inactive → successeur"
Description: """
Représentation du corps de réponse FHIR de l'opération `$lookup` appliquée sur le
CodeSystem TRE-R13-CommuneOM pour le code racine inactif **69282**
(Saint-Jean-d'Ardières, commune historique fusionnée le 01/01/2019).

La propriété `successeur` retournée contient **69264** (Belleville-en-Beaujolais),
et `dateSuppression` indique quand la commune a cessé d'exister administrativement.

Ce patron permet de **rediriger automatiquement une adresse ancienne** vers la
commune active actuelle lors d'une migration de base de données d'adresses.

**Requête HTTP correspondante** :
```
GET [base]/CodeSystem/$lookup
  ?system=https://smt.esante.gouv.fr/fhir/CodeSystem/TRE-R13-CommuneOM
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
