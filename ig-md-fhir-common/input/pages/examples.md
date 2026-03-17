# Exemples d'Usage - Cas Pratiques

## Vue d'ensemble

Cette page présente des **exemples concrets d'utilisation** des profils Tiers dans des cas réels de gestion hospitalière. Chaque exemple illustre une situation métier spécifique avec les données FHIR correspondantes et les mappings GEF associés.

---

## Exemple 1 : Tiers Multi-Rôles Complet

### Contexte métier

**Multiservices Santé et Logistique (MSL)** est une entreprise qui :
- **Fournit** des équipements médicaux (rôle supplier)
- **Achète** des prestations d'entretien (rôle debtor)
- **Gère** des remboursements santé pour ses employés (rôle payer)

### Profil utilisé

[TiersProfile](StructureDefinition-tiers-profile.html) - Profil de base permettant le multi-rôle

### Fichier FSH

[ExempleTiersComplet.fsh](Organization-ExempleTiersComplet.html)

### Points clés

✅ **Multi-rôle simultané** : Un seul Organization avec 3 rôles  
✅ **Extensions conditionnelles** : Fournisseur (code + comptabilité + paiement) + Débiteur (code + paramètres) + Payeur (santé)  
✅ **Domiciliation bancaire** : 1 compte avec EDI activé, moyens de paiement multiples  
✅ **Identifiants multiples** : SIRET + FINESS + etierId  

### Cas d'usage

- ✅ Recherche multi-critères : `?tiers-role=supplier&tiers-role=debtor&tiers-role=payer`
- ✅ Facturation bidirectionnelle : Émet factures (fournisseur) ET reçoit factures (débiteur)
- ✅ Gestion consolidée : Une seule fiche pour tous les échanges

---

## Exemple 2 : Tiers Double Rôle (Fournisseur + Débiteur)

### Contexte métier

**Clinique du Parc (CDP)** est un établissement de santé privé qui :
- **Vend** des consultations et actes médicaux à d'autres établissements (rôle supplier)
- **Achète** des médicaments et équipements auprès de laboratoires (rôle debtor)

### Profil utilisé

[TiersProfile](StructureDefinition-tiers-profile.html) avec double rôle

### Fichier FSH

[ExempleTiersDoubleRole.fsh](Organization-ExempleTiersDoubleRole.html)

### Points clés

✅ **Échanges bidirectionnels** : Client ET fournisseur du même partenaire  
✅ **Comptes bancaires multiples** : Compte principal (virements standards) + Compte gros montant  
✅ **Classification GEF** : TG Category #03 (Clinique), Nature juridique SAS  
✅ **Extensions distinctes** : Paramètres fournisseur distincts des paramètres débiteur  

### Cas d'usage

- ✅ Conventions inter-établissements : Échange de prestations médicales
- ✅ Gestion complexe achats/ventes : Délais paiement différents selon le sens
- ✅ Rapprochement comptable : Soldes créditeurs ET débiteurs simultanés

---

## Exemple 3 : Succursale avec partOf

### Contexte métier

**Centre Médical Raspail - Annexe Montparnasse** est une succursale rattachée à la **Clinique du Parc**. Elle sert de :
- Point de livraison pour fournitures médicales
- Adresse de facturation pour consultations externes

### Profil utilisé

[TiersProfile](StructureDefinition-tiers-profile.html) avec `partOf` + extension `succursaleUsage`

### Fichier FSH

[ExempleSuccursale.fsh](Organization-ExempleSuccursale.html)

### Points clés

✅ **Relation hiérarchique** : `partOf` référence l'établissement principal  
✅ **Usage qualifié** : Extension `succursaleUsage` = POINT_LIVRAISON + FACTURATION  
✅ **SIRET distinct** : La succursale a son propre SIRET (différent du siège)  
✅ **Compte bancaire local** : Domiciliation peut différer de l'établissement parent  

### Distinction : partOf vs héritageProfile

