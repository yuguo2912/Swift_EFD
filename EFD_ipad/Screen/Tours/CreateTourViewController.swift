//
//  CreateTourViewController.swift
//  EFD_ipad
//
//  Created by Gil Rodrigues on 08/02/2025.
//

import UIKit
import MapKit
import Foundation
import CoreLocation

class CreateTourViewController: UIViewController {

    @IBOutlet weak var errorLabel: UILabel!
    @IBOutlet weak var createButton: UIButton!
    @IBOutlet weak var deliveryManPicker: UIButton!
    @IBOutlet weak var deliveryDatePicker: UIDatePicker!
    @IBOutlet weak var numberOfPackagesTF: UITextField!
    @IBOutlet weak var deliveryMap: MKMapView!
    @IBOutlet weak var editPackageLocationBT: UIButton!
    @IBOutlet weak var deletePackageBT: UIButton!
    
    
    var packages: [PackageDTO] = [] {
        didSet {
            loadMap()
        }
    }
    
    let adminService = AdminService.getInstance()
    let packageService = PackageService.getInstance()
    var selectedDeliveryMan: Int = 0
    var selectedAnnotation: MKAnnotation?
    var selectedPackageIndex: Int = -1

    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupdeliveryMansMenu()
        loadDeliveryMans()
        setupCalendar()
        self.deliveryMap.delegate = self
        deletePackageBT.isHidden = true
        editPackageLocationBT.isHidden = true
        disableEditButton()
        disableDeleteButton()
    }
    
    func disableDeleteButton() {
        deletePackageBT.alpha = 0.5
        deletePackageBT.isEnabled = false
    }
    
    func enableDeleteButton() {
        deletePackageBT.alpha = 1
        deletePackageBT.isEnabled = true
    }
    
    func disableEditButton() {
        editPackageLocationBT.alpha = 0.5
        editPackageLocationBT.isEnabled = false
    }
    
    func enableEditButton() {
        editPackageLocationBT.alpha = 1
        editPackageLocationBT.isEnabled = true
    }
    
    func loadMap() {
        deliveryMap.isHidden = false
        
        let existingAnnotations = deliveryMap.annotations.filter { !($0 is MKUserLocation) }
            deliveryMap.removeAnnotations(existingAnnotations)

        let annotations: [MKPointAnnotation] = self.packages.compactMap { pack in
            guard let location = pack.location else { return nil }
            let point = MKPointAnnotation()
            point.coordinate = CLLocationCoordinate2D(latitude: location.getLatitude(), longitude: location.getLongitude())
            return point
        }

        self.deliveryMap.addAnnotations(annotations)
        self.deliveryMap.showAnnotations(annotations, animated: true)
    }

    
    func setupCalendar() {
        deliveryDatePicker.datePickerMode = .date
        if let tomorrow = Calendar.current.date(byAdding: .day, value: 1, to: Date()) {
            deliveryDatePicker.minimumDate = tomorrow
        }
    }
    
    func setupdeliveryMansMenu() {
        let defaultItem = UIAction(title: "Chargement...", attributes: .disabled, handler: { _ in })
        deliveryManPicker.menu = UIMenu(title: "Sélectionner un livreur", options: .displayInline, children: [defaultItem])
        deliveryManPicker.showsMenuAsPrimaryAction = true
        deliveryManPicker.changesSelectionAsPrimaryAction = true
    }
    
    func loadDeliveryMans() {
        adminService.getDeliveryMans() { result in
            switch result {
            case .success(let deliveryMans):
                DispatchQueue.main.async {
                    self.updateDeliveryManMenu(deliveryMans)
                    print(deliveryMans)
                }
            case .failure(let error):
                let alert = UIAlertController(title: "Erreur", message: error.localizedDescription, preferredStyle: .alert)
                let retryAction = UIAlertAction(title: "Réessayer", style: .default) { _ in
                    self.viewWillAppear(true)
                }
                let cancelAction = UIAlertAction(title: "Annuler", style: .cancel, handler: nil)
                alert.addAction(retryAction)
                alert.addAction(cancelAction)
                
                self.present(alert, animated: true)
            }
        }
    }

    func updateDeliveryManMenu(_ deliveryMans: [User]) {
        var menuItems = deliveryMans.enumerated().map { (index, deliveryMan) in
            UIAction(title: "\(deliveryMan.name) \(deliveryMan.lastname)", handler: { _ in
                self.deliveryManPicker.setTitle("\(deliveryMan.name) \(deliveryMan.lastname)", for: .normal)
                self.selectedDeliveryMan = index
                print("Livreur sélectionné : \(deliveryMan.name) \(deliveryMan.lastname)")
            })
        }

        if menuItems.isEmpty {
            menuItems.append(UIAction(title: "Aucun livreur disponible", handler: { _ in
                self.deliveryManPicker.setTitle("Aucun livreur", for: .normal)
            }))
        }
        
        deliveryManPicker.menu = UIMenu(title: "Sélectionner un livreur", options: .displayInline, children: menuItems)
    }


    @IBAction func handleCreateDeliveryTour(_ sender: Any) {
        guard let packagesText = numberOfPackagesTF.text, !packagesText.isEmpty else {
            self.errorLabel.text = "Veuillez entrer le nombre de colis."
            self.errorLabel.textColor = .red
            return
        }

        guard let numberOfPackages = Int(packagesText) else {
            self.errorLabel.text = "Le nombre de colis doit être un nombre entier valide."
            self.errorLabel.textColor = .red
            return
        }
        
        let formatter = ISO8601DateFormatter()
        let deliveryDate = formatter.string(from: Calendar.current.date(byAdding: .minute, value: 1, to: deliveryDatePicker.date) ?? deliveryDatePicker.date)
        
        let deliveryManId  = adminService.deliveryMans[self.selectedDeliveryMan].id
        
        let deliveryTour = CreateDeliveryTourDTO(deliveryManId: deliveryManId, deliveryDate: deliveryDate, numberOfPackages: numberOfPackages)
        
        adminService.createDeliveryTour(deliveryTour: deliveryTour) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let deliveryTour):
                    print(deliveryTour)
                    self.editPackageLocationBT.isHidden = false
                    self.deletePackageBT.isHidden = false
                    self.packages = deliveryTour.packages ?? []
                case .failure(let error):
                    self.errorLabel.text = "\(error)"
                    self.errorLabel.textColor = .red
                }
            }
        }
    }
    
    @IBAction func deletePackage(_ sender: Any) {
        guard let annotation = selectedAnnotation else { return }
        
        deliveryMap.removeAnnotation(annotation)
               
        if let index = packages.firstIndex(where: { pack in
            pack.location?.getLatitude() == annotation.coordinate.latitude &&
            pack.location?.getLongitude() == annotation.coordinate.longitude
        }) {
            
            packageService.deletePackage(packageId: self.packages[index].packageId!) { result in
                DispatchQueue.main.async {
                    switch result {
                    case .success:
                        self.packages.remove(at: index)
                    case .failure(let error):
                        let alert = UIAlertController(title: "Erreur", message: error.localizedDescription, preferredStyle: .alert)
                        let retryAction = UIAlertAction(title: "Réessayer", style: .default) { _ in
                            self.deletePackage(sender)
                        }
                        let cancelAction = UIAlertAction(title: "Annuler", style: .cancel, handler: nil)
                        alert.addAction(retryAction)
                        alert.addAction(cancelAction)
                        self.present(alert, animated: true)
                    }
                }
            }
        }
    }
    @IBAction func handleEditPackage(_ sender: Any) {
        
        print(self.selectedPackageIndex)
        
        if let selectedAnnotation = selectedAnnotation {
                let newLatitude = selectedAnnotation.coordinate.latitude
                let newLongitude = selectedAnnotation.coordinate.longitude

                packages[selectedPackageIndex].location?.setLatitude(newLatitude)
                packages[selectedPackageIndex].location?.setLongitude(newLongitude)
            }
        
        packageService.editPackage(package: self.packages[selectedPackageIndex]) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let package):
                    self.packages[self.selectedPackageIndex] = package
                    self.updateViewConstraints()
                case .failure(let error):
                    let alertController = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
                    let retryAction = UIAlertAction(title: "Retry", style: .default) { _ in
                        self.handleEditPackage(sender)
                    }
                    let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
                    alertController.addAction(retryAction)
                    alertController.addAction(cancelAction)
                    self.present(alertController, animated: true)
                }
            }
        }
    }
}

