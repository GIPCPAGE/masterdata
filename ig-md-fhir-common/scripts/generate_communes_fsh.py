#!/usr/bin/env python3
"""
Script de génération de la liste complète des communes françaises
depuis les données officielles INSEE (Code Officiel Géographique).

Source: https://www.insee.fr/fr/information/6800675
Fichier: commune2024.csv (mis à jour annuellement)

Usage:
    python generate_communes_fsh.py [--format json|fsh]

Output:
    --format fsh: input/fsh/codesystems/CommunesINSEECodeSystem_full.fsh (codes uniquement)
    --format json: fsh-generated/resources/CodeSystem-communes-insee-cs.json (avec propriétés)
"""

import csv
import urllib.request
import ssl
import json
import sys
from datetime import datetime

# URLs des données officielles INSEE
INSEE_COG_URL = "https://www.insee.fr/fr/statistiques/fichier/6800675/v_commune_2024.csv"

# Configuration
OUTPUT_FILE_FSH = "../input/fsh/codesystems/CommunesINSEECodeSystem_full.fsh"
OUTPUT_FILE_JSON = "../fsh-generated/resources/CodeSystem-communes-insee-cs-full.json"
FSH_HEADER = """// =============================================
// CodeSystem: Communes françaises (INSEE) - Liste Complète
// =============================================
// FICHIER GÉNÉRÉ AUTOMATIQUEMENT
// Date de génération: {date}
// Source: INSEE - Code Officiel Géographique {year}
// Nombre de communes: {count}

CodeSystem: CommunesINSEECodeSystem
Id: communes-insee-cs
Title: "Communes françaises (Code Officiel Géographique INSEE)"
Description: "Liste complète des communes françaises selon le Code Officiel Géographique de l'INSEE. Chaque commune est identifiée par un code unique de 5 caractères (2 chiffres département + 3 chiffres commune). Mise à jour annuelle selon les modifications administratives (fusions, créations, suppressions de communes)."

* ^url = "https://www.cpage.fr/ig/masterdata/geo/CodeSystem/communes-insee-cs"
* ^version = "{year}.1.0"
* ^status = #active
* ^experimental = false
* ^date = "{date}"
* ^caseSensitive = true
* ^content = #complete
* ^publisher = "CPage"
* ^contact.telecom.system = #url
* ^contact.telecom.value = "https://www.cpage.fr"
* ^copyright = "Source: INSEE - Code Officiel Géographique (COG) {year}. Données publiques sous Licence Ouverte 2.0"
* ^purpose = "Identifier de manière unique les communes françaises dans les adresses et localisations. Permet la validation des codes commune INSEE et la normalisation des adresses."
* ^count = {count}

// Propriétés pour gestion historique et temporalité
* ^property[0].code = #effectiveDate
* ^property[=].uri = "http://hl7.org/fhir/concept-properties#effectiveDate"
* ^property[=].description = "Date d'entrée en vigueur de la commune (création ou modification)"
* ^property[=].type = #dateTime

* ^property[+].code = #deprecationDate
* ^property[=].uri = "http://hl7.org/fhir/concept-properties#deprecationDate"
* ^property[=].description = "Date de suppression ou fusion de la commune"
* ^property[=].type = #dateTime

* ^property[+].code = #status
* ^property[=].uri = "http://hl7.org/fhir/concept-properties#status"
* ^property[=].description = "Statut de la commune : active, inactive (fusionnée), deprecated (supprimée)"
* ^property[=].type = #code

* ^property[+].code = #replacedBy
* ^property[=].description = "Code INSEE de la commune de remplacement (en cas de fusion)"
* ^property[=].type = #code

* ^property[+].code = #parent
* ^property[=].uri = "http://hl7.org/fhir/concept-properties#parent"
* ^property[=].description = "Code département (2 premiers chiffres du code commune)"
* ^property[=].type = #code

* ^property[+].code = #region
* ^property[=].description = "Code région INSEE (nouvelle région 2016+)"
* ^property[=].type = #code

// =============================================
// Liste complète des communes françaises
// =============================================

"""


