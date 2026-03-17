# Guide d'Implémentation FHIR - Référentiel Tiers

**Version**: 0.1.0 | **Date**: 17 mars 2026 | **Statut**: Draft

## Bienvenue

Ce **Guide d'Implémentation FHIR** définit comment gérer et échanger les informations sur les **tiers** (fournisseurs, clients, organismes payeurs) dans le secteur hospitalier français.

Un **tiers** est toute organisation avec laquelle un établissement de santé est en relation commerciale ou administrative : laboratoires pharmaceutiques, cliniques partenaires, caisses d'assurance maladie, mutuelles, collectivités territoriales, etc.

Ce guide est **interopérable** et basé sur le **standard national FR Core 2.1.0**.

### Périmètre de ce guide

Ce guide couvre actuellement les **organisations tierces** :

| Type d'organisation | Description | Exemples |
|---------------------|-------------|----------|
| **Fournisseurs** | Vendent des biens ou services à l'établissement | Laboratoires, équipementiers médicaux, prestataires de services |
| **Clients/Débiteurs** | Achètent des prestations à l'établissement | Autres hôpitaux, EHPAD, cabinets médicaux |
| **Organismes payeurs** | Remboursent les soins aux patients | CPAM, MSA, mutuelles, assurances complémentaires |
| **Succursales** | Sites secondaires rattachés à une organisation principale | Annexes, sites de livraison, adresses de facturation |

> **Note** : Les autres référentiels (personnels soignants, patients, structures internes, produits, actes) seront ajoutés dans les prochaines versions.

## Objectifs

Ce guide permet de :

✅ **Partager** les données sur les tiers entre établissements et systèmes  
✅ **Identifier** un même tiers dans différents systèmes (SIRET, FINESS, TVA, etc.)  
✅ **Rechercher** rapidement un fournisseur, client ou organisme payeur  
✅ **Gérer les multi-rôles** : une même organisation peut être à la fois fournisseur ET client  
✅ **Garantir la conformité** avec les échanges standards du secteur hospitalier français

## Architecture du guide

```
┌──────────────────────────────────────────────┐
│  Standard National FR Core 2.1.0             │
│  (HL7 France)                                │
│  • Identifiants français: SIRET, FINESS     │
│  • Adresses françaises                       │
└────────┬─────────────────────────────────────┘
         │
         ├─▶ ┌───────────────────────────────────────────────┐
         │   │ Ce Guide - Référentiel Tiers                 │
         │   │ (Interopérable et réutilisable)              │
         │   │                                              │
         │   │ • Profil de base: Organisation Tiers         │
         │   │ • Profils spécialisés: Fournisseur, Client,  │
         │   │   Organisme Payeur, Succursale               │
         │   │ • 10 critères de recherche REST              │
         │   │ • Support multi-rôles                        │
         │   └────────┬──────────────────────────────────────┘
         │            │
         └────────────┴─▶ ┌──────────────────────────────────┐
                          │ Guides spécialisés établissements│
                          │ (Extensions métier spécifiques)   │
                          │                                  │
                          │ • Gestion interne                │
                          │ • Processus métier               │
                          │ • Échanges sectoriels            │
                          └──────────────────────────────────┘
```

**Principe** : Ce guide définit le **socle commun** réutilisable par tous les établissements. Les spécificités locales sont ajoutées dans des guides dérivés.

## Contenu du guide

### Profils d'organisations

#### [Profil de base Organisation](StructureDefinition-tiers-profile.html)
Profil commun à tous les types de tiers. Inclut les identifiants nationaux (SIRET, FINESS, TVA), les coordonnées bancaires, et la classification de l'organisation.

**Caractéristiques** :
- **Multi-rôles** : Une même organisation peut être à la fois fournisseur, client ET organisme payeur
- **9 types d'identifiants** : SIRET, SIREN, FINESS, Numéro de sécurité sociale, TVA intracommunautaire, identifiants DOM-TOM, etc.
- **Coordonnées bancaires** : RIB/IBAN avec paramètres de paiement (virements, chèques, EDI, affacturage)

#### [Profil Fournisseur](StructureDefinition-fournisseur-profile.html)
Pour les organisations qui **vendent des biens ou services** à l'établissement.

**Informations spécifiques** :
- Code fournisseur unique
- Paramètres comptables (comptes de charges et dettes)
- Conditions de paiement : délais, montants minimums, taux, possibilité d'escompte

**Exemples** : Laboratoires pharmaceutiques, fournisseurs d'équipements médicaux, prestataires de services d'entretien

#### [Profil Client/Débiteur](StructureDefinition-debiteur-profile.html)
Pour les organisations qui **achètent des prestations** à l'établissement.

