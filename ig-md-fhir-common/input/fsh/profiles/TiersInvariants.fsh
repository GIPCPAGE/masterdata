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

Invariant: tiers-restriction-role
Description: "La restriction de rôle d'une adresse ou d'un compte bancaire doit faire partie du rôle du tiers : un tiers fournisseur ne porte que des restrictions fournisseur, un tiers débiteur que des restrictions débiteur ; un tiers mixte peut porter les deux."
Severity: #error
Expression: "extension('https://www.cpage.fr/ig/masterdata/common/StructureDefinition/tiers-role-extension').value.code = 'mixed' or (address.extension('https://www.cpage.fr/ig/masterdata/common/StructureDefinition/tiers-role-restriction-extension').value.code | contact.address.extension('https://www.cpage.fr/ig/masterdata/common/StructureDefinition/tiers-role-restriction-extension').value.code | extension('https://www.cpage.fr/ig/masterdata/common/StructureDefinition/tiers-bank-account').extension('role').value.code).all($this = %resource.extension('https://www.cpage.fr/ig/masterdata/common/StructureDefinition/tiers-role-extension').value.code)"
