# IG FHIR Tiers MDM - Conformité GEF

**Version**: 0.1.0 | **Date**: 23 février 2026 | **Statut**: Draft

## Bienvenue

Cet **Implementation Guide FHIR** définit les profils et ressources FHIR pour la gestion des **données de référence (Master Data)** dans le secteur hospitalier français, en conformité avec les **interfaces GEF (Gestion Économique et Financière)**.

Ce guide est **vendor-neutral** et **interopérable**, basé sur **FR Core 2.1.0**, et sert de socle pour les IG spécialisés.

### Périmètre de l'IG

Cet Implementation Guide couvre les **données de référence hospitalières** suivantes :

| Domaine | Ressources FHIR | État | Phase |
|---------|-----------------|------|-------|
| **Tiers** (organisations) | Organization | ✅ Complet | Phase 1-3 |
| **Personnes** (praticiens, patients) | Practitioner, Patient | ⏳ À venir | Phase 5 |
| **Structures** (services, unités) | OrganizationAffiliation, Location | ⏳ À venir | Phase 6 |
| **Produits** (médicaments, DM) | Medication, Device | ⏳ À venir | Phase 7 |
| **Activités** (actes, prestations) | ActivityDefinition, PlanDefinition | ⏳ À venir | Phase 8 |

**Version actuelle (Phase 3)** : Focus sur les **Tiers** uniquement (fournisseurs, débiteurs, payeurs santé).

Les autres domaines seront progressivement ajoutés dans les phases suivantes. Ce guide restera le socle commun pour toutes les données de référence GEF.

## Objectif : Interopérabilité GEF

Les **interfaces GEF** sont des formats d'échange standardisés utilisés entre systèmes hospitaliers pour synchroniser les données de tiers :
- **EFOU** : Extraction Fournisseurs (format texte fixe, 262 caractères)
- **KERD** : Intégration Débiteurs (format CSV)
- **EMAF** : Extraction Marchés Fournisseurs (contrats)

Ce guide fournit une **représentation FHIR complète** de ces formats pour permettre :
✅ Mapping bidirectionnel GEF ↔ FHIR  
✅ Validation des données selon nomenclatures GEF officielles  
✅ Interopérabilité entre systèmes hospitaliers  
✅ Modernisation progressive des échanges (GEF legacy → FHIR moderne)  
✅ Recherche et exploitation optimisées via SearchParameters REST

## Architecture Multi-IG

```
┌──────────────────────────────────────────────┐
│  FR Core 2.1.0 (HL7 France)                 │
│  • FRCoreOrganizationProfile                │
│  • Slices SIREN, SIRET, FINESS               │
└────────┬─────────────────────────────────────┘
         │
         ├─▶ ┌───────────────────────────────────────────────┐
         │   │ ig-md-fhir-common (ce guide)                 │
         │   │ CONFORMITÉ GEF - Interopérabilité externe    │
         │   │ • TiersProfile (base GEF)                    │
         │   │ • FournisseurProfile (EFOU-compliant)        │
         │   │ • DebiteurProfile (KERD-compliant)           │
         │   │ • 12 Extensions GEF (banking, identifiers,   │
         │   │   debtor-specific)                           │
         │   │ • 8 CodeSystems GEF (46 codes totaux)        │
         │   │ • 2 NamingSystems (Tahiti, RIDET)            │
         │   └────────┬──────────────────────────────────────┘
         │            │
         └────────────┴─▶ ┌──────────────────────────────────┐
                          │ ig-md-fhir-cpage (spécialisé)    │
                          │ ENRICHISSEMENTS CPAGE - Interne   │
                          │ • CPageFournisseurProfile        │
                          │ • CPageDebiteurProfile           │
                          │ • Extensions métier CPage        │
                          │ • Chorus, comptabilité, ASAP     │
                          └──────────────────────────────────┘
```

**Principe de séparation** :
- **ig-md-fhir-common** = Conformité GEF stricte (interop externe, vendor-neutral)
- **ig-md-fhir-cpage** = Enrichissements propriétaires CPage (métier interne)

## Contenu de ce Guide

### Profils FHIR

