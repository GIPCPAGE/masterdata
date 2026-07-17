// =============================================
// Extensions : Service (Common IG)
// =============================================
// Source Oracle : STR.SER

Extension: SERPeriodeValiditeExtension
Id: ser-periode-validite
Title: "Période de validité du service"
Description: "Période de validité du service (STR.SER — PK composite COSESE+DATDSE)."
Context: Organization
* extension contains dateDebut 1..1 MS and dateFin 0..1 MS
* extension[dateDebut].value[x] only date
* extension[dateDebut] ^short = "Date de début de période (DATDSE)"
* extension[dateFin].value[x] only date
* extension[dateFin] ^short = "Date de fin de période (DATFSE)"

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

// ── CodeSystem organisationnel pour SERVICE (pas dans FR Core v2-3307) ────────

CodeSystem: StrhOrganizationTypeCS
Id: strh-organization-type-cs
Title: "Types organisationnels CPage (complément FR Core v2-3307)"
Description: "Codes organisationnels CPage non couverts par fr-core-cs-v2-3307."
* ^experimental = false
* ^meta.profile = "http://hl7.org/fhir/StructureDefinition/shareablecodesystem"
* #SERVICE "Service hospitalier"
