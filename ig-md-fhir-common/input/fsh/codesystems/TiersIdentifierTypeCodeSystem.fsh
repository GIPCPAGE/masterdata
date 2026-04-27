// =============================================
// CodeSystem: Identifier Type
// =============================================

CodeSystem: TiersIdentifierTypeCS
Id: tiers-identifier-type-cs
Title: "Type d'identifiant tiers"
Description: """Codes qualifiant le type d'identifiant d'un tiers (codes 01-12).

Cette nomenclature est issue du **Protocole d'Échange Standard v2 (PESv2)** publié par la Direction
Générale des Finances Publiques (DGFiP). Elle correspond au type `TNatIdTiers` du bloc `<BlocTiers>`
défini dans le XSD PESv2 (schéma `PES_V2.xsd`).

Chaque code identifie la nature de l'identifiant utilisé pour reconnaître un tiers dans les échanges
financiers dématérialisés entre les collectivités et leur comptable public.

Pour toute question relative à la maintenance de cette liste, se référer à la documentation officielle
PESv2 disponible sur le portail de la DGFiP (https://www.collectivites-locales.gouv.fr/finances-locales/pesv2)."""
* ^url = "https://www.cpage.fr/ig/masterdata/common/CodeSystem/tiers-identifier-type-cs"
* ^version = "1.0.0"
* ^status = #active
* ^experimental = false
* ^publisher = "DGFiP — Direction Générale des Finances Publiques"
* ^contact.name = "CPage (diffusion FHIR)"
* ^contact.telecom.system = #url
* ^contact.telecom.value = "https://www.cpage.fr"
* ^copyright = "Source : DGFiP — Protocole d'Échange Standard v2 (PESv2), nomenclature TypIdTiers. Données publiques issues de la réglementation financière des collectivités locales."
* ^caseSensitive = true
* ^content = #complete
* ^count = 12

* #01 "SIRET" "Système d'Identification du Répertoire des ETablissements (14 caractères)"
* #02 "SIREN" "Système d'Identification du Répertoire des ENtreprises (9 caractères)"
* #03 "FINESS" "Fichier National des Établissements Sanitaires et Sociaux (9 caractères)"
* #04 "NIR" "Numéro d'Inscription au Répertoire - Sécurité Sociale (15 caractères)"
* #05 "TVA" "TVA intracommunautaire (numéro de TVA intra-UE)"
* #06 "HORS_UE" "Identifiant hors Union Européenne"
* #07 "TAHITI" "Numéro Tahiti (Polynésie française)"
* #08 "RIDET" "RIDET Nouméa (Nouvelle-Calédonie)"
* #09 "EN_COURS" "Fournisseur en cours d'immatriculation (identifiant temporaire)"
* #10 "FRWF" "Identifiant FRWF — Wallis-et-Futuna"
* #11 "IREP" "IREP — Identifiant du Répertoire des Établissements Publics (Polynésie française)"
* #12 "NFP" "NFP — Numéro de Fichier de Paie (identifiant employéur pour les échanges de paie)"