#### [TiersProfile](StructureDefinition-tiers-profile.html)
Profil de base conforme GEF pour tout type de tiers. Hérite de FR Core Organization. **Support multi-rôles** : un même tiers peut être simultanement fournisseur, débiteur ET payeur santé.
- **9 types d'identifiants** : SIRET, SIREN, FINESS, NIR, TVA, Hors UE, Tahiti, RIDET, En cours
- **Classification GEF** : Catégorie TG (24 codes), Nature juridique (12 codes)
- **Banking** : RIB/IBAN (9 sous-extensions incluant EDI, affacturage, moyens paiement)
- **Extensions rôles** : 10 extensions métier (3 fournisseur, 3 débiteur, 1 payeur, 1 succursale, 2 base)

#### [FournisseurProfile](StructureDefinition-fournisseur-profile.html)
Profil fournisseur conforme au message **EFOU** (Extraction Fournisseurs, positions 1-262).
- Hérite de TiersProfile
- Extensions qualifiant type identifiant GEF
- Mapping complet vers format texte fixe EFOU
- **Extensions spécifiques** : codeFournisseur, comptabilite (classe 2/6), paiement (délais, montant min, taux transitaire, escompte)

#### [DebiteurProfile](StructureDefinition-debiteur-profile.html)
Profil débiteur conforme au message **KERD** (Intégration Débiteurs CSV).
- Hérite de TiersProfile
- **Extensions spécifiques** :
  - codeDebiteur : Code unique débiteur
  - parametres : Compte lettre, type résident fiscal (R/NR), type débiteur, autorisation assurances, COH
  - debtorType : Occasionnel (O) / Normal (N)
- RIB obligatoire (1..* MS)

#### [PayeurSanteProfile](StructureDefinition-payeur-sante-profile.html) 🆕
Profil payeur d'assurance maladie (régime obligatoire et complémentaire).
- Hérite de TiersProfile
- **Extension payeurSante requise** (1..1 MS) :
  - typePayeur : RO (Régime Obligatoire) ou RC (Régime Complémentaire)
  - codeCentre : Code centre géographique
  - numeroCaisse : Numéro caisse primaire
  - grandRegime : SS, MSA, RSI, CNAV, MUTUELLE
  - numeroOrganisme : Identifiant national
  - flagEclatement : Éclatement factures par acte
  - delaiPec : Délai prise en charge (jours)
- **Contraintes** : Rôle = payer uniquement, pas de RIB (0..0)

### Terminologies GEF

#### Phase 1 - Fondations
- **GEFIdentifierTypeCS** (9 codes) : Types d'identifiants GEF 01-09
- **GEFTGCategoryCS** (24 codes) : Catégories tiers (État, régions, EPS, organismes sociaux, etc.)
- **GEFLegalNatureCS** (12 codes) : Natures juridiques (particulier, société, association, etc.)

#### Phase 2 - Débitorat
- **GEFDebtorTypeCS** (2 codes) : Occasionnel (O) / Normal (N)
- **GEFCivilityCS** (5 codes) : M, MME, MLLE, METMME, MOUMME
- **GEFChorusIdentifierTypeCS** (8 codes) : Types identifiants CHORUS 01-08 (sans 09)
- **GEFAddressLocalizationCS** (3 codes) : FRANCE, EUROPE, AUTRE

#### Phase 3 - Multi-rôles et Payeurs 🆕
- **TiersRoleCS** (3 codes) : supplier, debtor, **payer** (nouveau)
- **SuccursaleUsageCS** (3 codes) : POINT_LIVRAISON, FACTURATION, SIEGE_SOCIAL
- **MoyenPaiementCS** (6 codes) : NUMERAIRE, CHEQUE, VIREMENT, VIREMENT_APPLI_EXT, VIREMENT_GROS_MONTANT, VIREMENT_INTERNE
- **GrandRegimeCS** (5 codes) : SS, MSA, RSI, CNAV, MUTUELLE
- **TypeResidentCS** (2 codes) : R (Résident), NR (Non résident)

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

### [Critères de Recherche](search-parameters.html) 🆕

10 SearchParameters pour exploiter les ressources Tiers :

