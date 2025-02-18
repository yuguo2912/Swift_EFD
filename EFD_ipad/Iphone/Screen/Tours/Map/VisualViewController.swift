//
//  VisualViewController.swift
//  EFD_ipad
//
//  Created by Hugo Arnaudeau on 12/02/2025.
//

import UIKit
import MapKit
import CoreLocation

class VisualViewController: UIViewController {
    
    @IBOutlet weak var deliveryMapView: MKMapView!
    @IBOutlet weak var errorLocationView: UIView!
    @IBOutlet weak var errorLocationLabel: UILabel!
    @IBOutlet weak var errorLocationButton: UIButton!
    
    var deliveries: [PackageDeliveryDTO] = [] {
        didSet {
            self.reloadMap()
        }
    }
    
    let deliveryService = PackageDeliveryService() // 🔥 Correction ici
    var locationManager: CLLocationManager!
    var currentDeliver: User?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initErrorLocationView()
        self.initLocations()
        self.deliveryMapView.delegate = self
        
        if let savedUserData = UserDefaults.standard.data(forKey: "currentUser"),
           let user = try?JSONDecoder().decode(User.self, from: savedUserData){
            self.currentDeliver = user
            
        } else {
            print(" ")
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchDeliveriesForCurrentUser()
    }
    
    // ✅ Configuration de l'alerte de permission de localisation
    func initErrorLocationView() {
        self.errorLocationView.layer.cornerRadius = 30
        self.errorLocationLabel.text = "La localisation est désactivée. Activez-la dans les paramètres."
        self.errorLocationButton.setTitle("Paramètres", for: .normal)
        self.errorLocationView.isHidden = true
    }
    
    // ✅ Initialisation de la localisation
    func initLocations() {
        self.locationManager = CLLocationManager()
        self.locationManager.delegate = self
        if self.locationManager.authorizationStatus == .notDetermined {
            self.locationManager.requestWhenInUseAuthorization()
        } else {
            self.handleStatusUpdate(locationManager: self.locationManager)
        }
    }
    
    // ✅ Gestion des permissions de localisation
    func handleStatusUpdate(locationManager: CLLocationManager) {
        if locationManager.authorizationStatus == .restricted || locationManager.authorizationStatus == .denied {
            self.errorLocationView.isHidden = false
        } else if locationManager.authorizationStatus == .authorizedWhenInUse {
            self.errorLocationView.isHidden = true
            locationManager.startUpdatingLocation()
        }
    }
    
    // ✅ Récupération des livraisons pour le livreur connecté
    private func fetchDeliveriesForCurrentUser() {
        /*guard let userID = currentDeliver?.id else{
            
            print("⚠️ Aucun userID trouvé. Impossible de récupérer les livraisons.")
            return
        }*/
        
        deliveryService.getAllDeliveries { [weak self] result in
            DispatchQueue.main.async {
                guard let self = self else { return }
                
                switch result {
                case .success(let allDeliveries):
                    print("JSON reçu: \(allDeliveries)")
                    self.deliveries = allDeliveries // 🔥 Affiche tous les colis
                    if self.deliveries.isEmpty {
                        self.showNoDeliveriesAlert()
                    }
                    
                case .failure(let error):
                    print("Erreur de parsing JSON: \(error.localizedDescription)")
                    self.showErrorAlert(error)
                }
            }
        }
    }
    
    // ✅ Afficher une alerte si aucune livraison trouvée
    private func showNoDeliveriesAlert() {
        let alert = UIAlertController(title: "Aucune livraison", message: "Aucune livraison n'est assignée à votre compte.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true)
    }
    
    // ✅ Gestion des erreurs API
    private func showErrorAlert(_ error: Error) {
        let alert = UIAlertController(title: "Erreur", message: error.localizedDescription, preferredStyle: .alert)
        let retryAction = UIAlertAction(title: "Réessayer", style: .default) { _ in
            self.fetchDeliveriesForCurrentUser()
        }
        let cancelAction = UIAlertAction(title: "Annuler", style: .cancel, handler: nil)
        
        alert.addAction(retryAction)
        alert.addAction(cancelAction)
        present(alert, animated: true)
    }
    
    // ✅ Mise à jour de la carte avec les livraisons
    func reloadMap() {
        self.deliveryMapView.removeAnnotations(self.deliveryMapView.annotations) // Nettoie la carte
        
        let annotations = self.deliveries.compactMap { delivery -> MKPointAnnotation? in
            guard let location = delivery.location else { return nil } // Vérifie si une location existe
            
            let annotation = MKPointAnnotation()
            annotation.title = "Colis \(delivery.packageId)"
            annotation.coordinate = CLLocationCoordinate2D(latitude: location.getLatitude(), longitude: location.getLongitude())
            return annotation
        }
        
        self.deliveryMapView.addAnnotations(annotations)
        self.deliveryMapView.showAnnotations(self.deliveryMapView.annotations, animated: true)
    }

    // ✅ Ouvrir les paramètres de localisation
    @IBAction func handleLocationSettings(_ sender: UIButton) {
        if let settingURL = URL(string: UIApplication.openSettingsURLString) {
            UIApplication.shared.open(settingURL)
        }
    }
}

// ✅ Extension pour gérer les interactions avec la carte
extension VisualViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        guard let annotationCoordinate = view.annotation?.coordinate,
              let userLocation = mapView.userLocation.location else {
            return
        }
        
        let annotationLocation = CLLocation(latitude: annotationCoordinate.latitude, longitude: annotationCoordinate.longitude)
        let distance = annotationLocation.distance(from: userLocation)
        print("Distance au point de livraison: \(distance) mètres")
    }
}

// ✅ Gestion des mises à jour de localisation
extension VisualViewController: CLLocationManagerDelegate {
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        self.handleStatusUpdate(locationManager: manager)
    }
}
