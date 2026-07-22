// =============================================
// CodeSystem: Pays (ISO 3166-1 / INSEE) — référentiel pivot
// =============================================
// CodeSystem pivot exposant, pour chaque pays/territoire, l'ensemble de ses
// codes de représentation (alpha-2, alpha-3, numérique, INSEE COG) en une seule
// fois, ainsi que le rattachement à un Royaume/État partageant la souveraineté
// externe (ex: Îles Féroé, pays constitutif autonome du Royaume du Danemark —
// pas une subdivision territoriale du Danemark).
//
// Clé primaire : code ISO 3166-1 alpha-2 (concept.code), plus universel hors
// contexte FR que le code INSEE, et compatible avec un usage international.
//
// Périmètre aligné sur le schéma interne (PaysVersion, master-data-api) :
// tous les champs métier sont repris comme propriétés, à l'exception des champs
// de gestion interne au Master Data (id technique, transactionId, lifecycleState,
// champs d'audit) qui ne sont pas du contenu terminologique.
//
// Ce CodeSystem est un pivot de transmission groupée : contrairement à un
// ConceptMap (fait pour traduire un code vers un autre à la volée), il porte
// plusieurs représentations d'un même concept dans un seul payload. Contrairement
// à PaysProfile (Location), il ne modélise pas le cycle de vie transactionnel
// d'une instance Master Data — voir le README de l'IG pour la distinction entre
// les deux usages (terminologie/binding vs ressource d'instance).
//
// Contenu : fragment représentatif. La génération de la liste complète (tous les
// pays/territoires ISO 3166-1 croisés avec le référentiel INSEE COG) est un
// chantier de génération de données à part (cf. scripts/generate_*_fsh.py existants
// pour les communes), pas une saisie manuelle en FSH.

CodeSystem: PaysCodeSystem
Id: pays-cs
Title: "Pays (ISO 3166-1 / INSEE) — CodeSystem pivot"
Description: """
Référentiel pivot des pays et territoires, croisant ISO 3166-1 (alpha-2, alpha-3,
numérique) et le référentiel INSEE des pays et territoires étrangers (COG).

**Clé primaire** : code ISO 3166-1 alpha-2 (`concept.code`).

**Rattachement de souveraineté externe** : porté par la propriété standard
`parent` (`http://hl7.org/fhir/concept-properties#parent`), un seul niveau de
rattachement. Exprime le partage de compétences régaliennes (défense, affaires
étrangères) avec un Royaume/État, **pas** une subordination territoriale : les
Îles Féroé (FO) sont un pays constitutif autonome du Royaume du Danemark
(Home Rule depuis 1948), pas une partie ou une subdivision du Danemark (DK).
Faute de code ISO 3166-1 distinct pour le Royaume en tant qu'ensemble, la
valeur portée est celle du pays membre le plus visible du Royaume (convention
déjà en usage dans la plupart des référentiels pratiques) — limite connue et
acceptée, propre à ISO 3166, pas un choix de modélisation FHIR.

**Sémantique retenue : `part-of`** (définition officielle FHIR : "Child
elements list the individual parts of a composite whole"). Le "tout composite"
visé est le **Royaume/la Couronne** (Danemark + Féroé + Groenland), pas le pays
membre dont le code sert de substitut. `is-a` serait faux (aucune classification
n'est impliquée) ; `classified-with` est écarté après vérification de sa
définition officielle — il désigne des classifications fermées à parent unique
type CIM ("not otherwise classified"), sans rapport avec ce cas d'usage.

**Cas disputés/sensibles** (Taïwan, Kosovo, Sahara occidental, etc.) : décision de
gouvernance métier à valider en amont avant intégration au jeu de données complet —
non traité dans ce fragment d'exemple.
"""

* ^url = "https://www.cpage.fr/ig/masterdata/common/CodeSystem/pays-cs"
* ^version = "0.1.0"
* ^status = #active
* ^experimental = false
* ^caseSensitive = true
* ^hierarchyMeaning = #part-of
* ^content = #fragment
* ^publisher = "CPage"
* ^contact.telecom.system = #url
* ^contact.telecom.value = "https://www.cpage.fr"
* ^purpose = "Transmettre en un seul payload l'ensemble des codes de représentation d'un pays/territoire, et exposer un binding réutilisable par d'autres profils (ex: Address.country)."

// =============================================
// Déclaration des propriétés (périmètre PaysVersion)
// =============================================

* ^property[+].code = #codeIsoAlpha3
* ^property[=].uri = $iso3166-alpha3
* ^property[=].description = "Code ISO 3166-1 alpha-3 (3 lettres). Ex : DEU (Allemagne), DNK (Danemark)."
* ^property[=].type = #code

* ^property[+].code = #codeIsoNumerique
* ^property[=].uri = $iso3166-numeric
* ^property[=].description = "Code ISO 3166-1 numérique (3 chiffres). Ex : 276 (Allemagne), 208 (Danemark)."
* ^property[=].type = #code

* ^property[+].code = #codeInseePays
* ^property[=].uri = $tre-r20-pays
* ^property[=].description = "Code INSEE du référentiel des pays et territoires étrangers (5 caractères commençant par 99), aligné sur le référentiel ANS TRE-R20-Pays."
* ^property[=].type = #code

* ^property[+].code = #uriInsee
* ^property[=].description = "URI officiel INSEE du pays (Linked Data). Ex : http://id.insee.fr/geo/pays/allemagne."
* ^property[=].type = #string

* ^property[+].code = #typeEntite
* ^property[=].uri = $pays-type-entite-cs
* ^property[=].description = "Nature de l'entité (pays souverain, territoire, collectivité française). Binding : ValueSet PaysTypeEntiteVS / CodeSystem $pays-type-entite-cs."
* ^property[=].type = #code

