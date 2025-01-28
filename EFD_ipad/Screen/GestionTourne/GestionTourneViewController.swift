//
//  TourneViewController.swift
//  EFD_ipad
//
//  Created by Hugo Arnaudeau on 24/12/2024.
//

import UIKit

class GestionTourneViewController: UIViewController {

    @IBOutlet weak var headerLabel: UILabel!
    @IBOutlet weak var illustrationImageView: UIImageView!
    @IBOutlet weak var tourneesButton: UIButton!
    @IBOutlet weak var consultButton: UIButton!
    
        override func viewDidLoad() {
                super.viewDidLoad()
                view.backgroundColor = UIColor.systemGray6 // Fond clair.

                // Configurer le titre
                headerLabel.text = "Gestion des Tournées"
                headerLabel.font = UIFont.boldSystemFont(ofSize: 24)
                headerLabel.textColor = UIColor.label
                headerLabel.textAlignment = .center

                // Configurer l'image
                illustrationImageView.contentMode = .scaleAspectFit // Ajuste l'image à sa vue sans la déformer
                illustrationImageView.clipsToBounds = true // Coupe les parties débordantes si besoin

                // Configurer les boutons
                setupButton(tourneesButton, title: "Gérer les Tournées", imageName: "gearshape")
                setupButton(consultButton, title: "Consulter les Tournées", imageName: "doc.text.magnifyingglass")
            }

        private func setupButton(_ button: UIButton, title: String, imageName: String) {
            button.setTitle(title, for: .normal)
            button.setTitleColor(.white, for: .normal)
            button.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .medium)
            button.backgroundColor = UIColor.systemBlue
            button.layer.cornerRadius = 10
            button.setImage(UIImage(systemName: imageName), for: .normal) // SF Symbol
            button.tintColor = .white

            // Espacement entre image et texte
        }
    @IBAction func goToTournees(_ sender: Any) {
        let tournees = Tournee2ViewController()
        self.navigationController?.pushViewController(tournees, animated: true)
    }
    
    

    @IBAction func goToConsultTournees(_ sender: Any) {
        let consultTournee = ConsultTourneesViewController()
        self.navigationController?.pushViewController(consultTournee, animated: true)
    }
}

