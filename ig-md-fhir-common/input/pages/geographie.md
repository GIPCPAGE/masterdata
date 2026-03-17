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
