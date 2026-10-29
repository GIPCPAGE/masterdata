// =============================================
// RuleSet Adresse d'un établissement de tiers
// Appliqué à address (ordre 1) et à contact.address (ordres suivants)
// =============================================

RuleSet: TiersAdresse(path)
* {path}.line 0..3 MS
* {path}.line ^short = "Lignes 1 à 3 de l'adresse"
* {path}.line.extension contains
    $adxp-houseNumber named numeroVoie 0..1 MS and
    $adxp-streetNameType named typeVoie 0..1 MS and
    $adxp-streetNameBase named nomVoie 0..1 MS
* {path}.line.extension[numeroVoie] ^short = "Numéro de voie"
* {path}.line.extension[typeVoie] ^short = "Type de voie"
* {path}.line.extension[nomVoie] ^short = "Nom de voie"
* {path}.postalCode MS
* {path}.postalCode ^short = "Code postal"
* {path}.city MS
* {path}.city ^short = "Ville"
* {path}.extension[inseeCode] MS
* {path}.extension[inseeCode] ^short = "Commune (référentiel Communes du Master Data, code INSEE)"
* {path}.country MS
* {path}.country ^short = "Pays (référentiel Pays du Master Data)"
* {path}.extension contains TiersRoleRestrictionExtension named roleRestriction 0..1 MS
* {path}.extension[roleRestriction] ^short = "Restriction de rôle de l'adresse (F ou D)"
* {path}.extension[roleRestriction] ^definition = "Restreint l'adresse au circuit fournisseur ou débiteur. Vide : adresse commune aux deux circuits. La restriction doit faire partie du rôle du tiers."
