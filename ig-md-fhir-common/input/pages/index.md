# Guide d'Implémentation FHIR — Référentiel Commun CPage MasterData

Ce guide d'implémentation définit les **profils et terminologies FHIR communs** utilisés par les applications CPage MasterData pour l'échange et la validation des données de référence.

---

## Contenu de ce guide

### Axe Concepts Métiers — Tiers

Profils `Organization` pour les structures tierces (fournisseurs, débiteurs, payeurs santé) :

| Ressource | Description |
|-----------|-------------|
| **TiersProfile** | Profil de base — identifiants (SIRET, SIREN, FINESS, NIR, TVA…), coordonnées, rôles |
| **FournisseurProfile** | Spécialisation fournisseur (EFOU) |
| **DebiteurProfile** | Spécialisation débiteur (KERD) |
| **PayeurSanteProfile** | Régimes d'assurance maladie |

### Axe Nomenclatures — Données Géographiques COG

Référentiel des communes françaises selon le Code Officiel Géographique INSEE :

| Ressource | Description |
|-----------|-------------|
| **communes-fr-cs** | CodeSystem CPage — ~36 000 communes avec historique, fusions, codes postaux |
| **communes-fr-actives-vs** | ValueSet des communes en vigueur (`inactive = false`) |
| **insee-cog-commune** | NamingSystem — OID `1.2.250.1.213.2.12` + URI CPage |

---

## Ressources de conformité

L'ensemble des profils, extensions, CodeSystems, ValueSets et instances exemples est disponible sur la page [Ressources de conformité](artifacts.html).
