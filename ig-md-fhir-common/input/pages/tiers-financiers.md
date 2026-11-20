Cette page détaille le domaine **Tiers financiers** de l'IG Commun CPage MasterData : les profils,
extensions et terminologies modélisant les organisations (et, ponctuellement, les personnes
physiques) avec lesquelles un établissement de santé entretient une relation financière.

### Qu'est-ce qu'un « Tiers » ?

Dans la comptabilité publique française, un **Tiers** est toute personne physique ou morale externe
à l'établissement avec laquelle celui-ci a une relation financière : elle lui vend des biens ou
services (fournisseur) ou elle lui doit de l'argent (débiteur).

Le tiers du Master Data ne porte **aucun rôle** : être fournisseur ou débiteur est une relation entre
un établissement utilisateur et le tiers, qui reste dans le module de cet établissement (fiches
fournisseur et débiteur de la GEF). Il n'existe donc ni profil fournisseur, ni profil débiteur, ni
restriction de rôle sur une adresse ou un compte bancaire. Les paramètres propres aux circuits de traitement de la GEF (conditions de paiement,
comptes comptables, Chorus, régie, EDI, affacturage, moyens de paiement, commentaires...) restent
dans la GEF et ne remontent pas au Master Data.

Le Master Data porte ce qui est vrai pour **tous** les tenants. Ce qui est propre au couple
(tenant × tiers), comme le code tiers GEF (`IDTITI`), n'est pas exposé par ces profils.

Toutes les nomenclatures de catégorie, nature juridique et type d'identifiant sont issues du
**Protocole d'Échange Standard v2 (PESv2)**, publié par la DGFiP (Direction Générale des Finances
Publiques) pour les échanges dématérialisés entre ordonnateurs et comptables publics.

### Catalogue des profils

| Profil | Parent FHIR | Rôle métier |
|---|---|---|
| `TiersProfile` | `FRCoreOrganizationProfile` (FR Core) | Le tiers, représenté par son **établissement principal**. Porte l'identité (raison sociale, complément de nom, alias, actif), les identifiants (SIRET de l'établissement principal, SIREN, FINESS, TVA, NIR, hors UE, Tahiti, RIDET, FRWF, IREP, NFP), le rôle unique, les spécificités, la catégorie de tiers, la nature juridique, l'adresse d'ordre 1 (`address`, contacts en `telecom`), les autres adresses (`contact`), la personne physique (`contact[personnePhysique]`) et les comptes bancaires de l'établissement principal. |
| `TiersEtablissementSecondaireProfile` | `FRCoreOrganizationProfile` (FR Core) | Un site du tiers distinct de l'établissement principal, rattaché à celui-ci par `partOf`. Porte son SIRET (facultatif), son adresse, ses contacts et ses comptes bancaires propres. Il n'a pas de rôle : le rôle est celui du tiers. |

#### Établissements

Tout tiers a exactement un établissement principal (la fiche tiers de la GEF) : c'est l'instance
de `TiersProfile`. Chaque autre site est une instance de `TiersEtablissementSecondaireProfile`,
avec son propre SIRET, facultatif, et une référence `partOf` vers l'établissement principal. `partOf`
est une relation entre instances, pas un mécanisme d'héritage de profil.

Un établissement secondaire porte toujours au moins un identifiant. Publié par le Master Data, il
porte l'identifiant que le Master Data lui attribue (slice `etablissementId`, NamingSystem
`tiers-etablissement-identifier`), avec ou sans SIRET. Poussé par une application, il porte son
SIRET ou, à défaut, l'identifiant de l'établissement chez l'émetteur.

Règle de contrôle : quand il est renseigné, les 9 premiers chiffres du SIRET d'un établissement sont
le SIREN du tiers.

#### Adresses et contacts

