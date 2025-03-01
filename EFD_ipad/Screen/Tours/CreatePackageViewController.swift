//
//  CreatePackageViewController.swift
//  EFD_ipad
//
//  Created by Gil Rodrigues on 28/02/2025.
//

import UIKit
import MapKit

class CreatePackageViewController: UIViewController {

    @IBOutlet weak var adressTF: UITextField!
    @IBOutlet weak var postalCodeTF: UITextField!
    @IBOutlet weak var createPackageButton: UIButton!
    @IBOutlet weak var deliveryDatePicker: UIDatePicker!
    @IBOutlet weak var deliveryMap: MKMapView!
    
    var package: PackageDTO = PackageDTO() {
        didSet {
            //self.loadMap()
        }
    }
    
    var deliveryManId: Int = 0
    var tourId: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    override func viewWillAppear(_ animated: Bool) {
        //self.setupCalendar()
    }
    
}
