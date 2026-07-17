# ig-md-fhir-operations

IG FHIR (FSH/SUSHI) qui définit le contrat de publication/récupération du CPage MasterData : comment un système consommateur, après avoir été notifié de la disponibilité d'un lot sur NATS, retrouve son contenu via trois opérations FHIR système — sans qu'aucune ressource métier ne soit profilée ici.

Aucun profil métier n'est ajouté par cet IG : il dépend de `hl7.fhir.fr.core` et de `ig.mdm.fhir.common` pour la modélisation, et n'ajoute que des opérations, deux modèles logiques de transport et les terminologies qui les encadrent.

Publié dans le cadre de : https://gipcpage.github.io/masterdata/

## Contenu

```text
input/fsh/
├── logical/         PublicationBatch, PublicationBatchItem
├── operations/      $publication-metadata, $publication-bundle, $publication-list
├── terminology/     publication-scope, publication-batch-status, bundle-type-publication
├── conformance/     CapabilityStatement mdm-publication-server
├── examples/        Exemples Parameters/Bundle pour les 3 opérations
└── aliases.fsh

input/pages/
├── index.md                    Architecture pub/sub, GLOBAL/CLIENT, traçabilité
├── operations.md               Référence des 3 opérations + modèles logiques + traçabilité détaillée
├── api-publication-batch.md    Contrat consommateur : typologie, sync/async, sécurité, erreurs
├── nats-cases.md               Convention de sujets NATS et scénarios de notification
└── downloads.md                Artefacts téléchargeables
```

## Prérequis

- Node.js (pour SUSHI, via `npx`)
- Java (pour l'IG Publisher, `input-cache/publisher.jar`)

## Construire l'IG

Compilation FSH seule (rapide, valide la syntaxe et les références) :

```bash
npx --yes fsh-sushi .
```

ou :

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

La dépendance `ig.mdm.fhir.common: dev` se résout depuis le cache FHIR local (`~/.fhir` ou équivalent) : sans ce cache renseigné, le build signale une erreur de résolution de dépendance qui n'affecte pas la validité des artefacts propres à cet IG.

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
