CodeSystem: PublicationScope
Id: publication-scope
Title: "Code System - Perimetre de diffusion des lots de publication"
Description: "Definit le perimetre de diffusion d'un lot de publication MDM : GLOBAL pour les contenus partages (nomenclatures, referentiels), CLIENT pour les contenus tenant-specifiques (ressources metier contextualisees)."
* ^url = "https://www.cpage.fr/ig/masterdata/operations/CodeSystem/publication-scope"
* ^version = "0.1.0"
* ^status = #active
* ^experimental = false
* ^publisher = "CPage"
* ^contact[+].name = "CPage"
* ^contact[=].telecom[+].system = #email
* ^contact[=].telecom[=].value = "contact@cpage.fr"
* ^caseSensitive = true
* ^content = #complete

* #GLOBAL "GLOBAL" "Lot de diffusion global, applicable a tous les tenants. Utilise typiquement pour les nomenclatures et referentiels partages (CodeSystem, ValueSet, etc.)."
* #CLIENT "CLIENT" "Lot de diffusion client-specifique, ciblant un tenant precis. Utilise pour les ressources metier contextualisees (Organization, Location, etc.)."
