# ✅ CodeSystems Géographiques - Références Externes avec Gestion Temporelle

**Date** : 2026-03-17  
**Approche** : Références vers sources officielles + Documentation des propriétés temporelles

## 🎯 Nouvelle Approche : Références Externes

Au lieu d'énumérer tous les codes postaux (~6 328) et communes (~35 000) dans les fichiers FSH, les CodeSystems **font référence aux sources officielles externes** et documentent comment gérer l'historique.

### Avantages

✅ **Fichiers légers** : 10 KB (communes), 6 KB (codes postaux) au lieu de 152 KB  
✅ **Maintenance simplifiée** : Les codes sont maintenus par INSEE et La Poste  
✅ **Historique documenté** : Explications détaillées de la gestion temporelle  
✅ **Conforme FHIR** : Utilisation de `content = #not-present`  
✅ **API exemples** : Requêtes FHIR pour validation temporelle

## 📄 Fichiers Mis à Jour

### 1. Codes Postaux

**Fichier** : [`input/fsh/codesystems/CodesPostauxCodeSystem.fsh`](input/fsh/codesystems/CodesPostauxCodeSystem.fsh) (6 KB)

**Contenu** :
```fsh
CodeSystem: CodesPostauxCodeSystem
* ^content = #not-present  // Pas de liste exhaustive
* ^copyright = "Source: La Poste - Base HEXASIMAL"
```

**Source officielle** : https://datanova.laposte.fr/datasets/laposte-hexasmal  
**Format** : 5 chiffres (75001, 13055, 69001)  
**Codes** : ~6 328 codes postaux français

### 2. Communes INSEE

**Fichier** : [`input/fsh/codesystems/CommunesINSEECodeSystem.fsh`](input/fsh/codesystems/CommunesINSEECodeSystem.fsh) (10 KB)

**Contenu** :
```fsh
CodeSystem: CommunesINSEECodeSystem
* ^content = #not-present  // Pas de liste exhaustive
* ^copyright = "Source: INSEE - Code Officiel Géographique (COG)"
```

**Source officielle** : https://www.insee.fr/fr/information/6800675  
**Format** : 5 caractères (75056, 13055, 69123)  
**Codes** : ~35 000 communes françaises actives

## 📊 Propriétés Temporelles Déclarées

### Pour les Codes Postaux

| Propriété | URI | Type | Description |
|-----------|-----|------|-------------|
| `status` | http://hl7.org/fhir/concept-properties#status | code | active \| inactive \| deprecated |
| `effectiveDate` | http://hl7.org/fhir/concept-properties#effectiveDate | dateTime | Date de mise en service |
| `deprecationDate` | http://hl7.org/fhir/concept-properties#deprecationDate | dateTime | Date de suppression |
| `replacedBy` | - | code | Code postal de remplacement |
| `communeInsee` | - | string | Code INSEE commune principale |

### Pour les Communes

| Propriété | URI | Type | Description |
|-----------|-----|------|-------------|
| `status` | http://hl7.org/fhir/concept-properties#status | code | active \| inactive \| deprecated |
| `effectiveDate` | http://hl7.org/fhir/concept-properties#effectiveDate | dateTime | Date de création/modification |
| `deprecationDate` | http://hl7.org/fhir/concept-properties#deprecationDate | dateTime | Date de fusion/suppression |
| `replacedBy` | - | code | Code INSEE de remplacement |
| `parent` | http://hl7.org/fhir/concept-properties#parent | code | Code département |
| `region` | - | code | Code région INSEE |

## 🔍 Exemples de Modélisation Historique

### Exemple 1 : Commune Active

**Paris** (code 75056)

```json
{
  "code": "75056",
  "display": "Paris",
  "property": [
    {"code": "status", "valueCode": "active"},
    {"code": "effectiveDate", "valueDateTime": "1943-01-01"},
    {"code": "parent", "valueCode": "75"},
    {"code": "region", "valueCode": "11"}
  ]
}
```

**Validation** :
- ✅ Valide depuis 1943-01-01
- ✅ Toujours active
- ✅ Département 75 (Paris)
- ✅ Région 11 (Île-de-France)

### Exemple 2 : Commune Fusionnée

**Villepreux** (ancien code 78674, fusionnée en 2019)

