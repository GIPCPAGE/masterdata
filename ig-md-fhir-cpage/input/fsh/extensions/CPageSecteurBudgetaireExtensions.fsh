// =============================================
// Extensions CPage : Secteur budgétaire (SSBU)
// =============================================
// Champ spécifique CPage : clé de rattachement du secteur à son établissement.
// Colonne Oracle citée d'après le modèle Master Data (non vérifiée contre un DDL
// indépendant : aucun export de SSBU dans ce dépôt).

Extension: CPageSBCodeEtablissementRattachementExtension
Id: cpage-sb-code-etablissement-rattachement
Title: "Code de l'établissement de rattachement du secteur budgétaire"
Description: """
Code de l'établissement de regroupement auquel le secteur budgétaire est rattaché
(table SSBU — colonne ETA_NUETET, code interne de l'entité géographique, 2 caractères).

Obligatoire dans CPage lorsqu'un secteur budgétaire existe. Copie conservée pour la cohérence
du lien de hiérarchie, qui fait foi : le rattachement est porté par `Organization.partOf`.
Rattachement alternatif au groupement hospitalier : l'un ou l'autre.
"""
Context: Organization

* value[x] only string
* valueString ^short = "Code de l'établissement de rattachement (SSBU.ETA_NUETET — 2 caractères)"
