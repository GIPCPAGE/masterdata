// ============================================================================
// OperationDefinition : $hierarchy — Structure Hospitalière
//
// Opération CUSTOM (pas d'équivalent natif FHIR R4).
// Retourne la hiérarchie organisationnelle complète d'un établissement en un
// seul Bundle FHIR collection :
//   GHT → EJ → EG → (SERVICE | POLE → CR → CA) → UF → CHAMBRE → LIT
//
// Disponible sur les 3 endpoints :
//   GET /fhir/strh/Organization/$hierarchy          (Common IG)
//   GET /fhir/cpage/strh/Organization/$hierarchy    (CPage IG)
//   GET /fhir/frcore/strh/Organization/$hierarchy   (FR Core)
//
// Opérations FHIR NATIVES utilisées sur les mêmes endpoints :
//   GET /fhir/strh/Organization/_history            (FHIR R4 type-level history)
//   param _since : FHIR standard instant (ex: 2024-01-15T10:00:00Z)
// ============================================================================

Instance: strh-hierarchy-operation
InstanceOf: OperationDefinition
Usage: #definition

* id = "strh-hierarchy-operation"
* url = "https://www.cpage.fr/ig/masterdata/common/OperationDefinition/strh-hierarchy-operation"
* version = "1.0.0"
* name = "StrhHierarchyOperation"
* title = "Structure Hospitalière — Hiérarchie complète ($hierarchy)"
* status = #active
* kind = #operation
* experimental = false
* description = """
Retourne la hiérarchie organisationnelle complète d'un établissement en un seul
Bundle FHIR (type=collection) :

```
GHT → EJ → EG → (SERVICE | POLE → CR → CENTRE_ACTIVITE) → UF → CHAMBRE → LIT
```

Le cloisonnement tenant est appliqué automatiquement depuis le claim JWT `tenant_id`.
Un administrateur (sans `tenant_id`) obtient tous les établissements.

### Opérations natives FHIR utilisées sur le même endpoint

| URL | Description |
|-----|-------------|
| `GET /fhir/strh/Organization/_history` | Historique toutes versions (FHIR R4 natif) |
| `GET /fhir/strh/Organization/_history?_since=2024-01-01T00:00:00Z` | Depuis une date |
| `GET /fhir/strh/Organization?conceptCode=ENTITE_JURIDIQUE` | Recherche standard |

### Paramètre _since (FHIR natif) sur $hierarchy
Le paramètre `_since` (instant ISO 8601) est accepté sur `$hierarchy` pour le delta sync :
retourne uniquement les entités dont au moins une version a été créée après cet instant.

Exemple : `GET /fhir/strh/Organization/$hierarchy?_since=2024-06-01T00:00:00Z`
"""
* code = #hierarchy
* resource = #Organization
* system = false
* type = true
* instance = false

// ── Paramètres d'entrée ──────────────────────────────────────────────────────

* parameter[+]
  * name = #_since
  * use = #in
  * min = 0
  * max = "1"
  * documentation = """
Paramètre FHIR standard (instant ISO 8601). Si fourni, retourne uniquement les entités
dont au moins une version a été créée APRÈS cet instant. Permet le delta sync.
Exemple : `2024-06-10T08:00:00Z`
"""
  * type = #instant

* parameter[+]
  * name = #includeInactive
  * use = #in
  * min = 0
  * max = "1"
  * documentation = """
Paramètre custom MDM. Si `true`, inclut les entités fermées/désactivées
(statut INACTIF ou attribut `active = false`) dans le bundle retourné.
Par défaut `false` : seules les entités actives sont incluses.
"""
  * type = #boolean

* parameter[+]
  * name = #search
  * use = #in
  * min = 0
  * max = "1"
  * documentation = "Filtre texte libre appliqué sur les attributs JSONB des entités."
  * type = #string

// ── Paramètre de sortie ───────────────────────────────────────────────────────

* parameter[+]
  * name = #return
  * use = #out
  * min = 1
  * max = "1"
  * documentation = """
Bundle FHIR R4 (type=collection) contenant les Organization et Location
de la hiérarchie organisationnelle du tenant.

Chaque entrée est une ressource Organization ou Location conforme au profil
cible (Common IG, CPage IG ou FR Core 2.2.0 selon l'endpoint).
"""
  * type = #Bundle
