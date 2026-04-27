// =============================================
// Extension Bank Account
// =============================================

Extension: TiersBankAccount
Id: tiers-bank-account
Title: "Domiciliation bancaire (TBancaire)"
Description: """Coordonnées bancaires du tiers pour paiements (fournisseurs) ou recettes (débiteurs).

Conforme à la structure **TBancaire** du Protocole d'Échange Standard v2 (PESv2 — DGFiP),
bloc `<CpteBancaire>` du `<BlocTiers>`.

Le PESv2 impose un choix exclusif entre :
- **RIB français** : CodeEtab + CodeGuic + IdCpte + CleRib (tous 1..1) avec IdPayInt/IdBancInt optionnels
- **IBAN international** : IBAN (1..1) + BIC (0..1, obligatoire hors France)

Les champs LibBanc, TitCpte et DteBanc s'appliquent dans les deux cas."""
* ^url = "https://www.cpage.fr/ig/masterdata/common/StructureDefinition/tiers-bank-account"
* ^version = "1.0.0"
* ^status = #active
* ^copyright = "Source : DGFiP — Protocole d'Échange Standard v2 (PESv2), type TBancaire."
* ^context[0].type = #element
* ^context[0].expression = "Organization"

* extension contains
    // ── Champs communs aux deux modes ──
    titCpte 0..1 MS and
    libBanc 0..1 MS and
    dteBanc 0..1 MS and
    // ── Mode RIB français (CodeEtab+CodeGuic+IdCpte+CleRib) ──
    bankCode 0..1 MS and
    branchCode 0..1 MS and
    accountNumber 0..1 MS and
    ribKey 0..1 MS and
    idPayInt 0..1 MS and
    idBancInt 0..1 MS and
    // ── Mode IBAN international ──
    iban 0..1 MS and
    bic 0..1 MS and
    // ── Paramètres CPage hors PESv2 ──
    ediEnabled 0..1 MS and
    factoringEnabled 0..1 MS and
    paymentMethod 0..* MS

// ── Champs communs ──

* extension[titCpte] ^short = "Nom du titulaire du compte (TitCpte)"
* extension[titCpte] ^definition = "Désignation du titulaire du compte à créditer telle qu'elle figure sur le RIB (32 caractères). Champ TitCpte du PESv2 — obligatoire dans les échanges PESv2."
* extension[titCpte].value[x] only string
* extension[titCpte].valueString 1..1
* extension[titCpte].valueString ^maxLength = 32

* extension[libBanc] ^short = "Libellé de l'établissement bancaire (LibBanc)"
* extension[libBanc] ^definition = "Nom de l'établissement bancaire (24 caractères). Champ LibBanc du PESv2."
* extension[libBanc].value[x] only string
* extension[libBanc].valueString 1..1
* extension[libBanc].valueString ^maxLength = 24

* extension[dteBanc] ^short = "Date de mise à jour de la domiciliation (DteBanc)"
* extension[dteBanc] ^definition = "Date de mise à jour des éléments de la domiciliation bancaire. Champ DteBanc du PESv2."
* extension[dteBanc].value[x] only date
* extension[dteBanc].valueDate 1..1

// ── Mode RIB français ──

* extension[bankCode] ^short = "Code établissement bancaire (CodeEtab)"
* extension[bankCode] ^definition = "Code établissement bancaire (5 caractères alphanumériques). Les 4 champs CodeEtab, CodeGuic, IdCpte, CleRib doivent être valorisés ensemble avec un RIB correct — PESv2 rejet sinon."
* extension[bankCode].value[x] only string
* extension[bankCode].valueString 1..1
* extension[bankCode].valueString ^maxLength = 5

* extension[branchCode] ^short = "Code guichet (CodeGuic)"
* extension[branchCode] ^definition = "Code guichet de l'établissement bancaire (5 caractères). Les 4 champs RIB doivent être valorisés ensemble — PESv2 rejet sinon."
* extension[branchCode].value[x] only string
* extension[branchCode].valueString 1..1
* extension[branchCode].valueString ^maxLength = 5

