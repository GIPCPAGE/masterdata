# Guide d'Intégration REST

## Vue d'ensemble

Correspondances entre les données sources et les **profils FHIR cibles** de l'Axe Concepts Métiers.

| Source | Profil FHIR cible |
|--------|-------------------|
| Données fournisseurs | [`FournisseurProfile`](StructureDefinition-fournisseur-profile.html) |
| Données débiteurs/clients | [`DebiteurProfile`](StructureDefinition-debiteur-profile.html) |
| Organismes payeurs | [`PayeurSanteProfile`](StructureDefinition-payeur-sante-profile.html) |

Les communes INSEE dans les adresses : voir [Données Géographiques COG](geographie.html).

---

## API REST — Opérations FHIR

| Opération | Méthode | URL |
|-----------|---------|-----|
| Créer | `POST` | `[base]/Organization` |
| Lire | `GET` | `[base]/Organization/{id}` |
| Modifier | `PUT` | `[base]/Organization/{id}` |
| Rechercher | `GET` | `[base]/Organization?[critères]` |
| Supprimer | `DELETE` | `[base]/Organization/{id}` |

**Format** : JSON FHIR R4 · `Content-Type: application/fhir+json` · Encodage UTF-8

---

## Mappings de champs

### Fournisseur → FournisseurProfile

| Champ source | Élément FHIR |
|--------------|-------------|
| Raison sociale | `Organization.name` |
| SIRET | `Organization.identifier[system=sirene]` |
| Code fournisseur | `extension[codeFournisseur].valueString` |
| Adresse | `Organization.address` |
| IBAN / BIC | `extension[tiersBankAccount]` |
| Délai paiement | `extension[fournisseurPaiement].delaiReglement` |
| Compte classe 6 | `extension[fournisseurComptabilite].compteClasse6` |

### Débiteur → DebiteurProfile

| Champ source | Élément FHIR |
|--------------|-------------|
| Raison sociale | `Organization.name` |
| Code client | `extension[debiteurCode].valueString` |
| Type (Normal/Occ.) | `extension[tiersDebtorType].valueCode` |
| Résidence fiscale | `extension[debiteurTypeResident].valueCode` |
| IBAN | `extension[tiersBankAccount]` (obligatoire) |

### Organisme Payeur → PayeurSanteProfile

| Champ source | Élément FHIR |
|--------------|-------------|
| Nom organisme | `Organization.name` |
| Type RO/RC | `extension[payeurSante].typePaiement` |
| Grand régime | `extension[payeurSante].grandRegime` |
| Code centre | `extension[payeurSante].codeCentre` |
| Numéro caisse | `extension[payeurSante].numeroCaisse` |

---

## Scénarios courants

### Import depuis un système existant

1. Vérifier si l'organisation existe : `GET [base]/Organization?identifier=...|{SIRET}`
2. Si absent → `POST [base]/Organization`
3. Si présent → `PUT [base]/Organization/{id}`

### Synchronisation bidirectionnelle

- **Push** : déclencher `POST`/`PUT` à chaque modification de votre système
- **Pull** : interroger les changements récents avec `?_lastUpdated=gt{date}`
- **Conflits** : le référentiel fait autorité (source de vérité)

### Recherche

```http
GET [base]/Organization?name:contains=hopital
GET [base]/Organization?tiers-role=supplier
GET [base]/Organization?tiers-category=27
GET [base]/Organization?identifier=...|{SIRET}
```

---

## Voir aussi

- [Profils Tiers](tiers-organization.html) · [Paramètres de recherche](search-parameters.html) · [Exemples](examples.html)