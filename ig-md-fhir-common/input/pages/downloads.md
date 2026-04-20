# Téléchargements

Ce guide d'implémentation expose deux axes de ressources FHIR :
1. **Tiers** — profils `Organization`, extensions, SearchParameters
2. **Nomenclatures géographiques** — CodeSystem TRE-R13 COG, ValueSets communes, NamingSystem INSEE

L'implementation guide contient un package [téléchargeable ici](package.tgz) permettant de valider les instances par rapport aux profils qu'il contient.

Pour cela, il suffit de télécharger le [package.tgz](package.tgz) et l'importer dans un serveur, par exemple sur hapi en suivant ce [script python](https://github.com/nmdp-bioinformatics/igloader) open source.

Vous pourrez ensuite utiliser l'opération [$validate](https://www.hl7.org/fhir/resource-operation-validate.html) pour valider les instances de ressource contre un profil issu de cette spécification.

## Ensemble des ressources téléchargeables

* [L'ensemble de la spécification (zip)](full-ig.zip)
* [Package (tgz)](package.tgz)

### Définitions

* [Définitions JSON (zip)](definitions.json.zip)
* [Définitions XML (zip)](definitions.xml.zip)
* [Définitions Turtle (zip)](definitions.ttl.zip)

### Exemples

* [Exemples XML (zip)](examples.xml.zip)
* [Exemples JSON (zip)](examples.json.zip)

---

## Contenu du package

### Axe 1 — Tiers (Organization)

| Ressource | Identifiant |
|-----------|-------------|
| TiersProfile (StructureDefinition) | `tiers-profile` |
| FournisseurProfile (StructureDefinition) | `fournisseur-profile` |
| DebiteurProfile (StructureDefinition) | `debiteur-profile` |
| PayeurSanteProfile (StructureDefinition) | `payeur-sante-profile` |
| 19 extensions (StructureDefinition) | — |
| 10 SearchParameter | — |
| 10 CodeSystems | — |

### Axe 2 — Nomenclatures géographiques

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

- [Données Géographiques COG](geographie.html) — utilisation des terminologies communes
- [Artifacts de conformité](artifacts.html) — liste complète de toutes les ressources FHIR