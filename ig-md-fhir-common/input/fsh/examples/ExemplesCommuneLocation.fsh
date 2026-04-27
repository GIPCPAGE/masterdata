// =============================================
// Exemples — Commune française (Location / CommuneFrancaiseProfile)
// =============================================
// Illustre les trois patrons du COG dans des instances Location :
//
//   Patron A  — Commune historique inactive (fusionnée)
//               69282 : Saint-Jean-d'Ardières (fusionnée dans 69264 au 01/01/2019)
//
//   Patron B  — Commune nouvelle active (multi-codes postaux)
//               69264 : Belleville-en-Beaujolais (créée au 01/01/2019)
//
//   Patron B' — Commune déléguée
//               69019 : Belleville-sur-Saône, déléguée sous 69264

// -------------------------------------------------------
// Patron A : Commune historique inactive
// -------------------------------------------------------
// Saint-Jean-d'Ardières (69282) a été fusionnée dans la commune nouvelle
// Belleville-en-Beaujolais (69264) au 1er janvier 2019.
// Son code INSEE est conservé mais le statut passe à inactive.

Instance: CommuneStJeanArdieres
InstanceOf: CommuneFrancaiseProfile
Usage: #example
Title: "Commune — Saint-Jean-d'Ardières (69282) — inactive (fusionnée)"
Description: """
Patron A — Commune historique inactive.

Saint-Jean-d'Ardières (code INSEE 69282) a été absorbée par la commune nouvelle
Belleville-en-Beaujolais (69264) au 1er janvier 2019.
Son code INSEE est conservé dans le COG avec `status = inactive`.
"""

* identifier[codeInsee].system = "https://www.cpage.fr/ig/masterdata/common/CodeSystem/communes-fr-cs"
* identifier[codeInsee].value = "69282"

* status = #inactive

* name = "Saint-Jean-d'Ardières"

* type = CommuneTypeTerritoireCS#commune "Commune ordinaire"

* physicalType = http://terminology.hl7.org/CodeSystem/location-physical-type#jdn "Jurisdiction"

* address.country = "FR"
* address.postalCode = "69220"
* address.city = "Saint-Jean-d'Ardières"
* address.state = "Rhône"

* extension[codePostal].valueString = "69220"
* extension[codeDepartement].valueCode = #69
* extension[codeRegion].valueCode = #84

// -------------------------------------------------------
// Patron B : Commune nouvelle active (codes postaux multiples)
// -------------------------------------------------------
// Belleville-en-Beaujolais (69264) est une commune nouvelle créée le 01/01/2019,
// issue de la fusion de Belleville-sur-Saône (69019) et Saint-Jean-d'Ardières (69282).
// Elle couvre deux codes postaux : 69220 et 69430.

Instance: CommuneBellevilleEnBeaujolais
InstanceOf: CommuneFrancaiseProfile
Usage: #example
Title: "Commune — Belleville-en-Beaujolais (69264) — commune nouvelle"
Description: """
Patron B — Commune nouvelle active avec deux codes postaux.

Belleville-en-Beaujolais (code INSEE 69264) est une commune nouvelle créée
au 1er janvier 2019 par fusion de Belleville-sur-Saône (69019) et
Saint-Jean-d'Ardières (69282). Elle couvre les codes postaux 69220 et 69430.
Les communes déléguées sont référencées via leur propre instance Location.
"""

* identifier[codeInsee].system = "https://www.cpage.fr/ig/masterdata/common/CodeSystem/communes-fr-cs"
* identifier[codeInsee].value = "69264"

* status = #active

* name = "Belleville-en-Beaujolais"

* type = CommuneTypeTerritoireCS#commune-nouvelle "Commune nouvelle"

* physicalType = http://terminology.hl7.org/CodeSystem/location-physical-type#jdn "Jurisdiction"

// Code postal principal (premier code postal en address)
* address.country = "FR"
* address.postalCode = "69220"
* address.city = "Belleville-en-Beaujolais"
* address.state = "Rhône"

// Tous les codes postaux dans les extensions (répétable)
* extension[codePostal][0].valueString = "69220"
* extension[codePostal][1].valueString = "69430"

* extension[codeDepartement].valueCode = #69
* extension[codeRegion].valueCode = #84

// -------------------------------------------------------
// Patron B' : Commune déléguée (partOf → commune nouvelle)
// -------------------------------------------------------
// Belleville-sur-Saône (69019) est la commune déléguée (ancienne ville-centre)
// intégrée dans la commune nouvelle Belleville-en-Beaujolais (69264).
// partOf référence l'instance CommuneBellevilleEnBeaujolais.

Instance: CommuneBellevilleSurSaone
InstanceOf: CommuneFrancaiseProfile
Usage: #example
Title: "Commune — Belleville-sur-Saône (69019) — commune déléguée"
Description: """
Patron B' — Commune déléguée rattachée à une commune nouvelle via `partOf`.

Belleville-sur-Saône (code INSEE 69019) est l'ancienne ville-centre, devenue
commune déléguée depuis la création de Belleville-en-Beaujolais (69264) au
1er janvier 2019. Elle conserve son code INSEE d'origine.
`partOf` pointe vers l'instance Location de la commune nouvelle.
"""

* identifier[codeInsee].system = "https://www.cpage.fr/ig/masterdata/common/CodeSystem/communes-fr-cs"
* identifier[codeInsee].value = "69019"

* status = #active

* name = "Belleville-sur-Saône"

* type = CommuneTypeTerritoireCS#commune-deleguee "Commune déléguée"

* physicalType = http://terminology.hl7.org/CodeSystem/location-physical-type#jdn "Jurisdiction"

* address.country = "FR"
* address.postalCode = "69220"
* address.city = "Belleville-sur-Saône"
* address.state = "Rhône"

* extension[codePostal].valueString = "69220"
* extension[codeDepartement].valueCode = #69
* extension[codeRegion].valueCode = #84

// Lien hiérarchique vers la commune nouvelle parente
* partOf = Reference(CommuneBellevilleEnBeaujolais)
