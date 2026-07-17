// =============================================
// CodeSystem: Type de résident
// =============================================

CodeSystem: TypeResidentCS
Id: type-resident-cs
Title: "Type de résident fiscal"
Description: "Type de résident fiscal pour un débiteur"
* ^url = "https://www.cpage.fr/ig/masterdata/common/CodeSystem/type-resident-cs"
* ^version = "1.0.0"
* ^status = #active
* ^experimental = false
* ^caseSensitive = true
* ^content = #complete
* ^count = 2
* ^meta.profile = "http://hl7.org/fhir/StructureDefinition/shareablecodesystem"

* #R "Résident" "Résident fiscal français"
* #NR "Non résident" "Non résident fiscal français"
