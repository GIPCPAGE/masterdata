// =============================================
// CodeSystem: Catégorie de tiers
// =============================================

CodeSystem: TiersCategoryCS
Id: tiers-category-cs
Title: "Catégorie de tiers (TCatTiers)"
Description: """Catégories de tiers selon la nomenclature DGFiP (codes 00-74). Permet de classifier les types
d'organisations : État, collectivités, établissements publics, organismes sociaux, personnes physiques, etc.

Cette nomenclature est issue du **Protocole d'Échange Standard v2 (PESv2)** publié par la Direction
Générale des Finances Publiques (DGFiP). Elle correspond au type `TCatTiers` du bloc `<BlocTiers>`
défini dans le XSD PESv2 (schéma `PES_V2.xsd`).

Pour toute question relative à la maintenance de cette liste, se référer à la documentation officielle
PESv2 disponible sur le portail de la DGFiP (https://www.collectivites-locales.gouv.fr/finances-locales/pesv2)."""
* ^version = "1.0.0"
* ^status = #active
* ^experimental = false
* ^publisher = "DGFiP — Direction Générale des Finances Publiques"
* ^contact.name = "CPage (diffusion FHIR)"
* ^contact.telecom.system = #url
* ^contact.telecom.value = "https://www.cpage.fr"
* ^copyright = "Source : DGFiP — Protocole d'Échange Standard v2 (PESv2), type TCatTiers. Données publiques issues de la réglementation financière des collectivités locales."
* ^caseSensitive = true
* ^content = #complete
* ^count = 24
* ^meta.profile = "http://hl7.org/fhir/StructureDefinition/shareablecodesystem"

* #00 "Non renseigné" "Catégorie non renseignée. Extension CPage — code absent de la définition normative TCatTiers du PESv2."
* #01 "Personnes physiques" "Personne physique (particulier, artisan, commerçant, agriculteur)"
* #20 "Etat et établissements publics nationaux" "État français et établissements publics nationaux"
* #21 "Régions" "Région (collectivité territoriale)"
* #22 "Départements" "Département (collectivité territoriale)"
* #23 "Communes" "Commune"
* #24 "Groupements de collectivités" "Groupement de collectivités territoriales"
* #25 "Caisses des écoles" "Caisse des écoles"
* #26 "CCAS" "Centre Communal d'Action Sociale"
* #27 "Etablissements publics de santé" "Établissement public de santé (hôpitaux, CHU, etc.)"
* #28 "Ecole nationale de la santé publique" "École Nationale de la Santé Publique (ENSP)"
* #29 "Autres établissements publics et organismes internationaux" "Autre établissement public et organisme international"
* #50 "Personnes morales de droit privé autres qu'organismes sociaux" "Personne morale de droit privé autre qu'organisme social"
* #60 "Caisses de sécurité sociale régime général" "Caisse de Sécurité Sociale - régime général (CPAM, CRAM, etc.)"
* #61 "Caisses de sécurité sociale régime agricole" "Caisse de Sécurité Sociale - régime agricole (MSA)"
* #62 "Sécurité sociale des travailleurs non salariés et professions non agricoles" "Sécurité sociale des travailleurs non-salariés et professions non agricoles"
* #63 "Autres régimes obligatoires de sécurité sociale" "Autre régime obligatoire de sécurité sociale"
* #64 "Autres caisses de sécurité sociale" "Autres caisses de sécurité sociale (hors régimes général, agricole, TNS et autres régimes obligatoires)"
* #65 "Caisses complémentaires et divers autres tiers payants" "Caisses de sécurité sociale complémentaires, mutuelles et divers autres tiers payants"
* #70 "CNRACL" "Caisse Nationale de Retraites des Agents des Collectivités Locales"
* #71 "IRCANTEC" "Institution de Retraite Complémentaire des Agents Non Titulaires de l'État et des Collectivités"
* #72 "ASSEDIC" "ASSEDIC / Pôle Emploi"
* #73 "Caisses mutualistes de retraite complémentaires" "Caisse mutualiste de retraite complémentaire"
* #74 "Autres organismes sociaux" "Autre organisme social"
