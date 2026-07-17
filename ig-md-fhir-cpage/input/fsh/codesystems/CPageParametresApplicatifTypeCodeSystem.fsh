// =============================================
// CodeSystem Type fonctionnel — Paramètres Applicatif CPage
// Source : TypeParametreEnum (master-data-api)
// =============================================

CodeSystem: CPageParametresApplicatifTypeCodeSystem
Id: cpage-parametres-applicatif-type-codesystem
Title: "Type fonctionnel d'un paramètre applicatif (CPage)"
Description: "Catégorise le rôle fonctionnel et la gouvernance d'un paramètre applicatif. Source : TypeParametreEnum."
* ^status = #draft
* ^experimental = false
* ^content = #complete
* ^caseSensitive = true
* ^meta.profile = "http://hl7.org/fhir/StructureDefinition/shareablecodesystem"
* #A "Administrateur"              "Paramètre géré par un administrateur."
* #S "Système"                     "Paramètre système interne à CPage."
* #U "Utilisateur"                 "Préférence modifiable par l'utilisateur."
* #C "Connecteur"                  "Paramètre de configuration d'un connecteur."
* #D "Administrateur - Périodique" "Paramètre administrateur à révision périodique."
* #P "Système - Périodique"        "Paramètre système à révision périodique."
