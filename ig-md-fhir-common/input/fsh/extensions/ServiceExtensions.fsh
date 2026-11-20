// =============================================
// Extensions : Service (Common IG)
// =============================================
// Source Oracle : STR.SER
// La période de validité du service est portée par l'extension standard organization-period
// (usePeriod), héritée de FR Core : pas d'extension propre. La date CME réutilise l'extension
// commune strh-date-cme (StrHDateCmeExtension.fsh).

Extension: SERCodeValiditeExtension
Id: ser-code-validite
Title: "Code de validité du service"
Description: "Code de validité du service (INVASE : F=Fermé / I=Invalide / V=Valide)."
Context: Organization
* value[x] only code
* valueCode from EGCodeValiditeVS (required)
* valueCode ^short = "Code validité (INVASE)"

// ── Attributs LOCAL du service (actifs selon le tenant) ──────────────────────

Extension: SERChefAdjointExtension
Id: ser-chef-adjoint
Title: "Chef de service adjoint"
Description: "Matricule du chef de service adjoint (20 caractères au plus). Un service n'a qu'un chef adjoint ; l'historique des affectations est porté par les versions du service. Attribut de portée LOCAL, actif selon le tenant."
Context: Organization
* value[x] only string
* valueString ^short = "Matricule du chef de service adjoint"

Extension: SERSiteInternetExtension
Id: ser-site-internet
Title: "Service visible sur le site internet"
Description: "Indique si le service est visible sur le site internet de l'établissement. Attribut de portée LOCAL, actif selon le tenant."
Context: Organization
* value[x] only boolean
* valueBoolean ^short = "Visible sur le site internet"