def download_insee_data():
    """Télécharge les données INSEE COG."""
    print("📥 Téléchargement des données INSEE COG...")
    
    # Désactiver la vérification SSL si nécessaire (problème certificat INSEE)
    ssl_context = ssl._create_unverified_context()
    
    try:
        with urllib.request.urlopen(INSEE_COG_URL, context=ssl_context) as response:
            content = response.read().decode('utf-8')
            print(f"✅ Téléchargement réussi ({len(content)} caractères)")
            return content
    except Exception as e:
        print(f"❌ Erreur de téléchargement: {e}")
        print("💡 Télécharger manuellement depuis: https://www.insee.fr/fr/information/6800675")
        raise


def parse_communes_insee(csv_content):
    """Parse le fichier CSV INSEE et retourne la liste des communes."""
    print("📊 Parsing des données INSEE...")
    
    communes = []
    csv_reader = csv.DictReader(csv_content.splitlines(), delimiter=',')
    
    for row in csv_reader:
        # Format INSEE COG:
        # COM: Code commune (5 caractères)
        # LIBELLE: Nom de la commune
        # DEP: Département
        # REG: Région
        # TYPECOM: Type (COM=commune active, COMD=commune déléguée, ARM=arrondissement)
        # DATE_CREAT: Date de création (AAAA-MM-JJ)
        # DATE_EFFET: Date de prise d'effet pour fusion/modification
        
        code_commune = row.get('COM', '').strip()
        nom_commune = row.get('LIBELLE', '').strip()
        dept = row.get('DEP', '').strip()
        region = row.get('REG', '').strip()
        type_com = row.get('TYPECOM', 'COM').strip()
        date_creat = row.get('DATE_CREAT', '').strip()
        
        # Filtrer les lignes valides (communes actives)
        if code_commune and len(code_commune) == 5 and nom_commune:
            # Échapper les guillemets dans le nom
            nom_commune_escaped = nom_commune.replace('"', '\\"')
            
            # Déterminer le statut
            status = 'active' if type_com == 'COM' else 'inactive'
            
            communes.append({
                'code': code_commune,
                'nom': nom_commune_escaped,
                'dept': dept,
                'region': region,
                'status': status,
                'date_creat': date_creat
            })
    
    print(f"✅ {len(communes)} communes parsées")
    return sorted(communes, key=lambda x: x['code'])


def generate_fsh_file(communes, output_file):
    """Génère le fichier FSH complet (codes uniquement, sans propriétés)."""
    print(f"📝 Génération du fichier FSH: {output_file}")
    
    year = datetime.now().year
    date = datetime.now().strftime("%Y-%m-%d")
    count = len(communes)
    
    with open(output_file, 'w', encoding='utf-8') as f:
        # Header (sans propriétés, juste codes)
        header = FSH_HEADER.format(
            date=date,
            year=year,
            count=count
        )
        f.write(header)
        
        # Communes (codes uniquement)
        for commune in communes:
            code = commune['code']
            nom = commune['nom']
            f.write(f'* #{code} "{nom}"\n')
    
    print(f"✅ Fichier FSH généré avec {count} communes (codes uniquement)")
    print(f"📄 Fichier: {output_file}")


