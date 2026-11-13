// =============================================
// Extension Date de naissance (personne physique)
// =============================================

Extension: TiersBirthDate
Id: tiers-birth-date
Title: "Date de naissance"
Description: "Date de naissance d'un tiers personne physique. Portée par le contact personnePhysique, dont contact.name porte la civilité, le prénom et le nom (Organization.contact n'a pas d'élément date de naissance)."
* ^status = #active
* ^context[0].type = #element
* ^context[0].expression = "Organization.contact"
* value[x] only date
* valueDate 1..1
