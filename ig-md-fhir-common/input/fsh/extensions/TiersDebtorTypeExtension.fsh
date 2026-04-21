// =============================================
// Extension: Type Débiteur
// =============================================

Extension: TiersDebtorType
Id: tiers-debtor-type
Title: "Type Débiteur"
Description: "Extension pour qualifier le type de débiteur selon la nomenclature : Occasionnel (O) ou Normal (N). Correspond au champ KERD position 2. Un débiteur occasionnel est enregistré ponctuellement pour une opération spécifique, tandis qu'un débiteur normal est utilisé de façon récurrente."
Context: Organization
* ^url = "https://www.cpage.fr/ig/masterdata/common/StructureDefinition/tiers-debtor-type"
* ^version = "1.0.0"
* ^status = #active
* ^context[0].type = #element
* ^context[0].expression = "Organization"

* value[x] only code
* valueCode 1..1 MS
* valueCode from TiersDebtorTypeVS (required)
* valueCode ^short = "Type débiteur : O (Occasionnel) ou N (Normal)"
* valueCode ^definition = "Code indiquant si le débiteur est occasionnel (enregistrement ponctuel) ou normal/régulier (enregistrement permanent)"