def generate_json_file(communes, output_file):
    """Génère le fichier JSON complet avec toutes les propriétés."""
    print(f"📝 Génération du fichier JSON: {output_file}")
    
    year = datetime.now().year
    date = datetime.now().strftime("%Y-%m-%d")
    count = len(communes)
    
    # Structure de base du CodeSystem JSON
    codesystem = {
        "resourceType": "CodeSystem",
        "id": "communes-insee-cs",
        "url": "https://www.cpage.fr/ig/masterdata/geo/CodeSystem/communes-insee-cs",
        "version": f"{year}.1.0",
        "name": "CommunesINSEECodeSystem",
        "title": "Communes françaises (Code Officiel Géographique INSEE)",
        "status": "active",
        "experimental": False,
        "date": date,
        "publisher": "CPage",
        "contact": [{
            "telecom": [{
                "system": "url",
                "value": "https://www.cpage.fr"
            }]
        }],
        "description": "Liste complète des communes françaises selon le Code Officiel Géographique de l'INSEE.",
        "copyright": f"Source: INSEE - Code Officiel Géographique (COG) {year}. Données publiques sous Licence Ouverte 2.0",
        "caseSensitive": True,
        "content": "complete",
        "count": count,
        "property": [
            {
                "code": "status",
                "uri": "http://hl7.org/fhir/concept-properties#status",
                "description": "Statut de la commune : active, inactive (fusionnée), deprecated (supprimée)",
                "type": "code"
            },
            {
                "code": "effectiveDate",
                "uri": "http://hl7.org/fhir/concept-properties#effectiveDate",
                "description": "Date d'entrée en vigueur de la commune",
                "type": "dateTime"
            },
            {
                "code": "deprecationDate",
                "uri": "http://hl7.org/fhir/concept-properties#deprecationDate",
                "description": "Date de suppression ou fusion de la commune",
                "type": "dateTime"
            },
            {
                "code": "replacedBy",
                "description": "Code INSEE de la commune de remplacement",
                "type": "code"
            },
            {
                "code": "parent",
                "uri": "http://hl7.org/fhir/concept-properties#parent",
                "description": "Code département",
                "type": "code"
            },
            {
                "code": "region",
                "description": "Code région INSEE 2016+",
                "type": "code"
            }
        ],
        "concept": []
    }
    
    # Ajouter les concepts avec propriétés
    for commune in communes:
        concept = {
            "code": commune['code'],
            "display": commune['nom'],
            "property": []
        }
        
        # Ajouter les propriétés si disponibles
        if commune.get('status'):
            concept["property"].append({
                "code": "status",
                "valueCode": commune['status']
            })
        
        if commune.get('dept'):
            concept["property"].append({
                "code": "parent",
                "valueCode": commune['dept']
            })
        
        if commune.get('region'):
            concept["property"].append({
                "code": "region",
                "valueCode": commune['region']
            })
        
        if commune.get('date_creat'):
            concept["property"].append({
                "code": "effectiveDate",
                "valueDateTime": commune['date_creat']
            })
        
        codesystem["concept"].append(concept)
    
    # Écrire le JSON
    with open(output_file, 'w', encoding='utf-8') as f:
        json.dump(codesystem, f, ensure_ascii=False, indent=2)
    
    print(f"✅ Fichier JSON généré avec {count} communes et propriétés")
    print(f"📄 Fichier: {output_file}")


def main():
    """Point d'entrée principal."""
    print("=" * 60)
    print("🇫🇷 Générateur de CodeSystem Communes INSEE pour FHIR")
    print("=" * 60)
    
    # Parse arguments
    output_format = 'json'  # Par défaut JSON pour les propriétés
    if len(sys.argv) > 1:
        if sys.argv[1] == '--format':
            output_format = sys.argv[2] if len(sys.argv) > 2 else 'json'
    
    try:
        # Étape 1: Télécharger les données
        csv_content = download_insee_data()
        
        # Étape 2: Parser les communes
        communes = parse_communes_insee(csv_content)
        
        # Étape 3: Générer le fichier (FSH ou JSON)
        if output_format == 'json':
            generate_json_file(communes, OUTPUT_FILE_JSON)
        else:
            generate_fsh_file(communes, OUTPUT_FILE_FSH)
        
        print("\n" + "=" * 60)
        print("✅ Génération terminée avec succès !")
        print("=" * 60)
        
        if output_format == 'json':
            print(f"\nProchaines étapes:")
            print(f"1. Vérifier le fichier: {OUTPUT_FILE_JSON}")
            print(f"2. Copier vers fsh-generated/resources/ si nécessaire")
            print(f"3. Recompiler l'IG")
            print(f"\nNote: Le fichier JSON contient toutes les propriétés (status, parent, region, etc.)")
        else:
            print(f"\nProchaines étapes:")
            print(f"1. Vérifier le fichier: {OUTPUT_FILE_FSH}")
            print(f"2. Compiler avec SUSHI: npx sushi .")
            print(f"3. Supprimer l'ancien fichier CommunesINSEECodeSystem.fsh")
            print(f"4. Renommer _full.fsh en .fsh")
            print(f"\nNote: Format FSH ne contient que les codes (pas de propriétés)")
        
    except Exception as e:
        print(f"\n❌ Erreur: {e}")
        print("\n💡 Solutions :")
        print("   - Vérifier la connexion Internet")
        print("   - Télécharger manuellement le fichier CSV depuis l'INSEE")
        print("   - Vérifier l'URL du fichier INSEE (peut changer chaque année)")
        return 1
    
    return 0


if __name__ == "__main__":
    exit(main())
