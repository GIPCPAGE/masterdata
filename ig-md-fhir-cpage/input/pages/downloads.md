# Téléchargements

Ce guide d'implémentation contient les profils, extensions et terminologies FHIR spécifiques à CPage MasterData (tables Oracle ECO.FOU et ECO.DBT).

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