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

## Références

### Sources Officielles

- **INSEE - Code Officiel Géographique** : https://www.insee.fr/fr/information/6800675
- **La Poste - Base HEXASIMAL** : https://datanova.laposte.fr/datasets/laposte-hexasmal
- **API Découpage Administratif** : https://geo.api.gouv.fr/decoupage-administratif

### CodeSystems FHIR

- [Communes INSEE CodeSystem](CodeSystem-communes-insee-cs.html)
- [Codes Postaux CodeSystem](CodeSystem-codes-postaux-cs.html)
- [Communes INSEE ValueSet](ValueSet-communes-insee-vs.html)
- [Codes Postaux ValueSet](ValueSet-codes-postaux-vs.html)

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
