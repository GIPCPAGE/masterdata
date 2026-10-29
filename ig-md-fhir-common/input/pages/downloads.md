# Téléchargements

Ce guide d'implémentation regroupe les ressources FHIR du socle commun CPage MasterData :
- **Profils Organization** — Tiers, Établissement secondaire
- **Extensions** — rôle, restriction de rôle, identifiants, comptes bancaires, personne physique, etc.
- **Terminologies** — CodeSystems et ValueSets (catégories, civilités, natures juridiques, communes COG)
- **Paramètres de recherche** personnalisés

Le package NPM de cet IG est [téléchargeable ici](package.tgz). Il permet de valider des instances FHIR contre les profils qu'il contient.

Pour l'importer dans un serveur HAPI FHIR, vous pouvez utiliser ce [script Python](https://github.com/nmdp-bioinformatics/igloader) open source.

Vous pourrez ensuite utiliser l'opération [$validate](https://www.hl7.org/fhir/resource-operation-validate.html) pour valider les instances de ressource contre un profil issu de cette spécification.

---

## Ressources téléchargeables

* [Spécification complète (zip)](full-ig.zip)
* [Package NPM (tgz)](package.tgz)

### Définitions

* [Définitions JSON (zip)](definitions.json.zip)
* [Définitions XML (zip)](definitions.xml.zip)
* [Définitions Turtle (zip)](definitions.ttl.zip)

### Exemples

* [Exemples XML (zip)](examples.xml.zip)
* [Exemples JSON (zip)](examples.json.zip)

## Contenu du package

### Axe Concepts Métiers — Tiers (Organization)

| Ressource | Identifiant |
|-----------|-------------|
| TiersProfile (StructureDefinition) | `tiers-profile` |
| TiersEtablissementSecondaireProfile (StructureDefinition) | `tiers-etablissement-secondaire-profile` |
| 8 extensions (StructureDefinition) | — |
| 4 SearchParameter | — |
| 6 CodeSystems | — |

### Axe Nomenclatures

| Ressource | Identifiant |
|-----------|-------------|
| CodeSystem TRE-R13 COG (fragment) | `fr-commune-cog` |
| ValueSet communes actives | `fr-communes-actives` |
| ValueSet communes COG complet | `fr-communes-cog-complet` |
| NamingSystem COG INSEE | `insee-cog-commune` |
| NamingSystem Tahiti | `tahiti-identifier-ns` |
| NamingSystem RIDET | `ridet-identifier-ns` |

---

## Voir aussi

- [Artefacts de conformité](artifacts.html) — liste complète de toutes les ressources FHIR définies dans cet IG