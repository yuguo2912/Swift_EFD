//
//  TourneViewController.swift
//  EFD_ipad
//
//  Created by Hugo Arnaudeau on 24/12/2024.
//

import UIKit

class GestionTourneViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
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
