// =============================================
// Extensions : Pôle d'activité (Common IG)
// =============================================
// La période de validité du pôle est portée par l'extension standard organization-period
// (usePeriod), héritée de FR Core : pas d'extension propre. La date CME réutilise l'extension
// commune strh-date-cme (StrHDateCmeExtension.fsh).

// ── Code de validité (INVAPA) ─────────────────────────────────────────────────

Extension: POACodeValiditeExtension
Id: poa-code-validite
Title: "Code de validité du pôle"
Description: "Code de validité du pôle (INVAPA : I=Invalide / V=Valide)."
Context: Organization

* value[x] only code
// Réutilise le même ValueSet que EGCodeValiditeVS (I/V)
* valueCode from EGCodeValiditeVS (required)
* valueCode ^short = "Code validité (INVAPA)"

// ── Médecin coordonnateur (attribut LOCAL) ───────────────────────────────────

Extension: POAMedecinCoordonnateurExtension
Id: poa-medecin-coordonnateur
Title: "Médecin coordonnateur du pôle"
Description: "Médecin coordonnateur du pôle, en texte libre (255 caractères au plus) : la valeur n'est pas contrôlée contre un répertoire des médecins. Attribut de portée LOCAL, actif selon le tenant."
Context: Organization

* value[x] only string
* valueString ^short = "Médecin coordonnateur (texte libre)"
