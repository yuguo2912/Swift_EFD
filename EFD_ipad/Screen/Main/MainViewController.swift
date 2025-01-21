//
//  MainViewController.swift
//  EFD_ipad
//
//  Created by Hugo Arnaudeau on 23/12/2024.
//

import UIKit

class MainViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func goToGestionLivreurs(_ sender: Any) {
        let gestionlivreurs = GestionLivreurViewController()
        self.navigationController?.pushViewController(gestionlivreurs, animated: true)
    }

    
    @IBAction func goToSuivi(_ sender: Any) {
        let suivi = SuiviViewController()
        self.navigationController?.pushViewController(suivi, animated: true)
    }
    @IBAction func goToTournees(_ sender: Any) {
        let tournees = GestionTourneViewController()
        self.navigationController?.pushViewController(tournees, animated: true)
    }
    
    
    
    
    
    @IBAction func goToHisto(_ sender: Any) {
        
    }
}