**Informations spécifiques** :
- Code client unique
- Paramètres de facturation et encaissement
- Statut fiscal (résident/non-résident)
- Autorisations (paiement par assurances, etc.)
- Coordonnées bancaires **obligatoires** pour encaissement

**Exemples** : Autres hôpitaux, EHPAD, cliniques, maisons de retraite, cabinets médicaux

#### [Profil Organisme Payeur](StructureDefinition-payeur-sante-profile.html)
Pour les **organismes d'assurance maladie** qui remboursent les soins.

**Informations spécifiques** :
- Type de régime : Obligatoire (CPAM, MSA, RSI) ou Complémentaire (mutuelles)
- Grand régime de rattachement : Sécurité Sociale, MSA, RSI, CNAV, Mutuelle
- Paramètres de gestion : code centre, numéro de caisse, délais de prise en charge
- Éclatement des factures par acte (oui/non)

**Exemples** : CPAM, MSA, mutuelles, assurances complémentaires

### Classifications et nomenclatures

#### Types d'organisations
- **Catégories** : État, collectivités territoriales, établissements publics de santé, organismes sociaux, entreprises privées, personnes physiques
- **Natures juridiques** : Particulier, société commerciale, association, établissement public, collectivité territoriale, etc.

#### Rôles des organisations (multi-rôles supportés)
- **Fournisseur** (supplier) : Vend des biens ou services
- **Client** (debtor) : Achète des prestations
- **Organisme payeur** (payer) : Rembourse les soins aux patients

> Une même organisation peut avoir **plusieurs rôles simultanément**. Exemple : une clinique peut être à la fois fournisseur de consultations spécialisées ET cliente d'équipements médicaux.

#### Moyens de paiement
- Numéraire, Chèque, Virement bancaire standard
- Virement application externe, Virement gros montant, Virement interne

#### Régimes de protection sociale
- **Sécurité Sociale** (SS) : CPAM, régime général
- **Mutualité Sociale Agricole** (MSA) : Secteur agricole
- **RSI** : Régime Social des Indépendants
- **CNAV** : Caisse Nationale d'Assurance Vieillesse
- **MUTUELLE** : Organismes complémentaires

#### Usages des succursales
- **Point de livraison** : Adresse de réception des marchandises
- **Facturation** : Adresse d'envoi des factures
- **Siège social secondaire** : Établissement autonome rattaché

📊 **Total** : 12 CodeSystems, 74 codes, 15 extensions, 12 ValueSets, 10 SearchParameters

### NamingSystems Territoires d'Outre-Mer

#### [TahitiIdentifierNamingSystem](NamingSystem-tahiti-identifier-ns.html)
Système d'identification pour Polynésie française (PF).
- URI temporaire : `http://cpage.org/fhir/NamingSystem/tahiti-identifier`
- ⚠️ OID officiel à acquérir auprès de DGEN/ISPF

#### [RIDETIdentifierNamingSystem](NamingSystem-ridet-identifier-ns.html)
RIDET - Répertoire d'IDEntification des Entreprises et des Établissements (Nouvelle-Calédonie NC).
- URI temporaire : `http://cpage.org/fhir/NamingSystem/ridet-identifier`
- ⚠️ OID officiel à acquérir auprès de https://www.ridet.nc/

### [Critères de recherche](search-parameters.html)

10 critères pour interroger le référentiel via l'API REST :

| Critère | Description | Exemple d'usage |
|---------|-------------|-----------------|
| **tiers-role** | Recherche par rôle | Tous les fournisseurs |
| **tiers-category** | Recherche par type d'organisation | Toutes les cliniques, tous les CHU |
| **tiers-legal-nature** | Recherche par forme juridique | Sociétés commerciales, associations |
| **fournisseur-code** | Recherche un fournisseur par son code | Recherche par code fournisseur |
| **debiteur-code** | Recherche un client par son code | Recherche par code client |
| **bank-account-iban** | Recherche par compte bancaire | Identification bénéficiaire d'un virement |
| **payeur-grand-regime** | Recherche organisme par régime | Toutes les CPAM, toutes les mutuelles |
| **payeur-type** | Recherche par type de régime | Régimes obligatoires vs complémentaires |
| **succursale-usage** | Recherche succursale par usage | Points de livraison, adresses de facturation |
| **debiteur-type-resident** | Recherche par résidence fiscale | Résidents vs non-résidents |

**Voir** : [Documentation complète des critères de recherche](search-parameters.html)

### [Exemples pratiques](examples.html)

7 exemples d'organisations avec leurs données complètes :

#### Cas multi-rôles
- **Organisation multi-rôles** : Une entreprise qui est à la fois fournisseur, client ET organisme payeur pour ses employés
- **Clinique bi-rôle** : Un établissement qui vend des consultations ET achète des médicaments

#### Organisation hiérarchique
- **Succursale** : Un site secondaire rattaché à son établissement principal (point de livraison + facturation)

