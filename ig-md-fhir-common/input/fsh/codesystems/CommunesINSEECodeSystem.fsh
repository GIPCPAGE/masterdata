// =============================================
// CodeSystem: Communes françaises (INSEE)
// =============================================

CodeSystem: CommunesINSEECodeSystem
Id: communes-insee-cs
Title: "Communes françaises (Code Officiel Géographique INSEE)"
Description: "Liste des communes françaises selon le Code Officiel Géographique de l'INSEE. Chaque commune est identifiée par un code unique de 5 caractères (2 chiffres département + 3 chiffres commune)."

* ^url = "https://www.cpage.fr/ig/masterdata/geo/CodeSystem/communes-insee-cs"
* ^status = #active
* ^experimental = false
* ^caseSensitive = true
* ^content = #complete
* ^publisher = "CPage"
* ^contact.telecom.system = #url
* ^contact.telecom.value = "https://www.cpage.fr"
* ^copyright = "Source: INSEE - Code Officiel Géographique (COG)"
* ^purpose = "Identifier de manière unique les communes françaises dans les adresses et localisations. Basé sur le référentiel officiel INSEE mis à jour annuellement."

// Propriétés pour gestion historique et temporalité
* ^property[0].code = #effectiveDate
* ^property[=].uri = "http://hl7.org/fhir/concept-properties#effectiveDate"
* ^property[=].description = "Date d'entrée en vigueur de la commune (création ou modification)"
* ^property[=].type = #dateTime

* ^property[+].code = #deprecationDate
* ^property[=].uri = "http://hl7.org/fhir/concept-properties#deprecationDate"
* ^property[=].description = "Date de suppression ou fusion de la commune"
* ^property[=].type = #dateTime

* ^property[+].code = #status
* ^property[=].uri = "http://hl7.org/fhir/concept-properties#status"
* ^property[=].description = "Statut de la commune : active, inactive (fusionnée), deprecated (supprimée)"
* ^property[=].type = #code

* ^property[+].code = #replacedBy
* ^property[=].description = "Code INSEE de la commune de remplacement (en cas de fusion)"
* ^property[=].type = #code

* ^property[+].code = #parent
* ^property[=].uri = "http://hl7.org/fhir/concept-properties#parent"
* ^property[=].description = "Code département (2 premiers chiffres du code commune)"
* ^property[=].type = #code

* ^property[+].code = #region
* ^property[=].description = "Code région INSEE (nouvelle région 2016+)"
* ^property[=].type = #code

// =============================================
// Communes principales (échantillon)
// =============================================
// NOTE: Ce fichier contient un échantillon représentatif.
// Pour la liste complète (~36 000 communes), utiliser le script
// generate_communes_fsh.py fourni dans /scripts/

// Métropoles
* #75056 "Paris"
  * ^property[0].code = #status
  * ^property[=].valueCode = #active
  * ^property[+].code = #parent
  * ^property[=].valueCode = #75
  * ^property[+].code = #region
  * ^property[=].valueCode = #11

* #13055 "Marseille"
  * ^property[0].code = #status
  * ^property[=].valueCode = #active
  * ^property[+].code = #parent
  * ^property[=].valueCode = #13
  * ^property[+].code = #region
  * ^property[=].valueCode = #93

* #69123 "Lyon"
  * ^property[0].code = #status
  * ^property[=].valueCode = #active
  * ^property[+].code = #parent
  * ^property[=].valueCode = #69
  * ^property[+].code = #region
  * ^property[=].valueCode = #84

* #31555 "Toulouse"
  * ^property[0].code = #status
  * ^property[=].valueCode = #active
  * ^property[+].code = #parent
  * ^property[=].valueCode = #31
  * ^property[+].code = #region
  * ^property[=].valueCode = #76

* #06088 "Nice"
  * ^property[0].code = #status
  * ^property[=].valueCode = #active
  * ^property[+].code = #parent
  * ^property[=].valueCode = #06
  * ^property[+].code = #region
  * ^property[=].valueCode = #93
* #44109 "Nantes"
* #67482 "Strasbourg"
* #34172 "Montpellier"
* #33063 "Bordeaux"
* #59350 "Lille"
* #35238 "Rennes"
* #51454 "Reims"
* #76540 "Le Havre"
* #42218 "Saint-Étienne"
* #83137 "Toulon"
* #38185 "Grenoble"
* #49007 "Angers"
* #21231 "Dijon"
* #29232 "Brest"
* #87085 "Limoges"

