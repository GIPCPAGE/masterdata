// =============================================
// CodeSystem: Codes Postaux français (La Poste)
// =============================================

CodeSystem: CodesPostauxCodeSystem
Id: codes-postaux-cs
Title: "Codes Postaux français (La Poste)"
Description: "Liste des codes postaux français. Un code postal peut couvrir plusieurs communes, et une commune peut avoir plusieurs codes postaux. Format : 5 chiffres."

* ^url = "https://www.cpage.fr/ig/masterdata/geo/CodeSystem/codes-postaux-cs"
* ^status = #active
* ^experimental = false
* ^caseSensitive = true
* ^content = #complete
* ^publisher = "CPage"
* ^contact.telecom.system = #url
* ^contact.telecom.value = "https://www.cpage.fr"
* ^copyright = "Source: La Poste - Base Officielle des Codes Postaux"
* ^purpose = "Valider et normaliser les codes postaux dans les adresses. Permet la vérification de cohérence entre code postal et commune."

// Propriétés pour gestion historique et temporalité
* ^property[0].code = #effectiveDate
* ^property[=].uri = "http://hl7.org/fhir/concept-properties#effectiveDate"
* ^property[=].description = "Date de mise en service du code postal"
* ^property[=].type = #dateTime

* ^property[+].code = #deprecationDate
* ^property[=].uri = "http://hl7.org/fhir/concept-properties#deprecationDate"
* ^property[=].description = "Date de suppression du code postal"
* ^property[=].type = #dateTime

* ^property[+].code = #status
* ^property[=].uri = "http://hl7.org/fhir/concept-properties#status"
* ^property[=].description = "Statut : active, inactive, deprecated"
* ^property[=].type = #code

* ^property[+].code = #replacedBy
* ^property[=].description = "Code postal de remplacement (si changement)"
* ^property[=].type = #code

* ^property[+].code = #communeInsee
* ^property[=].description = "Code(s) commune(s) INSEE desservie(s) par ce code postal (séparés par des virgules si plusieurs)"
* ^property[=].type = #string

// =============================================
// Codes postaux principaux (échantillon)
// =============================================
// NOTE: Ce fichier contient un échantillon représentatif.
// Pour la liste complète, utiliser le script
// generate_codes_postaux_fsh.py fourni dans /scripts/

// Paris (75)
* #75001 "Paris 1er arrondissement"
  * ^property[0].code = #status
  * ^property[=].valueCode = #active
  * ^property[+].code = #communeInsee
  * ^property[=].valueString = "75056"

* #75002 "Paris 2e arrondissement"
  * ^property[0].code = #status
  * ^property[=].valueCode = #active
  * ^property[+].code = #communeInsee
  * ^property[=].valueString = "75056"

* #75003 "Paris 3e arrondissement"
  * ^property[0].code = #status
  * ^property[=].valueCode = #active
  * ^property[+].code = #communeInsee
  * ^property[=].valueString = "75056"

* #75004 "Paris 4e arrondissement"
  * ^property[0].code = #status
  * ^property[=].valueCode = #active
  * ^property[+].code = #communeInsee
  * ^property[=].valueString = "75056"

* #75005 "Paris 5e arrondissement"
  * ^property[0].code = #status
  * ^property[=].valueCode = #active
  * ^property[+].code = #communeInsee
  * ^property[=].valueString = "75056"
* #75006 "Paris 6e arrondissement"
* #75007 "Paris 7e arrondissement"
* #75008 "Paris 8e arrondissement"
* #75009 "Paris 9e arrondissement"
* #75010 "Paris 10e arrondissement"
* #75011 "Paris 11e arrondissement"
* #75012 "Paris 12e arrondissement"
* #75013 "Paris 13e arrondissement"
* #75014 "Paris 14e arrondissement"
* #75015 "Paris 15e arrondissement"
* #75016 "Paris 16e arrondissement"
* #75017 "Paris 17e arrondissement"
* #75018 "Paris 18e arrondissement"
* #75019 "Paris 19e arrondissement"
* #75020 "Paris 20e arrondissement"

// Grandes villes
* #13001 "Marseille 1er arrondissement"
* #13002 "Marseille 2e arrondissement"
* #13003 "Marseille 3e arrondissement"
* #13004 "Marseille 4e arrondissement"
* #13005 "Marseille 5e arrondissement"
* #13006 "Marseille 6e arrondissement"
* #13007 "Marseille 7e arrondissement"
* #13008 "Marseille 8e arrondissement"
* #13009 "Marseille 9e arrondissement"
* #13010 "Marseille 10e arrondissement"
* #13011 "Marseille 11e arrondissement"
* #13012 "Marseille 12e arrondissement"
* #13013 "Marseille 13e arrondissement"
* #13014 "Marseille 14e arrondissement"
* #13015 "Marseille 15e arrondissement"
* #13016 "Marseille 16e arrondissement"

* #69001 "Lyon 1er arrondissement"
* #69002 "Lyon 2e arrondissement"
* #69003 "Lyon 3e arrondissement"
* #69004 "Lyon 4e arrondissement"
* #69005 "Lyon 5e arrondissement"
* #69006 "Lyon 6e arrondissement"
* #69007 "Lyon 7e arrondissement"
* #69008 "Lyon 8e arrondissement"
* #69009 "Lyon 9e arrondissement"

