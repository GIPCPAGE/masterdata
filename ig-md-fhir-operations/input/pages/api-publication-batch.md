# API FHIR de récupération des lots publiés

## Objectif

Cette page décrit le contrat d'API vu du point de vue d'un système consommateur : comment récupérer un lot publié par le MasterData après avoir reçu une notification de disponibilité sur NATS, quelle typologie de lot s'attendre à recevoir, quand utiliser le mode asynchrone, et comment interpréter les erreurs retournées par le serveur.

Pour la référence paramètre par paramètre des trois opérations, voir [Opérations de publication](operations.html). Pour le détail des notifications NATS, voir [Cas d'exemple NATS](nats-cases.html).

---

## 1. Principe général

Le broker NATS ne transporte pas le contenu publié : il transporte une notification de disponibilité. Le consommateur suit ensuite le cycle suivant :

1. il reçoit une notification NATS (ou détecte un manque via `$publication-list`, voir [§6](#rattrapage)) ;
2. il récupère les métadonnées du lot via `$publication-metadata` ;
3. il récupère le contenu du lot via `$publication-bundle` ;
4. il applique localement les créations, mises à jour ou suppressions portées par le `Bundle`, dans l'ordre des entrées.

## 2. Pourquoi une API FHIR dédiée

Le standard FHIR permet de soumettre un `Bundle` (`transaction`/`batch`) et d'exposer des opérations personnalisées via le mécanisme `$operation`, y compris en mode asynchrone. Il ne définit en revanche pas nativement de sémantique du type « donne-moi le lot publié numéro X avec ses métadonnées de diffusion ». Cet IG comble ce vide avec trois opérations système dédiées plutôt que de détourner les interactions REST standard (`read`/`search`), qui ne portent pas la notion de lot, de scope de diffusion ni de rattrapage.

## 3. Positionnement dans l'architecture

```text
Master Data
  │  Transaction métier validée
  ▼
Moteur de publication
  │  Lot(s) produit(s)
  ├──► Notification NATS (disponibilité)
  └──► API FHIR (récupération)
          │
          ▼
Consommateur
  1. Reçoit notification NATS (ou détecte un trou via $publication-list)
  2. Appelle $publication-metadata
  3. Appelle $publication-bundle
  4. Applique le lot localement
```

## 4. Typologie des lots publiés

### 4.1 Lot `GLOBAL`

Contenu identique pour tous les destinataires : nomenclatures (`CodeSystem`, `ValueSet`), référentiels partagés. Pas de tenant cible (`targetTenant` absent), pas d'identifiant local à injecter.

### 4.2 Lot `CLIENT`

Contenu contextualisé pour un tenant précis (`Organization`, `Location`, `Practitioner`, etc.), avec des identifiants et une visibilité propres à ce tenant. `targetTenant` identifie le destinataire.

### 4.3 Règle de découpage

Une transaction métier interne peut impacter plusieurs objets simultanément, mais chaque lot publié doit rester homogène en périmètre de diffusion : un lot `GLOBAL` et un lot `CLIENT` ne sont jamais fusionnés, même s'ils proviennent de la même transaction source. Une transaction mixte (nomenclature + ressource métier) produit donc systématiquement plusieurs lots.

## 5. Synchrone et asynchrone {#synchrone-asynchrone}

D'après le [`CapabilityStatement mdm-publication-server`](CapabilityStatement-mdm-publication-server.html), `$publication-bundle` supporte les deux modes de réponse.

**Synchrone** — pour un lot de volumétrie raisonnable, l'opération retourne directement le `Bundle` :

```http
POST /fhir/$publication-bundle
Content-Type: application/fhir+json
```

**Asynchrone** — recommandé pour un lot volumineux ou dont la reconstruction prend du temps :

```http
POST /fhir/$publication-bundle
Prefer: respond-async
Content-Type: application/fhir+json
```

Réponse immédiate :

```http
HTTP/1.1 202 Accepted
Content-Location: /fhir/async-jobs/12345
```

Le consommateur interroge ensuite l'URL de suivi jusqu'à obtenir le résultat :

```http
GET /fhir/async-jobs/12345
```

- `202 Accepted` tant que le traitement est en cours ;
- `200 OK` avec le `Bundle` lorsque le lot est prêt ;
- `OperationOutcome` en cas d'erreur.

## 6. Rattrapage après une notification manquée {#rattrapage}

Un consommateur qui redémarre après une indisponibilité, ou qui soupçonne une notification NATS perdue, ne doit pas se fier uniquement au flux temps réel. Il peut interroger `$publication-list` avec le dernier `publicationBatchId` qu'il sait avoir appliqué comme borne basse exclusive, pour obtenir la liste ordonnée de tout ce qui a été publié depuis. Le détail de l'opération et un exemple de trou détecté figurent dans [Opérations de publication — `$publication-list`](operations.html#op-publication-list).

## 7. Sécurité

D'après le `CapabilityStatement`, l'accès à toutes les opérations exige un jeton **Bearer OAuth2 / OpenID Connect valide** (service `SMART-on-FHIR` déclaré dans `rest.security.service`). Le CORS n'est pas activé côté serveur (`rest.security.cors = false`). Le champ `targetTenant` d'un lot `CLIENT` est contrôlé au regard des droits portés par le jeton de l'appelant : un consommateur ne doit jamais pouvoir récupérer le contenu d'un lot `CLIENT` destiné à un autre tenant que le sien.

## 8. Abonnement partiel et projections

Le lot retourné est une projection de publication adaptée à son destinataire (la vue de publication référencée par `publicationViewCode`/`publicationViewId`). Si un consommateur n'est concerné que par une partie du contenu métier, il ne reçoit que le périmètre qui lui est destiné ; les ressources hors périmètre ne sont pas incluses dans le `Bundle`.

## 9. Gestion des erreurs {#gestion-des-erreurs}

En cas d'erreur, le serveur retourne une ressource FHIR `OperationOutcome`, par exemple :

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

Codes d'erreur fonctionnels attendus par les opérations `$publication-metadata` et `$publication-bundle` :

| Situation | HTTP | `issue.code` | Description |
|-----------|:----:|---------------|-------------|
| Lot inconnu | 404 | `not-found` | `publicationBatchId` ne correspond à aucun lot connu |
| Paramètres invalides | 400 | `required` / `value` | Paramètre obligatoire manquant ou valeur incohérente (ex. `fromExclusiveBatchId` absent sur `$publication-list`) |
| Accès interdit | 403 | `forbidden` | Le jeton de l'appelant n'autorise pas l'accès à ce lot |
| Lot non prêt | 409 | `conflict` | Le lot existe mais son statut n'est pas `READY` (ex. `PROCESSING`, `FAILED`) |
| Incohérence tenant | 422 | `business-rule` | Le `targetTenant` transmis ne correspond pas au lot demandé |
| Incohérence vue | 422 | `business-rule` | Le `publicationViewCode` transmis ne correspond pas au lot demandé |
| Erreur interne | 500 | `exception` | Erreur inattendue côté serveur |

Ce tableau n'est pas porté par une contrainte FSH formelle (les `OperationDefinition` de cet IG ne déclarent pas de liste fermée de codes d'erreur) ; il documente le comportement attendu du serveur de référence, cohérent avec les usages `issue.code` standards de FHIR R4.

## 10. Cas des nomenclatures

Pour les nomenclatures, le lot est généralement de scope `GLOBAL`. Deux voies de récupération coexistent selon le contexte : via `$publication-bundle` après notification NATS (flux de publication), ou via l'API FHIR standard si l'artefact est par ailleurs exposé nativement comme `CodeSystem`/`ValueSet` consultable (hors périmètre de cet IG).

## 11. Liens

- [Opérations de publication](operations.html) — référence complète des paramètres
- [Cas d'exemple NATS](nats-cases.html) — scénarios de notification
- [OperationDefinition `$publication-metadata`](OperationDefinition-publication-metadata.html)
- [OperationDefinition `$publication-bundle`](OperationDefinition-publication-bundle.html)
- [OperationDefinition `$publication-list`](OperationDefinition-publication-list.html)
- [CapabilityStatement du serveur](CapabilityStatement-mdm-publication-server.html)
