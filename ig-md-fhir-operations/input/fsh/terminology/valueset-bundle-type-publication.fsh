ValueSet: BundleTypePublicationVS
Id: bundle-type-publication
Title: "Value Set - Types de Bundle pour la publication MDM"
Description: "Restreint les types de Bundle autorises dans les lots de publication MDM aux valeurs transaction (atomique, coherente) et batch (traitement independant par entree)."
* ^url = "https://www.cpage.fr/ig/masterdata/operations/ValueSet/bundle-type-publication"
* ^version = "0.1.0"
* ^status = #active
* ^experimental = false
* ^publisher = "CPage"
* http://hl7.org/fhir/bundle-type#transaction "Transaction"
* http://hl7.org/fhir/bundle-type#batch "Batch"
