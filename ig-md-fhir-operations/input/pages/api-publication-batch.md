# API FHIR de récupération des lots publiés

Cette page décrit le contrat vu du côté d'un système consommateur : comment récupérer un lot après une notification, à quoi s'attendre selon le type de lot, quand utiliser le mode asynchrone, comment est protégé l'accès, et comment sont signalées les erreurs.

Pour la référence exhaustive des paramètres des trois opérations, voir [Opérations de publication](operations.html). Pour le détail des notifications, voir [Cas d'exemple NATS](nats-cases.html).

---

## Le cycle de récupération

Le broker NATS ne transporte qu'un signal de disponibilité, jamais le contenu. Un consommateur suit donc systématiquement l'un des deux enchaînements suivants.

**Flux normal**, déclenché par une notification :

1. réception d'une notification NATS annonçant un `publicationBatchId` ;
2. appel `$publication-metadata` — le lot est-il `READY`, quel est son `scope`, quelles ressources contient-il ;
3. appel `$publication-bundle` — récupération du contenu ;
4. application locale des créations, mises à jour ou suppressions, dans l'ordre des entrées du `Bundle`.

**Flux de rattrapage**, déclenché par un doute (voir [§ Rattrapage](#rattrapage)) :

1. appel `$publication-list` à partir du dernier lot connu ;
2. pour chaque `batchId` reçu, dans l'ordre : `$publication-metadata` puis `$publication-bundle`, puis application locale.

## Pourquoi des opérations dédiées plutôt que `read`/`search`

FHIR sait nativement soumettre un `Bundle` et exposer des opérations personnalisées, y compris en asynchrone — mais il ne définit aucune sémantique standard pour « donne-moi le lot publié numéro X, avec ses métadonnées de diffusion ». Les interactions REST classiques (`read`, `search`) n'ont pas de notion de lot, de périmètre de diffusion ni de rattrapage sur un historique de publications. Plutôt que de plier ces interactions à un usage qu'elles ne couvrent pas, cet IG introduit trois opérations système dédiées, dont le contrat est fixé indépendamment de la façon dont les ressources elles-mêmes sont par ailleurs profilées.

## Typologie des lots

### Lot `GLOBAL`

Contenu identique pour tous les destinataires — nomenclatures (`CodeSystem`, `ValueSet`), référentiels partagés. `targetTenant` n'est jamais renseigné dans les métadonnées de ce type de lot ; il n'y a rien à contextualiser par tenant.

### Lot `CLIENT`

Contenu propre à un tenant : ressources métier (`Organization`, `Location`, `Practitioner`...) portant des identifiants et une visibilité spécifiques à ce tenant. `targetTenant` identifie le destinataire dans les métadonnées.

### La règle de découpage homogène

Une transaction métier interne peut affecter simultanément une nomenclature et une ressource métier. Dans ce cas, le moteur de publication ne produit jamais un lot mixte : il produit un lot `GLOBAL` et un ou plusieurs lots `CLIENT` séparés, reliés entre eux par le `sourceTransactionId` qu'ils partagent mais portant chacun leur propre `publicationBatchId`. Un consommateur qui suit une seule notification pour une transaction mixte n'a donc reçu qu'une partie du tableau.

## Synchrone et asynchrone {#synchrone-asynchrone}

Le [CapabilityStatement `mdm-publication-server`](CapabilityStatement-mdm-publication-server.html) déclare que `$publication-bundle` supporte les deux modes.

En synchrone, l'appel retourne directement le `Bundle` :

```http
POST /fhir/$publication-bundle
Content-Type: application/fhir+json
```

En asynchrone — préférable pour un lot volumineux ou dont la reconstruction prend du temps — l'appelant ajoute l'en-tête `Prefer` :

```http
POST /fhir/$publication-bundle
Prefer: respond-async
Content-Type: application/fhir+json
```

Le serveur répond immédiatement sans le contenu :

```http
HTTP/1.1 202 Accepted
Content-Location: /fhir/async-jobs/12345
```

Le consommateur interroge ensuite l'URL de suivi jusqu'à obtenir un résultat définitif :

```http
GET /fhir/async-jobs/12345
```

- `202 Accepted` : traitement toujours en cours ;
- `200 OK` avec le `Bundle` : lot prêt, contenu livré ;
- `OperationOutcome` : échec du traitement asynchrone.

## Sécurité

D'après le `CapabilityStatement`, toutes les opérations exigent un jeton **Bearer OAuth2 / OpenID Connect** valide (service `SMART-on-FHIR` déclaré dans `rest.security.service`) ; le CORS n'est pas activé côté serveur (`rest.security.cors = false`). Le `targetTenant` porté par un lot `CLIENT` est confronté aux droits associés au jeton de l'appelant : un consommateur ne doit en aucun cas pouvoir récupérer un lot `CLIENT` destiné à un tenant qui n'est pas le sien, même s'il en connaît l'identifiant.

## Rattrapage après une notification manquée {#rattrapage}

NATS notifie en temps réel mais ne fournit, dans le cadre de cet IG, aucun mécanisme de relecture des messages passés. Un consommateur qui redémarre après un incident, ou qui n'a simplement pas confiance dans la continuité de son flux de notifications, ne doit pas attendre passivement le prochain message : il interroge `$publication-list` avec le dernier `publicationBatchId` qu'il sait avoir traité comme borne basse exclusive, obtient la liste ordonnée de ce qui a été publié depuis, et rejoue chaque lot manquant. Le détail de l'opération, avec un exemple de trou détecté, est dans [Opérations de publication — `$publication-list`](operations.html#op-publication-list).

## Projection et périmètre du contenu livré

Le contenu d'un lot `CLIENT` est déjà une projection adaptée à son destinataire — la vue référencée par `publicationViewCode` (paramètre exposé) / `publicationViewId` (champ du modèle logique). Un consommateur qui n'est concerné que par une partie du contenu métier ne reçoit, dans le `Bundle`, que ce qui relève de son périmètre : il n'y a pas de filtrage supplémentaire à effectuer côté client sur le contenu d'un lot donné.

## Gestion des erreurs {#gestion-des-erreurs}

Toute erreur est signalée par une ressource `OperationOutcome`, par exemple :

```json
{
  "resourceType": "OperationOutcome",
  "issue": [
    {
      "severity": "error",
      "code": "not-found",
      "details": { "text": "Lot de publication PB-2026-000999 inconnu." },
      "diagnostics": "publicationBatchId PB-2026-000999 not found"
    }
  ]
}
```

Situations attendues pour `$publication-metadata` et `$publication-bundle` :

| Situation | HTTP | `issue.code` | Description |
|-----------|:----:|---------------|-------------|
| Lot inconnu | 404 | `not-found` | `publicationBatchId` ne correspond à aucun lot connu |
| Paramètre obligatoire manquant | 400 | `required` | Ex. `publicationBatchId` absent, ou `fromExclusiveBatchId` absent sur `$publication-list` |
| Valeur incohérente | 400 | `value` | Format d'identifiant invalide |
| Accès refusé | 403 | `forbidden` | Le jeton de l'appelant n'autorise pas l'accès au lot demandé |
| Lot non prêt | 409 | `conflict` | Le lot existe mais son statut n'est pas `READY` |
| Incohérence tenant | 422 | `business-rule` | Le `targetTenant` transmis à `$publication-bundle` ne correspond pas au lot réellement désigné |
| Incohérence vue | 422 | `business-rule` | Le `publicationViewCode` transmis ne correspond pas au lot réellement désigné |
| Erreur interne | 500 | `exception` | Erreur inattendue côté serveur |

Ce tableau documente le comportement attendu du serveur de référence ; il n'est pas porté par une contrainte formelle dans les `OperationDefinition` de cet IG, qui ne fixent pas de liste fermée de codes `issue.code`.

## Cas particulier des nomenclatures

Les nomenclatures sont en général publiées en lot `GLOBAL`. Deux voies coexistent selon le contexte : la voie de publication décrite ici (`$publication-bundle` après notification NATS), ou une exposition native comme `CodeSystem`/`ValueSet` consultable par les interactions FHIR standard si l'artefact est par ailleurs publié tel quel — ce second cas est hors périmètre de cet IG.

## Liens

- [Opérations de publication](operations.html) — référence complète des paramètres
- [Cas d'exemple NATS](nats-cases.html) — scénarios de notification
- [OperationDefinition `$publication-metadata`](OperationDefinition-publication-metadata.html)
- [OperationDefinition `$publication-bundle`](OperationDefinition-publication-bundle.html)
- [OperationDefinition `$publication-list`](OperationDefinition-publication-list.html)
- [CapabilityStatement du serveur](CapabilityStatement-mdm-publication-server.html)
