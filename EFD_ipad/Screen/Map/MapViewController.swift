//
//  MapViewController.swift
//  EFD_ipad
//
//  Created by Gil Rodrigues on 08/02/2025.
//

import UIKit
import MapKit

class MapViewController: UIViewController {
    @IBOutlet weak var deliverymanPicker: UIButton!
    @IBOutlet weak var refreshButton: UIButton!
    @IBOutlet weak var map: MKMapView!
    
    let userService = UserService.getInstance()
    let adminService = AdminService.getInstance()
    
    var deliveryManId: Int = 0 {
        didSet {
            self.loadSelectedDeliveryMan(self.deliveryManId)
        }
    }
    var deliveryMans: UserWithLocationListDTO = UserWithLocationListDTO(users: []) {
        didSet {
            loadMap()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.map.delegate = self
    }
        
    @IBAction func refreshLocation(_ sender: Any) {
        self.loadSelectedDeliveryMan(self.deliveryManId)
    }
    override func viewWillAppear(_ animated: Bool) {
        
        self.setupdeliveryMansMenu()
        self.loadDeliveryMans()
    }
    
    func loadDeliveryManLocation(_ deliveryManId: Int) {
        if deliveryManId == 0 {
            self.loadAllDeliveryMan()
        }else {
            self.loadSelectedDeliveryMan(deliveryManId)
        }
    }
    
    func loadAllDeliveryMan() {
        userService.getAllDeliveryManLocations() { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let deliveryMans):
                    self.deliveryMans = deliveryMans
                case .failure(let error):
                    let alertController = UIAlertController(title: "Erreur", message: error.localizedDescription, preferredStyle: .alert)
                    let retryAction = UIAlertAction(title: "Ressayer", style: .default) { _ in
                        self.loadAllDeliveryMan()
                    }
                    let cancelAction = UIAlertAction(title: "Annuler", style: .cancel)
                    alertController.addAction(retryAction)
                    alertController.addAction(cancelAction)
                    self.present(alertController, animated: true)
                }
            }
        }
    }
    
    func loadSelectedDeliveryMan(_ deliveryManId: Int) {
        userService.getUserLocationById(id: deliveryManId) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let location):
                    if let index = self.deliveryMans.users.firstIndex(where: { $0.id == deliveryManId }) {
                        let updatedDeliveryMans = self.deliveryMans
                        updatedDeliveryMans.users[index].location = location
                        self.deliveryMans = updatedDeliveryMans
                    }
                case .failure(let error):
                    print(error.localizedDescription)
                    let alertController = UIAlertController(title: "Erreur", message: error.localizedDescription, preferredStyle: .alert)
                    let retryAction = UIAlertAction(title: "Ressayer", style: .default) { _ in
                        self.loadDeliveryManLocation(deliveryManId)
                    }
                    let cancelAction = UIAlertAction(title: "Annuler", style: .cancel)
                    alertController.addAction(retryAction)
                    alertController.addAction(cancelAction)
                    self.present(alertController, animated: true)
                }
            }
        }
    }
    
    func loadMap() {
        let existingAnnotations = map.annotations.filter { !($0 is MKUserLocation) }
        map.removeAnnotations(existingAnnotations)

        var annotations: [UserAnnotation] = []
        var usersWithoutLocation: [String] = []
        var selectedAnnotation: UserAnnotation? = nil

        for deliveryMan in self.deliveryMans.users {
            let latitude = deliveryMan.location.location.getLatitude()
            let longitude = deliveryMan.location.location.getLongitude()

            if latitude == 0.0 && longitude == 0.0 {
                usersWithoutLocation.append("\(deliveryMan.name) \(deliveryMan.lastName)")
                continue
            }
            
            let point = UserAnnotation(user: deliveryMan)
            annotations.append(point)
            
            if self.deliveryManId == deliveryMan.id {
                selectedAnnotation = point
            }
        }

        if !usersWithoutLocation.isEmpty {
            let message = usersWithoutLocation.joined(separator: ", ") + " n'a pas activé sa géolocalisation."
            let alert = UIAlertController(title: "Géolocalisation désactivée", message: message, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default))
            self.present(alert, animated: true)
        }

        self.map.addAnnotations(annotations)
        
        if let annotation = selectedAnnotation {
                let region = MKCoordinateRegion(
                    center: annotation.coordinate,
                    latitudinalMeters: 1000,
                    longitudinalMeters: 1000
                )
                self.map.setRegion(region, animated: true)
            } else {
                self.map.showAnnotations(annotations, animated: true)
            }
    }

    
    func setupdeliveryMansMenu() {
        let defaultItem = UIAction(title: "Chargement...", attributes: .disabled, handler: { _ in })
        deliverymanPicker.menu = UIMenu(title: "Sélectionner un livreur", options: .displayInline, children: [defaultItem])
        deliverymanPicker.showsMenuAsPrimaryAction = true
        deliverymanPicker.changesSelectionAsPrimaryAction = true
    }
    
    func loadDeliveryMans() {
        userService.getAllDeliveryManLocations() { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let deliveryMans):
                    print(deliveryMans)
                    self.updateDeliveryManMenu(deliveryMans.users)
                    self.deliveryMans = deliveryMans
                case .failure(let error):
                    print(error.localizedDescription)
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
    }
    func updateDeliveryManMenu(_ deliveryMans: [UserWithLocationDTO]) {
        var menuItems: [UIAction] = [
            UIAction(
                title: "Tous",
                handler: { _ in
                    self.deliverymanPicker.setTitle("Tous", for: .normal)
                    self.deliveryManId = 0
                }
            )
        ]

        let deliveryManItems = deliveryMans.map { deliveryMan in
            UIAction(
                title: "\(deliveryMan.name) \(deliveryMan.lastName)",
                handler: { _ in
                    self.deliverymanPicker.setTitle("\(deliveryMan.name) \(deliveryMan.lastName)", for: .normal)
                    self.deliveryManId = deliveryMan.id
                }
            )
        }

        menuItems.append(contentsOf: deliveryManItems)

        if menuItems.count == 1 {
            menuItems.append(UIAction(title: "Aucun livreur disponible", attributes: .disabled, handler: { _ in }))
        }

        deliverymanPicker.menu = UIMenu(title: "Sélectionner un livreur", options: .displayInline, children: menuItems)
    }

    
}
extension MapViewController: MKMapViewDelegate {
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
           let _ = self.deliveryMans.users.first(where: { $0.location.location.getLatitude() == point.coordinate.latitude && $0.location.location.getLongitude() == point.coordinate.longitude }) {
            annotationView?.markerTintColor = .green
            annotationView?.glyphImage = UIImage(systemName: "person.fill")
        }
        
        return annotationView
    }
}
