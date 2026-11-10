// =============================================
// Profil : CodeSystem des catégories d'établissement (FINESS, TRE_R66 de l'ANS)
// =============================================
// Basé sur la ressource FHIR CodeSystem.
//
// Ce profil identifie les CodeSystem de catégorie d'établissement dans les flux Master Data. Le CodeSystem
// `categorie-etablissement-cs` de ce guide le déclare dans meta.profile (fragment représentatif). Les lots publiés par
// l'API Master Data portent un CodeSystem par période de validité d'une catégorie : un seul concept, content = complete,
// meta.profile = ce profil. Un module qui reçoit une ressource CodeSystem la rattache ainsi à la catégorie sans
// dépendre d'un tag de typologie, que la lecture d'un export retire de la ressource.
//
// Les dix propriétés de concept et leurs types sont ceux de CategorieEtablissementCodeSystem ; `inactive` marque une
// période fermée (propriété standard FHIR concept-properties).
// Décision PB-Q03 du Knowledge Graph (graph/resources/categorie_etablissement_decisions.ttl).
// Le ValueSet categorie-etablissement-vs ne déclare pas de profil.

Invariant: cat-etab-code-trois-chiffres
Description: "Le code d'une catégorie d'établissement comporte trois chiffres (format de la TRE_R66)."
Severity: #error
Expression: "code.matches('^[0-9]{3}$')"

Profile: CategorieEtablissementCodeSystemProfile
Parent: CodeSystem
Id: categorie-etablissement-codesystem-profile
Title: "Catégories d'établissement (CodeSystem)"
Description: """
Profil du CodeSystem des catégories d'établissement du fichier national FINESS (terminologie TRE_R66 de l'ANS).

Le CodeSystem est publié sous deux formes :
- **fragment représentatif** dans ce guide (`categorie-etablissement-cs`) ;
- **une ressource par période de validité** dans les lots de l'API Master Data : un seul concept, `content = complete`.

Le profil impose :
- un **code à trois chiffres** pour chaque concept ;
- les **propriétés de concept** déclarées par le CodeSystem : `libelle_court`, `niv1`, `niv2`, `niv3`, `ars`, `drjscs`,
  `drihl`, `antenne_possible`, `date_debut_validite`, `date_fin_validite`, et `inactive` pour une période fermée ;
- des **valeurs de propriété** de type chaîne, booléen ou date.

Une propriété dont la valeur est inconnue est omise du concept ; un booléen à `false` est conservé.
"""

* concept obeys cat-etab-code-trois-chiffres
* concept.property.value[x] only string or boolean or dateTime

// =============================================
// Propriétés déclarées par le CodeSystem (discriminées par leur code)
// =============================================

* property ^slicing.discriminator.type = #value
* property ^slicing.discriminator.path = "code"
* property ^slicing.rules = #open
* property contains
    inactive 0..1 and
    libelleCourt 0..1 and
    niv1 0..1 and
    niv2 0..1 and
    niv3 0..1 and
    ars 0..1 and
    drjscs 0..1 and
    drihl 0..1 and
    antennePossible 0..1 and
    dateDebutValidite 0..1 and
    dateFinValidite 0..1

* property[inactive].code = #inactive
* property[inactive].type = #boolean
* property[libelleCourt].code = #libelle_court
* property[libelleCourt].type = #string
* property[niv1].code = #niv1
* property[niv1].type = #string
* property[niv2].code = #niv2
* property[niv2].type = #string
* property[niv3].code = #niv3
* property[niv3].type = #string
* property[ars].code = #ars
* property[ars].type = #boolean
* property[drjscs].code = #drjscs
* property[drjscs].type = #boolean
* property[drihl].code = #drihl
* property[drihl].type = #boolean
* property[antennePossible].code = #antenne_possible
* property[antennePossible].type = #boolean
* property[dateDebutValidite].code = #date_debut_validite
* property[dateDebutValidite].type = #dateTime
* property[dateFinValidite].code = #date_fin_validite
* property[dateFinValidite].type = #dateTime
