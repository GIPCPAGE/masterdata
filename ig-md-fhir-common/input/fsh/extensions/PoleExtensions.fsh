// =============================================
// Extensions : Pôle d'activité (Common IG)
// =============================================
// La période de validité du pôle est portée par l'extension standard organization-period
// (usePeriod), héritée de FR Core : pas d'extension propre.

// ── Code de validité (INVAPA) ─────────────────────────────────────────────────

Extension: POACodeValiditeExtension
Id: poa-code-validite
Title: "Code de validité du pôle"
Description: "Code de validité du pôle (INVAPA : F=Fermé / I=Invalide / V=Valide)."
Context: Organization

* value[x] only code
// Réutilise le même ValueSet que EGCodeValiditeVS (F/I/V)
* valueCode from EGCodeValiditeVS (required)
* valueCode ^short = "Code validité (INVAPA)"

// ── Date CME (attribut LOCAL) ────────────────────────────────────────────────

Extension: POADateCmeExtension
Id: poa-date-cme
Title: "Date CME du pôle"
Description: "Date associée à la commission médicale d'établissement (CME) pour le pôle. Attribut de portée LOCAL, sans équivalent FR Core ni HL7, actif selon le tenant."
Context: Organization

* value[x] only date
* valueDate ^short = "Date de la commission médicale d'établissement"

// ── Médecin coordonnateur (attribut LOCAL) ───────────────────────────────────

Extension: POAMedecinCoordonnateurExtension
Id: poa-medecin-coordonnateur
Title: "Médecin coordonnateur du pôle"
Description: "Médecin coordonnateur du pôle, en texte libre (255 caractères au plus) : la valeur n'est pas contrôlée contre un répertoire des médecins. Attribut de portée LOCAL, actif selon le tenant."
Context: Organization

* value[x] only string
* valueString ^short = "Médecin coordonnateur (texte libre)"
