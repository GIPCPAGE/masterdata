// =============================================
// Profil CPage : Entité Juridique
// Hérite de EntiteJuridiqueProfile (ig-md-fhir-common)
// =============================================
// Champs CPage-spécifiques issus de la table Oracle STR.CHO :
//
// Receveur comptable :
//   RAISCH/AD1-3RCH/BUDRCH/COP_NCPOPO2 → extension[receveur] (adresse)
//   CBARCH/CGURCH/CCBRCH/CCIRCH/CCPRCH → extension[receveur.rib]
//   CBICCH/CIBACH                        → extension[receveur.bicIban]
//   POSCCH                               → extension[receveur.posteComptable]
//   TELRCH/TELCCH                        → extension[receveur.telephones]
//
// Numéros sociaux :
//   CACTCH → extension[numerosOrganismesPatronaux.accidentTravail]
//   CRECCH → extension[numerosOrganismesPatronaux.retraiteComplementaire]
//   CNAVCH → extension[numerosOrganismesPatronaux.cnavts]
//   IRCACH → extension[numerosOrganismesPatronaux.ircantec]
//   CAMACH → extension[numerosOrganismesPatronaux.camarca]
//   CNRACH → extension[numerosOrganismesPatronaux.cnracl]
//   URNOCH/URCOCH/URLICH → extension[numerosOrganismesPatronaux.urssaf]
//
// TVA :
//   TVARCH/TVASCH/LTVACH/CTVACH/LTVICH/CTVICH → extension[parametresTva]
//
// Divers CPage :
//   TBICCH  → extension[indicateurBic]
//   CM22CH  → extension[comptabiliteM22]
//   ITPGCH  → extension[identifiantTpg]
//   CATGCH/NATJCH → ASAP (categories) — déjà dans FR Core legal nature / type

Profile: CPageEntiteJuridiqueProfile
Parent: EntiteJuridiqueProfile
Id: cpage-entite-juridique-profile
Title: "Entité Juridique (CPage)"
Description: """
Profil CPage pour l'entité juridique hospitalière.

Hérite de `EntiteJuridiqueProfile` (ig-md-fhir-common) et ajoute les champs
spécifiques CPage issus de la table Oracle `STR.CHO` :
- Receveur comptable (coordonnées, RIB, BIC/IBAN, poste comptable)
- Numéros d'organismes patronaux (URSSAF, CNRACL, IRCANTEC, CAMARCA, CNAVTS, retraite complémentaire, caisse AT)
- Paramètres de TVA (taux récupérables, comptes budgétaires exploitation/investissement)
- Indicateurs CPage (M22, TPG, BIC)
"""

// ── Receveur comptable ────────────────────────────────────────────────────────

* extension contains
    CPageEJReceveurExtension             named receveur               0..1 MS and
    CPageEJOrganismesPatronauxExtension  named organismesPatronaux    0..1 MS and
    CPageEJParametresTvaExtension        named parametresTva          0..1 MS and
    CPageEJIndicateurBicExtension        named indicateurBic          0..1 MS and
    CPageEJComptabiliteM22Extension      named comptabiliteM22        0..1 MS and
    CPageEJIdentifiantTpgExtension       named identifiantTpg         0..1 MS

* extension[receveur]            ^short = "Receveur comptable (RAISCH + adresse + RIB/BIC-IBAN + téléphone)"
* extension[organismesPatronaux] ^short = "Numéros organismes patronaux (URSSAF, CNRACL, IRCANTEC, etc.)"
* extension[parametresTva]       ^short = "Paramètres TVA (taux et comptes budgétaires)"
* extension[indicateurBic]       ^short = "Indicateur de traitement BIC (TBICCH)"
* extension[comptabiliteM22]     ^short = "Comptabilité M22 activée (CM22CH : O/N)"
* extension[identifiantTpg]      ^short = "Identifiant TPG (ITPGCH)"
