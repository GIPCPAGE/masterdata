// =============================================
// Profil : Secteur budgétaire
// =============================================
// Hérite de StructureHospitaliereOrganizationProfile (parent FR Core : FRCoreOrganizationProfile).
//
// Regroupement budgétaire qui porte une identité administrative propre (adresse, SIRET, FINESS,
// APE, URSSAF). Appartient à l'axe budgétaire ; se rattache à une entité géographique ou, pour
// certains tenants, à un groupement hospitalier, jamais aux deux. Facultatif dans la structure
// d'un tenant. Enfants : les centres de responsabilité.
// Source Oracle : SSBU (non vérifiée contre un DDL indépendant : aucun export de SSBU dans ce dépôt).
//
// Attributs Master Data → FHIR (réutilisation maximale de FR Core) :
//   identifiant          → identifier[strHId]                (hérité du profil socle)
//   code_interne         → identifier[sbCode]                (SSBU.NUSBSB)
//   libelle              → name                              (SSBU.LIBESB)
//   libelle_reduit       → alias + extension[shortName]      (SSBU.LIBRSB ; FR Core short-name)
//   date_debut/fin_validite → extension[usePeriod]           (SSBU.DATDSB/DATFSB ; organization-period, hérité de FR Core)
//   libelle_diffusion    → extension[libelleDiffusion]       (strh-libelle-diffusion, hérité du profil socle)
//   adresse (lignes, commune, code postal) → address         (SSBU.ADR1SB/ADR2SB/COMMSB/CODPSB ; fr-core-address)
//   bureau_distributeur  → address.line.extension[bureauDistributeur] (SSBU.BURDSB ; HL7 ADXP deliveryInstallationArea)
//   siret                → identifier[siret]                 (SSBU.SIRTSB)
//   finess               → identifier[finess]                (SSBU.FINSSB)
//   ape                  → extension[codeApe]                (SSBU.CAPESB ; ej-code-ape, partagée avec l'entité juridique)
//   urssaf_numero/code/libelle → extension[urssaf]           (sb-urssaf)
//   lettre_budgetaire    → extension[lettreBudgetaire]       (sb-lettre-budgetaire)
//   libelle_type_lettre_budgetaire → extension[libelleTypeLettreBudgetaire]
//   parent_groupement_hospitalier et rattachement à l'établissement → partOf
//   non exposé : code de validité
// Champ CPage-spécifique (clé de rattachement à l'établissement, SSBU.ETA_NUETET)
//   → CPageSecteurBudgetaireProfile (ig-md-fhir-cpage).

Profile: SecteurBudgetaireProfile
Parent: StructureHospitaliereOrganizationProfile
Id: strh-secteur-budgetaire-profile
Title: "Secteur budgétaire"
Description: """
Profil FHIR R4 représentant un secteur budgétaire : regroupement budgétaire qui porte une identité
administrative propre (adresse, SIRET, FINESS, APE, coordonnées URSSAF). Appartient à l'axe
budgétaire ; ses enfants sont les centres de responsabilité.

Il se rattache à une entité géographique ou, pour certains tenants, à un groupement hospitalier,
jamais aux deux, par `Organization.partOf`. Il est facultatif dans la structure d'un tenant.

Source Oracle : table `SSBU`, non vérifiée contre un DDL indépendant (aucun export de cette table
dans ce dépôt) : le mapping restitue le modèle Master Data.

**Profil CPage** : `CPageSecteurBudgetaireProfile` (ig-md-fhir-cpage) — clé de rattachement à
l'établissement.

**Scope** : TENANT uniquement.
"""

// ── Identifiants ──────────────────────────────────────────────────────────────
// Slicing déjà défini par le profil socle (discriminator value:system) — ne pas redéclarer.
// FR Core ne définit pas les tranches finess et siret sur fr-core-organization (seulement sur
// fr-core-organization-etablissement) : elles sont déclarées ici, avec les systèmes de FR Core.

* identifier contains
    sbCode 1..1 MS and
    siret 0..1 MS and
    finess 0..1 MS

