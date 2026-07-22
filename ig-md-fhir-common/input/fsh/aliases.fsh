// =============================================
// Aliases pour IG Tiers Générique (basé sur FR Core)
// =============================================

// FR Core
Alias: $fr-core-organization = https://hl7.fr/ig/fhir/core/StructureDefinition/fr-core-organization

// HL7 standard terminologies
Alias: $v2-0203 = http://terminology.hl7.org/CodeSystem/v2-0203
Alias: $org-type = http://terminology.hl7.org/CodeSystem/organization-type

// Identifier systems for this IG
// TODO: Replace with your official OIDs/URIs
Alias: $id-etier = urn:oid:1.2.250.1.999.1.1.1
// Pour le numero de TVA l'OID est correct : 
Alias: $id-tva = urn:oid:1.2.250.1.69.1.1011

// Terminologies géographiques — CPage (communes COG INSEE)
Alias: $communes-fr-cs = https://www.cpage.fr/ig/masterdata/common/CodeSystem/communes-fr-cs
Alias: $commune-type-territoire-cs = https://www.cpage.fr/ig/masterdata/common/CodeSystem/commune-type-territoire-cs
Alias: $location-physical-type = http://terminology.hl7.org/CodeSystem/location-physical-type

// Terminologies géographiques — Pays (ISO 3166-1 / INSEE / ANS)
// URNs validés sur l'output FHIR réel du master-data-api
Alias: $iso3166-alpha2      = urn:iso:std:iso:3166
Alias: $iso3166-alpha3      = urn:iso:std:iso:3166:-1:alpha3
Alias: $iso3166-numeric     = urn:iso:std:iso:3166:-1:num
Alias: $tre-r20-pays        = https://mos.esante.gouv.fr/NOS/TRE_R20-Pays/FHIR/TRE-R20-Pays
Alias: $pays-type-entite-cs = https://www.cpage.fr/ig/masterdata/common/CodeSystem/pays-type-entite-cs
Alias: $pays-cs             = https://www.cpage.fr/ig/masterdata/common/CodeSystem/pays-cs

// FR Core
Alias: $fr-core-location = https://hl7.fr/ig/fhir/core/StructureDefinition/fr-core-location