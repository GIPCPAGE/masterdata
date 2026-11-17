// =============================================
// Extensions : Unité Médicale (Common IG)
// =============================================
// L'unité médicale n'existe pas dans CPage : ces extensions portent les attributs PMSI et
// d'autorisation du modèle Master Data, sans équivalent FR Core ni HL7.
// La période de validité est portée par l'extension standard organization-period (usePeriod),
// héritée de FR Core. Les attributs de portée LOCAL sont actifs selon le tenant.

Extension: UMCodeValiditeExtension
Id: um-code-validite
Title: "Code de validité de l'unité médicale"
Description: "Code de validité de l'unité médicale (F=Fermé / I=Invalide / V=Valide)."
Context: Organization
* value[x] only code
* valueCode from EGCodeValiditeVS (required)
* valueCode ^short = "Code validité"

Extension: UMCategoriePmsiExtension
Id: um-categorie-pmsi
Title: "Catégorie PMSI de l'unité médicale"
Description: "Catégorie PMSI de l'unité médicale (3 caractères au plus) : code de la nomenclature CATEGORIE_PMSI_UM."
Context: Organization
* value[x] only string
* valueString ^short = "Code de la catégorie PMSI"

Extension: UMModeHospitalisationExtension
Id: um-mode-hospitalisation
Title: "Mode d'hospitalisation de l'unité médicale"
Description: "Mode d'hospitalisation de l'unité médicale (1 caractère) : code de la nomenclature MODE_HOSPITALISATION."
Context: Organization
* value[x] only string
* valueString ^short = "Code du mode d'hospitalisation"

Extension: UMTypeAutorisationExtension
Id: um-type-autorisation
Title: "Type d'autorisation de l'unité médicale"
Description: "Type d'autorisation de l'unité médicale (20 caractères au plus) : code de la nomenclature TYPE_AUTORISATION_UM."
Context: Organization
* value[x] only string
* valueString ^short = "Code du type d'autorisation"

Extension: UMCodeCpmExtension
Id: um-code-cpm
Title: "Code CPM de l'unité médicale"
Description: "Code CPM de l'unité médicale (3 caractères au plus), doublon probable de la catégorie PMSI. Attribut de portée LOCAL, actif selon le tenant."
Context: Organization
* value[x] only string
* valueString ^short = "Code CPM"

Extension: UMCodePmsiExtension
Id: um-code-pmsi
Title: "Code PMSI de l'unité médicale"
Description: "Code PMSI de l'unité médicale (4 caractères au plus). Attribut de portée LOCAL, actif selon le tenant."
Context: Organization
* value[x] only string
* valueString ^short = "Code PMSI"

Extension: UMDateAutorisationExtension
Id: um-date-autorisation
Title: "Date d'autorisation de l'unité médicale"
Description: "Date d'autorisation de l'unité médicale. Attribut de portée LOCAL, actif selon le tenant."
Context: Organization
* value[x] only dateTime
* valueDateTime ^short = "Date d'autorisation"

Extension: UMSoinsPalliatifsExtension
Id: um-soins-palliatifs
Title: "Lits de soins palliatifs de l'unité médicale"
Description: "Indique si l'unité médicale compte des lits de soins palliatifs. Attribut de portée LOCAL, actif selon le tenant."
Context: Organization
* value[x] only boolean
* valueBoolean ^short = "Lits de soins palliatifs"

Extension: UMNombreLitsAutorisesExtension
Id: um-nombre-lits-autorises
Title: "Nombre de lits autorisés de l'unité médicale"
Description: "Nombre de lits autorisés de l'unité médicale (entier positif ou nul). Attribut de portée LOCAL, actif selon le tenant."
Context: Organization
* value[x] only integer
* valueInteger ^short = "Nombre de lits autorisés"

Extension: UMCompteAnalytiqueExtension
Id: um-compte-analytique
Title: "Compte analytique de l'unité médicale"
Description: "Code du compte analytique de l'unité médicale : nomenclature de comptes analytiques propre à chaque tenant. Attribut de portée LOCAL, actif selon le tenant."
Context: Organization
* value[x] only string
* valueString ^short = "Code du compte analytique"

Extension: UMSectionAnalyseExtension
Id: um-section-analyse
Title: "Section d'analyse de l'unité médicale"
Description: "Section d'analyse référencée par l'unité médicale, à titre indicatif et sans cascade de fermeture. Attribut de portée LOCAL, actif selon le tenant."
Context: Organization
* value[x] only Reference(SectionAnalyseProfile)
* valueReference ^short = "Section d'analyse"