* identifier[sbCode].system = "https://www.cpage.fr/ig/masterdata/common/identifiers/sb-code" (exactly)
* identifier[sbCode].value 1..1 MS
* identifier[sbCode] ^short = "Code interne du secteur budgétaire (3 caractères)"

* identifier[siret].system = "https://sirene.fr" (exactly)
* identifier[siret].value 1..1 MS
* identifier[siret] ^short = "SIRET du secteur (14 caractères)"

* identifier[finess].system = "https://finess.esante.gouv.fr" (exactly)
* identifier[finess].value 1..1 MS
* identifier[finess] ^short = "Numéro FINESS du secteur (9 caractères), unique là où il est renseigné"

// ── Type organisationnel ──────────────────────────────────────────────────────
// Organization.type n'est pas slicé par FR Core : slicing déclaré ici.
// Code propre à CPage, absent du système FR Core fr-core-cs-v2-3307 (binding de type : example).

* type 1..* MS
* type ^slicing.discriminator.type = #value
* type ^slicing.discriminator.path = "coding.code"
* type ^slicing.rules = #open

* type contains secteurBudgetaireType 1..1 MS
* type[secteurBudgetaireType].coding.system = "https://hl7.fr/ig/fhir/core/CodeSystem/fr-core-cs-v2-3307" (exactly)
* type[secteurBudgetaireType].coding.code = #SECTEUR-BUDGETAIRE (exactly)
* type[secteurBudgetaireType] ^short = "Type : secteur budgétaire (SECTEUR-BUDGETAIRE)"

// ── Dénomination ─────────────────────────────────────────────────────────────

* name ^short = "Libellé du secteur budgétaire (40 caractères)"

* alias 0..1 MS
* alias ^short = "Libellé réduit (20 caractères)"

// Libellé réduit et période de validité : extensions FR Core héritées du parent
* extension[shortName] MS
* extension[shortName] ^short = "Libellé réduit, extension FR Core short-name"
* extension[usePeriod] MS
* extension[usePeriod] ^short = "Période de validité du secteur (date de début et de fin)"

// ── Adresse ───────────────────────────────────────────────────────────────────

* address 0..1 MS
* address.line 0..2 MS
* address.line ^short = "Adresse, lignes 1 et 2"
* address.city 0..1 MS
* address.city ^short = "Commune"
* address.postalCode 0..1 MS
* address.postalCode ^short = "Code postal (5 chiffres)"
* address.line.extension contains $adxp-deliveryInstallationArea named bureauDistributeur 0..1 MS
* address.line.extension[bureauDistributeur] ^short = "Bureau distributeur, quand il diffère de la commune"

// ── Extensions propres au secteur budgétaire ─────────────────────────────────

* extension contains
    EJCodeApeExtension                      named codeApe                    0..1 MS and
    SBUrssafExtension                       named urssaf                     0..1 MS and
    SBLettreBudgetaireExtension             named lettreBudgetaire           0..1 MS and
    SBLibelleTypeLettreBudgetaireExtension  named libelleTypeLettreBudgetaire 0..1 MS

* extension[codeApe] ^short = "Code APE / NAF (5 caractères)"
* extension[urssaf] ^short = "URSSAF (numéro / code / libellé)"
* extension[lettreBudgetaire] ^short = "Lettre budgétaire (1 caractère), autorisée pour l'entité juridique du secteur"
* extension[libelleTypeLettreBudgetaire] ^short = "Libellé type de la lettre budgétaire"

// ── Hiérarchie : entité géographique ou groupement hospitalier ───────────────
// L'un ou l'autre, jamais les deux : partOf est unique. Le rattachement est enregistré comme
// un lien de hiérarchie qui fait foi.

* partOf 0..1 MS
* partOf only Reference(EntiteGeographiqueProfile or GroupementHospitalierProfile)
* partOf ^short = "Entité géographique de rattachement, ou groupement hospitalier pour certains tenants (jamais les deux)"
