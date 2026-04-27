// =============================================
// Extensions : Commune française (COG INSEE)
// =============================================
// Six extensions portées par Location/CommuneFrancaiseProfile :
//   1. CommuneCodePostalExt          — code postal (répétable 0..*)
//   2. CommuneCodeDepartementExt     — code département INSEE (0..1)
//   3. CommuneCodeRegionExt          — code région INSEE (0..1)
//   4. CommuneDateDebutValiditeExt   — date de début de validité du code INSEE (0..1)
//   5. CommuneDateFinValiditeExt     — date de fin de validité / suppression (0..1)
//   6. CommuneDateMiseAJourExt       — date de dernière mise à jour de l'enregistrement (0..1)

// -------------------------------------------------------
// 1. Code postal
// -------------------------------------------------------
// Répétable : une commune peut être couverte par plusieurs codes postaux
// (grandes villes, communes géographiquement étendues, arrondissements).
// Correspond exactement à la propriété `codePostal` (type string, répétable)
// définie dans CommunesFrancaisesCodeSystem.

Extension: CommuneCodePostalExt
Id: commune-code-postal-ext
Title: "Code postal de la commune"
Description: "Code postal rattaché à la commune. Répétable : une commune peut avoir plusieurs codes postaux. Chaque instance porte un code à 5 chiffres issu de la base La Poste HEXASIMAL."
Context: Location
* ^url = "https://www.cpage.fr/ig/masterdata/common/StructureDefinition/commune-code-postal-ext"
* ^version = "1.0.0"
* ^status = #active
* ^context[0].type = #element
* ^context[0].expression = "Location"

* value[x] only string
* valueString 1..1 MS
* valueString ^short = "Code postal (5 chiffres)"
* valueString ^definition = "Code postal de la commune ou du secteur concerné. Format : 5 chiffres numériques."

// -------------------------------------------------------
// 2. Code département INSEE
// -------------------------------------------------------
// 2 caractères pour les départements métropolitains (01–95, 2A, 2B),
// 3 caractères pour les DROM (971–976).
// Correspond à la propriété `codeDepartement` (type code) du CodeSystem.

Extension: CommuneCodeDepartementExt
Id: commune-code-departement-ext
Title: "Code département INSEE"
Description: "Code département INSEE de la commune. Format : 2 caractères (01–95, 2A, 2B pour la Corse) ou 3 caractères pour les DROM (971–976). Correspond à la propriété `codeDepartement` du CodeSystem communes-fr-cs."
Context: Location
* ^url = "https://www.cpage.fr/ig/masterdata/common/StructureDefinition/commune-code-departement-ext"
* ^version = "1.0.0"
* ^status = #active
* ^context[0].type = #element
* ^context[0].expression = "Location"

* value[x] only code
* valueCode 1..1 MS
* valueCode ^short = "Code département (ex : 69, 2A, 971)"
* valueCode ^definition = "Code département INSEE associé à la commune. Exemples : 01 (Ain), 69 (Rhône), 2A (Corse-du-Sud), 971 (Guadeloupe)."

// -------------------------------------------------------
// 3. Code région INSEE
// -------------------------------------------------------
// Issu de la réforme territoriale de 2016 (loi NOTRe).
// Ex : 11 = Île-de-France, 84 = Auvergne-Rhône-Alpes, 93 = PACA.
// Correspond à la propriété `codeRegion` (type code) du CodeSystem.

Extension: CommuneCodeRegionExt
Id: commune-code-region-ext
Title: "Code région INSEE"
Description: "Code région INSEE de la commune, issu de la réforme territoriale de 2016 (loi NOTRe). Correspond à la propriété `codeRegion` du CodeSystem communes-fr-cs."
Context: Location
* ^url = "https://www.cpage.fr/ig/masterdata/common/StructureDefinition/commune-code-region-ext"
* ^version = "1.0.0"
* ^status = #active
* ^context[0].type = #element
* ^context[0].expression = "Location"

