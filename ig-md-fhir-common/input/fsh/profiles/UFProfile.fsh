// =============================================
// Profil : Unité Fonctionnelle (unité fonctionnelle)
// =============================================
// Hérite de FRCoreOrganizationUFProfile (FR Core 2.2.0).
//
// FR Core UF définit déjà : fr-core-organization-discipline-equipement,
//   fr-core-organization-type-activite, fr-core-organization-champ-activite,
//   fr-core-organization-place-hebergement-theorique, fr-core-organization-uf-indicateur,
//   fr-core-organization-uf-externe, fr-core-organization-demandeuse-acte,
//   fr-core-organization-executante-acte.
//
// Extensions FR Core de l'UAC reprises ici (leur contexte est Organization) :
//   fr-core-organization-discipline-prestation : discipline de prestation de la SAE
//   fr-core-organization-tarif                 : tarif national (nomenclature TNJP)
//
// CPage ajoute (Common IG) :
//   Core          : ufCode (NUUFUF), validité temporelle (DATDUF/DATFUF/INVAUF)
//   Sites/parents : ETA_NUETET (site localisation), CRE_NUCRCR (partOf CR),
//                   POA_NUPAPA (pôle optionnel)
//   Clinique      : CLDOUF, LITLUF
//   Budget        : SBUD_CODEBUD
//
// CPage-spécifiques (ig-md-fhir-cpage), attributs de portée CPAGE :
//   Clinique      : TYPEUF, SEANUF, LURGUF, ACLIUF, UFMAUF, CONFUF, CURMUF, DOACUF,
//                   REACUF, AUTOUF
//   Budget        : regroupements RU1/RU2/URG, SCUF (catégorie)
//   Module UFM : lits, étiquettes, options patients/clinique
//   Module UFE : TVA, comptabilité ECO
//   Module UFP : personnel/RH

Profile: UFProfile
Parent: FRCoreOrganizationUFProfile
Id: strh-uf-profile
Title: "Unité Fonctionnelle"
Description: """
Profil FHIR R4 représentant une unité fonctionnelle hospitalière.

Hérite de `FRCoreOrganizationUFProfile` (FR Core 2.2.0) qui porte déjà les 9 extensions
FR Core (discipline équipement, type activité, champ activité MCO/HAD/PSY, capacité lits,
indicateur UF HEB/SOIN/ADMIN/MED, UF externe, demandeuse/exécutante acte).

**Modèle temporel** : PK composite (NUUFUF + DATDUF).

**Hiérarchie** :
- `partOf` → Centre de Responsabilité (`CentreResponsabiliteProfile`) via le Centre de Responsabilité
- `extension[siteLocalisation]` → site géographique : site géographique de localisation physique
- `extension[poleId]` → pôle optionnel du pôle

**Scope** : TENANT uniquement.
"""

// ── Identifiants ──────────────────────────────────────────────────────────────

* identifier ^slicing.discriminator.type = #value
* identifier ^slicing.discriminator.path = "system"
* identifier ^slicing.rules = #open

* identifier contains
    strHId 1..1 MS and
    ufCode 1..1 MS

* identifier[strHId].system = "https://www.cpage.fr/ig/masterdata/common/identifiers/strh" (exactly)
* identifier[strHId].value 1..1 MS
* identifier[strHId] ^short = "Identifiant MDM interne (UUID)"

// Code UF (NUUFUF — 4 chars, != 0000)
* identifier[ufCode].system = "https://www.cpage.fr/ig/masterdata/common/identifiers/uf-code" (exactly)
* identifier[ufCode].value 1..1 MS
* identifier[ufCode] ^short = "Code UF (NUUFUF — 4 chars)"

// ── Dénomination ─────────────────────────────────────────────────────────────

* name 1..1 MS
* name ^short = "Libellé complet de l'UF (LIBEUF — 40 chars)"

* alias 0..1 MS
* alias ^short = "Libellé réduit (LIBRUF — 20 chars)"

// ── Statut actif ──────────────────────────────────────────────────────────────

* active 0..1 MS
* active ^short = "UF active — false si INVAUF=F ou INVAUF=I"

// ── Télécoms ──────────────────────────────────────────────────────────────────

* telecom 0..* MS
* telecom ^slicing.discriminator.type = #value
* telecom ^slicing.discriminator.path = "system"
* telecom ^slicing.rules = #open

* telecom contains
    telephone 0..1 MS and
    fax       0..1 MS

* telecom[telephone].system = #phone (exactly)
* telecom[telephone] ^short = "Téléphone (TELEUF — 20 chars)"

* telecom[fax].system = #fax (exactly)
* telecom[fax] ^short = "Télécopie (TELCUF — 20 chars)"

// ── Responsable : code du responsable ────────────────────────────────────────

* contact 0..1 MS
* contact.name.text 0..1 MS
* contact.name.text ^short = "Code du responsable de l'UF (attribut LOCAL, texte libre)"