| Concept | Type | Exemple | Moment |
|---------|------|---------|--------|
| **partOf** | Relation d'instance (runtime) | Succursale → Siège | Données |
| **Parent: TiersProfile** | Héritage de profil (compile-time) | FournisseurProfile → TiersProfile | Définition |

**partOf** n'est PAS un héritage ! C'est une référence organisationnelle.

### Cas d'usage

- ✅ Gestion multi-sites : Établissement avec plusieurs adresses opérationnelles
- ✅ Logistique : Livraisons directes sur sites secondaires
- ✅ Facturation décentralisée : Chaque site émet ses propres factures

---

## Exemple 4 : Fournisseur Complet (EFOU)

### Contexte métier

**Laboratoires Pharmaceutiques Durand (LPD)** est un fournisseur de médicaments avec :
- Paramètres comptables complets (comptes lettre classe 2 et 6)
- Délais de paiement négociés : 60 jours, paiement le 10
- Affacturage activé
- Moyens de paiement : Virements + Virements externes

### Profil utilisé

[FournisseurProfile](StructureDefinition-fournisseur-profile.html) - Conforme EFOU GEF

### Fichier FSH

[ExempleFournisseurComplet.fsh](Organization-ExempleFournisseurComplet.html)

### Points clés

✅ **Mapping EFOU complet** : Toutes positions 1-262 couvertes  
✅ **Comptabilité détaillée** : Compte classe 2 (4011LPD) + classe 6 (6012MED)  
✅ **Conditions paiement** : Délai 60j, jour 10, montant min 1000€, taux transitaire 3.5%, escomptable  
✅ **Banking avancé** : EDI + Affacturage + 2 comptes (standard + numéraire/chèque)  

### Mapping GEF EFOU

| Position EFOU | Longueur | Mapping FHIR |
|---------------|----------|--------------|
| 4-14 | 14 | identifier[etierId].value (FRNS0000123456) |
| 18-32 | 32 | name (Laboratoires Pharmaceutiques Durand) |
| 50-32 | 32 | alias (LPD SA) |
| 82-146 | 64 | address (rue, complément, CP, ville) |
| 183-203 | 20 | telecom[phone] (+33147896543) |
| 203-223 | 20 | telecom[fax] (+33147896544) |
| 223-14 | 14 | identifier[siret].value (42512345600018) |
| 237 | 1 | extension[tgCategory] (26 = Entreprise) |
| 239-5 | 5 | identifier.extension[gefType] (05 = TVA UE) |

### Cas d'usage

- ✅ Import EFOU → FHIR : Synchronisation depuis système financier GEF
- ✅ Validation paiements : Vérification conditions contractuelles avant règlement
- ✅ Affacturage : Cession créances au factor selon flag activé

---

## Exemple 5 : Débiteur Complet (KERD)

### Contexte métier

**CHU Necker-Enfants Malades** est un débiteur (établissement acheteur) avec :
- Type débiteur : Normal (N) - compte permanent
- Résidence fiscale : Résident (R)
- Autorisation assurances : Oui
- Force impression COH (Commande Ouverte Hôpital) : Oui
- 2 comptes bancaires (virements standards + gros montants)

### Profil utilisé

[DebiteurProfile](StructureDefinition-debiteur-profile.html) - Conforme KERD GEF

### Fichier FSH

[ExempleDebiteurComplet.fsh](Organization-ExempleDebiteurComplet.html)

### Points clés

✅ **Mapping KERD complet** : Tous champs CSV couverts  
✅ **Paramètres comptables** : Compte lettre 411NECKER pour recettes  
✅ **Type débiteur** : Normal (vs Occasionnel = compte temporaire)  
✅ **Banking obligatoire** : RIB 1..* MS (au moins un compte requis pour recettes)  
✅ **Gestion avancée** : Autorisation assurances + COH pour centralisation achats  

### Mapping GEF KERD (CSV)

