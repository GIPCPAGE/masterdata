// =============================================
// CodeSystem: Nature Juridique
// =============================================

CodeSystem: TiersLegalNatureCS
Id: tiers-legal-nature-cs
Title: "Nature juridique du tiers (TNatJur)"
Description: """Nature juridique des tiers selon la nomenclature **TNatJur** du Protocole d'Échange Standard v2
(PESv2) publié par la Direction Générale des Finances Publiques (DGFiP).

Cette liste correspond au type `TNatJur` défini dans le XSD PESv2 (`PES_V2.xsd`), champ `NatJurTiers`
du bloc `<BlocTiers>`. Les codes 01 à 11 sont normatifs PESv2.

Le code `00` (Inconnue) est une extension locale CPage pour représenter l'absence de valeur renseignée,
non présent dans la définition PESv2 originale.

Pour toute question relative à la maintenance de cette liste, se référer à la documentation officielle
PESv2 disponible sur le portail de la DGFiP (https://www.collectivites-locales.gouv.fr/finances-locales/pesv2)."""
* ^url = "https://www.cpage.fr/ig/masterdata/common/CodeSystem/tiers-legal-nature-cs"
* ^version = "1.0.0"
* ^status = #active
* ^experimental = false
* ^publisher = "DGFiP — Direction Générale des Finances Publiques"
* ^contact.name = "CPage (diffusion FHIR)"
* ^contact.telecom.system = #url
* ^contact.telecom.value = "https://www.cpage.fr"
* ^copyright = "Source : DGFiP — Protocole d'Échange Standard v2 (PESv2), type TNatJur. Données publiques issues de la réglementation financière des collectivités locales."
* ^caseSensitive = true
* ^content = #complete
* ^count = 12

* #00 "Inconnue" "Nature juridique non renseignée ou inconnue. Extension CPage — code absent de la définition normative TNatJur du PESv2."
* #01 "Particulier" "Personne physique - Particulier"
* #02 "Artisan - Commerçant - Agriculteur" "Personne physique exerçant une activité professionnelle (artisan, commerçant, agriculteur)"
* #03 "Société" "Société (SA, SARL, SAS, SNC, etc.)"
* #04 "CAM ou caisse appliquant les mêmes règles" "Caisse d'Assurance Maladie ou caisse appliquant les mêmes règles"
* #05 "Caisse complémentaire" "Caisse de sécurité sociale complémentaire"
* #06 "Association" "Association loi 1901"
* #07 "État ou organisme d'État" "État français ou organisme d'État"
* #08 "Établissement public national" "Établissement public national (EPA, EPIC, etc.)"
* #09 "Collectivité territoriale - EPL - EPS" "Collectivité territoriale, Établissement Public Local, Établissement Public de Santé"
* #10 "État étranger - Ambassade" "État étranger ou représentation diplomatique (ambassade, consulat)"
* #11 "CAF" "Caisse d'Allocations Familiales"