* value[x] only code
* valueCode 1..1 MS
* valueCode ^short = "Code région (ex : 84, 11, 93)"
* valueCode ^definition = "Code région INSEE. Exemples : 11 (Île-de-France), 84 (Auvergne-Rhône-Alpes), 93 (Provence-Alpes-Côte d'Azur), 02 (Martinique), 03 (Guyane)."

// -------------------------------------------------------
// 4. Date de début de validité
// -------------------------------------------------------
// Correspond à la propriété `dateCreation` du CodeSystem communes-fr-cs.
// Pour les communes antérieures au COG numérique : conventionnellement 1943-01-01.

Extension: CommuneDateDebutValiditeExt
Id: commune-date-debut-validite-ext
Title: "Date de début de validité"
Description: "Date d'entrée en vigueur du code INSEE de la commune. Correspond à la propriété `dateCreation` du CodeSystem communes-fr-cs. Pour les communes antérieures au COG numérique, la convention est 1943-01-01."
Context: Location
* ^url = "https://www.cpage.fr/ig/masterdata/common/StructureDefinition/commune-date-debut-validite-ext"
* ^version = "1.0.0"
* ^status = #active
* ^context[0].type = #element
* ^context[0].expression = "Location"

* value[x] only date
* valueDate 1..1 MS
* valueDate ^short = "Date de début de validité du code INSEE (AAAA-MM-JJ)"
* valueDate ^definition = "Date à partir de laquelle le code INSEE est en vigueur. Exemples : 1943-01-01 pour les communes historiques, 2019-01-01 pour Belleville-en-Beaujolais (commune nouvelle)."

// -------------------------------------------------------
// 5. Date de fin de validité
// -------------------------------------------------------
// Correspond à la propriété `dateSuppression` du CodeSystem communes-fr-cs.
// Renseignée uniquement pour les communes inactives (fusionnées ou supprimées).

Extension: CommuneDateFinValiditeExt
Id: commune-date-fin-validite-ext
Title: "Date de fin de validité"
Description: "Date à laquelle le code INSEE a cessé d'être actif (fusion, suppression ou transformation). Correspond à la propriété `dateSuppression` du CodeSystem communes-fr-cs. Présente uniquement quand `status = inactive`."
Context: Location
* ^url = "https://www.cpage.fr/ig/masterdata/common/StructureDefinition/commune-date-fin-validite-ext"
* ^version = "1.0.0"
* ^status = #active
* ^context[0].type = #element
* ^context[0].expression = "Location"

* value[x] only date
* valueDate 1..1 MS
* valueDate ^short = "Date de fin de validité du code INSEE (AAAA-MM-JJ)"
* valueDate ^definition = "Date à laquelle la commune a été fusionnée, supprimée ou transformée. Exemples : 2019-01-01 pour Saint-Jean-d'Ardières (fusionnée dans Belleville-en-Beaujolais)."

// -------------------------------------------------------
// 6. Date de mise à jour
// -------------------------------------------------------
// Date de la dernière modification de la fiche dans le référentiel CPage.
// Distincte de dateCreation (COG INSEE) : elle reflète la fraîcheur de l'enregistrement.

Extension: CommuneDateMiseAJourExt
Id: commune-date-mise-a-jour-ext
Title: "Date de mise à jour"
Description: "Date de la dernière mise à jour de l'enregistrement de la commune dans le référentiel CPage. Distinct de la date de création COG : il reflète la fraîcheur des données (ex : suite à une correction de code postal, un changement de nom ou une mise à jour annuelle COG)."
Context: Location
* ^url = "https://www.cpage.fr/ig/masterdata/common/StructureDefinition/commune-date-mise-a-jour-ext"
* ^version = "1.0.0"
* ^status = #active
* ^context[0].type = #element
* ^context[0].expression = "Location"

* value[x] only dateTime
* valueDateTime 1..1 MS
* valueDateTime ^short = "Date et heure de dernière mise à jour (AAAA-MM-JJ ou AAAA-MM-JJThh:mm:ss+TZ)"
* valueDateTime ^definition = "Horodatage de la dernière modification de la fiche commune dans le référentiel CPage (ex : 2026-01-01T00:00:00+01:00 lors de la mise à jour COG annuelle)."
