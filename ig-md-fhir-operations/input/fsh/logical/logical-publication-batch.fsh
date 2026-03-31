Logical: PublicationBatch
Id: PublicationBatch
Title: "Modele logique - Lot de publication"
Description: "Represente un lot de publication MDM : unite de diffusion homogene produite a partir d'une ou plusieurs transactions metier internes. Un lot est soit GLOBAL (nomenclatures partagees) soit CLIENT (ressources metier contextualisees par tenant). Le lot devient consultable via les operations FHIR $publication-metadata et $publication-bundle des lors qu'il passe au statut READY."

* publicationBatchId 1..1 string "Identifiant technique unique du lot" "Identifiant genere par la plateforme MDM. Utilise dans tous les appels aux operations FHIR pour designer ce lot specifique."
* scope 1..1 code "Perimetre de diffusion du lot" "GLOBAL pour les contenus partages (nomenclatures, referentiels), CLIENT pour les contenus tenant-specifiques (ressources metier)."
* scope from https://www.cpage.fr/ig/masterdata/operations/ValueSet/publication-scope (required)
* targetTenant 0..1 string "Tenant destinataire" "Identifiant du tenant cible lorsque le lot est de scope CLIENT. Non renseigne pour les lots GLOBAL."
* publicationViewId 0..1 string "Identifiant de la vue de publication" "Identifie la projection appliquee lors de la fabrication des ressources du lot."
* sourceTransactionId 0..1 string "Identifiant de la transaction metier source" "Reference la transaction metier interne qui a declenche la production de ce lot."
* sourceVersionNum 0..1 integer "Numero de version source" "Version de l'objet metier au moment de la creation du lot."
* bundleType 1..1 code "Type de Bundle retourne" "Definit si le contenu doit etre applique comme une unite coherente (transaction) ou de maniere independante (batch)."
* bundleType from https://www.cpage.fr/ig/masterdata/operations/ValueSet/bundle-type-publication (required)
* status 1..1 code "Statut du cycle de vie du lot" "Indique si le lot est en cours de fabrication (PROCESSING), pret a la consultation (READY), en echec (FAILED) ou expire (EXPIRED)."
* status from https://www.cpage.fr/ig/masterdata/operations/ValueSet/publication-batch-status (required)
* createdAt 0..1 dateTime "Date et heure de creation du lot"
