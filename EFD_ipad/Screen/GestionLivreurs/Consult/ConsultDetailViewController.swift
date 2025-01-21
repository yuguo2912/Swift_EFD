//
//  ConsultDetailViewController.swift
//  EFD_ipad
//
//  Created by Hugo Arnaudeau on 26/12/2024.
//

import UIKit

class ConsultDetailViewController: UIViewController {
    @IBOutlet weak var nomLabel: UILabel!
    @IBOutlet weak var prenomLabel: UILabel!
    @IBOutlet weak var ageLabel: UILabel!
    @IBOutlet weak var deleteButton: UIButton!
    @IBOutlet weak var modifyButton: UIButton!
    
    var livreur:  Livreur? // Variable pour recevoir le livreur sélectionné
    var livreurs: [Livreur]?
    var onLivreurDeleted: ((Livreur) -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Mettre à jour les labels avec les données du livreur
        if let livreur = self.livreur {
            self.nomLabel.text = livreur.nom
            self.prenomLabel.text = livreur.prenom
            self.ageLabel.text = "\(livreur.age)"
        }
    }
    @IBAction func modifyButtonTapped(_ sender: Any) {
        // Afficher une alerte pour permettre à l'utilisateur de modifier les informations du livreur
        let alert = UIAlertController(title: "Modifier Livreur", message: nil, preferredStyle: .alert)
        
        // Ajouter des champs pour modifier le nom, prénom et âge
        alert.addTextField { textField in
            textField.text = self.livreur?.nom
            textField.placeholder = "Nom"
        }
        alert.addTextField { textField in
            textField.text = self.livreur?.prenom
            textField.placeholder = "Prénom"
        }
        alert.addTextField { textField in
            textField.text = "\(self.livreur?.age ?? 0)"
            textField.placeholder = "Âge"
            textField.keyboardType = .numberPad
        }
        
        // Ajouter l'action de validation
        alert.addAction(UIAlertAction(title: "Valider", style: .default, handler: { [weak self] _ in
            guard let self = self else { return }
            
            // Récupérer les nouvelles valeurs
            let newNom = alert.textFields?[0].text ?? self.livreur?.nom ?? ""
            let newPrenom = alert.textFields?[1].text ?? self.livreur?.prenom ?? ""
            let newAge = Int(alert.textFields?[2].text ?? "\(self.livreur?.age ?? 0)") ?? self.livreur?.age ?? 0
            
            // Mettre à jour l'objet livreur
            self.livreur?.nom = newNom
            self.livreur?.prenom = newPrenom
            self.livreur?.age = newAge
            
            // Mettre à jour les labels
            self.nomLabel.text = newNom
            self.prenomLabel.text = newPrenom
            self.ageLabel.text = "\(newAge)"
            
            // Retourner à la liste des livreurs ou mettre à jour la liste
            // Si vous avez un tableau global, mettez à jour ce tableau ici
        }))
        
        // Ajouter l'action d'annulation
        alert.addAction(UIAlertAction(title: "Annuler", style: .cancel, handler: nil))
        
        // Afficher l'alerte
        self.present(alert, animated: true, completion: nil)
    }
    @IBAction func deleteButtonTapped(_ sender: Any) {
        // Confirmer la suppression via une alerte
        let alert = UIAlertController(title: "Supprimer Livreur", message: "Êtes-vous sûr de vouloir supprimer ce livreur ?", preferredStyle: .alert)
        
        // Ajouter l'action de suppression
        alert.addAction(UIAlertAction(title: "Supprimer", style: .destructive, handler: { [weak self] _ in
            guard let self = self, let livreur = self.livreur else { return }
            
            // Appeler la closure pour signaler la suppression
            self.onLivreurDeleted?(livreur)
            
            // Retourner à la liste des livreurs
            self.navigationController?.popViewController(animated: true)
        }))
        
        // Ajouter l'action d'annulation
        alert.addAction(UIAlertAction(title: "Annuler", style: .cancel, handler: nil))
        
        // Afficher l'alerte
        self.present(alert, animated: true, completion: nil)
    }
    
}
