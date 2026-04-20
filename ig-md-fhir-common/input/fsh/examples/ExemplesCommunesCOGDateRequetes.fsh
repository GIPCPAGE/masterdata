// =============================================
// Exemples — Requêtes par date sur le COG (TRE-R13)
// =============================================
// Ces instances illustrent les patrons de requête temporelle sur le CodeSystem
// TRE-R13-CommuneOM, pour retrouver les communes ayant changé depuis une date donnée.
//
// Contexte FHIR R4 : les opérateurs de filtre ValueSet (ValueSet.compose.include.filter)
// sont limités à : =  is-a  descendent-of  is-not-a  regex  in  not-in  generalizes  exists
// → aucun opérateur >=/<= sur des dateTime n'est défini dans FHIR R4 standard.
//
// Trois patrons sont illustrés :
//   Patron 1 — Filtre `exists` : communes qui ONT une dateSuppression (supprimées)
//   Patron 2 — Filtre `regex`  : communes créées une année donnée (ex : 2025)
//   Patron 3 — Custom operation $changes-since (extension serveur recommandée)

// =============================================
// Patron 1 : $expand — communes ayant été supprimées / fusionnées (dateSuppression exists)
// =============================================
// Opérateur `exists` : FHIR R4 standard, supporté si le serveur terminologique
// implémente le filtrage sur les propriétés déclarées du CodeSystem.
//
// Ceci retourne TOUTES les communes ayant une propriété `dateSuppression` renseignée,
// sans contrainte sur la date elle-même.
//
// Requête HTTP :
//   POST [base]/ValueSet/$expand
//
// Corps :

Instance: ExempleParametersExpandCommunesSupprimees
InstanceOf: Parameters
Usage: #example
Title: "Parameters — $expand : communes ayant une date de suppression"
Description: """
Corps de requête `$expand` retournant toutes les communes du COG qui ont été
supprimées ou fusionnées (propriété `dateSuppression` présente).

Utilise l'opérateur `exists` (FHIR R4 standard) — portable sur tout serveur
terminologique qui supporte le filtrage sur les propriétés du CodeSystem.

Le client effectue ensuite le tri par date côté applicatif.

**Requête HTTP** :
```
POST [base]/ValueSet/$expand
Content-Type: application/fhir+json
```
"""

// Paramètre valueSet : ValueSet ad hoc dans le corps de la requête
* parameter[+].name = "valueSet"
* parameter[=].resource.resourceType = "ValueSet"
* parameter[=].resource.status = #active
* parameter[=].resource.compose.include[+].system = "https://smt.esante.gouv.fr/fhir/CodeSystem/TRE-R13-CommuneOM"
// Filtre 1 : la propriété dateSuppression doit exister (commune inactive/fusionnée)
* parameter[=].resource.compose.include[=].filter[+].property = #dateSuppression
* parameter[=].resource.compose.include[=].filter[=].op = #exists
* parameter[=].resource.compose.include[=].filter[=].value = "true"

// Contrôle de la pagination
* parameter[+].name = "count"
* parameter[=].valueInteger = 100
* parameter[+].name = "offset"
* parameter[=].valueInteger = 0
// Inclure les concepts inactifs : obligatoire pour ce cas d'usage
* parameter[+].name = "activeOnly"
* parameter[=].valueBoolean = false
// Inclure les propriétés dans la réponse pour tri côté client
* parameter[+].name = "property"
* parameter[=].valueString = "dateSuppression"
* parameter[+].name = "property"
* parameter[=].valueString = "successeur"

// =============================================
// Patron 2 : $expand — communes créées une année donnée (regex sur dateCreation)
// =============================================
// Opérateur `regex` : FHIR R4 standard. Filtre les codes dont la propriété
// dateCreation correspond à l'expression régulière, ex : "2025.*" pour l'année 2025.
//
// ⚠ Le support du regex sur des propriétés dateTime est serveur-dépendant.
//    Vérifier la capacité du serveur (CapabilityStatement ou TerminologyCapabilities).
//
// Requête HTTP :
//   POST [base]/ValueSet/$expand

Instance: ExempleParametersExpandCommunesCrees2025
InstanceOf: Parameters
Usage: #example
Title: "Parameters — $expand : communes créées en 2025 (regex sur dateCreation)"
Description: """
Corps de requête `$expand` retournant les communes dont la propriété `dateCreation`
démarre par `2025` — soit les communes entrées en vigueur au cours de l'année 2025.

Utilise l'opérateur `regex` (FHIR R4 standard) sur la propriété `dateCreation`.

> Le support du regex sur les propriétés `dateTime` est **serveur-dépendant**.
> Certains serveurs terminologiques ne l'implémentent que sur les propriétés `string`
> ou `code`. Consulter le `TerminologyCapabilities` du serveur avant d'utiliser ce patron.

Pour un filtrage robuste sans dépendance serveur, préférer **Patron 3** (`$changes-since`).

**Requête HTTP** :
```
POST [base]/ValueSet/$expand
Content-Type: application/fhir+json
```
"""

* parameter[+].name = "valueSet"
* parameter[=].resource.resourceType = "ValueSet"
* parameter[=].resource.status = #active
* parameter[=].resource.compose.include[+].system = "https://smt.esante.gouv.fr/fhir/CodeSystem/TRE-R13-CommuneOM"
* parameter[=].resource.compose.include[=].filter[+].property = #dateCreation
* parameter[=].resource.compose.include[=].filter[=].op = #regex
// Expression : tout code dont dateCreation commence par "2025" (ISO 8601 : 2025-MM-DD)
* parameter[=].resource.compose.include[=].filter[=].value = "2025.*"