Pour chaque établissement, l'adresse d'ordre 1 est portée par `address` et ses contacts
(téléphone, email, télécopie, télex, site internet) par `telecom`. Les adresses d'ordre supérieur
sont portées par `contact` : `contact.address` porte l'adresse, `contact.name` son destinataire
lorsqu'il diffère de la raison sociale, et `contact.telecom` ses contacts.

Le type d'un contact est porté par `telecom.system` : `phone` (téléphone), `email`, `fax`
(télécopie), `url` (site internet). Le télex, sans système FHIR propre, est porté en `other` ; un
`other` reçu est lu comme un télex.

Le destinataire de l'adresse d'ordre 1 dépend de l'établissement :

- **établissement principal** : `contact.name.text` d'un contact de purpose
  `destinataire-adresse-principale` (sans adresse ni telecom), car `name` y porte la raison sociale
  du tiers ;
- **établissement secondaire** : `name` de son Organization.

Le CEDEX d'une adresse est porté à la suite de la ville dans `city`, tel qu'il s'écrit sur la
dernière ligne de l'adresse postale : `DIJON CEDEX 9`.

#### Comptes bancaires

Un compte bancaire est toujours porté par un établissement, via l'extension `TiersBankAccount`.
L'IBAN est la valeur maître : le RIB français s'en déduit.

- Un compte commun à toute la société est porté par l'établissement principal avec
  `communSociete = true`. Ce drapeau est interdit sur un établissement secondaire.
- Un compte propre à un site est porté par l'établissement secondaire concerné.
- Un site utilise ses propres comptes et les comptes communs de l'établissement principal.

#### Identifiants

`TiersProfile` redéfinit le slicing `identifier` (FR Core 2.2.0 ne le fournit plus nativement pour
`Organization`) avec un discriminateur `system` :

| Slice `identifier` | Code type d'identifiant | Origine |
|---|---|---|
| `etierId` | — | Identifiant du tiers dans le Master Data |
| `siret` | 01 | SIRET de l'établissement principal (le SIRET est porté par l'établissement) |
| `siren` / `finess` | 02 / 03 | Slices redéclarés ici |
| `nir` | 04 | Numéro de Sécurité sociale (15 caractères) |
| `tva` | 05 | TVA intracommunautaire |
| `horsUE` | 06 | Identifiant pour tiers hors Union Européenne |
| `tahiti` | 07 | Numéro Tahiti (Polynésie française) |
| `ridet` | 08 | RIDET (Nouvelle-Calédonie) |
| `frwf` | 10 | Identifiant Wallis-et-Futuna |
| `irep` | 11 | Répertoire des Établissements Publics (Polynésie française) |
| `nfp` | 12 | Numéro de Fichier de Paie (flux paie) |

Ces identifiants ultramarins (Tahiti, RIDET, Wallis-et-Futuna, IREP) reflètent le fait que le SIH
CPage couvre des établissements en dehors du régime SIRET/SIREN métropolitain classique.

### Extensions

| Extension | Contexte | Rôle |
|---|---|---|
| `organization-period` (HL7, déjà utilisée par FR Core) | Organization | Période de validité du tiers : `start` obligatoire, `end` facultatif (absent : pas de date de fin de validité) |
| `TiersBankAccount` | Organization | Compte bancaire : titulaire, IBAN, BIC, actif, compte commun à la société |
| `TiersSpecificityExtension` | Organization | Spécificités (répétable) : laboratoire, locataire, agent, débiteur mortuaire, hospitalier |
| `TiersCategory` | Organization | Catégorie de tiers (codes 00–74, nomenclature PESv2 `TCatTiers`) |
| `TiersLegalNature` | Organization | Nature juridique (codes 00–11, nomenclature PESv2 `TNatJur`) |
| `TiersIdentifierType` | Identifier | Qualifie le type d'un identifiant |
| `TiersBirthDate` | Organization.contact | Date de naissance d'un tiers personne physique, sur le contact `personnePhysique` |

