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
* ^meta.profile = "http://hl7.org/fhir/StructureDefinition/shareablecodesystem"

// =============================================
// Déclaration des propriétés
// =============================================

* ^property[+].code = #categorieTiers
* ^property[=].description = "Code d'une catégorie de tiers (CodeSystem tiers-category-cs) à laquelle cette nature juridique peut être rattachée. Propriété répétable : une nature juridique peut relever de plusieurs catégories. Extension CPage (liaison catégorie - nature juridique de Master Data), absente du type TNatJur du PESv2."
* ^property[=].type = #code

* #00 "Inconnue" "Nature juridique non renseignée ou inconnue. Extension CPage — code absent de la définition normative TNatJur du PESv2."
* #01 "Particulier" "Personne physique - Particulier"
* #01 ^property[+].code = #categorieTiers
* #01 ^property[=].valueCode = #01
* #02 "Artisan - Commerçant - Agriculteur" "Personne physique exerçant une activité professionnelle (artisan, commerçant, agriculteur)"
* #02 ^property[+].code = #categorieTiers
* #02 ^property[=].valueCode = #01
* #03 "Société" "Société (SA, SARL, SAS, SNC, etc.)"
* #03 ^property[+].code = #categorieTiers
* #03 ^property[=].valueCode = #50
* #04 "CAM ou caisse appliquant les mêmes règles" "Caisse d'Assurance Maladie ou caisse appliquant les mêmes règles"
* #04 ^property[+].code = #categorieTiers
* #04 ^property[=].valueCode = #60
* #04 ^property[+].code = #categorieTiers
* #04 ^property[=].valueCode = #61
* #04 ^property[+].code = #categorieTiers
* #04 ^property[=].valueCode = #62
* #04 ^property[+].code = #categorieTiers
* #04 ^property[=].valueCode = #63
* #04 ^property[+].code = #categorieTiers
* #04 ^property[=].valueCode = #64
* #04 ^property[+].code = #categorieTiers
* #04 ^property[=].valueCode = #65
* #04 ^property[+].code = #categorieTiers
* #04 ^property[=].valueCode = #72
* #04 ^property[+].code = #categorieTiers
* #04 ^property[=].valueCode = #74
* #05 "Caisse complémentaire" "Caisse de sécurité sociale complémentaire"
* #05 ^property[+].code = #categorieTiers
* #05 ^property[=].valueCode = #65
* #05 ^property[+].code = #categorieTiers
* #05 ^property[=].valueCode = #70
* #05 ^property[+].code = #categorieTiers
* #05 ^property[=].valueCode = #71
* #05 ^property[+].code = #categorieTiers
* #05 ^property[=].valueCode = #73
* #06 "Association" "Association loi 1901"
* #06 ^property[+].code = #categorieTiers
* #06 ^property[=].valueCode = #50
* #07 "État ou organisme d'État" "État français ou organisme d'État"
* #07 ^property[+].code = #categorieTiers
* #07 ^property[=].valueCode = #20
* #08 "Établissement public national" "Établissement public national (EPA, EPIC, etc.)"
* #08 ^property[+].code = #categorieTiers
* #08 ^property[=].valueCode = #20
* #08 ^property[+].code = #categorieTiers
* #08 ^property[=].valueCode = #28
* #09 "Collectivité territoriale - EPL - EPS" "Collectivité territoriale, Établissement Public Local, Établissement Public de Santé"
* #09 ^property[+].code = #categorieTiers
* #09 ^property[=].valueCode = #21
* #09 ^property[+].code = #categorieTiers
* #09 ^property[=].valueCode = #22
* #09 ^property[+].code = #categorieTiers
* #09 ^property[=].valueCode = #23
* #09 ^property[+].code = #categorieTiers
* #09 ^property[=].valueCode = #24
* #09 ^property[+].code = #categorieTiers
* #09 ^property[=].valueCode = #25
* #09 ^property[+].code = #categorieTiers
* #09 ^property[=].valueCode = #26
* #09 ^property[+].code = #categorieTiers
* #09 ^property[=].valueCode = #27
* #10 "État étranger - Ambassade" "État étranger ou représentation diplomatique (ambassade, consulat)"
* #10 ^property[+].code = #categorieTiers
* #10 ^property[=].valueCode = #29
* #11 "CAF" "Caisse d'Allocations Familiales"
* #11 ^property[+].code = #categorieTiers
* #11 ^property[=].valueCode = #63
