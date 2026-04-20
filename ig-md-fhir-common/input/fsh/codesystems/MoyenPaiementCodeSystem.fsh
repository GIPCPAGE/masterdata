// =============================================
// CodeSystem: Types de moyen de paiement
// =============================================

CodeSystem: MoyenPaiementCS
Id: moyen-paiement-cs
Title: "Types de moyen de paiement"
Description: "Types de moyens de paiement acceptés ou utilisés pour les transactions avec les tiers"
* ^url = "https://www.cpage.fr/ig/masterdata/common/CodeSystem/moyen-paiement-cs"
* ^version = "1.0.0"
* ^status = #active
* ^experimental = false
* ^caseSensitive = true
* ^content = #complete
* ^count = 6

* #NUMERAIRE "Numéraire" "Paiement en espèces (cash)"
* #CHEQUE "Chèque" "Paiement par chèque bancaire"
* #VIREMENT "Virement bancaire" "Virement bancaire standard"
* #VIREMENT_APPLI_EXT "Virement via application externe" "Virement via une application de paiement externe"
* #VIREMENT_GROS_MONTANT "Virement gros montant" "Virement pour montants importants nécessitant validation spéciale"
* #VIREMENT_INTERNE "Virement interne" "Virement entre comptes internes de l'organisation"
