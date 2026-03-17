#!/usr/bin/env python3
"""
Script de génération de la liste complète des communes françaises
depuis les données officielles INSEE (Code Officiel Géographique).

Source: https://www.insee.fr/fr/information/6800675
Fichier: commune2024.csv (mis à jour annuellement)

Usage:
    python generate_communes_fsh.py

Output:
    input/fsh/codesystems/CommunesINSEECodeSystem_full.fsh
"""

import csv
import urllib.request
import ssl
from datetime import datetime

# URLs des données officielles INSEE
INSEE_COG_URL = "https://www.insee.fr/fr/statistiques/fichier/6800675/v_commune_2024.csv"

# Configuration
OUTPUT_FILE = "../input/fsh/codesystems/CommunesINSEECodeSystem_full.fsh"
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
        
        code_commune = row.get('COM', '').strip()
        nom_commune = row.get('LIBELLE', '').strip()
        
        # Filtrer les lignes valides
        if code_commune and len(code_commune) == 5 and nom_commune:
            # Échapper les guillemets dans le nom
            nom_commune_escaped = nom_commune.replace('"', '\\"')
            communes.append((code_commune, nom_commune_escaped))
    
    print(f"✅ {len(communes)} communes parsées")
    return sorted(communes, key=lambda x: x[0])


def generate_fsh_file(communes, output_file):
    """Génère le fichier FSH complet."""
    print(f"📝 Génération du fichier FSH: {output_file}")
    
    year = datetime.now().year
    date = datetime.now().strftime("%Y-%m-%d")
    count = len(communes)
    
    with open(output_file, 'w', encoding='utf-8') as f:
        # Header
        header = FSH_HEADER.format(
            date=date,
            year=year,
            count=count
        )
        f.write(header)
        
        # Communes
        for code, nom in communes:
            f.write(f'* #{code} "{nom}"\n')
    
    print(f"✅ Fichier généré avec {count} communes")
    print(f"📄 Fichier: {output_file}")


def main():
    """Point d'entrée principal."""
    print("=" * 60)
    print("🇫🇷 Générateur de CodeSystem Communes INSEE pour FHIR")
    print("=" * 60)
    
    try:
        # Étape 1: Télécharger les données
        csv_content = download_insee_data()
        
        # Étape 2: Parser les communes
        communes = parse_communes_insee(csv_content)
        
        # Étape 3: Générer le fichier FSH
        generate_fsh_file(communes, OUTPUT_FILE)
        
        print("\n" + "=" * 60)
        print("✅ Génération terminée avec succès !")
        print("=" * 60)
        print(f"\nProchaines étapes:")
        print(f"1. Vérifier le fichier: {OUTPUT_FILE}")
        print(f"2. Compiler avec SUSHI: npx sushi .")
        print(f"3. Supprimer l'ancien fichier CommunesINSEECodeSystem.fsh")
        print(f"4. Renommer _full.fsh en .fsh")
        
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