* extension[accountNumber] ^short = "Numéro de compte (IdCpte)"
* extension[accountNumber] ^definition = "Numéro de compte du client (11 caractères). Les 4 champs RIB doivent être valorisés ensemble — PESv2 rejet sinon."
* extension[accountNumber].value[x] only string
* extension[accountNumber].valueString 1..1
* extension[accountNumber].valueString ^maxLength = 11

* extension[ribKey] ^short = "Clé RIB (CleRib)"
* extension[ribKey] ^definition = "Clé de contrôle RIB (2 chiffres). Les 4 champs RIB doivent être valorisés ensemble et cohérents — PESv2 rejet sinon."
* extension[ribKey].value[x] only string
* extension[ribKey].valueString 1..1
* extension[ribKey].valueString ^maxLength = 2

* extension[idPayInt] ^short = "Identification internationale du pays (IdPayInt)"
* extension[idPayInt] ^definition = "Code pays international (4 caractères alphanumériques) permettant d'obtenir les références IBAN. Obligatoire si IdBancInt est renseigné — PESv2 rejet du bordereau sinon."
* extension[idPayInt].value[x] only string
* extension[idPayInt].valueString 1..1
* extension[idPayInt].valueString ^maxLength = 4

* extension[idBancInt] ^short = "Identification internationale de la banque (IdBancInt)"
* extension[idBancInt] ^definition = "Identification bancaire internationale (11 caractères alphanumériques) pour obtenir les références IBAN. Obligatoire si IdPayInt est renseigné — PESv2 rejet du bordereau sinon."
* extension[idBancInt].value[x] only string
* extension[idBancInt].valueString 1..1
* extension[idBancInt].valueString ^maxLength = 11

// ── Mode IBAN international ──

* extension[iban] ^short = "IBAN (International Bank Account Number)"
* extension[iban] ^definition = "IBAN complet et valide (jusqu'à 34 caractères, majuscules obligatoires). Champ IBAN du PESv2 — rejet du bordereau si invalide ou incomplet."
* extension[iban].value[x] only string
* extension[iban].valueString 1..1
* extension[iban].valueString ^maxLength = 34

* extension[bic] ^short = "BIC / SWIFT (Bank International Code)"
* extension[bic] ^definition = "Code BIC/SWIFT (11 caractères, majuscules obligatoires). Champ BIC du PESv2 — obligatoire pour toute domiciliation à l'étranger, rejet sinon."
* extension[bic].value[x] only string
* extension[bic].valueString 1..1
* extension[bic].valueString ^maxLength = 11

// ── Paramètres CPage hors PESv2 ──

* extension[ediEnabled] ^short = "EDI activé"
* extension[ediEnabled] ^definition = "Indique si les échanges EDI sont activés pour ce compte bancaire (paiements électroniques automatisés). Extension CPage — absent du PESv2."
* extension[ediEnabled].value[x] only boolean
* extension[ediEnabled].valueBoolean 1..1

* extension[factoringEnabled] ^short = "Affacturage activé"
* extension[factoringEnabled] ^definition = "Indique si le compte est sujet à l'affacturage (cession de créances). Extension CPage — absent du PESv2."
* extension[factoringEnabled].value[x] only boolean
* extension[factoringEnabled].valueBoolean 1..1

* extension[paymentMethod] ^short = "Moyens de paiement acceptés"
* extension[paymentMethod] ^definition = "Liste des moyens de paiement acceptés sur ce compte. Extension CPage — absent du PESv2."
* extension[paymentMethod].value[x] only CodeableConcept
* extension[paymentMethod].valueCodeableConcept 1..1
* extension[paymentMethod].valueCodeableConcept from MoyenPaiementVS (required)

