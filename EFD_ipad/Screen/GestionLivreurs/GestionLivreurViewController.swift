//
//  GestionLivreurViewController.swift
//  EFD_ipad
//
//  Created by Hugo Arnaudeau on 23/12/2024.
//

import UIKit

class GestionLivreurViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func goToLivreurs(_ sender: Any) {
        let livreurs = LivreursViewController()
        self.navigationController?.pushViewController(livreurs, animated: true)
        //ajouter une méthode
    }
    
    @IBAction func goToConsult(_ sender: Any) {
        let consult = ConsultViewController()
        self.navigationController?.pushViewController(consult, animated: true)
    }
    
}
