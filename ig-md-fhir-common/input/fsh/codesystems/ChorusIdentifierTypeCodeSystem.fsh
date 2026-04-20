// =============================================
// CodeSystem: Type Identifiant CHORUS
// =============================================

CodeSystem: ChorusIdentifierTypeCS
Id: chorus-identifier-type-cs
Title: "Type Identifiant CHORUS"
Description: "Types d'identifiants reconnus par CHORUS (système de comptabilité publique). Nomenclature extraite de interfacesGEF.txt page 141. Identique à la table 'Identifiant TG' mais sans le code 09 (En cours d'immatriculation) car CHORUS n'accepte que les identifiants définitifs."
* ^url = "https://www.cpage.fr/ig/masterdata/common/CodeSystem/chorus-identifier-type-cs"
* ^version = "1.0.0"
* ^status = #active
* ^experimental = false
* ^caseSensitive = true
* ^content = #complete
* ^count = 8

* #01 "SIRET" "SIRET - Système d'Identification du Répertoire des Établissements (14 caractères)"
* #02 "SIREN" "SIREN - Système d'Identification du Répertoire des Entreprises (9 caractères)"
* #03 "FINESS" "FINESS - Fichier National des Établissements Sanitaires et Sociaux (9 caractères)"
* #04 "NIR" "NIR - Numéro d'Inscription au Répertoire (Sécurité Sociale, 15 caractères)"
* #05 "TVA Intracommunautaire" "Numéro de TVA intracommunautaire (Union Européenne)"
* #06 "Identifiant hors UE" "Identifiant pour entités hors Union Européenne"
* #07 "N° Tahiti" "Numéro d'identification Tahiti (Polynésie française)"
* #08 "RIDET" "RIDET - Répertoire d'IDEntification des Entreprises et des Établissements (Nouvelle-Calédonie)"
// Note: Pas de code #09 (En cours d'immatriculation) dans CHORUS - identifiants temporaires non acceptés
