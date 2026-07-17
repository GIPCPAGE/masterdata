# ig-md-fhir-operations

IG FHIR (FSH/SUSHI) décrivant le contrat de publication/récupération du CPage MasterData : comment un système consommateur retrouve, via trois opérations FHIR, le contenu des lots de publication produits par le MasterData après une notification de disponibilité sur NATS.

Cet IG ne modélise pas de ressources métier ; il dépend de `hl7.fhir.fr.core` et de `ig.mdm.fhir.common` pour cela. Il ajoute uniquement des opérations, deux modèles logiques de transport et les terminologies associées à la publication.

Publié dans le cadre de : https://gipcpage.github.io/masterdata/

## Contenu

```text
input/fsh/
├── logical/         PublicationBatch, PublicationBatchItem
├── operations/      $publication-metadata, $publication-bundle, $publication-list
├── terminology/     CodeSystems/ValueSets : publication-scope, publication-batch-status,
│                    bundle-type-publication
├── conformance/     CapabilityStatement mdm-publication-server
├── examples/        Exemples Parameters/Bundle pour les 3 opérations
└── aliases.fsh

input/pages/
├── index.md                    Vue d'ensemble de l'architecture pub/sub
├── operations.md                Référence des 3 opérations (paramètres, exemples, traçabilité)
├── api-publication-batch.md    Contrat API côté consommateur (typologie, sync/async, erreurs)
├── nats-cases.md                Convention de nommage des sujets NATS, scénarios de notification
└── downloads.md                 Artefacts téléchargeables
```

## Prérequis

- Node.js (pour SUSHI, via `npx`)
- Java (pour l'IG Publisher, `input-cache/publisher.jar`)

## Construire l'IG

Compilation FSH seule (rapide, valide la syntaxe et les références) :

```bash
npx --yes fsh-sushi .
```

ou, de manière équivalente :

```bash
npm run build
```

Génération complète du site HTML (télécharge l'IG Publisher au besoin) :

```bash
_updatePublisher.bat   # Windows — télécharge/actualise input-cache/publisher.jar
_genonce.bat           # Windows — build complet (SUSHI + IG Publisher), sortie dans output/
```

Équivalents Linux/Mac : `_updatePublisher.sh`, `_genonce.sh`. `_gencontinuous.*` relance le build à chaque modification (mode watch).

Le résultat HTML publié est généré dans `output/index.html`.

## Dépendances

| Package | Version |
|---------|---------|
| `hl7.fhir.fr.core` | 2.2.0 |
| `ig.mdm.fhir.common` | dev |

La dépendance `ig.mdm.fhir.common: dev` se résout depuis le cache local FHIR (`~/.fhir` ou équivalent) lorsqu'elle n'est pas publiée sur un registre : un build sans ce cache renseigné signalera une erreur de résolution de dépendance, qui n'affecte pas la validité des artefacts propres à cet IG.

## Ne pas modifier sans raison

- `input-cache/`, `output/`, `temp/`, `fsh-generated/` : générés par le build, ne pas committer de modifications manuelles.
- `template/` : gabarit IG Publisher partagé, à ne modifier qu'en connaissance de cause.

## Documentation publiée

Une fois l'IG construit, les pages narratives sont accessibles depuis `output/index.html` :

- **Accueil** — architecture pub/sub de bout en bout
- **Opérations de publication** — référence technique des 3 opérations
- **API FHIR de récupération des lots publiés** — contrat consommateur
- **Cas d'exemple NATS** — conventions et scénarios de notification
- **Ressources de conformité** — profils, terminologies, `CapabilityStatement`
- **Téléchargements** — packages et définitions