```json
{
  "code": "78674",
  "display": "Villepreux (ancienne commune)",
  "property": [
    {"code": "status", "valueCode": "inactive"},
    {"code": "effectiveDate", "valueDateTime": "1790-01-01"},
    {"code": "deprecationDate", "valueDateTime": "2019-01-01"},
    {"code": "replacedBy", "valueCode": "78640"}
  ]
}
```

**Validation** :
- ✅ Valide du 1790-01-01 au 2018-12-31
- ❌ Invalide depuis le 2019-01-01
- 🔄 Remplacée par le code 78640

**Utilisation temporelle** :
```
Date         Code valide ?  Raison
2018-06-15   ✅ OUI        1790-01-01 <= 2018-06-15 < 2019-01-01
2019-06-15   ❌ NON        2019-06-15 >= deprecationDate
             → Utiliser 78640 (replacedBy)
```

### Exemple 3 : Commune Nouvelle

**Évry-Courcouronnes** (code 91228, créée en 2019 par fusion)

```json
{
  "code": "91228",
  "display": "Évry-Courcouronnes",
  "property": [
    {"code": "status", "valueCode": "active"},
    {"code": "effectiveDate", "valueDateTime": "2019-01-01"},
    {"code": "parent", "valueCode": "91"},
    {"code": "region", "valueCode": "11"}
  ]
}
```

**Contexte historique** :
- Anciennes communes : 91225 (Courcouronnes) + 91228 (Évry)
- Date fusion : 2019-01-01
- Nouvelle commune : 91228 (Évry-Courcouronnes)
- Les anciens codes ont `status=inactive` et `deprecationDate=2019-01-01`

## 📝 Validation Temporelle

### Règles de Validation

Pour valider qu'un code est valide à une date donnée :

1. **date >= effectiveDate** (le code existait déjà)
2. **ET** (**date < deprecationDate** OU **deprecationDate absent**)
3. **Si status = inactive**, vérifier la date de fusion

### Algorithme

```javascript
function estValide(code, date) {
  // Récupérer les propriétés du code
  const effectiveDate = code.property.find(p => p.code === 'effectiveDate')?.valueDateTime;
  const deprecationDate = code.property.find(p => p.code === 'deprecationDate')?.valueDateTime;
  const status = code.property.find(p => p.code === 'status')?.valueCode;
  
  // Vérifier les dates
  if (effectiveDate && date < effectiveDate) return false;
  if (deprecationDate && date >= deprecationDate) return false;
  
  // Vérifier le statut
  if (status === 'deprecated') return false;
  
  return true;
}
```

### Exemples de Validation

```javascript
// Villepreux (78674)
estValide("78674", "2018-06-15")  // ✅ true
estValide("78674", "2019-06-15")  // ❌ false

// Paris (75056)
estValide("75056", "2024-06-15")  // ✅ true (toujours active)

// Mouen (14472) - créée en 2024
estValide("14472", "2023-12-31")  // ❌ false (pas encore créée)
estValide("14472", "2024-01-15")  // ✅ true (créée le 01/01/2024)
```

## 🔌 API FHIR pour Requêtes Temporelles

### 1. Valider un code à une date

**Requête** :
```http
GET [base]/CodeSystem/$validate-code?
  system=https://www.cpage.fr/ig/masterdata/geo/CodeSystem/communes-insee-cs
  &code=78674
  &date=2018-06-15
```

**Réponse** :
```json
{
  "parameter": [
    {"name": "result", "valueBoolean": true},
    {"name": "message", "valueString": "Code valide à cette date"}
  ]
}
```

### 2. Récupérer les propriétés temporelles

**Requête** :
```http
GET [base]/CodeSystem/$lookup?
  system=https://www.cpage.fr/ig/masterdata/geo/CodeSystem/communes-insee-cs
  &code=78674
  &property=effectiveDate
  &property=deprecationDate
  &property=status
  &property=replacedBy
```

