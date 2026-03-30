# Guide d'Implementation FHIR - Operations de publication MDM

**Version**: 0.1.0 | **Date**: 30 mars 2026 | **Statut**: Draft

## Bienvenue

Ce guide d'implementation FHIR decrit les operations exposees pour consulter les publications produites par le MDM.

Il s'appuie sur le socle commun **ig-md-fhir-common** et definit un contrat d'echange base sur :

- les operations FHIR systeme (`$operation`) ;
- la ressource `Parameters` pour les entrees/sorties descriptives ;
- la ressource `Bundle` pour la restitution du contenu publie.

## Descriptif du traitement

Le cycle de publication est alimente par des evenements NATS.
Les evenements recus sont transformes en lots de publication homogenes, puis exposes via les operations FHIR de cette IG.
La notification broker annonce la disponibilite d'un batch, et non la transaction metier brute.

Le detail des scenarios est documente ici :

- [Cas d'exemple NATS](nats-cases.html)

## Perimetre de ce guide

Ce guide couvre exclusivement les operations :

- [`$publication-metadata`](OperationDefinition-publication-metadata.html)
- [`$publication-bundle`](OperationDefinition-publication-bundle.html)

Ce guide ne couvre pas :

- les traitements internes de fabrication des lots ;
- les regles metier internes de versionnement ;
- l'orchestration technique hors interface FHIR.

## Objectifs

Ce guide permet de :

- recuperer les metadonnees d'un lot de publication ;
- recuperer le contenu publie d'un lot au format FHIR ;
- distinguer les lots globaux et les lots client-specifiques.

## Principe de decoupage des publications

Une transaction metier interne peut impacter plusieurs objets simultanement (ex. nomenclature + ressource metier).
La diffusion ne reprend pas necessairement la transaction interne telle quelle.

Regles :

- une transaction interne peut produire plusieurs lots de publication ;
- chaque lot publie doit rester homogene en termes de perimetre de diffusion ;
- les lots globaux et les lots client-specifiques doivent etre separes.

## Operations exposees

### `$publication-metadata`

Recupere les metadonnees d'un lot publie.

Endpoint :

- `POST /fhir/$publication-metadata`
- `Content-Type: application/fhir+json`

### `$publication-bundle`

Recupere le contenu publie d'un lot sous forme de `Bundle`.

Endpoint :

- `POST /fhir/$publication-bundle`
- `Content-Type: application/fhir+json`

Mode de reponse :

- synchrone pour les lots de faible volumetrie ;
- asynchrone via `Prefer: respond-async`, `202 Accepted` et `Content-Location` pour les lots volumineux.

## Type de bundle retourne

- `Bundle.type = transaction` : le lot doit etre applique comme une unite coherente.
- `Bundle.type = batch` : les entrees peuvent etre traitees independamment.

Le type est determine par la vue de publication et le besoin de coherence du lot.

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
