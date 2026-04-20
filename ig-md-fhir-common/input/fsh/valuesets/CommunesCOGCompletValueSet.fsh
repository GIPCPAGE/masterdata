// =============================================
// ValueSet: Communes françaises — COG complet (actives + historiques)
// =============================================
// Ce ValueSet inclut TOUS les codes du CodeSystem TRE-R13-CommuneOM,
// sans filtre sur `inactive` :
//   • communes actuellement actives (commune, commune-nouvelle, commune-deleguee)
//   • communes historiques inactives (fusionnées, supprimées)
//
// Usage recommandé :
//   - Migration d'une base d'adresses historique (valider des codes anciens)
//   - Audit / reporting territorial sur données passées
//   - $lookup pour retrouver le successeur d'une commune fusionnée
//   - Affichage de l'historique complet d'un territoire
//
// Pour la saisie d'adresse (formulaire utilisateur), utiliser
// fr-communes-actives (ValueSet filtré inactive = false).

ValueSet: CommunesCOGCompletValueSet
Id: fr-communes-cog-complet
Title: "Communes françaises — COG complet (actives et historiques)"
Description: """
Ensemble complet des communes françaises selon le Code Officiel Géographique (COG)
de l'INSEE, tel qu'exposé par le SMT e-santé — **sans filtre sur le statut**.

Ce ValueSet couvre :

- ✅ **Communes actives** — `typeTerritoire` = `commune` ou `commune-nouvelle`, `inactive = false`
- ✅ **Communes déléguées actives** — `typeTerritoire` = `commune-deleguee`, `inactive = false`
- ✅ **Communes historiques inactives** — `inactive = true`, avec propriétés `dateSuppression` et `successeur`

### Cas d'usage

| Use case | ValueSet recommandé |
|---|---|
| Saisie d'adresse (formulaire) | `fr-communes-actives` |
| Validation d'un code reçu de source externe | `fr-communes-cog-complet` + `$lookup(inactive)` |
| Migration / nettoyage base adresses historique | `fr-communes-cog-complet` |
| Audit territorial multimillésime | `fr-communes-cog-complet` |

### Note sur le contenu

Le CodeSystem source est déclaré avec `content = #fragment` dans cet IG
(seuls des exemples représentatifs sont publiés). En production, le serveur
terminologique charge le contenu complet depuis le SMT e-santé.

**CodeSystem source** : https://smt.esante.gouv.fr/fhir/CodeSystem/TRE-R13-CommuneOM
"""

* ^url = "https://smt.esante.gouv.fr/fhir/ValueSet/fr-communes-cog-complet"
* ^status = #active
* ^experimental = false
* ^date = "2025-01-01"
* ^publisher = "INSEE"
* ^contact.name = "INSEE"
* ^contact.telecom.system = #url
* ^contact.telecom.value = "https://www.insee.fr"
* ^copyright = "INSEE — données publiques"
* ^immutable = false

* ^compose.include[+].system = "https://smt.esante.gouv.fr/fhir/CodeSystem/TRE-R13-CommuneOM"
