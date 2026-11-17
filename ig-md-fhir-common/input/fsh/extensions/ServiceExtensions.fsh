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

Extension: SERSigleExtension
Id: ser-sigle
Title: "Sigle du service"
Description: "Sigle du service hospitalier (SIGLSE — 10 chars)."
Context: Organization
* value[x] only string
* valueString ^short = "Sigle (SIGLSE)"

Extension: SERTypeServiceExtension
Id: ser-type-service
Title: "Type de service"
Description: "Type de service (TYPESE : D=Direction / S=Service standard)."
Context: Organization
* value[x] only code
* valueCode from SERTypeServiceVS (required)
* valueCode ^short = "Type service (TYPESE)"

// ── Attributs LOCAL du service (actifs selon le tenant) ──────────────────────

Extension: SERDisciplineMedicaleExtension
Id: ser-discipline-medicale
Title: "Discipline médicale du service"
Description: "Discipline médicale du service : code de la nomenclature DISMED. Une extension par discipline, plusieurs disciplines possibles. Attribut de portée LOCAL, actif selon le tenant."
Context: Organization
* value[x] only string
* valueString ^short = "Code de la discipline médicale (nomenclature DISMED)"

Extension: SERChefAdjointExtension
Id: ser-chef-adjoint
Title: "Chef de service adjoint"
Description: "Matricule d'un chef de service adjoint (20 caractères au plus). Une extension par adjoint, plusieurs adjoints possibles, sans historique des périodes d'exercice. Attribut de portée LOCAL, actif selon le tenant."
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

ValueSet: SERTypeServiceVS
Id: ser-type-service-vs
Title: "Type de service (TYPESE)"
Description: "Type de service hospitalier selon le code TYPESE : Direction ou Service standard."
* ^experimental = false
* ^meta.profile = "http://hl7.org/fhir/StructureDefinition/shareablevalueset"
* SERTypeServiceCS#D "Direction"
* SERTypeServiceCS#S "Service"

CodeSystem: SERTypeServiceCS
Id: ser-type-service-cs
Title: "Type de service"
Description: "Code de type de service hospitalier (TYPESE) : D=Direction, S=Service standard."
* ^experimental = false
* ^meta.profile = "http://hl7.org/fhir/StructureDefinition/shareablecodesystem"
* #D "Direction"
* #S "Service"
