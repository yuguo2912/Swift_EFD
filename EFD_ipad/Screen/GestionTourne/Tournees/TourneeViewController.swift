//
//  TourneesViewController.swift
//  EFD_ipad
//
//  Created by Hugo Arnaudeau on 24/12/2024.
//

import UIKit
import CoreLocation

class TourneesViewController: UIViewController {

    @IBOutlet weak var nbColisField: UITextField!
    @IBOutlet weak var destinationField: UITextField!
    @IBOutlet weak var dateSpecField: UITextField!
    
    
    var onTourneeCreated: ((Tournees) -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}
