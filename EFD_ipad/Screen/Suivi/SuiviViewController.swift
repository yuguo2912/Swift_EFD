//
//  SuiviViewController.swift
//  EFD_ipad
//
//  Created by Hugo Arnaudeau on 24/12/2024.
//

import UIKit
import MapKit
import CoreLocation

class SuiviViewController: UIViewController {

    @IBOutlet weak var livreurLocation: MKMapView!
    

    var livreurs: [Livreur] = [] {
        didSet {
            self.reloadMap()
        }
    }

    var livreurService: EFDService {
        return DependencyModule.getInstance().livreurservice
    }

    var locationManager: CLLocationManager!
    var timer: Timer? // Timer pour mise à jour en temps réel

    override func viewDidLoad() {
        super.viewDidLoad()
        self.livreurLocation.delegate = self
        self.livreurLocation.showsUserLocation = true // Affiche la position actuelle de l'utilisateur
        self.initLocationManager()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Récupérer les livreurs depuis le service
        self.livreurService.getAllLivreur { livreurs in
            self.livreurs = livreurs
        }
        
        // Lancer un timer pour actualiser les positions toutes les 5 secondes
        self.timer = Timer.scheduledTimer(timeInterval: 5.0, target: self, selector: #selector(updateLivreurPositions), userInfo: nil, repeats: true)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.timer?.invalidate() // Arrêter le timer pour éviter des fuites de mémoire
    }

    // Initialisation du LocationManager
    func initLocationManager() {
        self.locationManager = CLLocationManager()
        self.locationManager.delegate = self
        self.locationManager.requestWhenInUseAuthorization()
        self.locationManager.startUpdatingLocation()
    }

    // Met à jour les annotations sur la carte
    func reloadMap() {
        let annotations = self.livreurs.compactMap { livreur -> MKPointAnnotation? in
            guard let location = livreur.location else { return nil }
            let point = MKPointAnnotation()
            point.title = "\(livreur.nom) \(livreur.prenom)"
            point.subtitle = "Âge: \(livreur.age)"
            point.coordinate = location
            return point
        }
        
        self.livreurLocation.removeAnnotations(self.livreurLocation.annotations)
        self.livreurLocation.addAnnotations(annotations)
        self.livreurLocation.showAnnotations(annotations, animated: true)
    }

    // Mise à jour des positions des livreurs en temps réel
    @objc func updateLivreurPositions() {
        for livreur in livreurs {
            guard let currentLocation = livreur.location else { continue }
            
            // Simuler un déplacement aléatoire du livreur
            let newLatitude = currentLocation.latitude + Double.random(in: -0.0005...0.0005)
            let newLongitude = currentLocation.longitude + Double.random(in: -0.0005...0.0005)
            
            livreur.location = CLLocationCoordinate2D(latitude: newLatitude, longitude: newLongitude)
        }
        
        // Recharger les annotations sur la carte
        self.reloadMap()
    }
}

extension SuiviViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        guard let annotationCoordinate = view.annotation?.coordinate,
              let userLocation = mapView.userLocation.location else {
            return
        }
        let annotationLocation = CLLocation(latitude: annotationCoordinate.latitude, longitude: annotationCoordinate.longitude)
        let distance = annotationLocation.distance(from: userLocation)
        print("Distance depuis l'utilisateur : \(distance) mètres")
    }
}

extension SuiviViewController: CLLocationManagerDelegate {
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        if manager.authorizationStatus == .authorizedWhenInUse || manager.authorizationStatus == .authorizedAlways {
            self.locationManager.startUpdatingLocation()
        } else {
            print("Localisation désactivée ou non autorisée")
        }
    }
}
