# Tiers financiers

Cette page détaille le domaine **Tiers financiers** de l'IG Commun CPage MasterData : les profils,
extensions et terminologies modélisant les organisations (et, ponctuellement, les personnes
physiques) avec lesquelles un établissement de santé entretient une relation financière.

## Qu'est-ce qu'un « Tiers » ?

Dans la comptabilité publique française, un **Tiers** est toute personne physique ou morale externe
à l'établissement avec laquelle celui-ci a une relation financière : elle lui vend des biens ou
services (fournisseur), elle lui doit de l'argent (débiteur), ou elle lui rembourse des frais de
soins (payeur santé). Le même tiers peut cumuler plusieurs rôles : un exemple fourni dans l'IG
(`ExempleTiersDoubleRole`) illustre une organisation qui est à la fois fournisseur et débitrice.

Le socle Oracle historique de ce domaine est la table **`ECO.ETIER`** (« tiers »), avec deux tables
spécialisées : **`ECO.FOU`** (fournisseurs) et **`ECO.DBT`** (débiteurs des titres de recette). Les
mappings colonne Oracle → élément FHIR décrits ci-dessous ont été **vérifiés contre un extrait réel
du DDL Oracle** (`ECO.ETIER`, `ECO.FOU`, `ECO.DBT`, contraintes et commentaires de colonnes inclus),
ce qui distingue ce domaine du domaine Structure hospitalière (voir la page dédiée), pour lequel
aucun DDL équivalent n'était disponible et dont le mapping repose sur les commentaires des fichiers
FSH.

Toutes les nomenclatures de catégorie, nature juridique et type d'identifiant sont issues du
**Protocole d'Échange Standard v2 (PESv2)**, publié par la DGFiP (Direction Générale des Finances
Publiques) pour les échanges dématérialisés entre ordonnateurs et comptables publics.

## Catalogue des profils

| Profil | Parent FHIR | Table Oracle source | Rôle métier |
|---|---|---|---|
| `TiersProfile` | `FRCoreOrganizationProfile` (FR Core) | `ECO.ETIER` | Profil de base, commun aux trois rôles. Porte l'identité (nom, adresse, actif/inactif), les identifiants partagés (SIRET, SIREN, FINESS, TVA, NIR, hors UE, Tahiti, RIDET, FRWF, IREP, NFP), la catégorie TG, la nature juridique et la domiciliation bancaire. |
| `FournisseurProfile` | `TiersProfile` | `ECO.FOU` | Un tiers dont on achète des biens ou services : porte les conditions de paiement, les comptes comptables (classes 2 et 6), les indicateurs réglementaires (marchés publics, UGAP, Chorus Pro) et les commentaires libres. |
| `DebiteurProfile` | `TiersProfile` | `ECO.DBT` | Un tiers qui doit de l'argent à l'établissement (titres de recette) : domiciliation bancaire obligatoire (au moins un RIB ou IBAN), type (occasionnel/normal), indicateurs de catégorie particulière (laboratoire, locataire, agent, patient hospitalier). |
| `PayeurSanteProfile` | `TiersProfile` | *(sous-ensemble qualifié de `ECO.ETIER`/organismes)* | Un organisme qui rembourse des frais de soins : assurance maladie obligatoire (CPAM, MSA...) ou complémentaire (mutuelle). Porte le grand régime, le numéro de caisse/organisme, et le référencement ROC (Référentiel des Organismes Complémentaires) pour le tiers payant. |

