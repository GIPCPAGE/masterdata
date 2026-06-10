// =============================================
// Profil : Unité Fonctionnelle (STR.UFO)
// =============================================
// Hérite de FRCoreOrganizationUFProfile (FR Core 2.2.0).
//
// FR Core UF définit déjà : fr-core-organization-discipline-equipement,
//   fr-core-organization-type-activite, fr-core-organization-champ-activite,
//   fr-core-organization-place-hebergement-theorique, fr-core-organization-uf-indicateur,
//   fr-core-organization-uf-externe, fr-core-organization-demandeuse-acte,
//   fr-core-organization-executante-acte.
//
// CPage ajoute (Common IG) :
//   Core          : ufCode (NUUFUF), validité temporelle (DATDUF/DATFUF/INVAUF)
//   Sites/parents : ETA_NUETET (site localisation), CRE_NUCRCR (partOf CR),
//                   POA_NUPAPA (pôle optionnel)
//   Clinique      : TYPEUF, SEANUF, CLDOUF, LURGUF, ACLIUF, UFMAUF, CONFUF,
//                   CURMUF, DOACUF, LITLUF, REACUF, AUTOUF
//   Budget        : SBUD_CODEBUD, regroupements RU1/RU2/URG, SCUF (catégorie)
//
// CPage-spécifiques (ig-md-fhir-cpage) :
//   Module UFM : lits, étiquettes, options patients/clinique
//   Module UFE : TVA, comptabilité ECO
//   Module UFP : personnel/RH

Profile: UFProfile
Parent: FRCoreOrganizationUFProfile
Id: strh-uf-profile
Title: "Unité Fonctionnelle"
Description: """
Profil FHIR R4 représentant une unité fonctionnelle hospitalière (table Oracle `STR.UFO`).

Hérite de `FRCoreOrganizationUFProfile` (FR Core 2.2.0) qui porte déjà les 9 extensions
FR Core (discipline équipement, type activité, champ activité MCO/HAD/PSY, capacité lits,
indicateur UF HEB/SOIN/ADMIN/MED, UF externe, demandeuse/exécutante acte).

**Modèle temporel** : PK composite (NUUFUF + DATDUF).

**Hiérarchie** :
- `partOf` → Centre de Responsabilité (`CentreResponsabiliteProfile`) via CRE_NUCRCR
- `extension[siteLocalisation]` → site géographique (ETA_NUETET — où l'UF est physiquement)
- `extension[poleId]` → pôle optionnel (POA_NUPAPA)

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

// ── Extensions CPage Common IG ────────────────────────────────────────────────

* extension contains
    UFPeriodeValiditeExtension           named periodValidite      0..1 MS and
    UFCodeValiditeExtension              named codeValidite        0..1 MS and
    UFSiteLocalisationExtension          named siteLocalisation    1..1 MS and
    UFPoleExtension                      named pole                0..1 MS and
    UFTypeUFMedicaleExtension            named typeUFMedicale      0..1 MS and
    UFIndicateurSeancesExtension         named indicateurSeances   0..1 MS and
    UFClasseDominanteExtension           named classeDominante     0..1 MS and
    UFLitsUrgenceExtension               named litsUrgence         0..1 MS and
    UFActiviteLiberaleExtension          named activiteLiberale    0..1 MS and
    UFMaterniteExtension                 named materniteLits       0..1 MS and
    UFConfidentialiteExtension           named confidentialite     0..1 MS and
    UFResponsabiliteExtension            named ufResponsabilite    0..1 MS and
    UFLettreBudgetaireExtension          named lettreBudgetaire    1..1 MS and
    UFDomaineActiviteExtension           named domaineActivite     0..1 MS and
    UFLibelleTresLongExtension           named libelleTresLong     0..1 MS and
    UFReacExtension                      named typeAutorisationUM  0..1 MS and
    UFAutorisationUrgenceExtension       named typeAutorisationUrg 0..1 MS and
    UFCategorieCUFExtension              named categorieUF         0..1 MS and
    UFRegroupementsExtension             named regroupements       0..1 MS

* extension[periodValidite]     ^short = "Période de validité (DATDUF / DATFUF)"
* extension[codeValidite]       ^short = "Code validité (INVAUF : F=Fermé / I=Invalide / V=Valide)"
* extension[siteLocalisation]   ^short = "Site géographique de localisation (ETA_NUETET — obligatoire)"
* extension[pole]               ^short = "Pôle d'activité optionnel (POA_NUPAPA)"
* extension[typeUFMedicale]     ^short = "Type UF médicale (TYPEUF : H=Hosp / E=Externe / D=Divers / A=Autre)"
* extension[indicateurSeances]  ^short = "UF à séances (SEANUF : O/N)"
* extension[classeDominante]    ^short = "Classe dominante UF médicale (CLDOUF)"
* extension[litsUrgence]        ^short = "Lits réservés urgence (LURGUF : O/N)"
* extension[activiteLiberale]   ^short = "Activité libérale (ACLIUF : O/N)"
* extension[materniteLits]      ^short = "UF où peuvent naître des bébés (UFMAUF : O/N)"
* extension[confidentialite]    ^short = "Confidentialité de l'UF (CONFUF : O/N)"
* extension[ufResponsabilite]   ^short = "UF de responsabilité (CURMUF : O/N)"
* extension[lettreBudgetaire]   ^short = "Lettre budgétaire du CR (SBUD_CODEBUD — obligatoire)"
* extension[domaineActivite]    ^short = "Domaine d'activité (DOACUF : M/C/O/N/D/P/S)"
* extension[libelleTresLong]    ^short = "Libellé très long (LITLUF — 80 chars)"
* extension[typeAutorisationUM] ^short = "Type autorisation unité médicale (REACUF — 3 chars)"
* extension[typeAutorisationUrg] ^short = "Type autorisation urgence (AUTOUF — 2 chars)"
* extension[categorieUF]        ^short = "Catégorie d'UF (SCUF_CATGCUF — FK SCUF)"
* extension[regroupements]      ^short = "Regroupements UF (RU1/RU2/URG) et codes analytiques"

// ── Hiérarchie : Centre de Responsabilité → UF ───────────────────────────────

* partOf 0..1 MS
* partOf only Reference(CentreResponsabiliteProfile)
* partOf ^short = "Centre de Responsabilité parent (CRE_NUCRCR)"

// ── Relations multi-parents (FR Core member extension) ────────────────────────
// Conforme FR Core structure_relations.html : une UF peut avoir plusieurs relations
// organisationnelles simultanées via l'extension fr-core-organization-member.
//
// Cas d'usage :
//   - UF appartient à un SERVICE (SER_COSESE — hiérarchie historique)
//   - UF appartient à un CENTRE_ACTIVITE (CAC_NUACAC — analytique)
//   - UF appartient à un POLE (POA_NUPAPA — optionnel)
//
// Remplace les attributs JSONB serviceId, centreActiviteId, poleId par des
// références FHIR standard conformes FR Core.

* extension[fr-core-organization-member] 0..* MS
* extension[fr-core-organization-member] ^short = """
    Relations multi-parents : service (SER_COSESE),
    centre d activité (CAC_NUACAC), pôle (POA_NUPAPA).
    Utiliser une extension par relation (FR Core member).
    """
