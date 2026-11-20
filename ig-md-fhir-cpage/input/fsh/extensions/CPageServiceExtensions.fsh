// =============================================
// Extensions CPage : Service (SER)
// =============================================
// Attributs de portée CPAGE du service, déplacés depuis l'IG common :
// les attributs de portée CPAGE ne sont exposés que par l'IG CPage.

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
* ^caseSensitive = true
* ^meta.profile = "http://hl7.org/fhir/StructureDefinition/shareablecodesystem"
* #D "Direction"
* #S "Service"
