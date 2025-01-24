//
//  ConsultTourneeDetailViewController.swift
//  EFD_ipad
//
//  Created by Hugo Arnaudeau on 14/01/2025.
//

import UIKit
import CoreLocation

class ConsultTourneeDetailViewController: UIViewController {
    
    @IBOutlet weak var nbColisLabel: UILabel!
    @IBOutlet weak var dateSpec: UILabel!
    @IBOutlet weak var DeleteButton: UIButton!
    @IBOutlet weak var editButton: UIButton!
    @IBOutlet weak var livreurLabel: UILabel!
    
    var tournee:  Tournees? // Variable pour recevoir le livreur sélectionné
    var tournees: [Tournees]?
    var onTourneeDate: ((Tournees) -> Void)?
    
    override func viewDidLoad() {
            super.viewDidLoad()
            
        // Mettre à jour les labels avec les données de la tournée
        if let tournee = self.tournee {
            self.nbColisLabel.text = "\(tournee.nbColis)"
            self.dateSpec.text = formatDateComponents(tournee.dateSpec)
            
            // Vérification si le livreur existe
            let livreur = tournee.livreur
            self.livreurLabel.text = "\(livreur.nom)\(livreur.prenom), \(livreur.age) ans"
        }
    }
        
        @IBAction func modifyButtonTapped(_ sender: Any) {
            // Afficher une alerte pour permettre à l'utilisateur de modifier les informations de la tournée
            let alert = UIAlertController(title: "Modifier Tournée", message: nil, preferredStyle: .alert)
            
            // Ajouter des champs pour modifier les informations
            alert.addTextField { textField in
                textField.text = "\(self.tournee?.nbColis ?? 0)"
                textField.placeholder = "Nombre de colis"
                textField.keyboardType = .numberPad
            }
            alert.addTextField { textField in
                textField.text = self.formatDateComponents(self.tournee?.dateSpec)
                textField.placeholder = "Date (yyyy-MM-dd HH:mm)"
            }
            
            // Ajouter l'action de validation
            alert.addAction(UIAlertAction(title: "Valider", style: .default, handler: { [weak self] _ in
                guard let self = self else { return }
                
                // Récupérer les nouvelles valeurs
                let newNbColis = Int(alert.textFields?[0].text ?? "") ?? self.tournee?.nbColis ?? 0
                
                let newDateText = alert.textFields?[2].text ?? ""
                let newDateComponents = self.parseDateComponents(from: newDateText)
                
                // Vérifier que la date est valide
                guard newDateComponents != nil else {
                    self.showError(message: "La date est invalide.")
                    return
                }
                
                // Mettre à jour l'objet tournée
                self.tournee?.nbColis = newNbColis
                self.tournee?.dateSpec = newDateComponents!
                
                // Mettre à jour les labels
                self.nbColisLabel.text = "\(newNbColis)"
                self.dateSpec.text = self.formatDateComponents(newDateComponents!)
            }))
            
            // Ajouter l'action d'annulation
            alert.addAction(UIAlertAction(title: "Annuler", style: .cancel, handler: nil))
            
            // Afficher l'alerte
            self.present(alert, animated: true, completion: nil)
        }
        
        @IBAction func deleteButtonTapped(_ sender: Any) {
            // Confirmer la suppression via une alerte
            let alert = UIAlertController(title: "Supprimer Tournée", message: "Êtes-vous sûr de vouloir supprimer cette tournée ?", preferredStyle: .alert)
            
            // Ajouter l'action de suppression
            alert.addAction(UIAlertAction(title: "Supprimer", style: .destructive, handler: { [weak self] _ in
                guard let self = self, let tournee = self.tournee else { return }
                
                // Appeler la closure pour signaler la suppression
                self.onTourneeDate?(tournee)
                
                // Retourner à la liste des tournées
                self.navigationController?.popViewController(animated: true)
            }))
            
            // Ajouter l'action d'annulation
            alert.addAction(UIAlertAction(title: "Annuler", style: .cancel, handler: nil))
            
            // Afficher l'alerte
            self.present(alert, animated: true, completion: nil)
        }
        
        // MARK: - Helpers
        
        /*func formatCoordinates(_ coordinates: CLLocationCoordinate2D) -> String {
            return String(format: "Lat: %.6f, Long: %.6f", coordinates.latitude, coordinates.longitude)
        }*/
        
        func formatDateComponents(_ components: DateComponents?) -> String {
            guard let components = components,
                  let date = Calendar.current.date(from: components) else { return "" }
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd HH:mm"
            return formatter.string(from: date)
        }
        
        /*func parseCoordinates(from text: String) -> CLLocationCoordinate2D? {
            let components = text.split(separator: ",").map { $0.trimmingCharacters(in: .whitespaces) }
            guard components.count == 2,
                  let latitude = Double(components[0]),
                  let longitude = Double(components[1]) else {
                return nil
            }
            return CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        }*/
        
        func parseDateComponents(from text: String) -> DateComponents? {
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd HH:mm"
            guard let date = formatter.date(from: text) else { return nil }
            return Calendar.current.dateComponents([.year, .month, .day, .hour, .minute], from: date)
        }
        
        func showError(message: String) {
            let alert = UIAlertController(title: "Erreur", message: message, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default))
            self.present(alert, animated: true, completion: nil)
        }
    }