// Préfectures de département
* #01053 "Bourg-en-Bresse"
* #02408 "Laon"
* #03190 "Moulins"
* #04070 "Digne-les-Bains"
* #05061 "Gap"
* #07186 "Privas"
* #08105 "Charleville-Mézières"
* #09122 "Foix"
* #10387 "Troyes"
* #11069 "Carcassonne"
* #12202 "Rodez"
* #14118 "Caen"
* #15014 "Aurillac"
* #16015 "Angoulême"
* #17300 "La Rochelle"
* #18033 "Bourges"
* #19272 "Tulle"
* #20001 "Ajaccio"
* #22278 "Saint-Brieuc"
* #23096 "Guéret"
* #24322 "Périgueux"
* #25056 "Besançon"
* #26362 "Valence"
* #27229 "Évreux"
* #28085 "Chartres"
* #30189 "Nîmes"
* #32013 "Auch"
* #36044 "Châteauroux"
* #37261 "Tours"
* #39300 "Lons-le-Saunier"
* #40192 "Mont-de-Marsan"
* #41018 "Blois"
* #43157 "Le Puy-en-Velay"
* #45234 "Orléans"
* #46042 "Cahors"
* #47001 "Agen"
* #48095 "Mende"
* #50502 "Saint-Lô"
* #52121 "Chaumont"
* #53130 "Laval"
* #54395 "Nancy"
* #55029 "Bar-le-Duc"
* #56260 "Vannes"
* #57463 "Metz"
* #58194 "Nevers"
* #60057 "Beauvais"
* #61001 "Alençon"
* #62041 "Arras"
* #63113 "Clermont-Ferrand"
* #64445 "Pau"
* #65286 "Tarbes"
* #66136 "Perpignan"
* #68066 "Colmar"
* #70550 "Vesoul"
* #71270 "Mâcon"
* #72181 "Le Mans"
* #73065 "Chambéry"
* #74010 "Annecy"
* #76351 "Rouen"
* #77288 "Melun"
* #78646 "Versailles"
* #79191 "Niort"
* #80021 "Amiens"
* #81004 "Albi"
* #82121 "Montauban"
* #84007 "Avignon"
* #85191 "La Roche-sur-Yon"
* #86194 "Poitiers"
* #88160 "Épinal"
* #89024 "Auxerre"
* #90010 "Belfort"
* #91228 "Évry-Courcouronnes"
* #92050 "Nanterre"
* #93008 "Bobigny"
* #94028 "Créteil"
* #95500 "Pontoise"

// DROM-COM
* #97105 "Basse-Terre"
* #97209 "Fort-de-France"
* #97302 "Cayenne"
* #97411 "Saint-Denis"
* #97608 "Mamoudzou"

// Communes importantes Île-de-France
* #92012 "Boulogne-Billancourt"
* #92023 "Clamart"
* #92026 "Courbevoie"
* #92049 "Levallois-Perret"
* #92063 "Puteaux"
* #93001 "Aubervilliers"
* #93029 "Drancy"
* #93048 "Montreuil"
* #93066 "Saint-Denis"
* #94017 "Champigny-sur-Marne"
* #94069 "Villejuif"
* #94080 "Vincennes"
* #95018 "Argenteuil"
* #95127 "Cergy"
* #95563 "Sarcelles"

// Communes autres grandes agglomérations
* #59009 "Armentières"
* #59183 "Douai"
* #59392 "Marcq-en-Barœul"
* #59560 "Roubaix"
* #59599 "Tourcoing"
* #59606 "Valenciennes"
* #69266 "Villeurbanne"
* #33281 "Mérignac"
* #33522 "Talence"
* #13001 "Aix-en-Provence"
* #13004 "Arles"
* #13119 "Vitrolles"

// =============================================
// EXEMPLES DE COMMUNES FUSIONNÉES (Historique)
// =============================================
// Illustration de la gestion temporelle

// Exemple 1: Commune fusionnée en 2019
// Les Clayes-sous-Bois (78165) a fusionné avec Villepreux (78674) 
// pour créer Les Clayes-sous-Bois (commune nouvelle conservant le code 78165)
* #78165 "Les Clayes-sous-Bois"
  * ^property[0].code = #status
  * ^property[=].valueCode = #active
  * ^property[+].code = #effectiveDate
  * ^property[=].valueDateTime = "2019-01-01"
  * ^property[+].code = #parent
  * ^property[=].valueCode = #78
  * ^designation.language = #fr
  * ^designation.value = "Commune nouvelle issue de la fusion Les Clayes-sous-Bois + Villepreux"

* #78674 "Villepreux"
  * ^property[0].code = #status
  * ^property[=].valueCode = #inactive
  * ^property[+].code = #deprecationDate
  * ^property[=].valueDateTime = "2019-01-01"
  * ^property[+].code = #replacedBy
  * ^property[=].valueCode = #78165
  * ^property[+].code = #parent
  * ^property[=].valueCode = #78
  * ^designation.language = #fr
  * ^designation.value = "Commune déléguée fusionnée dans Les Clayes-sous-Bois"

// Exemple 2: Commune créée récemment (2024)
* #14472 "Mouen"
  * ^property[0].code = #status
  * ^property[=].valueCode = #active
  * ^property[+].code = #effectiveDate
  * ^property[=].valueDateTime = "2024-01-01"
  * ^property[+].code = #parent
  * ^property[=].valueCode = #14
  * ^designation.language = #fr
  * ^designation.value = "Commune nouvelle créée en 2024"
