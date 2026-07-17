# Limitations FSH/SUSHI sur les contraintes de string

Vérifié contre SUSHI v3.20.0 (implémente FHIR Shorthand v3.0.0) et l'usage réel dans ce
monorepo (`ig-md-fhir-cpage` et `ig-md-fhir-common`).

## `maxLength` : supporté, mais pas utilisé dans cet IG

Contrairement à une version précédente de ce document, une contrainte `maxLength` sur un
champ `string` **est** directement exprimable en FSH, via le chemin caret :

```fsh
* extension[codeBanque].valueString ^maxLength = 5
```

C'est un champ natif de `ElementDefinition` (`ElementDefinition.maxLength`), et il est
utilisé abondamment dans l'IG Socle Commun (`ig-md-fhir-common`) — par exemple dans
`TiersBankAccountExtension.fsh`, `FournisseurAttributsExtension.fsh`,
`FournisseurComptabiliteExtension.fsh` (36 occurrences au total dans ce dépôt).

**Aucune extension de cet IG CPage ne l'utilise**, alors que beaucoup de champs
documentent une longueur fixe uniquement dans leur `^short` (ex. `CBARCH — 5 chars`,
`TBICCH — 1 char` dans `CPageEntiteJuridiqueExtensions.fsh`). Cette longueur documentée
n'est donc **pas** actuellement appliquée comme contrainte de validation FHIR sur ces
champs CPage — seul le commentaire humain la porte. Ajouter `^maxLength` sur ces
éléments serait cohérent avec la convention déjà en place dans l'IG commun, mais cela
modifierait les fichiers `.fsh` et sort du périmètre de ce document.

## `minLength` et motif (`pattern`) : nécessitent une Invariant

Deux cas restent réellement hors de portée d'une simple règle FSH sur un `string` :

- **`minLength`** : `ElementDefinition` ne possède pas de champ `minLength` en FHIR R4 —
  ce n'est pas une limitation de SUSHI mais du modèle `ElementDefinition` lui-même. Il
  n'existe donc aucun chemin caret équivalent à `^minLength`.
- **Motif regex (ex. « exactement 2 chiffres »)** : `ElementDefinition.pattern[x]`
  existe, mais représente une valeur *partielle fixe* à respecter (un gabarit de valeur),
  pas une expression régulière générale. Il ne permet donc pas d'exprimer une contrainte
  du type « 2 chiffres » ou « commence par une lettre majuscule ».

Pour ces deux cas, la seule solution FHIR est une **Invariant** avec une expression
FHIRPath, appliquée via `* <élément> obeys <invariant>` :

```fsh
Invariant: ribKeyLength
Description: "La clé RIB doit comporter exactement 2 chiffres."
Expression: "value.matches('^\\d{2}$')"
Severity: #error

* valueString obeys ribKeyLength
```

> Limitation résiduelle : les invariants sont visibles dans le profil (et dans les
> définitions publiées), mais leur application effective dépend du moteur de validation
> utilisé — tous les validateurs FHIR ne les évaluent pas systématiquement.

Aucune extension de ce dépôt (CPage ou commun) ne définit actuellement d'Invariant de ce
type : la contrainte de longueur/motif reste, pour l'instant, documentée uniquement dans
les `^short`/`^definition`, jamais dans `^maxLength` (CPage) ni dans une Invariant
(CPage ou commun).

Voir : <https://build.fhir.org/ig/HL7/fhir-shorthand/reference.html#invariants>
