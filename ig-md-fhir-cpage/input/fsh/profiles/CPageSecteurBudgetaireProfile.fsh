// =============================================
// Profil CPage : Secteur budgétaire (SSBU)
// =============================================

Profile: CPageSecteurBudgetaireProfile
Parent: SecteurBudgetaireProfile
Id: cpage-secteur-budgetaire-profile
Title: "Secteur budgétaire (CPage)"
Description: """
Profil CPage pour le secteur budgétaire.

Hérite de `SecteurBudgetaireProfile` (ig-md-fhir-common) et ajoute :
- le code de l'établissement de rattachement (colonne `SSBU.ETA_NUETET`)

Source Oracle `SSBU` non vérifiée contre un DDL indépendant (aucun export de cette table dans ce dépôt).
"""

* extension contains
    CPageSBCodeEtablissementRattachementExtension named codeEtablissementRattachement 0..1 MS

* extension[codeEtablissementRattachement] ^short = "Code de l'établissement de rattachement (SSBU.ETA_NUETET)"
