//
//  Tournee2ViewController.swift
//  EFD_ipad
//
//  Created by Hugo Arnaudeau on 18/01/2025.
//

import UIKit
import CoreLocation

class Tournee2ViewController: UIViewController {
    @IBOutlet weak var nbColisField: UITextField!
    @IBOutlet weak var dataSpecField: UITextField!
    
    @IBOutlet weak var livreurpicker: UIPickerView!
    
    
    var livreurs: [Livreur] = [] // Liste des livreurs disponibles
    var selectedLivreur: Livreur? // Livreur sélectionné
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        livreurpicker.delegate = self
        livreurpicker.dataSource = self
        
        // Charger les livreurs depuis le MockConnexionService
        MockConnexionService.getInstance().getAllLivreur { [weak self] data in
            guard let self = self else { return }
            self.livreurs = data
            self.livreurpicker.reloadAllComponents()
        }
        
        // Observer l'ajout de nouveaux livreurs
        NotificationCenter.default.addObserver(self, selector: #selector(handleNewLivreurNotification(_:)), name: .newLivreurAdded, object: nil)
    }
    
    @IBAction func handleTournees(_ sender: Any) {
        // Valider les champs
        guard let nbColisText = nbColisField.text,
              let nbColis = Int(nbColisText),
              let dateSpecText = dataSpecField.text,
              let dateSpec = parseDateComponents(from: dateSpecText),
              let livreur = selectedLivreur else { // Vérifier qu'un livreur est sélectionné
            // Afficher un message d'erreur si les champs sont invalides
            showError(message: "Veuillez vérifier les informations saisies et sélectionner un livreur.")
            return
        }
        
        // Créer une nouvelle tournée avec le livreur sélectionné
        let newTournee = Tournees(nbColis: nbColis, dateSpec: dateSpec, livreur: livreur)
        
        // Ajouter la tournée dans le service
        MockConnexionService.getInstance().addTournee(newTournee)
        
        // Envoyer une notification pour mettre à jour la table dans le ConsultViewController
        NotificationCenter.default.post(name: .newTourneeAdded, object: newTournee)
        
        // Fermer la vue
        self.dismiss(animated: true, completion: nil)
        self.navigationController?.popViewController(animated: true)
    }
    
    // MARK: - Notification Handlers
    
    @objc func handleNewLivreurNotification(_ notification: Notification) {
        if let newLivreur = notification.object as? Livreur {
            self.livreurs.append(newLivreur)
            self.livreurpicker.reloadAllComponents()
        }
    }
    
    // MARK: - Helpers
    
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
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: .newLivreurAdded, object: nil)
    }
}

// MARK: - UIPickerViewDataSource
extension Tournee2ViewController: UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1 // Une seule colonne pour les livreurs
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return livreurs.count
    }
}

// MARK: - UIPickerViewDelegate
extension Tournee2ViewController: UIPickerViewDelegate {
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        let livreur = livreurs[row]
        return "\(livreur.prenom) \(livreur.nom)" // Afficher le nom et prénom du livreur
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selectedLivreur = livreurs[row] // Stocker le livreur sélectionné
    }
}
extension Notification.Name {
    static let newTourneeAdded = Notification.Name("newTourneeAdded") // Crée un identifiant unique pour la notification
}