| SearchParameter | Type | Description | Exemple |
|-----------------|------|-------------|---------|
| **tiers-role** | token | Rôle du tiers (supplier/debtor/payer) | `?tiers-role=supplier` |
| **tiers-category** | token | Catégorie TG (00-74) | `?tiers-category=16` |
| **tiers-legal-nature** | token | Nature juridique (00-11) | `?tiers-legal-nature=03` |
| **fournisseur-code** | string | Code fournisseur unique | `?fournisseur-code=FRSUP00456` |
| **debiteur-code** | string | Code débiteur unique | `?debiteur-code=DEB000789` |
| **bank-account-iban** | string | IBAN du compte bancaire | `?bank-account-iban=FR763...` |
| **payeur-grand-regime** | token | Grand régime payeur (SS/MSA/MUTUELLE) | `?payeur-grand-regime=SS` |
| **payeur-type** | string | Type payeur (RO/RC) | `?payeur-type=RO` |
| **succursale-usage** | token | Usage succursale | `?succursale-usage=POINT_LIVRAISON` |
| **debiteur-type-resident** | token | Résidence fiscale (R/NR) | `?debiteur-type-resident=R` |

**Voir** : [Documentation complète SearchParameters](search-parameters.html)

### [Exemples d'Usage](examples.html) 🆕

7 exemples fonctionnels illustrant tous les cas d'usage GEF :

#### Multi-rôles
- **[ExempleTiersComplet](Organization-ExempleTiersComplet.html)** : Tiers avec 3 rôles simultanés (supplier + debtor + payer)
- **[ExempleTiersDoubleRole](Organization-ExempleTiersDoubleRole.html)** : Clinique fournisseur ET débiteur avec 2 comptes bancaires

#### Organisation hiérarchique
- **[ExempleSuccursale](Organization-ExempleSuccursale.html)** : Succursale avec partOf + usage (point livraison + facturation)

#### Profils spécialisés
- **[ExempleFournisseurComplet](Organization-ExempleFournisseurComplet.html)** : Fournisseur avec paramètres comptables et paiement (EFOU)
- **[ExempleDebiteurComplet](Organization-ExempleDebiteurComplet.html)** : CHU débiteur avec RIB obligatoire et paramètres (KERD)
- **[ExemplePayeurSanteCPAM](Organization-ExemplePayeurSanteCPAM.html)** : CPAM régime obligatoire (RO), grand régime SS
- **[ExemplePayeurSanteMutuelle](Organization-ExemplePayeurSanteMutuelle.html)** : MGEN régime complémentaire (RC), éclatement activé

**Voir** : [Documentation complète Exemples](examples.html)

### Instances de Test Legacy (Phase 1-2)

5 exemples fonctionnels initiaux illustrant les bases GEF :
- **ExempleFournisseurEPS** : CHU avec SIRET + RIB complet (Catégorie TG 27)
- **ExempleFournisseurTVA** : Société allemande avec TVA intracommunautaire
- **ExempleDebiteurPersonnePhysique** : Particulier avec NIR + Civilité M + Prénom (obligatoire TG 01)
- **ExempleDebiteurEPSPublic** : Hôpital avec FINESS + compte contrepartie + code régie (CHORUS)
- **ExempleFournisseurRIDET** : Société calédonienne avec RIDET (overseas NC)

### [Mapping GEF](mapping.html)

Tables complètes de correspondance :
- EFOU positions 1-262 → FournisseurProfile
- KERD colonnes CSV → DebiteurProfile
- Règles métier GEF (combinaisons Catégorie TG × Nature juridique)

## Implémentation

### Pour les Éditeurs de Logiciels Hospitaliers

1. **Lecture GEF → FHIR** : Parser EFOU/KERD → créer ressources Organization conformes aux profils
2. **Écriture FHIR → GEF** : Lire ressources FHIR → générer fichiers EFOU/KERD
3. **Validation** : Contrôler avec ValueSets GEF (bindings required)
4. **Extensions** : Implémenter toutes les extensions GEF pour couverture complète
5. **Multi-rôles** : Gérer un même tiers avec plusieurs rôles simultanés (supplier + debtor + payer)
6. **Recherches** : Implémenter les 10 SearchParameters pour exploitation optimale

### Pour les Intégrateurs

1. Consommer les profils comme contrat d'interface FHIR
2. Valider les données échangées contre les StructureDefinitions
3. Respecter les cardinalités (ex: RIB 1..* obligatoire pour débiteurs)
4. Implémenter règles métier (ex: civilité+prénom obligatoire si Catégorie TG=01)
5. **Utiliser les SearchParameters** pour requêtes REST efficaces
6. **Gérer les succursales** avec partOf (relation hiérarchique organisation)

