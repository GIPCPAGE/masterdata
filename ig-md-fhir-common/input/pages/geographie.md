# Axe Nomenclatures — Données Géographiques COG

## Vue d'ensemble

Le référentiel expose les **données géographiques officielles françaises** pour valider et normaliser les adresses :

- **~36 000 communes** selon le Code Officiel Géographique (COG) INSEE
- **~6 000 codes postaux** selon la base La Poste

### Deux modèles complémentaires

| Modèle | CodeSystem | Usage |
|--------|------------|-------|
| **CPage interne** | `communes-insee-cs` (URL CPage) | Legacy, compatibilité systèmes existants |
| **TRE-R13 (recommandé)** | `fr-commune-cog` — URL ANS SMT | Interopérabilité nationale, communes déléguées, historique fusions |

Pour tout nouveau développement, utiliser le **modèle TRE-R13**.

---

## Codes Commune INSEE

Chaque commune française possède un code **5 caractères** : 2 chiffres département + 3 chiffres commune.
Exemples : Paris = `75056`, Marseille = `13055`, Lyon = `69123`.

**URL** : `https://www.cpage.fr/ig/masterdata/geo/CodeSystem/communes-insee-cs`
**Source** : [INSEE - Code Officiel Géographique](https://www.insee.fr/fr/information/6800675) — mise à jour annuelle (janvier).

> ⚠ Pour les échanges interopérables, préférer l'extension FR Core `fr-core-address-insee-code` avec le CodeSystem TRE-R13 (voir section suivante).

---

## Codes Postaux Français

Identifiants La Poste de **5 chiffres**. Un code postal peut couvrir plusieurs communes ; une grande ville peut avoir plusieurs codes postaux (Paris : 20 codes, Lyon : 9 codes, Marseille : 16 codes).

**URL** : `https://www.cpage.fr/ig/masterdata/geo/CodeSystem/codes-postaux-cs`
**Source** : [La Poste - HEXASIMAL](https://datanova.laposte.fr/datasets/laposte-hexasmal) — mise à jour annuelle.

---

## Gestion de l'Historique

Les communes évoluent chaque année (fusions, créations, suppressions). Les propriétés temporelles permettent de valider des adresses historiques.

| Propriété | Description |
|-----------|-------------|
| `status` | `active` / `inactive` / `deprecated` |
| `effectiveDate` | Date d'entrée en vigueur |
| `deprecationDate` | Date de suppression/fusion |
| `replacedBy` | Code commune de remplacement |
| `parent` | Code département (2 chiffres) |

---

## Modélisation COG via TRE-R13 (ANS SMT)

### Architecture des ressources

| Ressource | Id | Rôle |
|-----------|-----|------|
| **CodeSystem** | [`fr-commune-cog`](CodeSystem-fr-commune-cog.html) | Codes COG avec propriétés historiques et hiérarchie `part-of` |
| **ValueSet** | [`fr-communes-actives`](ValueSet-fr-communes-actives.html) | Communes en vigueur (`inactive = false`) |
| **ValueSet** | [`fr-communes-cog-complet`](ValueSet-fr-communes-cog-complet.html) | Toutes les communes (actives + historique) |
| **NamingSystem** | [`insee-cog-commune`](NamingSystem-insee-cog-commune.html) | OID `1.2.250.1.213.2.12` + URI ANS SMT |

**URL canonique CodeSystem** : `https://smt.esante.gouv.fr/fhir/CodeSystem/TRE-R13-CommuneOM`

### Quel ValueSet utiliser ?

| Besoin | ValueSet |
|--------|----------|
| Saisie d'adresse, validation courante | [`fr-communes-actives`](ValueSet-fr-communes-actives.html) |
| Migration, audit, données historiques | [`fr-communes-cog-complet`](ValueSet-fr-communes-cog-complet.html) |

### Modèle hiérarchique (`hierarchyMeaning = part-of`)

```
CodeSystem TRE-R13-CommuneOM
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
  ?system=https://smt.esante.gouv.fr/fhir/CodeSystem/TRE-R13-CommuneOM
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
  ?system=https://smt.esante.gouv.fr/fhir/CodeSystem/TRE-R13-CommuneOM
  &code=69282
  &property=inactive&property=dateSuppression&property=successeur
```

→ retourne `inactive=true`, `dateSuppression=2019-01-01`, `successeur=69264`.
Exemple FSH : [`ExempleParametersLookupSuccesseur`](Parameters-ExempleParametersLookupSuccesseur.html)

---

### `$validate-code` — Vérifier qu'une commune est active

```http
GET [base]/ValueSet/fr-communes-actives/$validate-code
  ?system=https://smt.esante.gouv.fr/fhir/CodeSystem/TRE-R13-CommuneOM
  &code=69264
```

---

### `$expand` — Lister les communes

```http
# Communes actives
GET [base]/ValueSet/fr-communes-actives/$expand?count=20&offset=0

# Historique complet (actives + inactives)
GET [base]/ValueSet/fr-communes-cog-complet/$expand?count=100&offset=0
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