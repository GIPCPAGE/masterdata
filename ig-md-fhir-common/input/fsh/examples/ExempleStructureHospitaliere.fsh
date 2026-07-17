// =============================================
// Exemples : Structure Hospitalière
// CHU de Dijon — hiérarchie complète
// =============================================

// ── Entité Juridique ──────────────────────────────────────────────────────────

Instance: ExempleEntiteJuridiqueCHUDijon
InstanceOf: EntiteJuridiqueProfile
Usage: #example
Title: "Exemple Entité Juridique — CHU Dijon"
Description: "Entité légale du Centre Hospitalier Universitaire de Dijon."

* id = "entite-juridique-chu-dijon"
* meta.profile = "https://www.cpage.fr/ig/masterdata/common/StructureDefinition/strh-entite-juridique-profile"
* active = true
* name = "CHU Dijon Bourgogne"

* identifier[strHId].system = "https://www.cpage.fr/ig/masterdata/common/identifiers/strh"
* identifier[strHId].value = "chu-dijon-ej-001"

* identifier[siren].system = "https://sirene.fr"
* identifier[siren].value = "262100043"

* identifier[choCode].system = "https://www.cpage.fr/ig/masterdata/common/identifiers/cho-code"
* identifier[choCode].value = "CHU21"

* type[legalEntityType].coding.system = "https://hl7.fr/ig/fhir/core/CodeSystem/fr-core-cs-v2-3307"
* type[legalEntityType].coding.code = #LEGAL-ENTITY
* type[legalEntityType].coding.display = "Entité légale"

// ── Entité Géographique ───────────────────────────────────────────────────────

Instance: ExempleEntiteGeographiqueBocage
InstanceOf: EntiteGeographiqueProfile
Usage: #example
Title: "Exemple Entité Géographique — Site Bocage"
Description: "Site géographique Bocage Central du CHU Dijon."

* id = "entite-geographique-bocage"
* meta.profile = "https://www.cpage.fr/ig/masterdata/common/StructureDefinition/strh-entite-geographique-profile"
* active = true
* name = "CHU Dijon — Site Bocage Central"

* identifier[strHId].system = "https://www.cpage.fr/ig/masterdata/common/identifiers/strh"
* identifier[strHId].value = "chu-dijon-bocage-001"

* identifier[etaCode].system = "https://www.cpage.fr/ig/masterdata/common/identifiers/eta-code"
* identifier[etaCode].value = "BOCAGE"

* identifier[siret].system = "https://sirene.fr"
* identifier[siret].value = "26210004300010"

* identifier[finess].system = "https://finess.esante.gouv.fr"
* identifier[finess].value = "210785094"

* type[geoEntityType].coding.system = "https://hl7.fr/ig/fhir/core/CodeSystem/fr-core-cs-v2-3307"
* type[geoEntityType].coding.code = #GEOGRAPHICAL-ENTITY

* address.country = "FR"
* address.city = "Dijon"
* address.postalCode = "21079"
* address.line[0] = "2 Boulevard de la Marne"

* partOf = Reference(ExempleEntiteJuridiqueCHUDijon)

// ── Pôle ──────────────────────────────────────────────────────────────────────

Instance: ExemplePoleMedecine
InstanceOf: PoleProfile
Usage: #example
Title: "Exemple Pôle — Médecine"
Description: "Pôle Médecine du CHU Dijon."

* id = "pole-medecine-chu-dijon"
* meta.profile = "https://www.cpage.fr/ig/masterdata/common/StructureDefinition/strh-pole-profile"
* active = true
* name = "Pôle Médecine"

* identifier[strHId].system = "https://www.cpage.fr/ig/masterdata/common/identifiers/strh"
* identifier[strHId].value = "chu-dijon-pole-med-001"

* identifier[poaCode].system = "https://www.cpage.fr/ig/masterdata/common/identifiers/poa-code"
* identifier[poaCode].value = "P-MED"

* type[poleType].coding.system = "https://hl7.fr/ig/fhir/core/CodeSystem/fr-core-cs-v2-3307"
* type[poleType].coding.code = #POLE

* extension[codeInterne].valueString = "P-MED"

* partOf = Reference(ExempleEntiteGeographiqueBocage)

// ── Unité Fonctionnelle ────────────────────────────────────────────────────────

Instance: ExempleUFCardiologie
InstanceOf: UFProfile
Usage: #example
Title: "Exemple UF — Cardiologie"
Description: "Unité Fonctionnelle Cardiologie du CHU Dijon."

* id = "uf-cardiologie-chu-dijon"
* meta.profile = "https://www.cpage.fr/ig/masterdata/common/StructureDefinition/strh-uf-profile"
* active = true
* name = "UF Cardiologie"

* identifier[strHId].system = "https://www.cpage.fr/ig/masterdata/common/identifiers/strh"
* identifier[strHId].value = "chu-dijon-uf-cardio-001"

* identifier[ufCode].system = "https://www.cpage.fr/ig/masterdata/common/identifiers/uf-code"
* identifier[ufCode].value = "7301"

* type[0].coding.system = "https://hl7.fr/ig/fhir/core/CodeSystem/fr-core-cs-v2-3307"
* type[0].coding.code = #UF

* extension[siteLocalisation].valueReference = Reference(ExempleEntiteGeographiqueBocage)
* extension[lettreBudgetaire].valueString = "UF-7301"

* partOf = Reference(ExemplePoleMedecine)

// ── Chambre ────────────────────────────────────────────────────────────────────

Instance: ExempleChambre201
InstanceOf: ChambreProfile
Usage: #example
Title: "Exemple Chambre — 201"
Description: "Chambre 201 de l'UF Cardiologie."

* id = "chambre-201-cardio-chu-dijon"
* meta.profile = "https://www.cpage.fr/ig/masterdata/common/StructureDefinition/strh-chambre-profile"
* status = #active
* name = "Chambre 201"

* identifier[strHId].system = "https://www.cpage.fr/ig/masterdata/common/identifiers/strh"
* identifier[strHId].value = "chu-dijon-ch-201"

* identifier[chambreCode].system = "https://www.cpage.fr/ig/masterdata/common/identifiers/chambre-code"
* identifier[chambreCode].value = "0201"

* type[chambreType].coding.system = "https://hl7.fr/ig/fhir/core/CodeSystem/fr-core-cs-location-type"
* type[chambreType].coding.code = #CHAMB

* extension[codeInterne].valueString = "CH-201"

* managingOrganization = Reference(ExempleUFCardiologie)

// ── Lit ────────────────────────────────────────────────────────────────────────

Instance: ExempleLit201A
InstanceOf: LitProfile
Usage: #example
Title: "Exemple Lit — 201-A"
Description: "Lit A de la chambre 201."

* id = "lit-201-a-chu-dijon"
* meta.profile = "https://www.cpage.fr/ig/masterdata/common/StructureDefinition/strh-lit-profile"
* status = #active
* name = "Lit 201-A"

* identifier[strHId].system = "https://www.cpage.fr/ig/masterdata/common/identifiers/strh"
* identifier[strHId].value = "chu-dijon-lit-201-a"

* identifier[litCode].system = "https://www.cpage.fr/ig/masterdata/common/identifiers/lit-code"
* identifier[litCode].value = "201A"

* type[litType].coding.system = "https://hl7.fr/ig/fhir/core/CodeSystem/fr-core-cs-location-type"
* type[litType].coding.code = #LIT

* extension[codeInterne].valueString = "LIT-201-A"

* partOf = Reference(ExempleChambre201)
* managingOrganization = Reference(ExempleUFCardiologie)
