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
    @IBOutlet weak var destinationField: UITextField!
    @IBOutlet weak var dataSpecField: UITextField!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    @IBAction func handleTournees(_ sender: Any) {
        // Valider les champs
        guard let nbColisText = nbColisField.text,
              let nbColis = Int(nbColisText),
              let destinationText = destinationField.text,
              let destination = parseCoordinates(from: destinationText),
              let dateSpecText = dataSpecField.text,
              let dateSpec = parseDateComponents(from: dateSpecText) else {
            // Afficher un message d'erreur si les champs sont invalides
            showError(message: "Veuillez vérifier les informations saisies.")
            return
        }
        
        // Créer une nouvelle tournée
        let newTournee = Tournees(nbColis: nbColis, destination: destination, dateSpec: dateSpec)
        
        // Ajouter la tournée dans le service
        MockConnexionService.getInstance().addTournee(newTournee)
        
        // Envoyer une notification pour mettre à jour la table dans le ConsultViewController
        NotificationCenter.default.post(name: .newTourneeAdded, object: newTournee)
        
        // Fermer la vue
        self.dismiss(animated: true, completion: nil)
        self.navigationController?.popViewController(animated: true)
    }
    
    
    
    // MARK: - Helpers
    
    func parseCoordinates(from text: String) -> CLLocationCoordinate2D? {
        // Diviser le texte en latitude et longitude
        let components = text.split(separator: ",").map { $0.trimmingCharacters(in: .whitespaces) }
        guard components.count == 2,
              let latitude = Double(components[0]),
              let longitude = Double(components[1]) else {
            return nil
        }
        return CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
    
    func parseDateComponents(from text: String) -> DateComponents? {
        // Convertir le texte en `Date` à l'aide d'un `DateFormatter`
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm"
        guard let date = formatter.date(from: text) else { return nil }
        
        // Obtenir les `DateComponents` à partir de la date
        return Calendar.current.dateComponents([.year, .month, .day, .hour, .minute], from: date)
    }
    
    func showError(message: String) {
        // Afficher une alerte d'erreur
        let alert = UIAlertController(title: "Erreur", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        self.present(alert, animated: true, completion: nil)
    }
}

extension Notification.Name {
    static let newTourneeAdded = Notification.Name("newTourneeAdded")
}