#### Profils spécialisés
- **Fournisseur** : Laboratoire pharmaceutique avec conditions de paiement complètes
- **Client** : CHU acheteur avec coordonnées bancaires pour encaissement
- **CPAM** : Organisme payeur régime obligatoire Sécurité Sociale
- **Mutuelle** : Organisme payeur régime complémentaire

**Voir** : [Tous les exemples détaillés](examples.html)
- **ExempleDebiteurPersonnePhysique** : Particulier avec NIR + Civilité M + Prénom (obligatoire TG 01)
- **ExempleDebiteurEPSPublic** : Hôpital avec FINESS + compte contrepartie + code régie (CHORUS)
- **ExempleFournisseurRIDET** : Société calédonienne avec RIDET (overseas NC)

### [Mapping GEF](mapping.html)

Tables complètes de correspondance :
- EFOU positions 1-262 → FournisseurProfile
- KERD colonnes CSV → DebiteurProfile
- Règles métier GEF (combinaisons Catégorie TG × Nature juridique)

## Implémentation

## Pour qui est ce guide ?

### Établissements de santé

Ce guide vous permet de :
- **Échanger** vos données fournisseurs et clients avec d'autres établissements au format standard
- **Synchroniser** vos référentiels tiers entre vos différents systèmes (comptabilité, achats, facturation)
- **Rechercher** rapidement un fournisseur, client ou organisme payeur dans votre base
- **Maîtriser** la qualité de vos données grâce aux contrôles de conformité

### Éditeurs de logiciels

Ce guide vous fournit :
1. **Des profils FHIR prêts à l'emploi** pour gérer les organisations tierces
2. **Une API REST standardisée** avec 10 critères de recherche
3. **Des exemples concrets** pour valider vos implémentations
4. **La compatibilité** avec le standard national FR Core
5. **Le support du multi-rôle** : une organisation = plusieurs fonctions

### Cas d'usage pratiques

#### Gestion des multi-rôles

Une même organisation peut avoir **plusieurs rôles simultanés** :

```json
{
  "resourceType": "Organization",
  "id": "clinique-dupont",
  "name": "Clinique Dupont",
  "extension": [
    {"url": "tiersRole", "valueCoding": {"code": "supplier"}},
    {"url": "tiersRole", "valueCoding": {"code": "debtor"}}
  ]
}
```

**Avantages** :
- ✅ Une seule fiche pour tous les échanges commerciaux
- ✅ Pas de duplication de données (adresse, contacts, RIB uniques)
- ✅ Historique centralisé des relations
- ✅ Recherche flexible par rôle

**Exemple réel** : Une clinique partenaire vous vend des consultations spécialisées (rôle fournisseur) ET vous achète des médicaments (rôle client).

**Voir** : [Exemples multi-rôles détaillés](examples.html)

## Statut et conformité

✅ **Compilation** : 0 erreurs, 0 warnings  
✅ **Standard FHIR** : R4 4.0.1 conforme  
✅ **Standard national** : FR Core 2.1.0 conforme  
✅ **Multi-rôles** : Support complet (plusieurs rôles par organisation)  
✅ **Recherches** : 10 critères REST définis et testés

### Ressources produites

- **4 profils** : Organisation de base, Fournisseur, Client, Organisme payeur
- **19 extensions** : Informations métier spécifiques (codes, comptabilité, paiement, coordonnées bancaires)
- **12 nomenclatures** : Types d'organisations, rôles, moyens de paiement, régimes sociaux
- **24 exemples** : Cas réels d'organisations avec données complètes
- **10 critères de recherche** : API REST pour interroger le référentiel

## Liens et ressources

- 📦 **Code source** : [github.com/GIPCPAGE/masterdata](https://github.com/GIPCPAGE/masterdata)
- 🇫🇷 **Standard national** : [FR Core 2.1.0](https://hl7.fr/ig/fhir/core)
- 📚 **Spécification FHIR** : [FHIR R4](https://www.hl7.org/fhir/R4/)

## Feuille de route

### Version actuelle (Mars 2026)
✅ **Référentiel des organisations tierces**
- Profils de base et spécialisés (Fournisseur, Client, Organisme payeur)
- Support du multi-rôle
- 10 critères de recherche REST
- 19 extensions métier
- 24 exemples d'utilisation

### Prochaines versions

**Version 0.2** (À venir)
- Référentiel des **personnes** : Professionnels de santé, patients, contacts
- Référentiel des **structures internes** : Services, unités de soins, pôles

**Version 0.3** (À venir)  
- Référentiel des **produits** : Médicaments, dispositifs médicaux, consommables
- Référentiel des **actes et prestations** : Nomenclature des actes

## Contact

**Équipe Référentiels**  
📧 contact@cpage.fr  
🌐 https://www.cpage.fr