// ── Extensions CPage Common IG ────────────────────────────────────────────────

* extension contains
    FRCoreOrganizationDisciplinePrestationExtension named disciplinePrestation 0..1 MS and
    FRCoreOrganizationTarifExtension     named tarif               0..1 MS and
    UFCodeValiditeExtension              named codeValidite        0..1 MS and
    UFSiteLocalisationExtension          named siteLocalisation    1..1 MS and
    UFPoleExtension                      named pole                0..1 MS and
    UFClasseDominanteExtension           named classeDominante     0..1 MS and
    UFLettreBudgetaireExtension          named lettreBudgetaire    1..1 MS and
    UFLibelleTresLongExtension           named libelleTresLong     0..1 MS and
    StrHLibelleDiffusionExtension        named libelleDiffusion    0..1 MS and
    StrHCodeGroupementHospitalierExtension named codeGroupementHospitalier 0..1 MS and
    UFBatimentExtension           named batiment     0..1 MS and
    UFSectionAnalyseExtension            named sectionAnalyse      0..1 MS and
    UFChambreParticuliereExtension       named chambreParticuliere 0..1 MS and
    UFCompteAnalytiqueExtension          named compteAnalytique    0..1 MS and
    UFMedecinChefExtension               named medecinChef         0..1 MS and
    UFMedecinResponsableExtension        named medecinResponsable  0..1 MS and
    UFPenibiliteExtension                named penibilite          0..1 MS

* extension[disciplinePrestation] ^short = "Discipline de prestation de la SAE (FR Core, jeu de valeurs extensible) : porte les codes de la discipline de l'UF qui appartiennent à cette nomenclature"
* extension[tarif]              ^short = "Tarif national de l'UF (FR Core, nomenclature TNJP, jeu de valeurs extensible) : code tarif national d'appartenance du tarif de base de l'UF"
* extension[usePeriod]          ^short = "Période de validité (DATDUF / DATFUF), organization-period hérité de FR Core"
* extension[shortName]          ^short = "Libellé réduit (LIBRUF), extension FR Core short-name"
* extension[libelleDiffusion]   ^short = "Libellé de diffusion"
* extension[codeGroupementHospitalier] ^short = "Code du groupement hospitalier (attribut LOCAL)"
* extension[batiment]    ^short = "Bâtiment (attribut LOCAL)"
* extension[sectionAnalyse]     ^short = "Section d'analyse, à titre indicatif (attribut LOCAL)"
* extension[chambreParticuliere] ^short = "Chambre particulière (attribut LOCAL)"
* extension[compteAnalytique]   ^short = "Compte analytique (attribut LOCAL)"
* extension[medecinChef]        ^short = "Médecin chef (attribut LOCAL)"
* extension[medecinResponsable] ^short = "Médecin responsable (UFO.MED_NUMEME)"
* extension[penibilite]         ^short = "Typologie de pénibilité (attribut LOCAL)"
* extension[codeValidite]       ^short = "Code validité (INVAUF : F=Fermé / I=Invalide / V=Valide)"
* extension[siteLocalisation]   ^short = "Site géographique de localisation — obligatoire"
* extension[pole]               ^short = "Pôle d'activité optionnel du pôle"
* extension[classeDominante]    ^short = "Classe dominante UF médicale (CLDOUF)"
* extension[lettreBudgetaire]   ^short = "Lettre budgétaire du CR (SBUD_CODEBUD — obligatoire)"
* extension[libelleTresLong]    ^short = "Libellé très long (LITLUF — 80 chars)"

// ── Hiérarchie : Centre de Responsabilité → UF ───────────────────────────────

* partOf 0..1 MS
* partOf only Reference(CentreResponsabiliteProfile)
* partOf ^short = "Centre de Responsabilité parent du centre de responsabilité"

// ── Relations multi-parents (FR Core member extension) ────────────────────────
// Conforme FR Core structure_relations.html (STRU-1/STRU-6) : une UF peut avoir
// plusieurs relations organisationnelles simultanées (Service, Centre d'Activité,
// Pôle). L'extension FR Core member est sémantiquement portée par le PARENT, qui
// liste ses membres (cf. GHTProfile → EntiteJuridiqueProfile) — PAS par l'enfant.
// Ces relations multi-parents sont donc exprimées côté ServiceProfile,
// CentreActiviteProfile et PoleProfile (extension[membres]), pas ici.
//
// Cas d'usage couverts par ces 3 profils :
//   - UF appartient à un SERVICE (SER_COSESE — hiérarchie historique)
//   - UF appartient à un CENTRE_ACTIVITE (CAC_NUACAC — analytique)
//   - UF appartient à un POLE (POA_NUPAPA — optionnel)
//
// Remplace les attributs JSONB serviceId, centreActiviteId, poleId par des
// références FHIR standard conformes FR Core.
