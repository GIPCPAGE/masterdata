// =============================================
// Invariants du modèle Tiers
// =============================================

Invariant: tiers-siret-siren
Description: "Les 9 premiers chiffres du SIRET de l'établissement principal sont le SIREN du tiers."
Severity: #error
Expression: "identifier.where(system = 'https://sirene.fr').exists() and identifier.where(system = 'https://sirene.fr/siren').exists() implies identifier.where(system = 'https://sirene.fr').value.first().substring(0, 9) = identifier.where(system = 'https://sirene.fr/siren').value.first()"

Invariant: tiers-contact-adresse
Description: "Un contact sans purpose est une adresse d'ordre supérieur à 1 : il porte une adresse."
Severity: #error
Expression: "purpose.exists() or address.exists()"
