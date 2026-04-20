# Exemples d'Utilisation

## Vue d'ensemble

| Axe | Exemples |
|-----|----------|
| **Axe Concepts Métiers** | Organizations : multi-rôle, bi-rôle, succursale, fournisseur, client, EPS public, personne physique, société NC |
| **Axe Nomenclatures** | Communes COG : commune déléguée, commune nouvelle, opérations $lookup / $expand / $changes-since |

---

## Exemples Tiers — Organizations

| # | Ressource | Description |
|---|-----------|-------------|
| 1 | [ExempleTiersComplet](Organization-ExempleTiersComplet.html) | Organisation multi-rôles (supplier + debtor + payer) |
| 2 | [ExempleTiersDoubleRole](Organization-ExempleTiersDoubleRole.html) | Clinique bi-rôle : vend des consultations ET achète des médicaments |
| 3 | [ExempleSuccursale](Organization-ExempleSuccursale.html) | Site secondaire avec `partOf` → siège ; usages livraison + facturation |
| 4 | [ExempleFournisseurComplet](Organization-ExempleFournisseurComplet.html) | Laboratoire pharmaceutique — conditions paiement, EDI, affacturage |
| 5 | [ExempleFournisseurSuccursale](Organization-ExempleFournisseurSuccursale.html) | Fournisseur avec dépôt de livraison distinct (même SIREN, NIC différent) |
| 6 | [ExempleDebiteurPersonnePhysique](Organization-ExempleDebiteurPersonnePhysique.html) | Particulier : NIR + civilité + prénom (catégorie 01 obligatoire) |
| 7 | [ExempleDebiteurEPSPublic](Organization-ExempleDebiteurEPSPublic.html) | EPS public : FINESS + compte contrepartie + code régie CHORUS |
| 8 | [ExempleFournisseurRIDET](Organization-ExempleFournisseurRIDET.html) | Société néo-calédonienne avec identifiant RIDET |

---

## Exemples Communes COG

| # | Ressource | Description |
|---|-----------|-------------|
| 9 | [ExemplePatientCommuneDeleguee](Patient-ExemplePatientCommuneDeleguee.html) | Adresse avec commune déléguée (code 69282) via extension `fr-core-address-insee-code` |
| 10 | [ExempleOrganisationCommuneNouvelle](Organization-ExempleOrganisationCommuneNouvelle.html) | Adresse avec commune nouvelle (code 69264) |
| 11 | [ExempleParametersLookupCommuneNouvelle](Parameters-ExempleParametersLookupCommuneNouvelle.html) | `$lookup` — résolution commune déléguée → commune nouvelle |
| 12 | [ExempleParametersLookupSuccesseur](Parameters-ExempleParametersLookupSuccesseur.html) | `$lookup` — retrouver le successeur d'une commune inactive |
| 13 | [ExempleParametersExpandCommunesSupprimees](Parameters-ExempleParametersExpandCommunesSupprimees.html) | `$expand` — liste des communes supprimées/fusionnées |
| 14 | [ExempleParametersExpandCommunesCrees2025](Parameters-ExempleParametersExpandCommunesCrees2025.html) | `$expand` — communes créées en 2025 (filtre `regex`) |
| 15 | [ExempleParametersChangesSinceRequest](Parameters-ExempleParametersChangesSinceRequest.html) | `$changes-since` — requête de synchronisation |
| 16 | [ExempleParametersChangesSinceResponse](Parameters-ExempleParametersChangesSinceResponse.html) | `$changes-since` — réponse avec liste des modifications |

---

## Voir aussi

- [Profils Tiers](tiers-organization.html) · [Données Géographiques COG](geographie.html) · [Artifacts](artifacts.html)
| 14 | [ExempleParametersExpandCommunesCrees2025](Parameters-ExempleParametersExpandCommunesCrees2025.html) | `$expand` — communes créées en 2025 (filtre `regex`) |
| 15 | [ExempleParametersChangesSinceRequest](Parameters-ExempleParametersChangesSinceRequest.html) | `$changes-since` — requête de synchronisation |
| 16 | [ExempleParametersChangesSinceResponse](Parameters-ExempleParametersChangesSinceResponse.html) | `$changes-since` — réponse avec liste des modifications |

---

## Voir aussi

- [Profils Tiers](tiers-organization.html) · [Données Géographiques COG](geographie.html) · [Artifacts](artifacts.html)