# Exemples d'Utilisation

## Vue d'ensemble

Cette page présente des **exemples concrets** couvrant les deux axes du guide :

| Axe | Exemples | Section |
|-----|----------|---------|
| **Axe Concepts Métiers** | Organizations (fournisseur, client, payeur, multi-rôle, succursale, étranger) | [Exemples Tiers](#exemple-1--organisation-multi-rôles) |
| **Axe Nomenclatures** | Patient avec adresse commune déléguée, commune nouvelle, recherche historique | [Exemples Communes COG](#exemples-communes-cog) |

---

## Exemple 1 : Organisation Multi-Rôles

### Situation

**Multiservices Santé et Logistique (MSL)** est une entreprise qui entretient plusieurs types de relations avec un établissement de santé :

- **Fournit** des équipements médicaux (défibrillateurs, lits hospitaliers)
- **Achète** des prestations de maintenance et d'entretien
- **Gère** les remboursements santé pour ses propres employés

### Profil utilisé

[Organisation Tierce (TiersProfile)](StructureDefinition-tiers-profile.html) - Profil de base multi-rôles

### Ressource FHIR

[ExempleTiersComplet](Organization-ExempleTiersComplet.html)

### Points clés

✅ **Trois rôles simultanés** dans une seule fiche organisation
✅ **Extensions spécifiques** à chaque rôle (paramètres fournisseur + client + payeur)
✅ **Compte bancaire unique** avec moyens de paiement multiples
✅ **Identifiants officiels** : SIRET, FINESS, identifiant interne

### Avantages métier

- **Une seule fiche** pour gérer toutes les interactions
- **Historique cohérent** des échanges commerciaux
- **Recherche simplifiée** : trouver l'organisation quel que soit le contexte

**Exemple de recherche** : Trouver toutes les organisations qui sont à la fois fournisseurs ET clients
```http
GET [base]/Organization?tiers-role=supplier&tiers-role=debtor
```

---

## Exemple 2 : Fournisseur et Client Simultanément

### Situation

**Clinique du Parc** est un établissement de santé privé qui :

- **Vend** des consultations spécialisées à d'autres hôpitaux
- **Achète** des médicaments et du matériel médical

### Profil utilisé

[Organisation Tierce (TiersProfile)](StructureDefinition-tiers-profile.html) avec double rôle

### Ressource FHIR

[ExempleTiersDoubleRole](Organization-ExempleTiersDoubleRole.html)

### Points clés

✅ **Échanges bidirectionnels** : peut être à la fois créancier et débiteur du même partenaire
✅ **Comptes bancaires multiples** : compte standard + compte pour gros montants
✅ **Catégorie** : Clinique privée (établissement de santé)
✅ **Paramètres distincts** : conditions commerciales différentes selon le rôle

### Cas d'usage pratique

**Conventions inter-établissements** : Deux hôpitaux échangent des prestations médicales (cardiologie contre orthopédie par exemple). Chacun est à la fois fournisseur et client de l'autre.

**Gestion comptable** : Le système doit gérer simultanément :
- Les factures émises (créances) pour les consultations vendues
- Les factures reçues (dettes) pour les achats de médicaments

---

## Exemple 3 : Établissement avec Succursale

### Situation

**Centre Médical Raspail - Annexe Montparnasse** est un site secondaire de la **Clinique du Parc**. Cette succursale sert de :

- Point de livraison pour les fournitures médicales
- Adresse de facturation pour les consultations externes

### Profil utilisé

[Organisation Tierce (TiersProfile)](StructureDefinition-tiers-profile.html) avec relation hiérarchique

### Ressource FHIR

[ExempleSuccursale](Organization-ExempleSuccursale.html)

### Points clés

✅ **Relation hiérarchique** : référence à l'établissement parent via `partOf`
✅ **Usage qualifié** : marqué comme "point de livraison" et "adresse de facturation"
✅ **SIRET distinct** : chaque site a son propre numéro SIRET
✅ **Coordonnées locales** : adresse, téléphone et compte bancaire spécifiques

### Distinction importante : Relation vs Héritage

| Type | Nature | Exemple | Moment d'application |
|------|--------|---------|----------------------|
| **partOf** | Relation organisationnelle | Succursale → Siège | Dans les données (runtime) |
| **Parent: TiersProfile** | Héritage technique | FournisseurProfile → TiersProfile | À la définition (design) |

⚠️ **partOf n'est PAS un héritage technique** ! C'est une référence qui indique qu'une organisation fait partie d'une autre organisation.

### Cas d'usage pratique

**Gestion multi-sites** : Un hôpital universitaire avec plusieurs campus doit gérer les livraisons sur chaque site tout en centralisant la facturation au siège.

---

## Exemple 4 : Fournisseur de Médicaments

### Situation

**Laboratoires Pharmaceutiques Durand (LPD)** fournit des médicaments aux établissements de santé avec :

- Délais de paiement négociés : 60 jours, règlement le 10 du mois
- Facturation électronique activée
- Plusieurs moyens de paiement acceptés (virements, virements externes)

### Profil utilisé

[Profil Fournisseur (FournisseurProfile)](StructureDefinition-fournisseur-profile.html)

### Ressource FHIR

[ExempleFournisseurComplet](Organization-ExempleFournisseurComplet.html)

### Points clés

✅ **Conditions de paiement détaillées** : délai, jour de règlement, montant minimum
✅ **Paramètres comptables** : comptes de gestion pour la comptabilité analytique
✅ **Domiciliation bancaire** : échange de données informatisé (EDI) pour les virements
✅ **Affacturage** : possibilité de céder les créances à un organisme financier

### Cas d'usage pratique

**Validation avant paiement** : Avant de régler une facture de 50 000 €, le système vérifie :
- Le délai de 60 jours est-il respecté ?
- Le montant dépasse-t-il le minimum négocié (1000 €) ?
- L'affacturage est-il activé (auquel cas payer le factor, pas le fournisseur) ?

---

## Exemple 5 : Client Acheteur (Établissement Public)

### Situation

**CHU Necker-Enfants Malades** achète des prestations et équipements auprès d'autres organisations. Caractéristiques :

- Type : Client permanent (compte actif en continu)
- Résidence fiscale : France (résident fiscal)
- Autorisation : peut faire intervenir des assurances
- Centralisation : commandes groupées pour plusieurs services

### Profil utilisé

[Profil Débiteur (DebiteurProfile)](StructureDefinition-debiteur-profile.html)

### Ressource FHIR

[ExempleDebiteurComplet](Organization-ExempleDebiteurComplet.html)

### Points clés

✅ **Type client** : Normal = compte permanent (vs occasionnel = compte temporaire)
✅ **Coordonnées bancaires requises** : nécessaires pour recevoir les paiements
✅ **Gestion des assurances** : peut accepter les paiements directs par les mutuelles
✅ **Centralisation des achats** : commandes ouvertes pour plusieurs départements

### Cas d'usage pratique

**Encaissement de recettes** : Le CHU vend des prestations médicales à d'autres établissements (consultations spécialisées, analyses de laboratoire). Le système doit :
- Identifier le compte bancaire pour recevoir les virements
- Enregistrer les paiements reçus en comptabilité
- Permettre aux mutuelles de régler directement si autorisé

---

## Exemple 6 : Organisme Payeur - Sécurité Sociale (CPAM)

### Situation

**CPAM de Paris** est la caisse primaire d'assurance maladie qui :

- Rembourse les prestations de soins aux patients assurés
- Appartient au régime obligatoire de Sécurité Sociale
- Gère les feuilles de soins électroniques (FSE)
- Applique un délai de prise en charge de 90 jours

### Profil utilisé

[Profil Payeur Santé (PayeurSanteProfile)](StructureDefinition-payeur-sante-profile.html) - Régime obligatoire

### Ressource FHIR

[ExemplePayeurSanteCPAM](Organization-ExemplePayeurSanteCPAM.html)

### Points clés

✅ **Rôle unique** : Payeur uniquement (pas fournisseur ni client)
✅ **Type** : Régime Obligatoire (RO) = assurance maladie de base
✅ **Régime** : Sécurité Sociale (SS)
✅ **Identifiants spécifiques** : code centre (750 = Paris), numéro caisse (75001)
✅ **Pas de coordonnées bancaires** : les organismes payeurs ne communiquent pas leur RIB

### Paramètres importants

| Information | Valeur | Signification |
|-------------|--------|---------------|
| Type payeur | RO | Régime Obligatoire (couverture de base) |
| Code centre | 750 | Centre géographique Paris |
| Numéro caisse | 75001 | Caisse primaire identifiant |
| Régime | Sécurité Sociale | Grand régime national |
| Délai prise en charge | 90 jours | Durée maximale de traitement des demandes |

### Cas d'usage pratique

**Télétransmission de FSE** : L'établissement envoie électroniquement les feuilles de soins à la CPAM pour remboursement. Le système doit :
- Identifier le bon organisme payeur selon l'adresse du patient
- Transmettre les actes médicaux facturés
- Suivre le délai de 90 jours pour la prise en charge
- Relancer si dépassement du délai

**Tiers-payant** : Le patient ne paie rien, la CPAM règle directement l'établissement.

---

## Exemple 7 : Organisme Payeur - Mutuelle Complémentaire (MGEN)

### Situation

**MGEN (Mutuelle Générale de l'Éducation Nationale)** est une mutuelle qui :

- Complète les remboursements de la Sécurité Sociale
- Appartient au régime complémentaire
- Applique un éclatement des factures par acte médical
- Délai de prise en charge : 60 jours

### Profil utilisé

[Profil Payeur Santé (PayeurSanteProfile)](StructureDefinition-payeur-sante-profile.html) - Régime complémentaire

### Ressource FHIR

[ExemplePayeurSanteMutuelle](Organization-ExemplePayeurSanteMutuelle.html)

### Points clés

✅ **Type** : Régime Complémentaire (RC) = couverture supplémentaire
✅ **Régime** : Mutuelle (vs Sécurité Sociale)
✅ **Éclatement activé** : factures détaillées acte par acte
✅ **Délai plus court** : 60 jours (vs 90 jours pour la CPAM)
✅ **Catégorie** : Mutuelle (vs Assurance maladie pour CPAM)

### Différences Régime Obligatoire vs Complémentaire

| Critère | CPAM (Régime Obligatoire) | MGEN (Régime Complémentaire) |
|---------|---------------------------|------------------------------|
| Type | RO | RC |
| Régime | Sécurité Sociale | Mutuelle |
| Catégorie | Assurance maladie | Mutuelle |
| Éclatement factures | Non | Oui (détail par acte) |
| Délai traitement | 90 jours | 60 jours |
| Ordre remboursement | 1er (obligatoire) | 2ème (après RO) |
| Adhésion | Automatique (salariés) | Volontaire |

### Cas d'usage pratique

**Tiers-payant intégral** : 
1. Patient consulte, facture totale 100 €
2. CPAM rembourse 70 € (régime obligatoire)
3. MGEN rembourse 30 € (régime complémentaire)
4. Patient : 0 € de reste à charge

**Éclatement par acte** : La MGEN demande une facturation détaillée :
- Consultation : 25 €
- Radiographie : 40 €
- Analyses : 35 €

Au lieu d'une facture globale de 100 €.

---

## Exemple 8 : Société Étrangère avec TVA Intracommunautaire

### Situation

**MedTech Solutions GmbH** est un fournisseur allemand d'équipements médicaux qui :

- Vend des appareils de diagnostic en France
- Possède un numéro de TVA intracommunautaire (Allemagne)
- Facture sans TVA française (autoliquidation par l'acheteur)

### Profil utilisé

[Profil Fournisseur (FournisseurProfile)](StructureDefinition-fournisseur-profile.html)

### Ressource FHIR

[ExempleFournisseurTVA](Organization-ExempleFournisseurTVA.html)

### Points clés

✅ **Numéro TVA UE** : DE123456789 (Allemagne)
✅ **Pays** : DE (Allemagne selon ISO 3166-1)
✅ **Catégorie** : Personne morale de droit privé
✅ **Nature juridique** : Société (GmbH = SARL allemande)

### Cas d'usage pratique

**Facturation internationale (UE)** :
- Fournisseur allemand émet facture HT (sans TVA)
- Acheteur français applique l'autoliquidation de TVA
- Déclaration fiscale : TVA déclarée en France par l'acheteur

**Rapprochement bancaire** : 
- Virement reçu depuis compte IBAN allemand (DE89...)
- Recherche par IBAN pour identifier MedTech Solutions
- Lettrage automatique de la facture

---

## Exemples de Recherches Combinées

### Scénario 1 : Tous les fournisseurs établissements publics de santé

**Besoin métier** : Trouver les hôpitaux publics qui vendent des prestations.

```http
GET [base]/Organization?tiers-role=supplier&tiers-category=27
```

**Critères** :
- `tiers-role=supplier` : rôle fournisseur
- `tiers-category=27` : Établissement Public de Santé (EPS)

---

### Scénario 2 : Clients non-résidents fiscaux

**Besoin métier** : Identifier les organisations étrangères pour appliquer la retenue à la source.

```http
GET [base]/Organization?tiers-role=debtor&debiteur-type-resident=NR
```

**Critères** :
- `tiers-role=debtor` : rôle client/acheteur
- `debiteur-type-resident=NR` : Non-Résident fiscal

---

### Scénario 3 : Tous les régimes obligatoires d'assurance maladie

**Besoin métier** : Lister les organismes de Sécurité Sociale pour transmission FSE.

```http
GET [base]/Organization?tiers-role=payer&payeur-type=RO
```

**Résultat** : CPAM, MSA, RSI, CNAV (régimes obligatoires uniquement, exclut les mutuelles).

---

### Scénario 4 : Rapprochement bancaire

**Besoin métier** : Identifier qui a émis un virement reçu.

```http
GET [base]/Organization?bank-account-iban=FR7630004000020000012345678
```

**Utilité** : Lettrage automatique des virements en comptabilité.

---

### Scénario 5 : Organisations multi-rôles (fournisseur ET client)

**Besoin métier** : Gérer les établissements avec relations commerciales bidirectionnelles.

```http
GET [base]/Organization?tiers-role=supplier&tiers-role=debtor
```

**Résultat** : Organisations ayant les deux rôles simultanément (échanges croisés de prestations).

---

## Bonnes Pratiques

### 1. Vérifier avant de créer

Toujours rechercher si l'organisation existe déjà :

```http
# Recherche par SIRET
GET [base]/Organization?identifier=urn:oid:1.2.250.1.24.3.2|85211234500018
```

Si résultat vide : OK pour créer une nouvelle fiche
Si résultat trouvé : Risque de doublon, utiliser la fiche existante

---

### 2. Privilégier le multi-rôle

**Plutôt que** : Créer 3 fiches séparées (une fournisseur, une client, une payeur)

**Préférer** : Une seule fiche avec 3 rôles

**Avantages** :
- Pas de duplication de données (adresse, contacts, identifiants)
- Historique unifié de toutes les transactions
- Gestion simplifiée des relations commerciales

---

### 3. Utiliser les identifiants officiels

Privilégier dans l'ordre :
1. **SIRET** (entreprises françaises) : le plus fiable
2. **FINESS** (établissements de santé) : obligatoire secteur santé
3. **TVA intracommunautaire** (UE) : pour fournisseurs européens
4. **Identifiant interne** : en dernier recours

---

### 4. Maintenir les coordonnées à jour

**Informations critiques à vérifier régulièrement** :
- Adresse (déménagements)
- Coordonnées bancaires (changements de compte)
- Contacts téléphone/email (départs de personnel)
- Statut actif/inactif (fermetures, fusions)

---

## Exemples Communes COG

Les exemples suivants illustrent l'utilisation des **terminologies géographiques** de l'Axe Nomenclatures : communes françaises codées via le Code Officiel Géographique INSEE (TRE-R13).

### Exemple COG-1 : Patient avec adresse en commune déléguée

**Situation** : Un patient réside dans la commune déléguée **Saint-Rambert-l'Ile-Barbe** (69019), rattachée à la commune nouvelle **Lyon** (69264).

**Ressource FHIR** : [ExemplePatientCommuneDeleguee](Patient-ExemplePatientCommuneDeleguee.html)

**Points clés** :
- Extension `fr-core-address-insee-code` avec code `69019` (commune déléguée)
- Vérification via `$lookup` : `active = false` (commune déléguée, non indépendante)
- Le code `69264` (Lyon) est la commune nouvelle parente

```http
# Vérifier le statut d'une commune déléguée
GET [base]/CodeSystem/$lookup
  ?system=https://smt.esante.gouv.fr/fhir/CodeSystem/TRE-R13-CommuneOM
  &code=69019
  &property=communeNouvelle
```

---

### Exemple COG-2 : Organisation dans une commune nouvelle

**Situation** : Un laboratoire est installé dans la commune nouvelle **Caen-la-Mer** (14666), créée en 2016 par fusion de plusieurs communes.

**Ressource FHIR** : [ExempleOrganisationCommuneNouvelle](Organization-ExempleOrganisationCommuneNouvelle.html)

**Points clés** :
- Code INSEE actif `14666`
- Propriété `typeTerritoire = Commune-Nouvelle`
- Propriété `dateCreation = 2016-01-01`

---

### Exemple COG-3 : Recherche du successeur d'une commune supprimée

**Situation** : Résolution d'un code commune historique `69282` (Oullins, supprimé en 2022) vers son successeur.

**Ressource FHIR** : [ExempleParametersLookupSuccesseur](Parameters-ExempleParametersLookupSuccesseur.html)

```http
# Réponse $lookup pour un code inactif
GET [base]/CodeSystem/$lookup
  ?system=https://smt.esante.gouv.fr/fhir/CodeSystem/TRE-R13-CommuneOM
  &code=69282
  &property=successeur
```

La réponse `Parameters` contiendra :
- `inactive = true`
- `dateSuppression = 2022-01-01`
- `successeur = 69264` (Pierre-Bénite)

---

### Exemple COG-4 : Lister les communes actives ($expand)

```http
# 100 premières communes actives
GET [base]/ValueSet/fr-communes-actives/$expand?count=100&offset=0

# Toutes les communes (actives + historique)
GET [base]/ValueSet/fr-communes-cog-complet/$expand
```

**[Voir la documentation géographique complète →](geographie.html)**

---

## Voir aussi

- [Paramètres de recherche Tiers](search-parameters.html) - Tous les critères de recherche disponibles
- [Données Géographiques COG](geographie.html) - Requêtes complètes $lookup, $expand, $validate-code
- [Guide d'implémentation](index.html) - Vue d'ensemble du référentiel
- [Classifications et nomenclatures](terminologies.html) - Codes et catégories utilisés
- [Documentation technique des profils](StructureDefinition-tiers-profile.html) - Spécifications détaillées