Le complément de nom utilise l'extension FR Core `shortName`, et le statut actif l'élément
`Organization.active`.

#### Personne physique

L'identité d'un tiers personne physique (catégorie de tiers = 01) est portée par le contact
`personnePhysique`, identifié par son `purpose` (`TiersContactPurposeCS#personne-physique`) :
la civilité dans `name.prefix` (codes `TiersCivilityVS`), le prénom dans `name.given`, le nom dans
`name.family` et la date de naissance dans l'extension `TiersBirthDate`, `Organization.contact`
n'ayant pas d'élément date de naissance. Les contacts sans `purpose` restent les adresses
d'ordre supérieur à 1 et portent obligatoirement une adresse.

### Terminologies

#### CodeSystems

| CodeSystem | Source | Contenu |
|---|---|---|
| `TiersCategoryCS` | PESv2 (`TCatTiers`) | 24 catégories : État, collectivités territoriales, établissements publics de santé, organismes sociaux (CPAM, MSA, CNRACL, IRCANTEC...), personne physique, etc. |
| `TiersLegalNatureCS` | PESv2 (`TNatJur`) | 12 natures juridiques : particulier, société, association, établissement public national, collectivité territoriale, État étranger, CAF, etc. |
| `TiersIdentifierTypeCS` | PESv2 (`TNatIdTiers`) | 11 types d'identifiant : SIRET, SIREN, FINESS, NIR, TVA, hors UE, Tahiti, RIDET, FRWF, IREP, NFP |
| `TiersSpecificityCodeSystem` | CPage | 5 spécificités : LABORATOIRE, LOCATAIRE, AGENT, MORTUAIRE, HOSPITALIER |
| `TiersCivilityCS` | CPage | 5 civilités (M, MME, MLLE, METMME, MOUMME) |
| `TiersContactPurposeCS` | CPage | Objet d'un contact : `personne-physique`, `destinataire-adresse-principale` |

Chaque CodeSystem est accompagné de son ValueSet (`TiersCategoryVS`, `TiersLegalNatureVS`,
`TiersIdentifierTypeVS`, `TiersSpecificityValueSet`, `TiersCivilityVS`),
chacun un simple `include codes from system`. `TiersContactPurposeCS` n'a pas de ValueSet : son
unique code est fixé sur le contact `personnePhysique`.

#### SearchParameter

| SearchParameter | Code de recherche | Usage |
|---|---|---|
| `BankAccountIbanSearchParameter` | `bank-account-iban` | Retrouver un tiers par IBAN |
| `TiersCategorySearchParameter` | — | Filtrer par catégorie de tiers |
| `TiersLegalNatureSearchParameter` | — | Filtrer par nature juridique |

### Exemples

| Exemple | Profil | Illustre |
|---|---|---|
| `ExempleTiersComplet` | `TiersProfile` | Tiers : SIRET, adresse d'ordre 1 et seconde adresse, complément de nom, deux comptes bancaires |
| `ExempleTiersPersonnePhysique` | `TiersProfile` | Tiers personne physique : NIR, contact `personnePhysique` (civilité, prénom, nom, date de naissance) |
| `ExempleTiersEtablissementSecondaire` | `TiersEtablissementSecondaireProfile` | Site rattaché à `ExempleTiersComplet` : SIRET propre, adresse restreinte au circuit débiteur, compte propre au site |

### NamingSystem

| NamingSystem | Objet |
|---|---|
| `tiers-etablissement-identifier-ns` | Identifiant attribué par le Master Data à un établissement de tiers |
| `ridet-identifier-ns` | RIDET — Nouvelle-Calédonie (URI provisoire, en attente d'OID officiel) |
| *(Tahiti)* | Identifiant Tahiti — Polynésie française (même statut provisoire) |

### Retour

[Accueil](index.html) · [Structure hospitalière](structure-hospitaliere.html) ·
[Ressources de conformité](artifacts.html)
