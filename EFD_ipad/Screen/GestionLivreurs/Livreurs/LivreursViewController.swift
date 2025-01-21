//
//  LivreursViewController.swift
//  EFD_ipad
//
//  Created by Hugo Arnaudeau on 23/12/2024.
//

import UIKit

class LivreursViewController: UIViewController {
    
    @IBOutlet weak var nameLabel: UITextField!
    @IBOutlet weak var prenomLabel: UITextField!
    @IBOutlet weak var ageLabel: UITextField!
    
    var onLivreurCreated: ((Livreur) -> Void)?
    
    //methode pour que la création de compte soit envoyé dans la consultation des profils (stocké dans un dictionnaire peut être?)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    @IBAction func handleLivreurs(_ sender: Any) {
        // Valider les champs
        guard let nom = nameLabel.text, !nom.isEmpty,
              let prenom = prenomLabel.text, !prenom.isEmpty,
              let ageText = ageLabel.text, let age = Int(ageText) else {
            // Afficher un message d'erreur si les champs sont invalides
            return
        }
        
        // Créer un nouveau livreur
        let newLivreur = Livreur(nom: nom, prenom: prenom, age: age)
        
        // Ajouter le livreur dans le service
        MockConnexionService.getInstance().addLivreur(newLivreur)
        
        // Envoyer une notification pour mettre à jour la table dans le ConsultViewController
        NotificationCenter.default.post(name: .newLivreurAdded, object: newLivreur)
        
        // Optionnel : Naviguer ou fermer la vue
        self.dismiss(animated: true, completion: nil)
        self.navigationController?.popViewController(animated: true)
    }
    
}

extension Notification.Name {
    static let newLivreurAdded = Notification.Name("newLivreurAdded")
}
