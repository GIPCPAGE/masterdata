// =============================================
// Extensions : Unité Fonctionnelle — attributs LOCAL (Common IG)
// =============================================
// Champs de portée LOCAL de l'unité fonctionnelle sans équivalent FR Core ni HL7, actifs selon
// le tenant. Le code du groupement hospitalier réutilise l'extension commune
// strh-code-groupement-hospitalier (StrHCodeGroupementHospitalierExtension.fsh).

Extension: UFBatimentExtension
Id: uf-batiment
Title: "Bâtiment de l'UF"
Description: "Bâtiment dans lequel se trouve l'unité fonctionnelle. Attribut de portée LOCAL, actif selon le tenant."
Context: Organization
* value[x] only Reference(BatimentProfile)
* valueReference ^short = "Bâtiment"

Extension: UFSectionAnalyseExtension
Id: uf-section-analyse
Title: "Section d'analyse de l'UF"
Description: "Section d'analyse référencée par l'unité fonctionnelle, à titre indicatif et sans cascade de fermeture. Attribut de portée LOCAL, actif selon le tenant."
Context: Organization
* value[x] only Reference(SectionAnalyseProfile)
* valueReference ^short = "Section d'analyse"

Extension: UFChambreParticuliereExtension
Id: uf-chambre-particuliere
Title: "Chambre particulière de l'UF"
Description: "Indique si l'unité fonctionnelle propose des chambres particulières ; distinct de l'indicateur de chambre individuelle porté par la chambre. Attribut de portée LOCAL, actif selon le tenant."
Context: Organization
* value[x] only boolean
* valueBoolean ^short = "Chambre particulière"

Extension: UFCompteAnalytiqueExtension
Id: uf-compte-analytique
Title: "Compte analytique de l'UF"
Description: "Code du compte analytique de l'unité fonctionnelle : nomenclature de comptes analytiques propre à chaque tenant. Attribut de portée LOCAL, actif selon le tenant."
Context: Organization
* value[x] only string
* valueString ^short = "Code du compte analytique"

Extension: UFMedecinChefExtension
Id: uf-medecin-chef
Title: "Médecin chef de l'UF"
Description: "Code du médecin chef de l'unité fonctionnelle, sans répertoire des médecins. Attribut de portée LOCAL, actif selon le tenant."
Context: Organization
* value[x] only string
* valueString ^short = "Code du médecin chef"

Extension: UFMedecinResponsableExtension
Id: uf-medecin-responsable
Title: "Médecin responsable de l'UF"
Description: "Code du médecin responsable de l'unité fonctionnelle (UFO.MED_NUMEME, 20 caractères au plus), sans répertoire des médecins."
Context: Organization
* value[x] only string
* valueString ^short = "Code du médecin responsable"

Extension: UFPenibiliteExtension
Id: uf-penibilite
Title: "Typologie de pénibilité de l'UF"
Description: "Code de la typologie de pénibilité de l'unité fonctionnelle (nomenclature PENIBILITE, zéros de tête conservés). Attribut de portée LOCAL, actif selon le tenant."
Context: Organization
* value[x] only string
* valueString ^short = "Code de la typologie de pénibilité"