extension CreateTourViewController: MKMapViewDelegate {
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
        
        if let point = annotation as? MKPointAnnotation,
           let _ = packages.first(where: { $0.location?.getLatitude() == point.coordinate.latitude && $0.location?.getLongitude() == point.coordinate.longitude }) {
            annotationView?.markerTintColor = .systemBlue
            annotationView?.glyphImage = UIImage(systemName: "shippingbox")
        } else {
            annotationView?.markerTintColor = .red
            annotationView?.glyphImage = nil
        }
        
        return annotationView
    }
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        guard let annotation = view.annotation else { return }
        
        selectedAnnotation = annotation
        
        if let index = packages.firstIndex(where: { pack in
            guard let location = pack.location else { return false }
            return location.getLatitude() == annotation.coordinate.latitude &&
                    location.getLongitude() == annotation.coordinate.longitude
        }) {
            self.selectedPackageIndex = index
        }
        enableEditButton()
        enableDeleteButton()
    }

    func mapView(_ mapView: MKMapView, didDeselect view: MKAnnotationView) {
        selectedAnnotation = nil
        self.selectedPackageIndex = -1
        disableEditButton()
        disableDeleteButton()
    }
    
    func mapView(_ mapView: MKMapView, annotationView : MKAnnotationView, didChange newState: MKAnnotationView.DragState, fromOldState oldState: MKAnnotationView.DragState) {
        if newState == .ending {
                annotationView.dragState = .none
                
                if let movedAnnotation = annotationView.annotation {
                    if let oldLocation = selectedAnnotation?.coordinate,
                       oldLocation.latitude != movedAnnotation.coordinate.latitude ||
                       oldLocation.longitude != movedAnnotation.coordinate.longitude {
                        enableEditButton()
                        selectedAnnotation = movedAnnotation
                        self.packages[selectedPackageIndex].location?.setLatitude(movedAnnotation.coordinate.latitude)
                        self.packages[selectedPackageIndex].location?.setLongitude(movedAnnotation.coordinate.longitude)
                        
                    }
                }
            }
    }
    
    
}
