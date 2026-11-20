// =============================================
// Profil CPage : Service (STR.SER)
// =============================================

Profile: CPageServiceProfile
Parent: ServiceProfile
Id: cpage-service-profile
Title: "Service (CPage)"
Description: """
Profil CPage pour le service hospitalier.

Hérite de `ServiceProfile` (ig-md-fhir-common) et porte les attributs de portée CPAGE du service :
- Sigle du service
- Type de service (direction ou service)
"""

* extension contains
    SERSigleExtension                    named sigle                      0..1 MS and
    SERTypeServiceExtension              named typeService                0..1 MS

* extension[sigle] ^short = "Sigle du service"
* extension[typeService] ^short = "Type service (TYPESE : D=Direction / S=Service)"
