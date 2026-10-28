// =============================================
// Extension Compte bancaire du tiers
// =============================================

Extension: TiersBankAccount
Id: tiers-bank-account
Title: "Compte bancaire du tiers"
Description: """Compte bancaire d'un établissement du tiers.

L'IBAN est la valeur maître : le RIB français s'en déduit et n'est pas porté séparément.

- **Rattachement** : un compte est toujours porté par un établissement. Un compte propre à un site est porté par l'établissement secondaire concerné.
- **Compte commun à la société** : un compte de toute la société est porté par l'établissement principal avec `communSociete = true`. Ce drapeau n'est autorisé que sur l'établissement principal. Un site utilise ses propres comptes et les comptes communs de l'établissement principal.
- **Restriction de rôle** : facultative (fournisseur ou débiteur). L'absence de restriction signifie que le compte est commun aux deux circuits."""
* ^status = #active
* ^context[0].type = #element
* ^context[0].expression = "Organization"

* extension contains
    titulaire 0..1 MS and
    iban 1..1 MS and
    bic 0..1 MS and
    actif 0..1 MS and
    role 0..1 MS and
    communSociete 0..1 MS

* extension[titulaire] ^short = "Titulaire du compte"
* extension[titulaire] ^definition = "Désignation du titulaire du compte."
* extension[titulaire].value[x] only string
* extension[titulaire].valueString 1..1

* extension[iban] ^short = "IBAN"
* extension[iban] ^definition = "IBAN complet (jusqu'à 34 caractères, majuscules). Valeur maître du compte : le RIB français est calculé à partir de l'IBAN."
* extension[iban].value[x] only string
* extension[iban].valueString 1..1
* extension[iban].valueString ^maxLength = 34

* extension[bic] ^short = "BIC / SWIFT"
* extension[bic] ^definition = "Code BIC/SWIFT de la banque."
* extension[bic].value[x] only string
* extension[bic].valueString 1..1
* extension[bic].valueString ^maxLength = 11

* extension[actif] ^short = "Compte actif"
* extension[actif] ^definition = "Indique si le compte est actif."
* extension[actif].value[x] only boolean
* extension[actif].valueBoolean 1..1

* extension[role] ^short = "Restriction de rôle (F ou D)"
* extension[role] ^definition = "Restreint le compte au circuit fournisseur (supplier) ou débiteur (debtor). Vide : compte commun aux deux circuits. La restriction doit faire partie du rôle du tiers."
* extension[role].value[x] only Coding
* extension[role].valueCoding 1..1
* extension[role].valueCoding from TiersRestrictionRoleValueSet (required)

* extension[communSociete] ^short = "Compte commun à toute la société"
* extension[communSociete] ^definition = "Vrai si le compte est commun à toute la société. Autorisé uniquement sur l'établissement principal. Un compte propre à un site a communSociete = false."
* extension[communSociete].value[x] only boolean
* extension[communSociete].valueBoolean 1..1