| Champ KERD | Mapping FHIR |
|------------|--------------|
| Code débiteur | extension[codeDebiteur].value (DEBNECKER01) |
| Raison sociale | name (Centre Hospitalier Universitaire Necker) |
| SIRET | identifier[siret].value (78912345600011) |
| FINESS | identifier[finess].value (920023456) |
| Type débiteur | extension[debtorType].value (N = Normal) |
| Type résident | extension[parametres].extension[typeResident] (R) |
| Compte lettre | extension[parametres].extension[compteLettre] (411NECKER) |
| RIB (obligatoire) | extension[bankAccount] 1..* MS |
| Code banque | extension[bankAccount].extension[bankCode] (30001) |
| IBAN | extension[bankAccount].extension[iban] (FR76...) |

### Cas d'usage

- ✅ Import KERD → FHIR : Synchronisation depuis système financier GEF
- ✅ Gestion recettes : Encaissement prestations vendues à autres établissements
- ✅ Autorisation assurances : Paiement direct par mutuelles autorisé

---

## Exemple 6 : Payeur Santé CPAM (Régime Obligatoire)

### Contexte métier

**CPAM de Paris** est un organisme payeur d'assurance maladie du régime obligatoire qui :
- Rembourse les prestations de soins sur présentation FSE
- Appartient au grand régime Sécurité Sociale (SS)
- Gère le centre 750 (Paris), caisse 75001
- Délai de prise en charge : 90 jours

### Profil utilisé

[PayeurSanteProfile](StructureDefinition-payeur-sante-profile.html) - Payeur régime obligatoire

### Fichier FSH

[ExemplePayeurSanteCPAM.fsh](Organization-ExemplePayeurSanteCPAM.html)

### Points clés

✅ **Rôle unique** : Uniquement `payer` (pas supplier ni debtor)  
✅ **Extension payeurSante requise** : 1..1 MS  
✅ **Type payeur** : RO (Régime Obligatoire)  
✅ **Grand régime** : SS (Sécurité Sociale)  
✅ **Pas de RIB** : extension[bankAccount] 0..0 (les payeurs ne fournissent pas leur compte)  

### Paramètres spécifiques

| Extension | Valeur | Signification |
|-----------|--------|---------------|
| typePayeur | RO | Régime Obligatoire (vs RC = Complémentaire) |
| codeCentre | 750 | Centre Paris |
| numeroCaisse | 75001 | Caisse primaire 75001 |
| grandRegime | SS | Sécurité Sociale |
| numeroOrganisme | 007501 | Identifiant national organisme |
| flagEclatement | false | Pas d'éclatement des factures par acte |
| delaiPec | 90 | Délai prise en charge 90 jours |

### Cas d'usage

- ✅ Télétransmission FSE : Envoi feuilles de soins électroniques pour remboursement
- ✅ Gestion tiers-payant : Paiement direct établissement sans avance patient
- ✅ Suivi délais PEC : Alertes si dépassement 90 jours

---

## Exemple 7 : Payeur Santé Mutuelle (Régime Complémentaire)

### Contexte métier