**Réponse** :
```json
{
  "parameter": [
    {"name": "code", "valueCode": "78674"},
    {"name": "display", "valueString": "Villepreux (ancienne commune)"},
    {"name": "property", "part": [
      {"name": "code", "valueCode": "status"},
      {"name": "value", "valueCode": "inactive"}
    ]},
    {"name": "property", "part": [
      {"name": "code", "valueCode": "effectiveDate"},
      {"name": "value", "valueDateTime": "1790-01-01"}
    ]},
    {"name": "property", "part": [
      {"name": "code", "valueCode": "deprecationDate"},
      {"name": "value", "valueDateTime": "2019-01-01"}
    ]},
    {"name": "property", "part": [
      {"name": "code", "valueCode": "replacedBy"},
      {"name": "value", "valueCode": "78640"}
    ]}
  ]
}
```

### 3. Trouver le code de remplacement

**Requête** :
```http
GET [base]/CodeSystem/$lookup?code=78674&property=replacedBy
```

Puis récupérer la nouvelle commune :

```http
GET [base]/CodeSystem/$lookup?code=78640
```

### 4. Rechercher les communes actives

**Requête** :
```http
GET [base]/ValueSet/$expand?
  url=https://www.cpage.fr/ig/masterdata/geo/ValueSet/communes-insee-vs
  &filter=active
  &date=2024-01-01
```

## 📚 Documentation dans les Fichiers FSH

Les fichiers FSH contiennent maintenant :

✅ **Déclarations de propriétés** avec URIs et descriptions  
✅ **Exemples détaillés** de modélisation historique  
✅ **Règles de validation** temporelle  
✅ **Requêtes FHIR** pour interroger l'historique  
✅ **Codes région INSEE** (métropole + DROM)  
✅ **Exemples de codes** (Paris, Marseille, Lyon, etc.)

**Voir** :
- [`CodesPostauxCodeSystem.fsh`](input/fsh/codesystems/CodesPostauxCodeSystem.fsh) - Lignes 50-150
- [`CommunesINSEECodeSystem.fsh`](input/fsh/codesystems/CommunesINSEECodeSystem.fsh) - Lignes 80-250

## 🎯 Utilisation en Production

### Implémentation Recommandée

1. **Serveur de terminologie FHIR** avec les CodeSystems chargés depuis INSEE/La Poste
2. **Base de données temporelle** maintenant l'historique des codes
3. **API de validation** utilisant les propriétés temporelles
4. **Cache** des codes actifs pour performance

### Exemple d'Architecture

```
┌─────────────────┐
│  Application    │
└────────┬────────┘
         │ Validation code + date
         ↓
┌─────────────────┐
│  Serveur FHIR   │
│  Terminology    │
└────────┬────────┘
         │
         ↓
┌─────────────────┐      ┌──────────────┐
│  Code System    │←─────│ INSEE COG    │
│  avec propriétés│      │ (source)     │
│  temporelles    │      └──────────────┘
└─────────────────┘
         │
         ↓
    Validation temporelle
    (effectiveDate, deprecationDate)
```

## 🔄 Migration depuis les Listes Complètes

### Avant (liste exhaustive)

```fsh
* ^content = #complete
* ^count = 6328
* #75001 "PARIS 01"
* #75002 "PARIS 02"
... (6326 autres codes)
```

**Problème** :
- ❌ Fichiers volumineux (152 KB)
- ❌ Maintenance difficile
- ❌ Pas d'historique

### Après (référence externe)

```fsh
* ^content = #not-present
* ^copyright = "Source: La Poste HEXASIMAL"
// Documentation des propriétés temporelles
```

**Avantages** :
- ✅ Fichiers légers (6 KB)
- ✅ Source officielle référencée
- ✅ Historique documenté

## ✨ Résumé

| Aspect | Valeur |
|--------|--------|
| **Approche** | Références externes + Documentation temporelle |
| **Fichiers** | 10 KB (communes) + 6 KB (codes postaux) |
| **Compilation** | ✅ 0 Errors, 0 Warnings |
| **Propriétés** | 6 (communes) + 5 (codes postaux) |
| **Documentation** | Exemples détaillés validation temporelle |
| **APIs FHIR** | $validate-code, $lookup avec dates |
| **Sources** | INSEE COG + La Poste HEXASIMAL |

---

**Commit** : 8faff43  
**Message** : "refactor(geo): Replace code lists with external references and temporal property documentation"  
**Repository** : https://github.com/GIPCPAGE/masterdata.git
