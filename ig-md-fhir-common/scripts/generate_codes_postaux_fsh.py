#!/usr/bin/env python3
"""
Script de génération de la liste complète des codes postaux français
depuis la base officielle La Poste.

Source: Base Adresse Nationale (BAN) ou fichier La Poste HEXASIMAL
URL: https://datanova.laposte.fr/datasets/laposte-hexasmal

Usage:
    python generate_codes_postaux_fsh.py [fichier_csv]

Output:
    input/fsh/codesystems/CodesPostauxCodeSystem_full.fsh
"""

import csv
import sys
import urllib.request
from datetime import datetime
from collections import OrderedDict

# Configuration
OUTPUT_FILE = "../input/fsh/codesystems/CodesPostauxCodeSystem_full.fsh"
LA_POSTE_URL = "https://datanova.laposte.fr/data-fair/api/v1/datasets/laposte-hexasmal/raw"

FSH_HEADER = """// =============================================
// CodeSystem: Codes Postaux français (La Poste) - Liste Complète
// =============================================
// FICHIER GÉNÉRÉ AUTOMATIQUEMENT
// Date de génération: {date}
// Source: La Poste - Base HEXASIMAL
// Nombre de codes postaux: {count}

CodeSystem: CodesPostauxCodeSystem
Id: codes-postaux-cs
Title: "Codes Postaux français (La Poste)"
Description: "Liste complète des codes postaux français. Un code postal peut couvrir plusieurs communes (code postal partagé), et une grande commune peut avoir plusieurs codes postaux (arrondissements, secteurs). Format : 5 chiffres."

* ^url = "https://www.cpage.fr/ig/masterdata/geo/CodeSystem/codes-postaux-cs"
* ^version = "{year}.1.0"
* ^status = #active
* ^experimental = false
* ^date = "{date}"
* ^caseSensitive = true
* ^content = #complete
* ^publisher = "CPage"
* ^contact.telecom.system = #url
* ^contact.telecom.value = "https://www.cpage.fr"
* ^copyright = "Source: La Poste - Base Officielle HEXASIMAL. Données publiques sous Licence Ouverte 2.0"
* ^purpose = "Valider et normaliser les codes postaux dans les adresses. Permet la vérification de cohérence entre code postal et commune."
* ^count = {count}

// =============================================
// Liste complète des codes postaux français
// =============================================

"""


def download_laposte_data():
    """Télécharge les données La Poste HEXASIMAL."""
    print("📥 Téléchargement des données La Poste HEXASIMAL...")
    
    try:
        with urllib.request.urlopen(LA_POSTE_URL) as response:
            content = response.read().decode('utf-8')
            print(f"✅ Téléchargement réussi ({len(content)} caractères)")
            return content
    except Exception as e:
        print(f"❌ Erreur de téléchargement: {e}")
        print("💡 Télécharger manuellement depuis:")
        print("   https://datanova.laposte.fr/datasets/laposte-hexasmal")
        raise


def parse_codes_postaux_laposte(csv_content):
    """Parse le fichier CSV La Poste et retourne les codes postaux uniques."""
    print("📊 Parsing des codes postaux...")
    
    # Dictionnnaire pour éviter doublons et stocker le libellé principal
    codes_postaux = OrderedDict()
    csv_reader = csv.DictReader(csv_content.splitlines(), delimiter=';')
    
    for row in csv_reader:
        # Format HEXASIMAL:
        # Code_postal: Code postal (5 chiffres)
        # Nom_commune: Nom de la commune
        # Ligne_5: Complément adresse (arrondissement, etc.)
        
        code_postal = row.get('Code_postal', '').strip()
        nom_commune = row.get('Nom_commune', '').strip()
        ligne_5 = row.get('Ligne_5', '').strip()
        
        # Filtrer les lignes valides
        if code_postal and len(code_postal) == 5 and code_postal.isdigit():
            # Construire le libellé
            if ligne_5:
                libelle = f"{nom_commune} - {ligne_5}"
            else:
                libelle = nom_commune
            
            # Éviter doublons (garder le premier libellé)
            if code_postal not in codes_postaux:
                # Échapper les guillemets
                libelle_escaped = libelle.replace('"', '\\"')
                codes_postaux[code_postal] = libelle_escaped
    
    print(f"✅ {len(codes_postaux)} codes postaux uniques parsés")
    return list(codes_postaux.items())


def parse_codes_postaux_csv(csv_file):
    """Parse un fichier CSV personnalisé (format: code;libelle)."""
    print(f"📊 Parsing du fichier: {csv_file}")
    
    codes_postaux = []
    
    with open(csv_file, 'r', encoding='utf-8') as f:
        csv_reader = csv.reader(f, delimiter=';')
        next(csv_reader, None)  # Skip header
        
        for row in csv_reader:
            if len(row) >= 2:
                code = row[0].strip()
                libelle = row[1].strip()
                
                if code and len(code) == 5 and code.isdigit():
                    libelle_escaped = libelle.replace('"', '\\"')
                    codes_postaux.append((code, libelle_escaped))
    
    print(f"✅ {len(codes_postaux)} codes postaux parsés")
    return sorted(codes_postaux, key=lambda x: x[0])


def generate_fsh_file(codes_postaux, output_file):
    """Génère le fichier FSH complet."""
    print(f"📝 Génération du fichier FSH: {output_file}")
    
    year = datetime.now().year
    date = datetime.now().strftime("%Y-%m-%d")
    count = len(codes_postaux)
    
    with open(output_file, 'w', encoding='utf-8') as f:
        # Header
        header = FSH_HEADER.format(
            date=date,
            year=year,
            count=count
        )
        f.write(header)
        
        # Codes postaux
        for code, libelle in codes_postaux:
            f.write(f'* #{code} "{libelle}"\n')
    
    print(f"✅ Fichier généré avec {count} codes postaux")
    print(f"📄 Fichier: {output_file}")


def main():
    """Point d'entrée principal."""
    print("=" * 60)
    print("📮 Générateur de CodeSystem Codes Postaux pour FHIR")
    print("=" * 60)
    
    try:
        # Vérifier si un fichier CSV est fourni en argument
        if len(sys.argv) > 1:
            csv_file = sys.argv[1]
            print(f"📁 Utilisation du fichier local: {csv_file}")
            codes_postaux = parse_codes_postaux_csv(csv_file)
        else:
            # Télécharger depuis La Poste
            csv_content = download_laposte_data()
            codes_postaux = parse_codes_postaux_laposte(csv_content)
        
        # Générer le fichier FSH
        generate_fsh_file(codes_postaux, OUTPUT_FILE)
        
        print("\n" + "=" * 60)
        print("✅ Génération terminée avec succès !")
        print("=" * 60)
        print(f"\nProchaines étapes:")
        print(f"1. Vérifier le fichier: {OUTPUT_FILE}")
        print(f"2. Compiler avec SUSHI: npx sushi .")
        print(f"3. Supprimer l'ancien fichier CodesPostauxCodeSystem.fsh")
        print(f"4. Renommer _full.fsh en .fsh")
        
    except Exception as e:
        print(f"\n❌ Erreur: {e}")
        print("\n💡 Solutions:")
        print("   - Télécharger manuellement le fichier HEXASIMAL depuis La Poste")
        print("   - Fournir un fichier CSV local: python script.py fichier.csv")
        print("   - Format CSV attendu: code_postal;libelle")
        return 1
    
    return 0


if __name__ == "__main__":
    exit(main())
