// =============================================
// Extension: Paramètres Débiteur
// =============================================

Extension: DebiteurParametresExtension
Id: debiteur-parametres
Title: "Paramètres Débiteur"
Description: "Paramètres de gestion pour un débiteur/client : compte comptable, type de résident, facturation des actes de biologie et liquidation souple. Correspond aux colonnes COMPTI, EUROTI, FACBTI, TRLSTI de la table ETIER."
* ^url = "https://www.cpage.fr/ig/masterdata/common/StructureDefinition/debiteur-parametres"
* ^version = "1.0.0"
* ^status = #active
* ^context[0].type = #element
* ^context[0].expression = "Organization"

* extension contains
    compteLettre 0..1 MS and
    typeResident 0..1 MS and
    typeDebiteur 0..1 MS and
    assuAutorise 0..1 MS and
    forceImpressionCoh 0..1 MS and
    facturationActesBiologie 0..1 MS and
    liquidationSoupleAutorisee 0..1 MS and
    asapDesactive 0..1 MS and
    dateIntegration 0..1 MS and
    fournisseurAssocie 0..1 MS

* extension[compteLettre] ^short = "Compte lettre"
* extension[compteLettre] ^definition = "Compte comptable du débiteur"
* extension[compteLettre].value[x] only string
* extension[compteLettre].valueString 1..1

* extension[typeResident] ^short = "Type de résident"
* extension[typeResident] ^definition = "Type de résident (R=résident, NR=non résident)"
* extension[typeResident].value[x] only code
* extension[typeResident].valueCode 1..1
* extension[typeResident].valueCode from TypeResidentVS (required)

* extension[typeDebiteur] ^short = "Type de débiteur"
* extension[typeDebiteur] ^definition = "Type de débiteur selon classification interne"
* extension[typeDebiteur].value[x] only string
* extension[typeDebiteur].valueString 1..1

* extension[assuAutorise] ^short = "Assurance autorisée"
* extension[assuAutorise] ^definition = "Débiteur autorisé pour les opérations d'assurance"
* extension[assuAutorise].value[x] only boolean
* extension[assuAutorise].valueBoolean 1..1

* extension[forceImpressionCoh] ^short = "Force impression cohérente"
* extension[forceImpressionCoh] ^definition = "Force l'impression cohérente des documents"
* extension[forceImpressionCoh].value[x] only boolean
* extension[forceImpressionCoh].valueBoolean 1..1

* extension[facturationActesBiologie] ^short = "Facturation des Actes de Biologie (FACBTI)"
* extension[facturationActesBiologie] ^definition = "Indique si la facturation des actes de biologie (FAB) est activée pour ce débiteur (O/N). Correspond à la colonne FACBTI de la table ETIER."
* extension[facturationActesBiologie].value[x] only boolean
* extension[facturationActesBiologie].valueBoolean 1..1

* extension[liquidationSoupleAutorisee] ^short = "Liquidation souple autorisée (TRLSTI)"
* extension[liquidationSoupleAutorisee] ^definition = "Indique si la liquidation souple (par défaut) est autorisée pour ce débiteur (O/N). Correspond à la colonne TRLSTI de la table ETIER."
* extension[liquidationSoupleAutorisee].value[x] only boolean
* extension[liquidationSoupleAutorisee].valueBoolean 1..1

* extension[asapDesactive] ^short = "Désactiver la génération d'ASAP dématérialisé (ASAPDT)"
* extension[asapDesactive] ^definition = "Indique qu'aucun ASAP dématérialisé ne doit être généré pour ce débiteur (O=désactivé, N=activé). Correspond à la colonne ASAPDT de la table DBT."
* extension[asapDesactive].value[x] only boolean
* extension[asapDesactive].valueBoolean 1..1

* extension[dateIntegration] ^short = "Date d'intégration du débiteur externe (DINTDT)"
* extension[dateIntegration] ^definition = "Date à laquelle le débiteur a été intégré depuis un système externe. Correspond à la colonne DINTDT de la table DBT."
* extension[dateIntegration].value[x] only date
* extension[dateIntegration].valueDate 1..1

* extension[fournisseurAssocie] ^short = "Code fournisseur associé (NUFODT)"
* extension[fournisseurAssocie] ^definition = "Code interne (6 caractères) du fournisseur lié à ce débiteur. Permet d'associer un tiers-fournisseur à un tiers-débiteur dans le référentiel. Correspond à la colonne NUFODT de la table DBT."
* extension[fournisseurAssocie].value[x] only string
* extension[fournisseurAssocie].valueString 1..1
* extension[fournisseurAssocie].valueString ^maxLength = 6