* ^property[+].code = #parent
* ^property[=].uri = "http://hl7.org/fhir/concept-properties#parent"
* ^property[=].description = "Royaume/État avec lequel l'entité partage des compétences régaliennes (défense, affaires étrangères), sans lien de subordination territoriale — ne pas confondre avec une annexion ou une dépendance coloniale. Valeur = code alpha-2. Ex : Îles Féroé (FO) → Danemark (DK), au titre du Royaume du Danemark dont les deux sont membres à égalité constitutionnelle. Un seul niveau de rattachement."
* ^property[=].type = #code

* ^property[+].code = #libelleLong
* ^property[=].description = "Dénomination longue officielle. Ex : République fédérale d'Allemagne."
* ^property[=].type = #string

* ^property[+].code = #nationalite
* ^property[=].description = "Nationalité associée, libellé au féminin singulier. Valeur déduite, non normalisée."
* ^property[=].type = #string

* ^property[+].code = #indicatifTelephonique
* ^property[=].description = "Indicatif téléphonique international, préfixé par +. Ex : +49 (Allemagne)."
* ^property[=].type = #string

* ^property[+].code = #appartenanceUe
* ^property[=].description = "Indique si le pays/territoire est membre de l'Union européenne."
* ^property[=].type = #boolean

* ^property[+].code = #dateDebutValidite
* ^property[=].description = "Date d'entrée en vigueur du code dans le référentiel. Convention : 1943-01-01 lorsque l'origine exacte n'est pas connue (cf. convention communes)."
* ^property[=].type = #dateTime

* ^property[+].code = #inactive
* ^property[=].uri = "http://hl7.org/fhir/concept-properties#inactive"
* ^property[=].description = "Indique si le pays est inactif (disparu du référentiel ISO 3166-1). true = code ne doit plus être utilisé comme référence courante. Pattern identique à communes-fr-cs."
* ^property[=].type = #boolean

* ^property[+].code = #dateFinValidite
* ^property[=].description = "Date de fin de validité du code. Renseignée uniquement pour les pays historiques disparus du référentiel ISO 3166-1 (inactive = true). Ex : 2011-07-09 (scission Soudan / Soudan du Sud)."
* ^property[=].type = #dateTime

// =============================================
// Exemples de concepts (fragment représentatif)
// =============================================
// Illustre le cas nominal (pays souverain) et le rattachement de souveraineté
// externe (Îles Féroé, pays constitutif du Royaume du Danemark), patron le
// plus fréquemment cité pour ce référentiel.

* #DE "Allemagne"
  * ^property[+].code = #codeIsoAlpha3
  * ^property[=].valueCode = #DEU
  * ^property[+].code = #codeIsoNumerique
  * ^property[=].valueCode = #276
  * ^property[+].code = #codeInseePays
  * ^property[=].valueCode = #99109
  * ^property[+].code = #uriInsee
  * ^property[=].valueString = "http://id.insee.fr/geo/pays/allemagne"
  * ^property[+].code = #typeEntite
  * ^property[=].valueCode = #PAYS
  * ^property[+].code = #libelleLong
  * ^property[=].valueString = "République fédérale d'Allemagne"
  * ^property[+].code = #nationalite
  * ^property[=].valueString = "allemande"
  * ^property[+].code = #indicatifTelephonique
  * ^property[=].valueString = "+49"
  * ^property[+].code = #appartenanceUe
  * ^property[=].valueBoolean = true
  * ^property[+].code = #dateDebutValidite
  * ^property[=].valueDateTime = "1943-01-01"

* #DK "Danemark"
  * ^property[+].code = #codeIsoAlpha3
  * ^property[=].valueCode = #DNK
  * ^property[+].code = #codeIsoNumerique
  * ^property[=].valueCode = #208
  * ^property[+].code = #codeInseePays
  * ^property[=].valueCode = #99136
  * ^property[+].code = #uriInsee
  * ^property[=].valueString = "http://id.insee.fr/geo/pays/danemark"
  * ^property[+].code = #typeEntite
  * ^property[=].valueCode = #PAYS
  * ^property[+].code = #libelleLong
  * ^property[=].valueString = "Royaume du Danemark"
  * ^property[+].code = #nationalite
  * ^property[=].valueString = "danoise"
  * ^property[+].code = #indicatifTelephonique
  * ^property[=].valueString = "+45"
  * ^property[+].code = #appartenanceUe
  * ^property[=].valueBoolean = true
  * ^property[+].code = #dateDebutValidite
  * ^property[=].valueDateTime = "1943-01-01"

* #FO "Îles Féroé"
  * ^property[+].code = #codeIsoAlpha3
  * ^property[=].valueCode = #FRO
  * ^property[+].code = #codeIsoNumerique
  * ^property[=].valueCode = #234
  * ^property[+].code = #codeInseePays
  * ^property[=].valueCode = #99137
  * ^property[+].code = #uriInsee
  * ^property[=].valueString = "http://id.insee.fr/geo/pays/iles-feroe"
  * ^property[+].code = #typeEntite
  * ^property[=].valueCode = #TERRITOIRE
  * ^property[+].code = #parent
  * ^property[=].valueCode = #DK
  * ^property[+].code = #libelleLong
  * ^property[=].valueString = "Îles Féroé"
  * ^property[+].code = #indicatifTelephonique
  * ^property[=].valueString = "+298"
  * ^property[+].code = #appartenanceUe
  * ^property[=].valueBoolean = false
  * ^property[+].code = #dateDebutValidite
  * ^property[=].valueDateTime = "1943-01-01"
