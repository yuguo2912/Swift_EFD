//
//  EditPackageViewController.swift
//  EFD_ipad
//
//  Created by Gil Rodrigues on 08/02/2025.
//

import UIKit
import MapKit

class EditPackageViewController: UIViewController {
    
    @IBOutlet weak var saveSuccessLabel: UILabel!
    @IBOutlet weak var adressTF: UITextField!
    @IBOutlet weak var postalCodeTF: UITextField!
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var deleteButton: UIButton!
    @IBOutlet weak var deliveryMap: MKMapView!
    var package: PackageDTO = PackageDTO() {
        didSet {
            loadMap()
            loadAdressTF()
        }
    }
    
    let packageService = PackageService.getInstance()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.adressTF.delegate = self
        self.postalCodeTF.delegate = self
        self.deliveryMap.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        loadMap()
        loadAdressTF()
    }
    
    @IBAction func handleDelete(_ sender: Any) {
        self.deletePackage()
    }
    
    func deletePackage() {
        packageService.deletePackage(packageId: self.package.packageId!) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(_):
                    self.navigationController?.popViewController(animated: true)
                case.failure(let error):
                    let alertController = UIAlertController(title: "Erreur", message: error.localizedDescription, preferredStyle: .alert)
                    let retryAction = UIAlertAction(title: "Réessayer", style: .default,handler: { action in
                        self.deletePackage()
                    })
                    let cancelAction = UIAlertAction(title: "Annuler", style: .cancel)
                    alertController.addAction(retryAction)
                    alertController.addAction(cancelAction)
                    self.present(alertController, animated: true)
                }
            }
        }
    }
    
    @IBAction func handleSaveUpdatedLocation(_ sender: Any) {
        self.saveUpdatedLocation()
    }
    
    func saveUpdatedLocation() {
        packageService.editPackage(package: self.package) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let package):
                    self.package = package
                    self.saveSuccessLabel.isHidden = false
                case .failure(let error):
                    let alertController = UIAlertController(title: "Erreur", message: error.localizedDescription, preferredStyle: .alert)
                    let retryAction = UIAlertAction(title: "Réessayer", style: .default, handler: {_ in 
                        self.saveUpdatedLocation()
                    })
                    let cancelAction = UIAlertAction(title: "Annuler", style: .cancel, handler: nil)
                    alertController.addAction(retryAction)
                    alertController.addAction(cancelAction)
                    self.present(alertController, animated: true, completion: nil)
                }
            }
        }
    }
    
    func loadAdressTF() {
        guard let location = package.location else {
                return
            }
            
            let geoCoder = CLGeocoder()
            let locationCoords = CLLocation(latitude: location.getLatitude(), longitude: location.getLongitude())
            
            geoCoder.reverseGeocodeLocation(locationCoords) { (placemarks, error) in
                if let error = error {
                    print(error.localizedDescription)
                    return
                }
                
                if let placemark = placemarks?.first {
                    DispatchQueue.main.async {
                        self.adressTF.text = placemark.thoroughfare ?? ""
                        self.postalCodeTF.text = placemark.postalCode ?? ""
                    }
                }
            }
    }
    
    func loadMap() {
        guard let deliveryMap = self.deliveryMap else { return  }
        let existingAnnotations = deliveryMap.annotations.filter { !($0 is MKUserLocation) }
            deliveryMap.removeAnnotations(existingAnnotations)
        
        guard let location = self.package.location else {
            return
        }

        let annotation = MKPointAnnotation()
        annotation.coordinate = CLLocationCoordinate2D(latitude: location.getLatitude(), longitude: location.getLongitude())

        self.deliveryMap.addAnnotation(annotation)
        self.deliveryMap.showAnnotations([annotation], animated: true)
    }
    
    func findLocationFromAddress(address: String) {
        let geoCoder = CLGeocoder()
        
        geoCoder.geocodeAddressString(address) { (placemarks, error) in
            if let _ = error {
                return
            }
            
            guard let placemark = placemarks?.first, let location = placemark.location else {
                return
            }
            
            let latitude = location.coordinate.latitude
            let longitude = location.coordinate.longitude
            
            DispatchQueue.main.async {
                self.package.location = Coordinates(latitude: latitude, longitude: longitude)
                self.loadMap()
            }
        }
    }
    
    
}

extension EditPackageViewController : UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        guard let address = adressTF.text, !address.isEmpty,
                  let postalCode = postalCodeTF.text, !postalCode.isEmpty else {
                return
            }
        
        findLocationFromAddress(address: "\(address), \(postalCode)")
    }
}

extension EditPackageViewController : MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView, viewFor annotation: any MKAnnotation) -> MKAnnotationView? {
        guard !(annotation is MKUserLocation) else { return nil }
        let identifier = "PackageAnnotation"
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier) as? MKMarkerAnnotationView
        if annotationView == nil {
            annotationView = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            annotationView?.canShowCallout = true
            annotationView?.isDraggable = true
        } else {
            annotationView?.annotation = annotation
        }
        
        annotationView?.markerTintColor = .systemBlue
        annotationView?.glyphImage = UIImage(systemName: "shippingbox")
        
        return annotationView
    }
    
    func mapView(_ mapView: MKMapView, annotationView : MKAnnotationView, didChange newState: MKAnnotationView.DragState, fromOldState oldState: MKAnnotationView.DragState) {
        if newState == .ending {
            annotationView.dragState = .none
            if let movedAnnotation = annotationView.annotation {
                if self.package.location == nil {
                    self.package.location = Coordinates(latitude: movedAnnotation.coordinate.latitude, longitude: movedAnnotation.coordinate.longitude)
                } else {
                    self.package.location?.setLatitude(movedAnnotation.coordinate.latitude)
                    self.package.location?.setLongitude(movedAnnotation.coordinate.longitude)
                }
            }
        }
    }

}
