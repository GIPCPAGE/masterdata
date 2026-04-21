# Axe Nomenclatures — Données Géographiques COG

## Vue d'ensemble

Le référentiel expose les **données géographiques officielles françaises** pour valider et normaliser les adresses :

- **~36 000 communes** selon le Code Officiel Géographique (COG) INSEE
- Historique complet : fusions, créations, suppressions (mise à jour annuelle 1er janvier)

Chaque commune possède un code **5 caractères** : 2 chiffres département + 3 chiffres commune.
Exemples : Paris = `75056`, Marseille = `13055`, Lyon = `69123`.

---

## Architecture des ressources

| Ressource | Id | Rôle |
|-----------|-----|------|
| **CodeSystem** | [`communes-fr-cs`](CodeSystem-communes-fr-cs.html) | Codes COG avec propriétés historiques et hiérarchie `part-of` |
| **ValueSet** | [`communes-fr-actives-vs`](ValueSet-communes-fr-actives-vs.html) | Communes en vigueur (`inactive = false`) |
| **NamingSystem** | [`insee-cog-commune`](NamingSystem-insee-cog-commune.html) | OID `1.2.250.1.213.2.12` + URI CPage |

**URL canonique CodeSystem** : `https://www.cpage.fr/ig/masterdata/common/CodeSystem/communes-fr-cs`
**Source** : [INSEE — Code Officiel Géographique](https://www.insee.fr/fr/information/6800675)

---

## Propriétés du CodeSystem

| Propriété | Type | Description |
|-----------|------|-------------|
| `inactive` | boolean | `true` si la commune a été supprimée ou fusionnée |
| `dateCreation` | dateTime | Date de création de la commune |
| `dateSuppression` | dateTime | Date de suppression / fusion |
| `successeur` | code | Code de la commune qui remplace (en cas de fusion) |
| `predecesseur` | code | Code(s) des communes absorbées (répétable) |
| `codePostal` | string | Code(s) postal(aux) associé(s) (répétable) |
| `typeTerritoire` | code | `commune` \| `commune-nouvelle` \| `commune-deleguee` |
| `codeDepartement` | code | Code département (2 caractères) |
| `codeRegion` | code | Code région (2 chiffres) |
| `communeNouvelle` | code | Si commune déléguée : code de la commune nouvelle parente |

---

## Modèle hiérarchique (`hierarchyMeaning = part-of`)

```
CodeSystem communes-fr-cs
├── 69282  Saint-Jean-d'Ardières    [inactive=true,  successeur=69264]
└── 69264  Belleville-en-Beaujolais [inactive=false, typeTerritoire=commune-nouvelle]
    ├── 69282  (déléguée) Saint-Jean-d'Ardières  [typeTerritoire=commune-deleguee]
    └── 69019  (déléguée) Belleville-sur-Saône   [typeTerritoire=commune-deleguee]
```

Le code `69282` apparaît deux fois : commune historique inactive en racine, et commune déléguée active sous `69264`.

---

## Opérations terminologiques

### `$lookup` — Résoudre une commune déléguée → commune nouvelle

```http
GET [base]/CodeSystem/$lookup
  ?system=https://www.cpage.fr/ig/masterdata/common/CodeSystem/communes-fr-cs
  &code=69282
  &property=communeNouvelle
  &property=typeTerritoire
```

→ retourne `communeNouvelle = 69264` (Belleville-en-Beaujolais).
Exemple FSH : [`ExempleParametersLookupCommuneNouvelle`](Parameters-ExempleParametersLookupCommuneNouvelle.html)

---

### `$lookup` — Retrouver le successeur d'une commune inactive

```http
GET [base]/CodeSystem/$lookup
  ?system=https://www.cpage.fr/ig/masterdata/common/CodeSystem/communes-fr-cs
  &code=69282
  &property=inactive&property=dateSuppression&property=successeur
```

→ retourne `inactive=true`, `dateSuppression=2019-01-01`, `successeur=69264`.
Exemple FSH : [`ExempleParametersLookupSuccesseur`](Parameters-ExempleParametersLookupSuccesseur.html)

---

### `$validate-code` — Vérifier qu'une commune est active

```http
GET [base]/ValueSet/communes-fr-actives-vs/$validate-code
  ?system=https://www.cpage.fr/ig/masterdata/common/CodeSystem/communes-fr-cs
  &code=69264
```

---

### `$expand` — Lister les communes actives

```http
GET [base]/ValueSet/communes-fr-actives-vs/$expand?count=20&offset=0
```

---

### `$changes-since` — Synchronisation périodique (extension de cet IG)

```http
GET [base]/CodeSystem/fr-commune-cog/$changes-since?date=2025-01-01
```

| Paramètre | Requis | Description |
|-----------|--------|-------------|
| `date` | ✅ | Date de référence inclusive (`>=`) |
| `typeTerritoire` | Non | Filtrer par type (`commune`, `commune-nouvelle`, `commune-deleguee`) |
| `includeCreations` | Non | Inclure les nouvelles communes (défaut : true) |
| `includeSuppressions` | Non | Inclure les communes fusionnées/supprimées (défaut : true) |

Exemples FSH : [`ExempleParametersChangesSinceRequest`](Parameters-ExempleParametersChangesSinceRequest.html) · [`ExempleParametersChangesSinceResponse`](Parameters-ExempleParametersChangesSinceResponse.html)

---

## Utilisation dans les adresses FHIR

L'extension FR Core `fr-core-address-insee-code` se pose sur `_city` (JSON) :

```json
{
  "address": [{
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

**Règle de choix du code** :

| Situation | Code à utiliser |
|-----------|----------------|
| Commune ordinaire active | Code de la commune (`69264`) |
| Commune déléguée (adresse de résidence réelle) | Code de la déléguée (`69282`), puis `$lookup communeNouvelle` pour l'adresse administrative |

Exemples FSH : [`ExemplePatientCommuneDeleguee`](Patient-ExemplePatientCommuneDeleguee.html) · [`ExempleOrganisationCommuneNouvelle`](Organization-ExempleOrganisationCommuneNouvelle.html)

---

## Voir aussi

- [Profils Tiers](tiers-organization.html) — utilisation des adresses avec codes communes
- [Exemples](examples.html) — exemples concrets avec communes déléguées et nouvelles
- [Artifacts de conformité](artifacts.html) — définitions FHIR des CodeSystems et ValueSets