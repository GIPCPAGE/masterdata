# Guide d'Implementation FHIR - Operations de publication MDM

**Version**: 0.1.0 | **Date**: 30 mars 2026 | **Statut**: Draft

## Bienvenue

Ce guide d'implementation FHIR decrit les operations exposees pour consulter les publications produites par le MDM.

Il s'appuie sur le socle commun **ig-md-fhir-common** et definit un contrat d'echange base sur :

- les operations FHIR systeme (`$operation`) ;
- la ressource `Parameters` pour les entrees/sorties descriptives ;
- la ressource `Bundle` pour la restitution du contenu publie.

## Descriptif du traitement

Le cycle de publication du Master Data produit des **lots de publication** à destination des consommateurs.

Lorsqu’un lot est prêt, le serveur publie sur NATS une **notification de disponibilité**.
Cette notification n’embarque pas la transaction meétier brute ni l’ensemble dtailleé du contenu. Elle annonce uniquement qu’un lot publié est disponible et peut être récupéré via l’API FHIR.

Le consommateur suit alors le cycle suivant :
- il reçoit une notification NATS ;
- il récupère les métadonnées du lot ;
- il récupère le contenu du lot sous forme de Bundle FHIR ;

Le détail des scénarios est documenté ici :

- [Cas d'exemple NATS](nats-cases.html)

## Périmètre de ce guide

Ce guide couvre exclusivement les operations :

- [`$publication-metadata`](OperationDefinition-publication-metadata.html)
- [`$publication-bundle`](OperationDefinition-publication-bundle.html)

Ce guide ne couvre pas :

- les traitements internes de fabrication des lots ;
- les regles metier internes de versionnement ;
- l'orchestration technique hors interface FHIR.
- la logique interne de consommation des messages par les applications clientes.

## Objectifs

Ce guide permet de :

- récupérer les métadonnées d'un lot de publication ;
- récupérer le contenu publié d'un lot au format FHIR ;
- distinguer les lots globaux et les lots client-specifiques.
- découpler la notification broker de la récupération détaillée des données.

## Principe de découpage des publications

Une transaction métier interne peut impacter plusieurs objets simultanément (ex. nomenclature + ressource métier).
La diffusion ne reprend pas necessairement la transaction interne telle quelle.

Règles :

- une transaction interne peut produire plusieurs lots de publication ;
- chaque lot publié doit rester homogène en termes de périmètre de diffusion ;
- les lots globaux et les lots client-spécifiques doivent être séparés.
- un lot GLOBAL ne doit pas contenir de contenu contextualisé par client ;
- un lot CLIENT ne doit exposer que le contenu autorisé pour le client concerné.

## Opérations exposées

### `$publication-metadata`

Récupère les métadonnées d'un lot publié.

Endpoint :

- `POST /fhir/$publication-metadata`
- `Content-Type: application/fhir+json`

### `$publication-bundle`

Récupère le contenu publié d'un lot sous forme de `Bundle`.

Endpoint :

- `POST /fhir/$publication-bundle`
- `Content-Type: application/fhir+json`

Mode de réponse :

- synchrone pour les lots de faible volumétrie ;
- asynchrone via `Prefer: respond-async`, `202 Accepted` et `Content-Location` pour les lots volumineux.

## Type de bundle retourne

- `Bundle.type = transaction` : le lot doit être interprèté comme une unité cohérente.
- `Bundle.type = batch` : les entrées peuvent être traitées indépendamment.

Le type est déterminé par la vue de publication et le besoin de cohérence du lot.

## Navigation

- [Operations de publication](operations.html)
- [API FHIR de recuperation des lots publies](api-publication-batch.html)
- [Cas d'exemple NATS](nats-cases.html)
- [Artefacts](artifacts.html)
- [Telechargements](downloads.html)

## Conformite

- Standard FHIR : R4 (`4.0.1`)
- Dependance nationale : `hl7.fhir.fr.core#2.1.0`
- Socle commun : `ig-md-fhir-common`

## Contact

**Equipe Referentiels**
contact@cpage.fr
https://www.cpage.fr