Il n'existe **pas** de profil `SuccursaleProfile` distinct. Une succursale (point de livraison,
adresse de facturation locale, siège secondaire) est simplement une **autre instance** du même profil
(`FournisseurProfile` ou `DebiteurProfile`), reliée à son organisation principale par
`Organization.partOf`, et qualifiée par `SuccursaleUsageExtension`. Voir la section
[Succursales](#succursales--un-motif-pas-un-profil) ci-dessous : `partOf` est une relation
hiérarchique entre instances au moment de l'exécution, pas un mécanisme d'héritage de profil FHIR.

### TiersProfile — le profil socle

`TiersProfile` redéfinit le slicing `identifier` (FR Core 2.2.0 ne le fournit plus nativement pour
`Organization`) avec un discriminateur `system`, et ajoute des slices pour chaque type
d'identifiant reconnu par les interfaces CPage historiques (EFOU, KERD) :

| Slice `identifier` | Code type d'identifiant | Origine |
|---|---|---|
| `etierId` | — | Identifiant interne CPage (`IDTITI`) |
| `siret` / `siren` / `finess` | 01 / 02 / 03 | Slices déjà présents dans FR Core, redéclarés ici |
| `tva` | 05 | TVA intracommunautaire |
| `nir` | 04 | Numéro de Sécurité sociale (15 caractères) |
| `horsUE` | 06 | Identifiant pour tiers hors Union Européenne |
| `tahiti` | 07 | Numéro Tahiti (Polynésie française) |
| `ridet` | 08 | RIDET (Nouvelle-Calédonie) |
| `frwf` | 10 | Identifiant Wallis-et-Futuna |
| `irep` | 11 | Répertoire des Établissements Publics (Polynésie française) |
| `nfp` | 12 | Numéro de Fichier de Paie (flux paie) |

Ces identifiants ultramarins (Tahiti, RIDET, Wallis-et-Futuna, IREP) reflètent le fait que le SIH
CPage couvre des établissements en dehors du régime SIRET/SIREN métropolitain classique.

### Succursales — un motif, pas un profil

Les fichiers d'exemple `ExempleSuccursale.fsh` et `ExempleSuccursaleFournisseur.fsh` illustrent le
motif : une deuxième instance de `FournisseurProfile` (ou `DebiteurProfile`), avec son propre SIRET
(établissement INSEE distinct du siège), son propre code interne, éventuellement son propre RIB, et
une référence `partOf` vers l'instance représentant le siège. L'extension `SuccursaleUsageExtension`
qualifie l'usage de cette succursale : `POINT_LIVRAISON`, `FACTURATION`, ou `SIEGE_SOCIAL` — une
succursale peut cumuler plusieurs usages.

## Extensions

### Extensions portées par `TiersProfile` (communes aux trois rôles)

| Extension | Contexte | Rôle |
|---|---|---|
| `TiersRoleExtension` | Organization | Rôle(s) du tiers : `supplier`, `debtor`, `payer` (répétable — un tiers peut cumuler des rôles) |
| `TiersCategory` | Organization | Catégorie TG (codes 00–74, nomenclature PESv2 `TCatTiers`) |
| `TiersLegalNature` | Organization | Nature juridique (codes 00–11, nomenclature PESv2 `TNatJur`) |
| `TiersBankAccount` | Organization | Domiciliation bancaire — structure `TBancaire` du PESv2 : RIB français (code établissement + guichet + compte + clé) **ou** IBAN/BIC international, plus paramètres CPage (EDI, affacturage, moyens de paiement) |
| `TiersIdentifierType` | Identifier | Qualifie le type d'un identifiant (codes 01–09) |
| `TiersAddressLocalization` | Address | Zone géographique de l'adresse : `FRANCE`, `EUROPE`, `AUTRE` |
| `TiersPersonDetails` | Organization | Civilité, prénom, matricule, numéro de dossier patient — pour les tiers personnes physiques (catégorie TG = 01) |
| `TiersPublicSectorExtension` | Organization | Compte de contrepartie et code régie (secteur public) |
| `TiersInternalCodeExtension` | Organization | Code interne fournisseur/débiteur |
| `SuccursaleUsageExtension` | Organization | Usage d'une succursale rattachée par `partOf` |
| `ChorusIdentifierType` | Identifier | Type d'identifiant reconnu par CHORUS Pro (codes 01–08, sans le code 09 « en cours d'immatriculation » — CHORUS n'accepte que les identifiants définitifs) |

### Extensions spécifiques `FournisseurProfile`

| Extension | Contenu |
|---|---|
| `FournisseurComptabiliteExtension` | Lettre budgétaire + numéro de compte, classes comptables 2 (immobilisations) et 6 (charges) |
| `FournisseurPaiementExtension` | Délai et jour de paiement, montant minimum de commande, taux transitaire, indicateur escompte |
| `FournisseurAttributsExtension` | Type (fournisseur régulier / transitaire / régie / prestataire), priorité de règlement, catégorie interne, références croisées (numéro client, débiteur associé, Mutuelle Nationale des Hospitaliers), indicateurs réglementaires (marchés publics, UGAP, honoraires, Chorus), indicateurs techniques de synchronisation (à extraire, modifié depuis extraction) |
| `FournisseurCommentairesExtension` | Trois commentaires libres + option d'édition sur les documents |

### Extensions spécifiques `DebiteurProfile`

| Extension | Contenu |
|---|---|
| `DebiteurParametresExtension` | Compte comptable, type de résident, facturation des actes de biologie, liquidation souple, désactivation ASAP dématérialisé, fournisseur associé |
| `TiersDebtorAttributsExtension` | Type débiteur (occasionnel/normal) et indicateurs de catégorie particulière : laboratoire, locataire, agent, patient hospitalier (`HOSPTI`) |

### Extension spécifique `PayeurSanteProfile`

| Extension | Contenu |
|---|---|
| `PayeurSanteExtension` | Type de payeur, code centre, numéro de caisse, grand régime, numéro d'organisme, délai de prise en charge, et un bloc **ROC** (Référentiel des Organismes Complémentaires) répétable — numéro AMC, code CSR, convention — pour le tiers payant intégral avec les mutuelles |

## Terminologies

### CodeSystems

| CodeSystem | Source | Contenu |
|---|---|---|
| `TiersCategoryCS` | PESv2 (`TCatTiers`) | 24 catégories : État, collectivités territoriales, établissements publics de santé, organismes sociaux (CPAM, MSA, CNRACL, IRCANTEC...), personne physique, etc. |
| `TiersLegalNatureCS` | PESv2 (`TNatJur`) | 12 natures juridiques : particulier, société, association, établissement public national, collectivité territoriale, État étranger, CAF, etc. |
| `TiersIdentifierTypeCS` | PESv2 (`TNatIdTiers`) | 12 types d'identifiant : SIRET, SIREN, FINESS, NIR, TVA, hors UE, Tahiti, RIDET, en cours d'immatriculation, FRWF, IREP, NFP |
| `TiersRoleCodeSystem` | CPage | 3 rôles : `supplier`, `debtor`, `payer` |
| `TiersCivilityCS` | CPage | 5 civilités (M, MME, MLLE, METMME, MOUMME) |
| `TiersDebtorTypeCS` | CPage | Occasionnel / Normal |
| `TypeResidentCS` | CPage | Résident / Non résident |
| `TiersAddressLocalizationCS` | CPage | FRANCE / EUROPE / AUTRE |
| `SuccursaleUsageCS` | CPage | Point de livraison / Facturation / Siège social |
| `ChorusIdentifierTypeCS` | CPage (dérivé PESv2) | 8 types d'identifiant acceptés par CHORUS Pro |
| `GrandRegimeCS` | CPage | Sécurité Sociale, MSA, RSI, CNAV, Mutuelle |
| `MoyenPaiementCS` | CPage | Numéraire, chèque, virement (standard, application externe, gros montant, interne) |

Chaque CodeSystem est accompagné de son ValueSet (`TiersCategoryVS`, `TiersLegalNatureVS`,
`TiersIdentifierTypeVS`, `TiersRoleValueSet`, `TiersCivilityVS`, `TiersDebtorTypeVS`, `TypeResidentVS`,
`TiersAddressLocalizationVS`, `SuccursaleUsageVS`, `ChorusIdentifierTypeVS`, `GrandRegimeVS`,
`MoyenPaiementVS`), chacun un simple `include codes from system`.

### SearchParameter

| SearchParameter | Code de recherche | Usage |
|---|---|---|
| `TiersRoleSearchParameter` | `tiers-role` | Filtrer par rôle (fournisseur/débiteur/payeur), multi-valeurs OR et AND |
| `BankAccountIbanSearchParameter` | `bank-account-iban` | Retrouver un tiers par IBAN |
| `TiersCategorySearchParameter` | — | Filtrer par catégorie TG |
| `TiersLegalNatureSearchParameter` | — | Filtrer par nature juridique |
| `DebiteurCodeSearchParameter` | — | Rechercher un débiteur par code interne |
| `DebiteurTypeResidentSearchParameter` | — | Filtrer les débiteurs par type de résident fiscal |
| `FournisseurCodeSearchParameter` | — | Rechercher un fournisseur par code interne |
| `PayeurGrandRegimeSearchParameter` | — | Filtrer les payeurs santé par grand régime |
| `PayeurTypeSearchParameter` | — | Filtrer par type de payeur |
| `SuccursaleUsageSearchParameter` | — | Filtrer par usage de succursale |

## NamingSystem

| NamingSystem | Objet |
|---|---|
| `ridet-identifier-ns` | RIDET — Nouvelle-Calédonie (URI provisoire, en attente d'OID officiel) |
| *(Tahiti)* | Identifiant Tahiti — Polynésie française (même statut provisoire) |

## Retour

[Accueil](index.html) · [Structure hospitalière](structure-hospitaliere.html) ·
[Ressources de conformité](artifacts.html)
