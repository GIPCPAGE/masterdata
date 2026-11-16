// =============================================
// Extensions : Secteur budgétaire
// =============================================
// Champs de portée LOCAL du secteur budgétaire sans équivalent FR Core ni HL7.
// Le code APE réutilise l'extension ej-code-ape (EntiteJuridiqueExtensions.fsh).
// Colonnes Oracle SSBU citées d'après le modèle Master Data (non vérifiées contre
// un DDL indépendant : aucun export de SSBU dans ce dépôt).

// ── Coordonnées URSSAF (numéro, code, libellé) ───────────────────────────────

Extension: SBUrssafExtension
Id: sb-urssaf
Title: "URSSAF du secteur budgétaire"
Description: "Coordonnées URSSAF du secteur budgétaire : numéro, code et libellé. Distincte du bloc URSSAF de l'entité juridique, porté par l'IG CPage dans les numéros d'organismes patronaux."
Context: Organization

* extension contains
    numero  0..1 MS and
    code    0..1 MS and
    libelle 0..1 MS

* extension[numero].value[x] only string
* extension[numero] ^short = "Numéro URSSAF (15 caractères au plus)"
* extension[code].value[x] only string
* extension[code] ^short = "Code URSSAF (15 caractères au plus)"
* extension[libelle].value[x] only string
* extension[libelle] ^short = "Libellé URSSAF (255 caractères au plus)"

// ── Lettre budgétaire ────────────────────────────────────────────────────────
// Même représentation que celle du centre de responsabilité et de l'unité
// fonctionnelle (cre-lettre-budgetaire, uf-lettre-budgetaire) : le code de la lettre.

Extension: SBLettreBudgetaireExtension
Id: sb-lettre-budgetaire
Title: "Lettre budgétaire du secteur budgétaire"
Description: "Lettre budgétaire du secteur budgétaire (1 caractère), choisie parmi les lettres autorisées pour son entité juridique. Avec le code interne, elle forme l'identité du secteur."
Context: Organization

* value[x] only string
* valueString ^short = "Lettre budgétaire (1 caractère)"

// ── Libellé type de la lettre budgétaire ─────────────────────────────────────

Extension: SBLibelleTypeLettreBudgetaireExtension
Id: sb-libelle-type-lettre-budgetaire
Title: "Libellé type de la lettre budgétaire"
Description: "Libellé type de la lettre budgétaire du secteur budgétaire : clé de rattachement du secteur vers sa lettre, parmi celles autorisées pour son entité juridique."
Context: Organization

* value[x] only string
* valueString ^short = "Libellé type de la lettre budgétaire"