**MGEN (Mutuelle Générale de l'Éducation Nationale)** est une mutuelle complémentaire qui :
- Complète les remboursements Sécurité Sociale
- Appartient au grand régime Mutuelle
- Applique l'éclatement des factures par acte
- Délai de prise en charge : 60 jours

### Profil utilisé

[PayeurSanteProfile](StructureDefinition-payeur-sante-profile.html) - Payeur régime complémentaire

### Fichier FSH

[ExemplePayeurSanteMutuelle.fsh](Organization-ExemplePayeurSanteMutuelle.html)

### Points clés

✅ **Type payeur** : RC (Régime Complémentaire)  
✅ **Grand régime** : MUTUELLE (vs SS pour CPAM)  
✅ **Éclatement activé** : flagEclatement = true  
✅ **Délai PEC plus court** : 60 jours (vs 90 jours CPAM)  
✅ **TG Category** : #63 (Mutuelle)  

### Différences RO vs RC

| Critère | CPAM (RO) | MGEN (RC) |
|---------|-----------|-----------|
| Type payeur | RO | RC |
| Grand régime | SS | MUTUELLE |
| TG Category | #60 (Assurance maladie) | #63 (Mutuelle) |
| Éclatement factures | false | true |
| Délai PEC | 90 jours | 60 jours |
| Ordre paiement | 1er (obligatoire) | 2ème (après RO) |

### Cas d'usage

- ✅ Facturation complémentaire : Envoi après remboursement CPAM
- ✅ Tiers-payant intégral : CPAM + Mutuelle = 0€ reste à charge patient
- ✅ Éclatement par acte : Facturation détaillée acte par acte (vs globale)

---

## Exemple 8 : Recherches Combinées

### Scénario 1 : Trouver tous les fournisseurs EPS actifs

```http
GET [base]/Organization?tiers-role=supplier
  &tiers-category=16
  &active=true
```

**Résultat** : Établissements publics de santé ayant le rôle fournisseur (vendent prestations ou médicaments).

---

### Scénario 2 : Identifier les débiteurs non-résidents

```http
GET [base]/Organization?tiers-role=debtor
  &debiteur-type-resident=NR
```

**Résultat** : Débiteurs non-résidents fiscaux (obligation retenue à la source).

---

### Scénario 3 : Lister tous les payeurs régime obligatoire

```http
GET [base]/Organization?tiers-role=payer
  &payeur-type=RO
```

**Résultat** : CPAM, MSA, RSI, CNAV (régimes obligatoires uniquement, exclut mutuelles).

---

### Scénario 4 : Trouver un tiers par IBAN

```http
GET [base]/Organization?bank-account-iban=FR7630004000020000012345678
```

**Résultat** : Tiers propriétaire du compte bancaire (rapprochement virement).

---

### Scénario 5 : Tiers multi-rôles (supplier ET debtor)

```http
GET [base]/Organization?tiers-role=supplier
  &tiers-role=debtor
```

**Résultat** : Organisations ayant les DEUX rôles simultanément (échanges bidirectionnels).

---

## Bonnes Pratiques d'Implémentation

### 1. Validation avant création

Toujours vérifier l'existence du tiers par recherches :

```http
# Vérifier si code fournisseur existe déjà
GET [base]/Organization?fournisseur-code:exact={nouveau_code}

# Résultat vide = OK pour créer
# Résultat non vide = Doublon, refuser ou fusionner
```

### 2. Gestion des doublons

Identifier doublons potentiels par SIRET avant import :

```http
GET [base]/Organization?identifier=urn:oid:1.2.250.1.24.3.2|85211234500018
```

### 3. Synchronisation bidirectionnelle GEF ↔ FHIR

**Import EFOU → FHIR** :
1. Parser EFOU ligne 262 caractères
2. Créer Organization conforme FournisseurProfile
3. Mapper positions EFOU → extensions FHIR

**Export FHIR → EFOU** :
1. Récupérer Organization par `?tiers-role=supplier`
2. Extraire extensions FournisseurProfile
3. Formater sortie texte fixe 262 caractères

### 4. Multi-rôle : Une resource, multiples extensions

```json
{
  "resourceType": "Organization",
  "extension": [
    {"url": "tiersRole", "valueCode": "supplier"},
    {"url": "tiersRole", "valueCode": "debtor"},
    {"url": "codeFournisseur", "valueString": "FRSUP123"},
    {"url": "codeDebiteur", "valueString": "DEB456"},
    {"url": "comptabilite", ...},
    {"url": "parametres", ...}
  ]
}
```

**Avantages** :
- ✅ Pas de duplication données
- ✅ Historique unifié
- ✅ Gestion relations simplifiée

---

## Voir aussi

- [SearchParameters](search-parameters.html) - Critères de recherche détaillés
- [TiersProfile](StructureDefinition-tiers-profile.html) - Documentation profil de base
- [Multi-rôles](tiers-multi-roles.html) - Explications concept multi-rôle
- [Héritage vs partOf](heritage-vs-partof.html) - Distinction entre concepts
- [Index](index.html) - Retour à l'accueil
