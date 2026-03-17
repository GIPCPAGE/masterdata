# Scripts de Génération des Données Géographiques

Ce dossier contient les scripts Python pour générer automatiquement les **listes complètes** des communes et codes postaux français depuis les sources officielles.

## Scripts Disponibles

### 1. `generate_communes_fsh.py`

Génère la liste complète des **~36 000 communes françaises** depuis les données INSEE (Code Officiel Géographique).

**Source officielle** : [INSEE - Code Officiel Géographique](https://www.insee.fr/fr/information/6800675)

**Usage** :
```bash
cd scripts
python generate_communes_fsh.py
```

**Output** : `../input/fsh/codesystems/CommunesINSEECodeSystem_full.fsh`

**Colonnes INSEE utilisées** :
- `COM` : Code commune (5 caractères : 2 dept + 3 commune)
- `LIBELLE` : Nom officiel de la commune

---

### 2. `generate_codes_postaux_fsh.py`

Génère la liste complète des **codes postaux français** depuis la base La Poste HEXASIMAL.

**Source officielle** : [La Poste - Base HEXASIMAL](https://datanova.laposte.fr/datasets/laposte-hexasmal)

**Usage avec téléchargement automatique** :
```bash
cd scripts
python generate_codes_postaux_fsh.py
```

**Usage avec fichier CSV local** :
```bash
python generate_codes_postaux_fsh.py ../data/laposte_hexasimal.csv
```

**Output** : `../input/fsh/codesystems/CodesPostauxCodeSystem_full.fsh`

---

## Prérequis

**Python 3.7+** avec modules standards :
- `csv`
- `urllib.request`
- `ssl`

Aucune dépendance externe nécessaire.

---

## Procédure Complète

### Étape 1 : Générer les fichiers FSH complets

```bash
cd C:\Travail\MDM\MDM\mdm-igs\ig-md-fhir-common\scripts

# Communes INSEE
python generate_communes_fsh.py

# Codes Postaux La Poste
python generate_codes_postaux_fsh.py
```

### Étape 2 : Remplacer les fichiers échantillons

```bash
cd ..

# Supprimer les fichiers échantillons
Remove-Item input\fsh\codesystems\CommunesINSEECodeSystem.fsh
Remove-Item input\fsh\codesystems\CodesPostauxCodeSystem.fsh

# Renommer les fichiers complets
Rename-Item input\fsh\codesystems\CommunesINSEECodeSystem_full.fsh CommunesINSEECodeSystem.fsh
Rename-Item input\fsh\codesystems\CodesPostauxCodeSystem_full.fsh CodesPostauxCodeSystem.fsh
```

### Étape 3 : Compiler avec SUSHI

```bash
npx sushi .
```

⚠️ **Attention** : La compilation peut prendre **plusieurs minutes** avec 36 000+ codes.

---

## Format des Données

### Communes INSEE (COG)

**Fichier CSV INSEE** : `v_commune_2024.csv`

Colonnes principales :
- `COM` : Code commune (ex: "75056" = Paris)
- `LIBELLE` : Nom (ex: "Paris")
- `DEP` : Département (ex: "75")
- `REG` : Région (ex: "11" = Île-de-France)

**CodeSystem FHIR généré** :
```fsh
* #75056 "Paris"
* #13055 "Marseille"
* #69123 "Lyon"
...
```

---

### Codes Postaux La Poste (HEXASIMAL)

**Fichier CSV La Poste** : `laposte_hexasimal.csv`

Colonnes principales :
- `Code_postal` : Code postal (ex: "75001")
- `Nom_commune` : Commune (ex: "PARIS")
- `Ligne_5` : Complément (ex: "PARIS 01")

**CodeSystem FHIR généré** :
```fsh
* #75001 "Paris 1er arrondissement"
* #75002 "Paris 2e arrondissement"
* #13001 "Marseille 1er arrondissement"
...
```

---

## Mise à Jour Annuelle

Les données INSEE et La Poste sont **mises à jour chaque année** (janvier).

**Fréquence recommandée** : Régénérer les fichiers FSH **une fois par an** en janvier.

**Procédure** :
1. Vérifier la disponibilité du nouveau millésime INSEE (ex: `commune2025.csv`)
2. Mettre à jour l'URL dans `generate_communes_fsh.py` si nécessaire
3. Relancer les scripts
4. Recompiler l'IG
5. Publier la nouvelle version

---

## Taille des Fichiers

**Estimations** :

| Fichier | Nombre de codes | Taille FSH |
|---------|----------------|------------|
| Communes INSEE | ~36 000 | ~2-3 MB |
| Codes Postaux | ~6 000 | ~300-500 KB |
| **Total** | **~42 000** | **~3 MB** |

⚠️ **Impact** :
- Compilation SUSHI : 3-10 minutes
- ImplementationGuide final : +3 MB
- Temps de chargement FHIR server : +5-10 secondes

---

## Alternative : Référence Externe

Si la taille pose problème, envisager **CodeSystem externe** :

```fsh
CodeSystem: CommunesINSEECodeSystem
* ^content = #not-present
* ^url = "https://api.insee.fr/codes-communes"
```

Avantages :
- IG léger
- Données toujours à jour

Inconvénients :
- Nécessite API externe
- Dépendance réseau

---

## Support

Pour toute question sur les scripts :
- Vérifier les URLs sources (peuvent changer)
- Consulter la documentation officielle INSEE/La Poste
- Adapter les colonnes CSV si format modifié

---

## Licence

Scripts sous licence MIT.  
Données INSEE : [Licence Ouverte 2.0](https://www.etalab.gouv.fr/licence-ouverte-open-licence/)  
Données La Poste : [Licence Ouverte 2.0](https://www.etalab.gouv.fr/licence-ouverte-open-licence/)