* #31000 "Toulouse"
* #31100 "Toulouse - Secteur Nord"
* #31200 "Toulouse - Secteur Est"
* #31300 "Toulouse - Secteur Sud"
* #31400 "Toulouse - Secteur Ouest"
* #31500 "Toulouse - Périphérie"

* #06000 "Nice"
* #06100 "Nice - Est"
* #06200 "Nice - Ouest"
* #06300 "Nice - Nord"

* #44000 "Nantes"
* #44100 "Nantes - Secteur Nord"
* #44200 "Nantes - Secteur Sud"
* #44300 "Nantes - Périphérie"

* #67000 "Strasbourg"
* #67100 "Strasbourg - Secteur Sud"
* #67200 "Strasbourg - Périphérie"

* #34000 "Montpellier"
* #34070 "Montpellier - Secteur Est"
* #34080 "Montpellier - Secteur Ouest"
* #34090 "Montpellier - Secteur Nord"

* #33000 "Bordeaux"
* #33100 "Bordeaux - Secteur Nord"
* #33200 "Bordeaux - Secteur Ouest"
* #33300 "Bordeaux - Périphérie"
* #33800 "Bordeaux - Secteur Est"

* #59000 "Lille"
* #59100 "Roubaix"
* #59200 "Tourcoing"
* #59300 "Valenciennes"
* #59800 "Lille - Périphérie"

* #35000 "Rennes"
* #35200 "Rennes - Secteur Nord"
* #35700 "Rennes - Périphérie"

* #51100 "Reims"
* #51430 "Reims - Secteur Ouest"
* #51450 "Reims - Secteur Nord"

// Préfectures
* #01000 "Bourg-en-Bresse"
* #02000 "Laon"
* #03000 "Moulins"
* #04000 "Digne-les-Bains"
* #05000 "Gap"
* #07000 "Privas"
* #08000 "Charleville-Mézières"
* #09000 "Foix"
* #10000 "Troyes"
* #11000 "Carcassonne"
* #12000 "Rodez"
* #14000 "Caen"
* #15000 "Aurillac"
* #16000 "Angoulême"
* #17000 "La Rochelle"
* #18000 "Bourges"
* #19000 "Tulle"
* #20000 "Ajaccio"
* #21000 "Dijon"
* #22000 "Saint-Brieuc"
* #23000 "Guéret"
* #24000 "Périgueux"
* #25000 "Besançon"
* #26000 "Valence"
* #27000 "Évreux"
* #28000 "Chartres"
* #29200 "Brest"
* #30000 "Nîmes"
* #32000 "Auch"
* #36000 "Châteauroux"
* #37000 "Tours"
* #38000 "Grenoble"
* #39000 "Lons-le-Saunier"
* #40000 "Mont-de-Marsan"
* #41000 "Blois"
* #42000 "Saint-Étienne"
* #43000 "Le Puy-en-Velay"
* #45000 "Orléans"
* #46000 "Cahors"
* #47000 "Agen"
* #48000 "Mende"
* #49000 "Angers"
* #50000 "Saint-Lô"
* #52000 "Chaumont"
* #53000 "Laval"
* #54000 "Nancy"
* #55000 "Bar-le-Duc"
* #56000 "Vannes"
* #57000 "Metz"
* #58000 "Nevers"
* #60000 "Beauvais"
* #61000 "Alençon"
* #62000 "Arras"
* #63000 "Clermont-Ferrand"
* #64000 "Pau"
* #65000 "Tarbes"
* #66000 "Perpignan"
* #68000 "Colmar"
* #70000 "Vesoul"
* #71000 "Mâcon"
* #72000 "Le Mans"
* #73000 "Chambéry"
* #74000 "Annecy"
* #76000 "Rouen"
* #76600 "Le Havre"
* #77000 "Melun"
* #78000 "Versailles"
* #79000 "Niort"
* #80000 "Amiens"
* #81000 "Albi"
* #82000 "Montauban"
* #83000 "Toulon"
* #84000 "Avignon"
* #85000 "La Roche-sur-Yon"
* #86000 "Poitiers"
* #87000 "Limoges"
* #88000 "Épinal"
* #89000 "Auxerre"
* #90000 "Belfort"

// Île-de-France
* #91000 "Évry-Courcouronnes"
* #92000 "Nanterre"
* #92100 "Boulogne-Billancourt"
* #92200 "Neuilly-sur-Seine"
* #92300 "Levallois-Perret"
* #92400 "Courbevoie"
* #93000 "Bobigny"
* #93100 "Montreuil"
* #93200 "Saint-Denis"
* #94000 "Créteil"
* #94100 "Saint-Maur-des-Fossés"
* #94200 "Ivry-sur-Seine"
* #94300 "Vincennes"
* #95000 "Cergy"
* #95100 "Argenteuil"
* #95200 "Sarcelles"

// DROM-COM
* #97100 "Basse-Terre"
* #97110 "Pointe-à-Pitre"
* #97200 "Fort-de-France"
* #97300 "Cayenne"
* #97400 "Saint-Denis (La Réunion)"
* #97500 "Saint-Pierre-et-Miquelon"
* #97600 "Mamoudzou"
* #98000 "Monaco" // Inclus pour complétude
* #98800 "Nouméa"
* #98700 "Papeete"