* parameter[+].name = "count"
* parameter[=].valueInteger = 100
* parameter[+].name = "offset"
* parameter[=].valueInteger = 0
* parameter[+].name = "activeOnly"
* parameter[=].valueBoolean = false
* parameter[+].name = "property"
* parameter[=].valueString = "dateCreation"
* parameter[+].name = "property"
* parameter[=].valueString = "typeTerritoire"
* parameter[+].name = "property"
* parameter[=].valueString = "predecesseur"

// =============================================
// Patron 3 : Custom operation $changes-since
// =============================================
// Cette opération n'est pas définie dans la spécification FHIR R4 standard.
// Elle est recommandée comme EXTENSION du serveur terminologique implémentant cet IG,
// pour répondre nativement au besoin : "quelles communes ont changé depuis YYYY-MM-DD ?"
//
// Définition recommandée :
//   Nom          : $changes-since
//   Niveau       : CodeSystem (instance)
//   Paramètre IN : date (dateTime) — date de référence (inclusive)
//   Paramètre IN : typeTerritoire (code, optionnel) — filtrer par type
//   Paramètre OUT: Parameters avec une entrée par concept modifié
//                  (nouvelle commune, fusion, création de commune déléguée)
//
// Requête HTTP correspondante :
//   GET [base]/CodeSystem/fr-commune-cog/$changes-since?date=2025-01-01
//   GET [base]/CodeSystem/fr-commune-cog/$changes-since?date=2025-01-01&typeTerritoire=commune-nouvelle

// --- Corps de requête (POST, équivalent) ---
Instance: ExempleParametersChangesSinceRequest
InstanceOf: Parameters
Usage: #example
Title: "Parameters — Requête $changes-since (custom) : communes modifiées depuis 2025-01-01"
Description: """
Corps de requête pour l'opération custom `$changes-since` exposée par le serveur
terminologique.

Cette opération retourne la liste des communes ayant **changé** depuis la date passée
en paramètre : nouvelles communes (`dateCreation >= date`), communes fusionnées
(`dateSuppression >= date`), communes déléguées créées lors d'une fusion.

> Cette opération est une **extension de cet IG**, non définie dans FHIR R4 standard.
> Elle doit être déclarée dans le `CapabilityStatement` du serveur implémentant l'IG.

**Requête HTTP** :
```
GET [base]/CodeSystem/fr-commune-cog/$changes-since?date=2025-01-01
```
ou
```
POST [base]/CodeSystem/fr-commune-cog/$changes-since
Content-Type: application/fhir+json
```
"""

// Paramètre date : date de référence (inclusive) au format FHIR dateTime
* parameter[+].name = "date"
* parameter[=].valueDateTime = "2025-01-01"

// Paramètre optionnel : filtrer par type de territoire
// Commenter pour retourner tous types (commune + commune-nouvelle + commune-deleguee)
// * parameter[+].name = "typeTerritoire"
// * parameter[=].valueCode = #commune-nouvelle

// Paramètre optionnel : inclure ou non les suppressions (defaut : true)
* parameter[+].name = "includeSuppressions"
* parameter[=].valueBoolean = true

// Paramètre optionnel : inclure ou non les créations (defaut : true)
* parameter[+].name = "includeCreations"
* parameter[=].valueBoolean = true

// =============================================
// Patron 3b : Réponse type de $changes-since
// =============================================
// Exemple de la réponse retournée par $changes-since pour le millésime 2025.
// Chaque commune modifiée apparaît comme un groupe de parts sous un paramètre "commune".

Instance: ExempleParametersChangesSinceResponse
InstanceOf: Parameters
Usage: #example
Title: "Parameters — Réponse $changes-since : communes modifiées au 2025-01-01"
Description: """
Exemple de réponse de l'opération custom `$changes-since` pour la date `2025-01-01`.

Chaque entrée `commune` représente un concept ayant changé, avec le type de changement
(`creation` ou `suppression`) et les propriétés pertinentes.

Le client peut utiliser ces données directement pour :
- Mettre à jour un cache local de communes
- Déclencher une revalidation des adresses impactées
- Alimenter un journal d'audit des changements territoriaux
"""

// Métadonnées de la réponse
* parameter[+].name = "dateReference"
* parameter[=].valueDateTime = "2025-01-01"

* parameter[+].name = "total"
* parameter[=].valueInteger = 2

// Exemple 1 : commune nouvelle créée le 2025-01-01
* parameter[+].name = "commune"
* parameter[=].part[+].name = "code"
* parameter[=].part[=].valueCode = #01015
* parameter[=].part[+].name = "display"
* parameter[=].part[=].valueString = "Ambronay"
* parameter[=].part[+].name = "typeChangement"
* parameter[=].part[=].valueCode = #creation
* parameter[=].part[+].name = "dateChangement"
* parameter[=].part[=].valueDateTime = "2025-01-01"
* parameter[=].part[+].name = "typeTerritoire"
* parameter[=].part[=].valueCode = #commune
* parameter[=].part[+].name = "codeDepartement"
* parameter[=].part[=].valueCode = #01

// Exemple 2 : commune fusionnée (suppression) le 2025-01-01
* parameter[+].name = "commune"
* parameter[=].part[+].name = "code"
* parameter[=].part[=].valueCode = #01234
* parameter[=].part[+].name = "display"
* parameter[=].part[=].valueString = "Exemple Commune Fusionnée"
* parameter[=].part[+].name = "typeChangement"
* parameter[=].part[=].valueCode = #suppression
* parameter[=].part[+].name = "dateChangement"
* parameter[=].part[=].valueDateTime = "2025-01-01"
* parameter[=].part[+].name = "successeur"
* parameter[=].part[=].valueCode = #01235
* parameter[=].part[+].name = "codeDepartement"
* parameter[=].part[=].valueCode = #01
