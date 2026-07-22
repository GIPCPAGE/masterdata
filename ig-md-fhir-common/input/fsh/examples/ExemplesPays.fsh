// =============================================
// Exemples — Pays (Location / PaysProfile)
// =============================================
// Illustre les trois patrons du référentiel pays :
//
//   Patron A — Pays souverain actif, membre UE
//               FR : France
//
//   Patron B — Pays historique inactif (supprimé du référentiel ISO)
//               SU : Union des républiques socialistes soviétiques (URSS)
//
//   Patron C — Collectivité française rattachée à un pays souverain
//               PF : Polynésie française (partOf → France)

// -------------------------------------------------------
// Patron A : Pays souverain actif (France)
// -------------------------------------------------------

Instance: PaysFrance
InstanceOf: PaysProfile
Usage: #example
Title: "Pays — France (FR) — pays souverain actif"
Description: """
Patron A — Pays souverain actif, membre de l'Union européenne.

La France (code ISO alpha-2 : FR) est un pays souverain.
Code INSEE pays : 99100. Membre de l'UE.
"""

* identifier[codeAlpha2].system = $iso3166-alpha2
* identifier[codeAlpha2].value = "FR"

* identifier[codeAlpha3].system = $iso3166-alpha3
* identifier[codeAlpha3].value = "FRA"

* identifier[codeNumerique].system = $iso3166-numeric
* identifier[codeNumerique].value = "250"

* identifier[codeInsee].system = $tre-r20-pays
* identifier[codeInsee].value = "99100"

* status = #active

* name = "France"

* type = PaysTypeEntiteCS#pays "Pays souverain"

* physicalType = http://terminology.hl7.org/CodeSystem/location-physical-type#jdn "Jurisdiction"

* extension[libelleLong].valueString = "République française"
* extension[uriInsee].valueUri = "http://id.insee.fr/geo/pays/france"
* extension[unionEuropeenne].valueBoolean = true
* extension[nationalite].valueString = "française"
* extension[dateCreationInsee].valueDate = "1943-01-01"

// -------------------------------------------------------
// Patron B : Pays historique inactif (URSS)
// -------------------------------------------------------

Instance: PaysURSS
InstanceOf: PaysProfile
Usage: #example
Title: "Pays — URSS (SU) — pays historique inactif"
Description: """
Patron B — Pays historique inactif.

L'URSS (code ISO alpha-2 : SU) a été supprimée du référentiel ISO le 26 décembre 1991.
Son code est conservé à titre historique avec status = inactive.
"""

* identifier[codeAlpha2].system = $iso3166-alpha2
* identifier[codeAlpha2].value = "SU"

* identifier[codeAlpha3].system = $iso3166-alpha3
* identifier[codeAlpha3].value = "SUN"

* identifier[codeNumerique].system = $iso3166-numeric
* identifier[codeNumerique].value = "810"

* identifier[codeInsee].system = $tre-r20-pays
* identifier[codeInsee].value = "99122"

* status = #inactive

* name = "Union des républiques socialistes soviétiques"

* type = PaysTypeEntiteCS#pays "Pays souverain"

* physicalType = http://terminology.hl7.org/CodeSystem/location-physical-type#jdn "Jurisdiction"

* extension[libelleLong].valueString = "Union des républiques socialistes soviétiques"
* extension[unionEuropeenne].valueBoolean = false
* extension[dateCreationInsee].valueDate = "1943-01-01"
* extension[dateFin].valueDate = "1991-12-26"

// -------------------------------------------------------
// Patron C : Collectivité française (Polynésie française)
// -------------------------------------------------------

Instance: PaysPolynesie
InstanceOf: PaysProfile
Usage: #example
Title: "Pays — Polynésie française (PF) — collectivité française"
Description: """
Patron C — Collectivité française rattachée à la France.

La Polynésie française (code ISO alpha-2 : PF) est une collectivité française
d'outre-mer. `partOf` référence l'instance Location de la France (PaysFrance).
"""

* identifier[codeAlpha2].system = $iso3166-alpha2
* identifier[codeAlpha2].value = "PF"

* identifier[codeAlpha3].system = $iso3166-alpha3
* identifier[codeAlpha3].value = "PYF"

* identifier[codeNumerique].system = $iso3166-numeric
* identifier[codeNumerique].value = "258"

* identifier[codeInsee].system = $tre-r20-pays
* identifier[codeInsee].value = "99134"

* status = #active

* name = "Polynésie française"

* type = PaysTypeEntiteCS#collectivite-francaise "Collectivité française"

* physicalType = http://terminology.hl7.org/CodeSystem/location-physical-type#jdn "Jurisdiction"

* extension[libelleLong].valueString = "Polynésie française"
* extension[unionEuropeenne].valueBoolean = false
* extension[nationalite].valueString = "polynésienne"
* extension[dateCreationInsee].valueDate = "1943-01-01"

* partOf = Reference(PaysFrance)
