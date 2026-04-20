# Données Géographiques - Communes et Codes Postaux

## Vue d'ensemble

Le référentiel intègre les **données géographiques officielles françaises** pour faciliter la saisie et la validation des adresses :

- **~36 000 communes** selon le Code Officiel Géographique INSEE
- **~6 000 codes postaux** selon la base La Poste

Ces données permettent de :
- ✅ **Valider** les codes postaux et communes dans les adresses
- ✅ **Normaliser** l'écriture des noms de commune
- ✅ **Assurer la cohérence** entre code postal, commune et département
- ✅ **Faciliter la saisie** avec auto-complétion

### Deux modèles complémentaires

| Modèle | CodeSystem | Usage |
|---|---|---|
| **CPage interne** | `communes-insee-cs` (URL CPage) | Intégration systèmes existants |
| **TRE-R13 (recommandé)** | `fr-commune-cog` — URL SMT e-santé / ANS | Interopérabilité nationale, historique fusions, communes déléguées |

Pour tout nouveau développement, privilégier le **modèle TRE-R13** décrit en [fin de cette page](#mod%C3%A9lisation-cog-via-tre-r13-smt-e-sant%C3%A9--ans).

---

## Codes Commune INSEE

### Description

Chaque commune française possède un **code unique de 5 caractères** :
- **2 chiffres** : département
- **3 chiffres** : numéro de commune dans le département

**Exemple** : 
- Paris = `75056` (dept 75, commune 056)
- Marseille = `13055` (dept 13, commune 055)
- Lyon = `69123` (dept 69, commune 123)

### CodeSystem

**URL** : `https://www.cpage.fr/ig/masterdata/geo/CodeSystem/communes-insee-cs`

**Source officielle** : [INSEE - Code Officiel Géographique](https://www.insee.fr/fr/information/6800675)

**Mise à jour** : Annuelle (janvier) pour refléter les fusions, créations et suppressions de communes

### Utilisation dans les Adresses

> ⚠ **Note de compatibilité** : L'extension ci-dessous (`insee-commune-code`) est propre au modèle CPage interne.
> Pour les échanges interopérables, utiliser l'extension standard FR Core `fr-core-address-insee-code`
> avec le CodeSystem TRE-R13 — voir la section [Modélisation COG via TRE-R13](#mod%C3%A9lisation-cog-via-tre-r13-smt-e-sant%C3%A9--ans).

```json
{
  "resourceType": "Organization",
  "address": [{
    "line": ["10 Rue de la Santé"],
    "city": "Paris",
    "postalCode": "75014",
    "country": "FR",
    "extension": [{
      "url": "https://www.cpage.fr/ig/masterdata/geo/StructureDefinition/insee-commune-code",
      "valueCode": "75056"
    }]
  }]
}
```

### Recherche par Code Commune

```http
GET [base]/Organization?address-city-insee-code=75056
```

**Cas d'usage** :
- Statistiques par commune
- Rapports géographiques (nombre de fournisseurs par commune)
- Géolocalisation précise

---

## Codes Postaux Français

### Description

Les codes postaux français sont des **identifiants de 5 chiffres** utilisés par La Poste pour l'acheminement du courrier.

**Particularités** :
- Un code postal peut couvrir **plusieurs communes** (code postal partagé)
- Une grande commune peut avoir **plusieurs codes postaux** (Paris : 20 codes, Lyon : 9 codes)

**Exemple** : 
- 75001 = Paris 1er arrondissement
- 13001 = Marseille 1er arrondissement
- 69001 = Lyon 1er arrondissement

### CodeSystem

**URL** : `https://www.cpage.fr/ig/masterdata/geo/CodeSystem/codes-postaux-cs`

**Source officielle** : [La Poste - Base HEXASIMAL](https://datanova.laposte.fr/datasets/laposte-hexasmal)

**Mise à jour** : Annuelle

### Utilisation Standard

```json
{
  "resourceType": "Organization",
  "address": [{
    "line": ["10 Rue de la Santé"],
    "city": "Paris",
    "postalCode": "75014",
    "country": "FR"
  }]
}
```

Le champ `postalCode` standard FHIR accepte directement le code postal.

### Validation

Vérifier qu'un code postal existe :

```http
GET [base]/Organization?address-postalcode=75014
```

---

## Gestion de l'Historique et Temporalité

### Pourquoi l'Historique ?

Les communes et codes postaux **changent dans le temps** :

**Communes** :
- **Fusions** : 2 ou plusieurs communes fusionnent (ex: communes nouvelles)
- **Créations** : Nouvelle commune créée
- **Suppressions** : Commune rattachée à une autre
- **Changements de nom** : Rare mais existe

**Codes postaux** :
- **Création** : Nouveau code postal attribué
- **Suppression** : Code postal obsolète
- **Redécoupage** : Modification des zones desservies

**Impact métier** :
- Adresses historiques doivent rester valides
- Statistiques doivent tenir compte des changements territoriaux
- Factures anciennes gardent les codes d'époque

---

### Propriétés Temporelles CodeSystem

#### Communes INSEE

| Propriété | Type | Description | Exemple |
|-----------|------|-------------|---------|
| **status** | code | Active, inactive, deprecated | `active` |
| **effectiveDate** | dateTime | Date d'entrée en vigueur | `2019-01-01` |
| **deprecationDate** | dateTime | Date de suppression/fusion | `2024-01-01` |
| **replacedBy** | code | Code commune de remplacement | `78165` |
| **parent** | code | Code département (2 chiffres) | `75` |
| **region** | code | Code région INSEE (2016+) | `11` |

#### Codes Postaux

| Propriété | Type | Description | Exemple |
|-----------|------|-------------|---------|
| **status** | code | Active, inactive, deprecated | `active` |
| **effectiveDate** | dateTime | Date de mise en service | `2020-06-01` |
| **deprecationDate** | dateTime | Date de suppression | `2023-12-31` |
| **replacedBy** | code | Code postal de remplacement | `75015` |
| **communeInsee** | string | Code(s) commune(s) desservie(s) | `75056` ou `75056,92012` |

---

### Exemples d'Utilisation Historique

#### Exemple 1 : Commune Fusionnée

**Cas réel** : Villepreux (78674) a fusionné avec Les Clayes-sous-Bois (78165) le 1er janvier 2019.

```json
{
  "code": "78674",
  "display": "Villepreux",
  "property": [
    {
      "code": "status",
      "valueCode": "inactive"
    },
    {
      "code": "deprecationDate",
      "valueDateTime": "2019-01-01"
    },
    {
      "code": "replacedBy",
      "valueCode": "78165"
    }
  ]
}
```

**Utilisation** :
- Adresse postée **avant 2019** : 78674 Villepreux ✅ Valide
- Adresse postée **après 2019** : 78165 Les Clayes-sous-Bois ✅ Valide
- Recherche historique : Trouver toutes les adresses Villepreux → Rediriger vers 78165

---

#### Exemple 2 : Commune Nouvellement Créée

**Cas** : Mouen (14472) créée le 1er janvier 2024.

```json
{
  "code": "14472",
  "display": "Mouen",
  "property": [
    {
      "code": "status",
      "valueCode": "active"
    },
    {
      "code": "effectiveDate",
      "valueDateTime": "2024-01-01"
    },
    {
      "code": "parent",
      "valueCode": "14"
    }
  ]
}
```

**Utilisation** :
- Adresse postée **avant 2024** : 14472 ❌ N'existait pas encore
- Adresse postée **après 2024** : 14472 Mouen ✅ Valide

---

### Requêtes API avec Filtres Temporels

> **Périmètre** : Les requêtes ci-dessous ciblent le CodeSystem CPage interne (`communes-insee-cs`)
> et utilisent les propriétés de ce modèle (`status`, `replacedBy`).
> Pour le modèle TRE-R13 (propriétés `inactive`, `successeur`, `dateSuppression`),
> voir la section [$lookup TRE-R13](#operations-terminologiques-lookup).

#### Trouver Communes Actives Seulement

```http
GET [base]/CodeSystem/communes-insee-cs/$lookup?code=78674&property=status

Response:
{
  "parameter": [{
    "name": "property",
    "part": [
      {"name": "code", "valueCode": "status"},
      {"name": "value", "valueCode": "inactive"}
    ]
  }]
}
```

#### Trouver Commune de Remplacement

```http
GET [base]/CodeSystem/communes-insee-cs/$lookup?code=78674&property=replacedBy

Response:
{
  "parameter": [{
    "name": "property",
    "part": [
      {"name": "code", "valueCode": "replacedBy"},
      {"name": "value", "valueCode": "78165"}
    ]
  }]
}
```

#### Valider Adresse à Une Date Donnée

**Question** : Le code postal 75014 était-il valide le 15 mars 2020 ?

```http
GET [base]/CodeSystem/codes-postaux-cs/$validate-code
  ?code=75014
  &date=2020-03-15

Response:
{
  "parameter": [{
    "name": "result",
    "valueBoolean": true
  }]
}
```

---

### Cas d'Usage Métier

#### Cas 1 : Validation Facture Historique

**Problème** : Facture émise en 2018 avec commune "Villepreux (78674)". Est-elle valide ?

**Solution** :
1. Lookup code 78674
2. Vérifier `deprecationDate` = 2019-01-01
3. Date facture (2018) < deprecationDate ✅ **Valide**

#### Cas 2 : Migration Base Adresses

**Problème** : Mettre à jour toutes les adresses avec communes fusionnées.

**Requête** :
```sql
SELECT * FROM addresses 
WHERE commune_insee IN (
  SELECT code FROM communes 
  WHERE status = 'inactive' 
  AND replacedBy IS NOT NULL
)
```

**Action** : Pour chaque adresse, remplacer par `replacedBy`.

#### Cas 3 : Statistiques Territoriales

**Problème** : Compter le nombre de fournisseurs par commune en 2023.

**Solution** : Utiliser les codes commune **valides au 31/12/2023** :
- Si `effectiveDate` ≤ 2023-12-31
- ET (`deprecationDate` > 2023-12-31 OU absent)

---

### Maintenance Annuelle

#### Procédure de Mise à Jour

**Janvier** : INSEE publie le nouveau millésime COG

**Étapes** :

1. **Télécharger** nouveau fichier INSEE
```bash
cd scripts
python generate_communes_fsh.py
```

2. **Vérifier les changements**
```bash
git diff input/fsh/codesystems/CommunesINSEECodeSystem.fsh
```

Repérer les communes :
- Nouvelles (`effectiveDate` = année courante)
- Fusionnées (`status` = inactive, `replacedBy` renseigné)
- Modifiées (changement de nom)

3. **Recompiler**
```bash
npx sushi .
```

4. **Tester** :
- Vérifier que anciennes communes fusionnées ont `replacedBy`
- Valider que nouvelles communes ont `effectiveDate`
- Tester requêtes `$lookup` et `$validate-code`

5. **Déployer** :
```bash
git commit -m "feat(geo): Mise à jour COG 2025 - X communes fusionnées, Y nouvelles"
git push
```

---

### Codes Région INSEE (2016+)

Depuis 2016, la France a **13 régions métropolitaines** + 5 DROM.

| Code | Région |
|------|--------|
| **11** | Île-de-France |
| **24** | Centre-Val de Loire |
| **27** | Bourgogne-Franche-Comté |
| **28** | Normandie |
| **32** | Hauts-de-France |
| **44** | Grand Est |
| **52** | Pays de la Loire |
| **53** | Bretagne |
| **75** | Nouvelle-Aquitaine |
| **76** | Occitanie |
| **84** | Auvergne-Rhône-Alpes |
| **93** | Provence-Alpes-Côte d'Azur |
| **94** | Corse |
| **01** | Guadeloupe |
| **02** | Martinique |
| **03** | Guyane |
| **04** | La Réunion |
| **06** | Mayotte |

**Utilisation** : Statistiques régionales, rapports géographiques.

**Recherche par région** :
```http
GET [base]/CodeSystem/communes-insee-cs/$lookup?property=region&value=11
```

Retourne toutes les communes d'Île-de-France.

---

## Cohérence Code Postal ↔ Commune

### Règle de Validation

**Important** : Le code postal et la commune doivent être cohérents.

**Exemple correct** :
- Code postal : 75014
- Commune : Paris
- Code INSEE : 75056

**Exemple incorrect** :
- Code postal : 75014
- Commune : Lyon ❌ (incohérent)

### Vérification Recommandée

Lors de la création d'une adresse, vérifier :

```
SI code_postal[0:2] != code_insee[0:2] ALORS
    Alerte : "Le code postal et la commune ne correspondent pas au même département"
FIN SI
```

**Exemple** :
- Code postal : `75`014 → Département 75 (Paris)
- Code INSEE : `75`056 → Département 75 ✅ Cohérent

---

## Cas Particuliers

### Paris, Lyon, Marseille (Arrondissements)

Ces villes ont plusieurs codes postaux :

**Paris (20 codes)** :
- 75001, 75002, 75003, ... 75020
- Code INSEE unique : 75056

**Lyon (9 codes)** :
- 69001, 69002, ... 69009
- Code INSEE unique : 69123

**Marseille (16 codes)** :
- 13001, 13002, ... 13016
- Code INSEE unique : 13055

### Codes Postaux Partagés

Un même code postal peut desservir plusieurs communes :

**Exemple** : 01330
- Ambérieux-en-Dombes (01007)
- Villars-les-Dombes (01443)

Dans ce cas, spécifier le **nom de commune** et le **code INSEE** pour lever l'ambiguïté.

### DROM-COM

**Codes postaux spécifiques** :
- 97100-97199 : Guadeloupe
- 97200-97299 : Martinique
- 97300-97399 : Guyane
- 97400-97499 : La Réunion
- 97600-97699 : Mayotte
- 98000-98999 : Nouvelle-Calédonie, Polynésie

---

## Génération des Listes Complètes

Le référentiel inclut actuellement un **échantillon représentatif** (~300 communes, ~400 codes postaux).

Pour générer la **liste complète** (~36 000 communes, ~6 000 codes postaux) :

```bash
cd scripts

# Communes INSEE
python generate_communes_fsh.py

# Codes Postaux La Poste
python generate_codes_postaux_fsh.py
```

Voir [README_GENERATION.md](https://github.com/GIPCPAGE/masterdata/blob/master/scripts/README_GENERATION.md) pour les détails.

⚠️ **Attention** : La liste complète génère des fichiers FSH de **~3 MB** et la compilation SUSHI prend **3-10 minutes**.

---

## Exemples d'Utilisation

### Exemple 1 : Adresse Simple

```json
{
  "address": [{
    "use": "work",
    "line": ["123 Avenue des Champs-Élysées"],
    "city": "Paris",
    "postalCode": "75008",
    "country": "FR"
  }]
}
```

### Exemple 2 : Adresse avec Code INSEE

```json
{
  "address": [{
    "use": "work",
    "line": ["10 Boulevard Vivier Merle"],
    "city": "Lyon",
    "postalCode": "69003",
    "country": "FR",
    "extension": [{
      "url": "https://www.cpage.fr/ig/masterdata/geo/StructureDefinition/insee-commune-code",
      "valueCode": "69123"
    }]
  }]
}
```

### Exemple 3 : Adresse DROM

```json
{
  "address": [{
    "use": "work",
    "line": ["15 Rue de la Liberté"],
    "city": "Fort-de-France",
    "postalCode": "97200",
    "country": "FR",
    "extension": [{
      "url": "https://www.cpage.fr/ig/masterdata/geo/StructureDefinition/insee-commune-code",
      "valueCode": "97209"
    }]
  }]
}
```

---

## Recherche par Critères Géographiques

### Par Code Postal

Trouver toutes les organisations à Paris 14ème :

```http
GET [base]/Organization?address-postalcode=75014
```

### Par Commune

Trouver toutes les organisations à Lyon :

```http
GET [base]/Organization?address-city=Lyon
```

### Par Département

Trouver toutes les organisations en Isère (38) :

```http
GET [base]/Organization?address-insee-code:starts-with=38
```

### Par Région

Combiner avec l'extension région (si implémentée) :

```http
GET [base]/Organization?address-region=11
```

Code région 11 = Île-de-France (INSEE)

---

## Bonnes Pratiques

### 1. Validation à la Saisie

Implémenter une **auto-complétion** sur les communes et codes postaux :

- Utilisateur tape "Par..." → Suggestions : Paris, Paray-le-Monial, etc.
- Sélection "Paris" → Pré-remplit code postal 75001-75020
- Utilisateur choisit arrondissement → Renseigne code INSEE 75056

### 2. Normalisation Orthographique

Utiliser le **nom officiel INSEE** :
- ✅ "Saint-Étienne" (avec tiret et accent)
- ❌ "St Etienne" (abréviation non standard)

### 3. Cohérence Département

Vérifier la cohérence département :

```
code_postal[0:2] == code_insee[0:2] == department_code
```

### 4. Mise à Jour Annuelle

Les communes changent chaque année (fusions, créations) :
- **Janvier** : INSEE publie le nouveau COG
- **Février** : Régénérer les CodeSystems
- **Mars** : Recompiler et déployer le nouvel IG

---

## Modélisation COG via TRE-R13 (SMT e-santé / ANS)

Cette section décrit le modèle avancé basé sur la terminologie officielle publiée par l'ANS
sur le Serveur Multi-Terminologies (SMT), et les opérations FHIR disponibles pour interroger
les communes françaises en tenant compte des fusions et des communes déléguées.

### Architecture des ressources

| Ressource | Id | Rôle |
|---|---|---|
| **CodeSystem** | [`fr-commune-cog`](CodeSystem-fr-commune-cog.html) | Codes COG avec propriétés historiques et hiérarchie `part-of` |
| **ValueSet** | [`fr-communes-actives`](ValueSet-fr-communes-actives.html) | Filtre `inactive = false` — communes actuellement en vigueur |
| **ValueSet** | [`fr-communes-cog-complet`](ValueSet-fr-communes-cog-complet.html) | Sans filtre — toutes les communes : actives **et** historiques |
| **NamingSystem** | [`insee-cog-commune`](NamingSystem-insee-cog-commune.html) | Déclare l'autorité INSEE avec URI SMT et OID `1.2.250.1.213.2.12` |

**URL canonique** : `https://smt.esante.gouv.fr/fhir/CodeSystem/TRE-R13-CommuneOM`

### Deux modes de requête pour les communes

Le modèle répond à deux besoins distincts, couverts par deux ValueSets complémentaires :

| Besoin | ValueSet à utiliser | Filtre |
|---|---|---|
| **Communes actives** — saisie d'adresse, validation courante | [`fr-communes-actives`](ValueSet-fr-communes-actives.html) | `inactive = false` |
| **Historique complet** — migration, audit, données passées | [`fr-communes-cog-complet`](ValueSet-fr-communes-cog-complet.html) | aucun (tous codes) |

> **Règle de choix** : utiliser `fr-communes-actives` pour tout flux opérationnel (création/mise à jour d'adresse). Utiliser `fr-communes-cog-complet` pour valider ou consulter un code reçu d'un système externe ou d'une base historique.

### Modèle hiérarchique (`hierarchyMeaning = part-of`)

```
CodeSystem TRE-R13-CommuneOM
│
├── 69282  Saint-Jean-d'Ardières    [inactive=true,  typeTerritoire=commune,         successeur=69264]
│
└── 69264  Belleville-en-Beaujolais [inactive=false, typeTerritoire=commune-nouvelle, predecesseur=69282|69019]
    ├── 69282  Saint-Jean-d'Ardières (déléguée)  [typeTerritoire=commune-deleguee, communeNouvelle=69264]
    └── 69019  Belleville-sur-Saône  (déléguée)  [typeTerritoire=commune-deleguee, communeNouvelle=69264]
```

Le code `69282` apparaît **deux fois** :
- Au niveau racine → commune historique **inactive** (avant 2019)
- Sous `69264` → commune déléguée **active** (depuis 2019, périmètre géographique conservé)

---

### Opérations terminologiques — `$lookup` {#operations-terminologiques-lookup}

`$lookup` interroge le CodeSystem pour récupérer les propriétés d'un code.  
**URL de base du CodeSystem** cible : `https://smt.esante.gouv.fr/fhir/CodeSystem/TRE-R13-CommuneOM`

#### Cas 1 — Résoudre une commune déléguée → commune nouvelle

Un patient est enregistré avec le code `69282` (son quartier réel).
Pour retrouver la commune administrative parent :  

```http
GET [base]/CodeSystem/$lookup
  ?system=https://smt.esante.gouv.fr/fhir/CodeSystem/TRE-R13-CommuneOM
  &code=69282
  &property=communeNouvelle
  &property=typeTerritoire
```

Réponse :

```json
{
  "resourceType": "Parameters",
  "parameter": [
    { "name": "display",   "valueString": "Saint-Jean-d'Ardières (déléguée)" },
    { "name": "abstract",  "valueBoolean": false },
    {
      "name": "property",
      "part": [
        { "name": "code",      "valueCode": "typeTerritoire" },
        { "name": "valueCode", "valueCode": "commune-deleguee" }
      ]
    },
    {
      "name": "property",
      "part": [
        { "name": "code",        "valueCode": "communeNouvelle" },
        { "name": "valueCode",   "valueCode": "69264" },
        { "name": "description", "valueString": "Belleville-en-Beaujolais" }
      ]
    }
  ]
}
```

→ **`communeNouvelle = 69264`** : la commune nouvelle à utiliser pour l'adresse administrative.

Exemple FSH illustrant ce cas : [`ExempleParametersLookupCommuneNouvelle`](Parameters-ExempleParametersLookupCommuneNouvelle.html)

---

#### Cas 2 — Retrouver le successeur d'une commune historique inactive

Un système reçoit l'ancien code `69282` (commune racine, inactive depuis 2019) :

```http
GET [base]/CodeSystem/$lookup
  ?system=https://smt.esante.gouv.fr/fhir/CodeSystem/TRE-R13-CommuneOM
  &code=69282
  &property=inactive
  &property=dateSuppression
  &property=successeur
```

Réponse :

```json
{
  "resourceType": "Parameters",
  "parameter": [
    { "name": "display", "valueString": "Saint-Jean-d'Ardières" },
    {
      "name": "property",
      "part": [
        { "name": "code",         "valueCode": "inactive" },
        { "name": "valueBoolean", "valueBoolean": true }
      ]
    },
    {
      "name": "property",
      "part": [
        { "name": "code",          "valueCode": "dateSuppression" },
        { "name": "valueDateTime", "valueDateTime": "2019-01-01" }
      ]
    },
    {
      "name": "property",
      "part": [
        { "name": "code",        "valueCode": "successeur" },
        { "name": "valueCode",   "valueCode": "69264" },
        { "name": "description", "valueString": "Belleville-en-Beaujolais" }
      ]
    }
  ]
}
```

Exemple FSH illustrant ce cas : [`ExempleParametersLookupSuccesseur`](Parameters-ExempleParametersLookupSuccesseur.html)

---

#### Cas 3 — Récupérer toutes les propriétés d'une commune active

```http
GET [base]/CodeSystem/$lookup
  ?system=https://smt.esante.gouv.fr/fhir/CodeSystem/TRE-R13-CommuneOM
  &code=69264
  &property=typeTerritoire
  &property=codePostal
  &property=codeDepartement
  &property=codeRegion
  &property=dateCreation
  &property=predecesseur
```

Réponse partielle :

```json
{
  "parameter": [
    { "name": "display", "valueString": "Belleville-en-Beaujolais" },
    { "name": "property", "part": [{ "name": "code", "valueCode": "typeTerritoire" }, { "name": "valueCode", "valueCode": "commune-nouvelle" }] },
    { "name": "property", "part": [{ "name": "code", "valueCode": "codePostal" },     { "name": "valueString", "valueString": "69220" }] },
    { "name": "property", "part": [{ "name": "code", "valueCode": "codePostal" },     { "name": "valueString", "valueString": "69430" }] },
    { "name": "property", "part": [{ "name": "code", "valueCode": "codeDepartement"}, { "name": "valueCode",   "valueCode": "69" }] },
    { "name": "property", "part": [{ "name": "code", "valueCode": "codeRegion" },     { "name": "valueCode",   "valueCode": "84" }] },
    { "name": "property", "part": [{ "name": "code", "valueCode": "dateCreation" },   { "name": "valueDateTime", "valueDateTime": "2019-01-01" }] },
    { "name": "property", "part": [{ "name": "code", "valueCode": "predecesseur" },   { "name": "valueCode",   "valueCode": "69282" }] },
    { "name": "property", "part": [{ "name": "code", "valueCode": "predecesseur" },   { "name": "valueCode",   "valueCode": "69019" }] }
  ]
}
```

#### Cas 4 — Vérifier le statut d'un code (actif ou non)

```http
GET [base]/CodeSystem/$lookup
  ?system=https://smt.esante.gouv.fr/fhir/CodeSystem/TRE-R13-CommuneOM
  &code=69282
  &property=inactive
```

→ `"valueBoolean": true` → commune inactive au niveau racine (fusionnée).

---

### Opérations terminologiques — `$validate-code`

`$validate-code` vérifie qu'un code appartient à un ValueSet donné.

#### Valider qu'une commune est active (ValueSet `fr-communes-actives`)

```http
GET [base]/ValueSet/fr-communes-actives/$validate-code
  ?system=https://smt.esante.gouv.fr/fhir/CodeSystem/TRE-R13-CommuneOM
  &code=69264
```

Réponse — commune nouvelle active ✅ :

```json
{ "parameter": [{ "name": "result", "valueBoolean": true }] }
```

```http
GET [base]/ValueSet/fr-communes-actives/$validate-code
  ?system=https://smt.esante.gouv.fr/fhir/CodeSystem/TRE-R13-CommuneOM
  &code=69282
```

Réponse — code racine inactif ❌ (la commune déléguée doit être trouvée via sa hiérarchie) :

```json
{
  "parameter": [
    { "name": "result",  "valueBoolean": false },
    { "name": "message", "valueString": "Le code 69282 est inactif au niveau racine. Utiliser le contexte hiérarchique (communeNouvelle=69264) pour la commune déléguée." }
  ]
}
```

---

### Opérations terminologiques — `$expand`

`$expand` développe le ValueSet en liste de codes.

#### Lister toutes les communes actives

```http
GET [base]/ValueSet/fr-communes-actives/$expand
  &count=20
  &offset=0
```

#### Lister l'historique complet (actives + inactives)

```http
GET [base]/ValueSet/fr-communes-cog-complet/$expand
  &count=100
  &offset=0
```

Retourne tous les codes du COG sans distinction de statut.  
Chaque entrée peut ensuite faire l'objet d'un `$lookup` pour récupérer `inactive`, `dateSuppression`, `successeur`, etc.

#### Lister uniquement les communes historiques inactives

Utiliser `$expand` sur le ValueSet complet puis filtrer dynamiquement avec `activeOnly=false` et un filtre textuel, ou composer un ValueSet ad hoc :

```http
POST [base]/ValueSet/$expand
Content-Type: application/fhir+json

{
  "resourceType": "Parameters",
  "parameter": [{
    "name": "valueSet",
    "resource": {
      "resourceType": "ValueSet",
      "compose": {
        "include": [{
          "system": "https://smt.esante.gouv.fr/fhir/CodeSystem/TRE-R13-CommuneOM",
          "filter": [
            { "property": "inactive", "op": "=", "value": "true" }
          ]
        }]
      }
    }
  }]
}
```

Retourne uniquement les communes fusionnées ou supprimées — pratique pour une campagne de migration d'adresses.

#### Filtrer par type de territoire

Formulaire de saisie d'adresse : on ne veut proposer que les communes et communes nouvelles,
**pas** les communes déléguées (qui ne constituent pas un choix autonome pour l'utilisateur).

```http
GET [base]/ValueSet/$expand
Content-Type: application/fhir+json

{
  "resourceType": "Parameters",
  "parameter": [{
    "name": "valueSet",
    "resource": {
      "resourceType": "ValueSet",
      "compose": {
        "include": [{
          "system": "https://smt.esante.gouv.fr/fhir/CodeSystem/TRE-R13-CommuneOM",
          "filter": [
            { "property": "inactive",        "op": "=", "value": "false" },
            { "property": "typeTerritoire",  "op": "!=", "value": "commune-deleguee" }
          ]
        }]
      }
    }
  }]
}
```

Retourne uniquement les codes `commune` et `commune-nouvelle` actifs → idéal pour
une liste déroulante de saisie d'adresse.

---

### Requêtes par date — communes modifiées depuis une date donnée

#### Limitation FHIR R4

Les opérateurs de filtre définis dans FHIR R4 (`=`, `is-a`, `regex`, `exists`, …) **ne comprennent pas d'opérateur de comparaison `>=` ou `<=` sur les dateTime**. Il n'est donc pas possible d'écrire nativement un filtre `dateCreation >= 2025-01-01` dans un `ValueSet.compose.include.filter`.

Trois patrons complémentaires sont disponibles, du plus portable au plus puissant :

| Patron | Opérateur FHIR | Portable ? | Précision |
|---|---|---|---|
| **1 — `exists`** | Standard R4 | ✅ Toujours | Communes *qui ont* une dateSuppression, sans contrainte de date |
| **2 — `regex`** | Standard R4 | ⚠ Serveur-dépendant | Filtre par année (`2025.*`) sur `dateCreation` |
| **3 — `$changes-since`** | Extension custom | 🔧 À implémenter | Filtrage exact `>= date`, résultat structuré |

---

#### Patron 1 — Communes supprimées/fusionnées (filtre `exists`)

Retourne toutes les communes ayant une propriété `dateSuppression` renseignée.  
**Portable sur tout serveur terminologique FHIR R4** qui supporte le filtrage `exists`.

```http
POST [base]/ValueSet/$expand
Content-Type: application/fhir+json
```

```json
{
  "resourceType": "Parameters",
  "parameter": [
    {
      "name": "valueSet",
      "resource": {
        "resourceType": "ValueSet",
        "compose": {
          "include": [{
            "system": "https://smt.esante.gouv.fr/fhir/CodeSystem/TRE-R13-CommuneOM",
            "filter": [
              { "property": "dateSuppression", "op": "exists", "value": "true" }
            ]
          }]
        }
      }
    },
    { "name": "activeOnly",  "valueBoolean": false },
    { "name": "property",    "valueString":  "dateSuppression" },
    { "name": "property",    "valueString":  "successeur" },
    { "name": "count",       "valueInteger": 100 }
  ]
}
```

Le client trie ensuite les résultats par `dateSuppression` côté applicatif.

Exemple FSH : [`ExempleParametersExpandCommunesSupprimees`](Parameters-ExempleParametersExpandCommunesSupprimees.html)

---

#### Patron 2 — Communes créées une année précise (filtre `regex`)

Retourne les communes dont `dateCreation` correspond à l'année visée.

```http
POST [base]/ValueSet/$expand
Content-Type: application/fhir+json
```

```json
{
  "resourceType": "Parameters",
  "parameter": [
    {
      "name": "valueSet",
      "resource": {
        "resourceType": "ValueSet",
        "compose": {
          "include": [{
            "system": "https://smt.esante.gouv.fr/fhir/CodeSystem/TRE-R13-CommuneOM",
            "filter": [
              { "property": "dateCreation", "op": "regex", "value": "2025.*" }
            ]
          }]
        }
      }
    },
    { "name": "activeOnly", "valueBoolean": false },
    { "name": "property",   "valueString":  "dateCreation" },
    { "name": "property",   "valueString":  "typeTerritoire" },
    { "name": "property",   "valueString":  "predecesseur" }
  ]
}
```

> ⚠ Le support du filtre `regex` sur les propriétés `dateTime` est **serveur-dépendant**.
> Vérifier dans le `TerminologyCapabilities` du serveur avant d'utiliser ce patron.

Exemple FSH : [`ExempleParametersExpandCommunesCrees2025`](Parameters-ExempleParametersExpandCommunesCrees2025.html)

---

#### Patron 3 — Custom operation `$changes-since` (recommandée)

Cette opération est une **extension de cet IG**, non définie dans FHIR R4 standard.  
Elle doit être déclarée dans le `CapabilityStatement` du serveur terminologique.

```http
GET [base]/CodeSystem/fr-commune-cog/$changes-since?date=2025-01-01
```

Paramètres :

| Paramètre | Type | Requis | Description |
|---|---|---|---|
| `date` | dateTime | ✅ Oui | Date de référence inclusive (`>=`) |
| `typeTerritoire` | code | Non | Filtrer par type (`commune`, `commune-nouvelle`, `commune-deleguee`) |
| `includeCreations` | boolean | Non | Inclure les nouvelles communes (défaut : true) |
| `includeSuppressions` | boolean | Non | Inclure les communes fusionnées/supprimées (défaut : true) |

Exemples d'appels :

```http
# Toutes les communes modifiées depuis le 1er millésime 2025
GET [base]/CodeSystem/fr-commune-cog/$changes-since?date=2025-01-01

# Uniquement les communes nouvelles créées depuis 2024
GET [base]/CodeSystem/fr-commune-cog/$changes-since?date=2024-01-01&typeTerritoire=commune-nouvelle

# Uniquement les suppressions (pour migration d'adresses)
GET [base]/CodeSystem/fr-commune-cog/$changes-since?date=2025-01-01&includeCreations=false
```

Réponse : un `Parameters` contenant une entrée `commune` par concept modifié, avec `typeChangement` (`creation` ou `suppression`), la date de changement, et les propriétés associées (`successeur`, `codeDepartement`, etc.).

Exemples FSH :
- [`ExempleParametersChangesSinceRequest`](Parameters-ExempleParametersChangesSinceRequest.html) — corps de requête
- [`ExempleParametersChangesSinceResponse`](Parameters-ExempleParametersChangesSinceResponse.html) — corps de réponse

---

#### Algorithme de synchronisation périodique

```
1. Stocker en base la date de dernière synchronisation (ex : 2024-12-31)

2. Appeler $changes-since?date={dernière_synchro}

3. Pour chaque commune retournée :
     SI typeChangement = "creation"
       → ajouter le code dans le cache local
     SI typeChangement = "suppression"
       → marquer le code inactif, enregistrer successeur
       → planifier une revalidation des adresses portant ce code

4. Mettre à jour la date de dernière synchronisation = today
```

---

### Utilisation dans les adresses FHIR

#### Extension `fr-core-address-insee-code`

L'extension FR Core `fr-core-address-insee-code` se pose sur l'élément primitif `city`
(JSON : `_city`). Sa valeur est un `Coding` pointant vers le CodeSystem TRE-R13.

**Règle de choix du code** :

| Le patient/org habite dans… | Code à utiliser | Raison |
|---|---|---|
| Commune ordinaire active | Code de la commune (`69264`) | Cas standard |
| Commune déléguée (quartier réel) | Code de la déléguée (`69282`) | Précision géographique maximale |
| $lookup `communeNouvelle` pour retrouver le parent | → `69264` | Résolution administrative |

#### Exemple JSON — adresse avec commune déléguée

```json
{
  "resourceType": "Patient",
  "address": [{
    "use": "home",
    "city": "Belleville-en-Beaujolais",
    "postalCode": "69220",
    "country": "FR",
    "_city": {
      "extension": [{
        "url": "https://hl7.fr/ig/fhir/core/StructureDefinition/fr-core-address-insee-code",
        "valueCoding": {
          "system": "https://smt.esante.gouv.fr/fhir/CodeSystem/TRE-R13-CommuneOM",
          "code": "69282",
          "display": "Saint-Jean-d'Ardières (déléguée)"
        }
      }]
    }
  }]
}
```

Exemple FSH équivalent : [`ExemplePatientCommuneDeleguee`](Patient-ExemplePatientCommuneDeleguee.html)

#### Exemple JSON — adresse avec commune nouvelle (cas direct)

```json
{
  "resourceType": "Organization",
  "address": [{
    "use": "work",
    "city": "Belleville-en-Beaujolais",
    "postalCode": "69220",
    "country": "FR",
    "_city": {
      "extension": [{
        "url": "https://hl7.fr/ig/fhir/core/StructureDefinition/fr-core-address-insee-code",
        "valueCoding": {
          "system": "https://smt.esante.gouv.fr/fhir/CodeSystem/TRE-R13-CommuneOM",
          "code": "69264",
          "display": "Belleville-en-Beaujolais"
        }
      }]
    }
  }]
}
```

Exemple FSH équivalent : [`ExempleOrganisationCommuneNouvelle`](Organization-ExempleOrganisationCommuneNouvelle.html)

---

### Algorithme de résolution d'adresse

Quand un système reçoit un code commune INSEE (source externe, champ hérité, etc.) :

```
1. $lookup(code) → récupérer inactive, typeTerritoire

2. SI inactive = false ET typeTerritoire = "commune" OU "commune-nouvelle"
      → utiliser ce code directement ✅

3. SI inactive = false ET typeTerritoire = "commune-deleguee"
      → $lookup(code, property=communeNouvelle) → code_parent
      → enregistrer code_commune_deleguee pour localisation fine
      → enregistrer code_parent pour l'adresse administrative ✅

4. SI inactive = true
      → $lookup(code, property=successeur) → code_successeur
      → reprendre depuis l'étape 1 avec code_successeur ✅
```

---

### Recherche sur les ressources (Organization, Patient)

#### Par code commune INSEE (custom search parameter)

```http
GET [base]/Organization?address-insee-code=69264
GET [base]/Patient?address-insee-code=69282
```

> Les search parameters sur l'extension `fr-core-address-insee-code` peuvent nécessiter
> une déclaration de `SearchParameter` spécifique à votre serveur.

#### Par code département (préfixe du code INSEE)

```http
GET [base]/Organization?address-insee-code:starts-with=69
```

Retourne toutes les organisations dont le code commune INSEE commence par `69` → Rhône.

#### Par code postal + commune nouvelle

```http
GET [base]/Organization?address-postalcode=69220&address-city=Belleville-en-Beaujolais
```

---

## Comment exploiter l'API — exemples `curl`

Les exemples ci-dessous ciblent votre serveur FHIR (`[base]`).
Remplacer `[base]` par l'URL réelle, par exemple `https://mon-serveur.cpage.fr/fhir`.

---

### 1. Lire le CodeSystem

Récupère la définition complète du CodeSystem (propriétés, hiérarchie, concepts fragmentaires).

```bash
curl -H "Accept: application/fhir+json" \
  "[base]/CodeSystem/fr-commune-cog"
```

---

### 2. Valider un code commune

Vérifie qu'un code a bien été reconnu par le serveur.

```bash
# Code actif — commune nouvelle
curl -H "Accept: application/fhir+json" \
  "[base]/CodeSystem/fr-commune-cog/\$validate-code?code=69264"

# Code inactif — commune historique fusionnée
curl -H "Accept: application/fhir+json" \
  "[base]/CodeSystem/fr-commune-cog/\$validate-code?code=69282"
```

Réponse (code actif) :

```json
{
  "resourceType": "Parameters",
  "parameter": [
    { "name": "result",  "valueBoolean": true },
    { "name": "display", "valueString": "Belleville-en-Beaujolais" }
  ]
}
```

---

### 3. Récupérer le détail d'une commune (`$lookup`)

#### 3a. Détail d'une commune active

```bash
curl -H "Accept: application/fhir+json" \
  "[base]/CodeSystem/\$lookup\
?system=https://smt.esante.gouv.fr/fhir/CodeSystem/TRE-R13-CommuneOM\
&code=69264\
&property=typeTerritoire\
&property=codeDepartement\
&property=codeRegion\
&property=dateCreation\
&property=predecesseur"
```

#### 3b. Résoudre une commune déléguée → commune nouvelle

```bash
curl -H "Accept: application/fhir+json" \
  "[base]/CodeSystem/\$lookup\
?system=https://smt.esante.gouv.fr/fhir/CodeSystem/TRE-R13-CommuneOM\
&code=69019\
&property=typeTerritoire\
&property=communeNouvelle"
```

Réponse :

```json
{
  "resourceType": "Parameters",
  "parameter": [
    { "name": "display", "valueString": "Belleville-sur-Saône (déléguée)" },
    {
      "name": "property",
      "part": [
        { "name": "code",      "valueCode": "typeTerritoire" },
        { "name": "valueCode", "valueCode": "commune-deleguee" }
      ]
    },
    {
      "name": "property",
      "part": [
        { "name": "code",      "valueCode": "communeNouvelle" },
        { "name": "valueCode", "valueCode": "69264" }
      ]
    }
  ]
}
```

#### 3c. Retrouver le successeur d'une commune inactive

```bash
curl -H "Accept: application/fhir+json" \
  "[base]/CodeSystem/\$lookup\
?system=https://smt.esante.gouv.fr/fhir/CodeSystem/TRE-R13-CommuneOM\
&code=69282\
&property=inactive\
&property=dateSuppression\
&property=successeur"
```

Réponse :

```json
{
  "resourceType": "Parameters",
  "parameter": [
    { "name": "display", "valueString": "Saint-Jean-d'Ardières" },
    { "name": "property", "part": [{ "name": "code", "valueCode": "inactive" },       { "name": "valueBoolean", "valueBoolean": true }] },
    { "name": "property", "part": [{ "name": "code", "valueCode": "dateSuppression"}, { "name": "valueDateTime","valueDateTime": "2019-01-01" }] },
    { "name": "property", "part": [{ "name": "code", "valueCode": "successeur" },     { "name": "valueCode",    "valueCode": "69264" }] }
  ]
}
```

---

### 4. Valider un code contre le ValueSet des communes actives

```bash
curl -H "Accept: application/fhir+json" \
  "[base]/ValueSet/fr-communes-actives/\$validate-code\
?system=https://smt.esante.gouv.fr/fhir/CodeSystem/TRE-R13-CommuneOM\
&code=69264"
```

---

### 5. Développer la liste des communes actives (`$expand`)

```bash
# 50 premières communes actives
curl -H "Accept: application/fhir+json" \
  "[base]/ValueSet/fr-communes-actives/\$expand?count=50&offset=0"

# COG complet (actives + historiques)
curl -H "Accept: application/fhir+json" \
  "[base]/ValueSet/fr-communes-cog-complet/\$expand?count=100&offset=0"
```

---

### 6. Rechercher des ressources par commune

```bash
# Toutes les organizations d'une commune (par code INSEE)
curl -H "Accept: application/fhir+json" \
  "[base]/Organization?address-insee-code=69264"

# Toutes les organizations d'un département (préfixe)
curl -H "Accept: application/fhir+json" \
  "[base]/Organization?address-insee-code:starts-with=69"

# Patients d'une commune déléguée
curl -H "Accept: application/fhir+json" \
  "[base]/Patient?address-insee-code=69019"
```

---

### Récapitulatif

| Action | Commande |
|---|---|
| Lire le CodeSystem | `GET [base]/CodeSystem/fr-commune-cog` |
| Valider un code | `GET [base]/CodeSystem/fr-commune-cog/$validate-code?code={code}` |
| Détail d'un code | `GET [base]/CodeSystem/$lookup?system=...TRE-R13-CommuneOM&code={code}&property=...` |
| Résoudre commune déléguée | `$lookup` + `property=communeNouvelle` |
| Retrouver successeur | `$lookup` + `property=successeur&property=inactive` |
| Valider contre VS actives | `GET [base]/ValueSet/fr-communes-actives/$validate-code?system=...&code={code}` |
| Lister communes actives | `GET [base]/ValueSet/fr-communes-actives/$expand` |
| Lister COG complet | `GET [base]/ValueSet/fr-communes-cog-complet/$expand` |
| Rechercher par commune | `GET [base]/Organization?address-insee-code={code}` |

---

### 7. Pagination des résultats

Le COG contient ~35 000 communes. Toute requête `$expand` ou de recherche doit utiliser la
pagination pour éviter des réponses de plusieurs mégaoctets.

#### Pagination sur `$expand`

Les paramètres `count` et `offset` contrôlent la fenêtre de résultats.

```bash
# Page 1 : communes 1 à 100
curl -H "Accept: application/fhir+json" \
  "[base]/ValueSet/fr-communes-actives/\$expand?count=100&offset=0"

# Page 2 : communes 101 à 200
curl -H "Accept: application/fhir+json" \
  "[base]/ValueSet/fr-communes-actives/\$expand?count=100&offset=100"

# Page N : offset = (N-1) * count
curl -H "Accept: application/fhir+json" \
  "[base]/ValueSet/fr-communes-actives/\$expand?count=100&offset=200"
```

La réponse contient `ValueSet.expansion.total` (nombre total de codes) et `ValueSet.expansion.offset` :

```json
{
  "resourceType": "ValueSet",
  "expansion": {
    "total": 34935,
    "offset": 100,
    "contains": [
      { "system": "https://smt.esante.gouv.fr/fhir/CodeSystem/TRE-R13-CommuneOM", "code": "01002", "display": "L'Abergement-de-Varey" },
      ...
    ]
  }
}
```

**Calcul du nombre de pages** : `ceil(total / count)`.

#### Pagination sur les recherches FHIR (`_count` + `_offset`)

```bash
# Page 1 : 50 organizations par page
curl -H "Accept: application/fhir+json" \
  "[base]/Organization?address-insee-code:starts-with=69&_count=50&_offset=0"

# Page 2
curl -H "Accept: application/fhir+json" \
  "[base]/Organization?address-insee-code:starts-with=69&_count=50&_offset=50"
```

La réponse est un `Bundle` avec `Bundle.total` et un lien `next` :

```json
{
  "resourceType": "Bundle",
  "total": 342,
  "link": [
    { "relation": "self",  "url": "[base]/Organization?address-insee-code:starts-with=69&_count=50&_offset=0" },
    { "relation": "next",  "url": "[base]/Organization?address-insee-code:starts-with=69&_count=50&_offset=50" },
    { "relation": "last",  "url": "[base]/Organization?address-insee-code:starts-with=69&_count=50&_offset=300" }
  ],
  "entry": [ ... ]
}
```

#### Itération automatique sur toutes les pages (script bash)

```bash
BASE="https://mon-serveur.cpage.fr/fhir"
COUNT=200
OFFSET=0
TOTAL=1  # initialisé à 1 pour entrer dans la boucle

while [ "$OFFSET" -lt "$TOTAL" ]; do
  RESPONSE=$(curl -s -H "Accept: application/fhir+json" \
    "$BASE/ValueSet/fr-communes-actives/\$expand?count=$COUNT&offset=$OFFSET")

  # Extraire le total (nécessite jq)
  TOTAL=$(echo "$RESPONSE" | jq '.expansion.total')

  echo "Page offset=$OFFSET / total=$TOTAL"
  echo "$RESPONSE" | jq '.expansion.contains[].code'

  OFFSET=$((OFFSET + COUNT))
done
```

#### Règles à respecter

| Règle | Valeur recommandée |
|---|---|
| `count` max par page (`$expand`) | 500 (au-delà certains serveurs tronquent) |
| `_count` max par page (recherche) | 100–200 |
| Présence de `expansion.total` | Obligatoire pour calculer le nombre de pages — vérifier que le serveur le retourne |
| Lien `next` dans Bundle | À préférer au calcul manuel d'offset pour les recherches |

---

## Références

### Sources Officielles

- **INSEE - Code Officiel Géographique** : https://www.insee.fr/fr/information/6800675
- **SMT e-santé (ANS) — TRE-R13** : https://smt.esante.gouv.fr/fhir/CodeSystem/TRE-R13-CommuneOM
- **La Poste - Base HEXASIMAL** : https://datanova.laposte.fr/datasets/laposte-hexasmal
- **API Découpage Administratif** : https://geo.api.gouv.fr/decoupage-administratif

### CodeSystems FHIR

- [Communes INSEE CodeSystem (CPage interne)](CodeSystem-communes-insee-cs.html)
- [Communes COG TRE-R13 CodeSystem](CodeSystem-fr-commune-cog.html)
- [Codes Postaux CodeSystem](CodeSystem-codes-postaux-cs.html)
- [Communes COG actives ValueSet](ValueSet-fr-communes-actives.html)
- [Communes COG complet ValueSet (actives + historiques)](ValueSet-fr-communes-cog-complet.html)
- [Communes INSEE ValueSet](ValueSet-communes-insee-vs.html)
- [Codes Postaux ValueSet](ValueSet-codes-postaux-vs.html)
- [NamingSystem COG INSEE](NamingSystem-insee-cog-commune.html)

### Exemples FHIR

- [Patient — commune déléguée](Patient-ExemplePatientCommuneDeleguee.html)
- [Organisation — commune nouvelle](Organization-ExempleOrganisationCommuneNouvelle.html)
- [Parameters — $lookup commune déléguée → commune nouvelle](Parameters-ExempleParametersLookupCommuneNouvelle.html)
- [Parameters — $lookup commune inactive → successeur](Parameters-ExempleParametersLookupSuccesseur.html)
- [Parameters — $expand communes supprimées (exists)](Parameters-ExempleParametersExpandCommunesSupprimees.html)
- [Parameters — $expand communes créées en 2025 (regex)](Parameters-ExempleParametersExpandCommunesCrees2025.html)
- [Parameters — $changes-since requête](Parameters-ExempleParametersChangesSinceRequest.html)
- [Parameters — $changes-since réponse](Parameters-ExempleParametersChangesSinceResponse.html)

### Voir Aussi

- [Guide d'implémentation](index.html) - Vue d'ensemble du référentiel
- [Structure des organisations](tiers-organization.md) - Comment structurer les adresses
- [Scripts de génération](https://github.com/GIPCPAGE/masterdata/tree/master/scripts) - Générer listes complètes

---

## Support

Pour toute question sur l'utilisation des données géographiques :
- Consulter la [documentation INSEE](https://www.insee.fr/fr/information/2560452)
- Vérifier les [changements annuels du COG](https://www.insee.fr/fr/information/2666684)
- Contacter l'équipe du référentiel pour signaler des incohérences
