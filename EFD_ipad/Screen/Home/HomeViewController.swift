//
//  HomeViewController.swift
//  EFD_ipad
//
//  Created by Hugo Arnaudeau on 24/12/2024.
//

import UIKit

class HomeViewController: UIViewController {
    
    @IBOutlet weak var identifiantTextField: UITextField!
    @IBOutlet weak var mdpTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mdpTextField.isSecureTextEntry = true
        
        // Do any additional setup after loading the view.
    }
    @IBAction func goToMain(_ sender: Any) {
        //Appeler la méthode de vérification
        verificationAdmin { [weak self] isValid in
            guard let self = self else { return }
            if isValid {
                // Naviguer vers la vue principale
                let mainVC = MainViewController()
                self.navigationController?.pushViewController(mainVC, animated: true)
            } else {
                // Afficher une alerte pour mot de passe incorrect
                let alert = UIAlertController(title: "Alerte", message: "Mauvais identifiant ou mot de passe", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }
        }
    }
    // Vérification des identifiants
    func verificationAdmin(completion: @escaping (Bool) -> Void) {
        // Récupérer les identifiants saisis
        guard let username = identifiantTextField.text,
              let password = mdpTextField.text else {
            completion(false)
            return
        }
        
        // Appeler le mock service
        MockConnexionService.getInstance().getAllConnexion { connexions in
            // Vérifier si les identifiants correspondent à une entrée du mock
            let isValid = connexions.contains { connexion in
                connexion.username == username && connexion.password == password
            }
            completion(isValid)
        }
    }
}