### Cas d'Usage Multi-rôles

Un même Organization peut avoir **plusieurs rôles simultanés** :

```json
{
  "resourceType": "Organization",
  "id": "multiservices-sante",
  "extension": [
    {"url": "tiersRole", "valueCode": "supplier"},
    {"url": "tiersRole", "valueCode": "debtor"},
    {"url": "tiersRole", "valueCode": "payer"},
    {"url": "codeFournisseur", "valueString": "FRSUP00456"},
    {"url": "codeDebiteur", "valueString": "DEB000789"},
    {"url": "payeurSante", "extension": [...]}
  ]
}
```

**Avantages** :
- ✅ Pas de duplication données (1 fiche unique)
- ✅ Historique unifié
- ✅ Relations simplifiées (1 Organization vs 3)
- ✅ Recherche flexible par rôle

**Voir** : [Multi-rôles expliqués](tiers-multi-roles.html) | [Héritage vs partOf](heritage-vs-partof.html)

## Conformité et Validation

✅ **SUSHI v3.16.3** : 0 erreurs, 0 warnings  
✅ **FHIR R4 4.0.1** : Full compliance  
✅ **FR Core 2.1.0** : Héritage correct  
✅ **GEF Coverage** : EFOU (100%), KERD (100%), EMAF (Phase 4)  
✅ **Multi-rôles** : Support complet (supplier + debtor + payer simultanés)  
✅ **SearchParameters** : 10 critères de recherche définis et testés

## Liens et Ressources

- 📦 **Repository GitHub** : [github.com/NicolasMoreauCPage/mdm-igs](https://github.com/NicolasMoreauCPage/mdm-igs)
- 🔗 **IG Spécialisé CPage** : ig-md-fhir-cpage
- 🇫🇷 **FR Core 2.1.0** : [hl7.fr/ig/fhir/core](https://hl7.fr/ig/fhir/core/)
- 📚 **FHIR R4** : [hl7.org/fhir/R4](https://www.hl7.org/fhir/R4/)
- 📄 **Documentation GEF** : interfacesGEF.txt (172 pages)

## Statut et Roadmap

### Phase 1 ✅ Complétée (11 fév 2026)
- GEFIdentifierType, GEFBankAccount, GEFTGCategory, GEFLegalNature
- TiersProfile avec 6 identifier slices
- FournisseurProfile, DebiteurProfile
- NamingSystems Tahiti/RIDET

### Phase 2 ✅ Complétée (23 fév 2026)
- 7 extensions débitorat
- 4 terminologies (DebtorType, Civility, ChorusIdentifierType, AddressLocalization)
- Intégration complète dans DebiteurProfile

### Phase 3 ✅ Complétée (17 mars 2026) 🆕
- **Support multi-rôles** : Extension tiersRole 0..* (supplier + debtor + payer)
- **PayeurSanteProfile** : Profil payeurs santé (CPAM, mutuelles)
- **4 nouveaux CodeSystems** : TiersRole (avec payer), SuccursaleUsage, MoyenPaiement, GrandRegime, TypeResident
- **10 SearchParameters** : Critères de recherche pour exploitation (role, category, codes métier, IBAN, payeurs, succursales)
- **7 exemples complets** : Multi-rôles, succursale avec partOf, fournisseur/débiteur/payeurs avec tous paramètres
- **Extensions banking enrichies** : GEFBankAccount avec EDI, affacturage, moyens paiement (0..*)
- **Extensions métier** : 6 nouvelles extensions (FournisseurCode, Comptabilite, Paiement, DebiteurCode, Parametres, PayeurSante)
- **Documentation complète** : Pages search-parameters.md, examples.md, mise à jour index.md

### Phase 4 ⏳ À venir
- Support EMAF (contrats fournisseurs - Contract resource)
- Acquisition OIDs officiels Tahiti/RIDET
- Génération snapshots IG Publisher
- Extensions CPage spécialisées (Chorus, ASAP)

## Contact

**Équipe CPage MasterData**  
📧 contact@cpage.fr  
🌐 https://www.cpage.fr
