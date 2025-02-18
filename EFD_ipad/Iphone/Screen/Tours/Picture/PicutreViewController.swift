//
//  CameraViewController.swift
//  MultimediaDiscovery
//
//  Created by Benoit Briatte on 04/02/2025.
//

import UIKit
import CoreLocation
class PicutreViewController: UIViewController, CLLocationManagerDelegate {

    @IBOutlet weak var selectedImageView: UIImageView!
    
    var tourID: Int? // ID de la tournée à valider
        var deliveryLatitude: Double? // Latitude du point de livraison
        var deliveryLongitude: Double? // Longitude du point de livraison
        
        let locationManager = CLLocationManager() // Gestionnaire de localisation
        var userLocation: CLLocation? // Stocke la localisation actuelle de l'utilisateur

        override func viewDidLoad() {
            super.viewDidLoad()
            self.title = "Camera"
            self.navigationItem.rightBarButtonItems = [
                UIBarButtonItem(barButtonSystemItem: .camera, target: self, action: #selector(handleCamera)),
                UIBarButtonItem(barButtonSystemItem: .bookmarks, target: self, action: #selector(handleLibrary))
            ]
            
            setupLocationManager() // Initialisation du GPS
        }
        
        func setupLocationManager() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.requestWhenInUseAuthorization() // Demande d'autorisation GPS
            locationManager.startUpdatingLocation() // Démarrer la mise à jour de la localisation
        }
        
        // Récupération de la localisation actuelle
        func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
            userLocation = locations.last
        }
        
        @objc func handleCamera() {
            guard UIImagePickerController.isSourceTypeAvailable(.camera) else {
                return
            }
            let picker = UIImagePickerController()
            picker.sourceType = .camera
            picker.delegate = self
            picker.allowsEditing = true
            self.present(picker, animated: true)
        }
        
        @objc func handleLibrary() {
            let picker = UIImagePickerController()
            picker.sourceType = .photoLibrary
            picker.delegate = self
            picker.allowsEditing = true
            self.present(picker, animated: true)
        }
    }

    extension PicutreViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            picker.dismiss(animated: true) // Ferme l'image picker
            guard let image = info[.editedImage] as? UIImage else {
                return
            }
            
            self.selectedImageView.image = image
            validateTour() // Appel pour valider la tournée
        }
        
        private func validateTour() {
            guard let tourID = tourID else {
                showAlert(title: "Erreur", message: "Aucune tournée sélectionnée")
                return
            }
            
            guard let userLocation = userLocation else {
                showAlert(title: "Erreur", message: "Impossible d'obtenir votre position GPS")
                return
            }
            
            guard let deliveryLat = deliveryLatitude, let deliveryLon = deliveryLongitude else {
                showAlert(title: "Erreur", message: "Coordonnées de la livraison introuvables")
                return
            }
            
            // Vérifier la distance entre l'utilisateur et le point de livraison
            let deliveryLocation = CLLocation(latitude: deliveryLat, longitude: deliveryLon)
            let distance = userLocation.distance(from: deliveryLocation) // Distance en mètres

            if distance > 200 {
                showAlert(title: "Erreur", message: "Vous devez être à moins de 200m du point de livraison pour valider.")
                return
            }
            
            let urlString = "http://localhost:8000/package/setDeliveryStatus"
            guard let url = URL(string: urlString) else {
                showAlert(title: "Erreur", message: "URL invalide")
                return
            }
            
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")

            // Corps de la requête JSON
            let jsonBody: [String: Any] = [
                "tourID": tourID,
                "status": "validated",
                "latitude": userLocation.coordinate.latitude,
                "longitude": userLocation.coordinate.longitude
            ]
            
            do {
                request.httpBody = try JSONSerialization.data(withJSONObject: jsonBody, options: [])
            } catch {
                showAlert(title: "Erreur", message: "Impossible de créer le JSON")
                return
            }
            
            let task = URLSession.shared.dataTask(with: request) { data, response, error in
                DispatchQueue.main.async {
                    if let error = error {
                        self.showAlert(title: "Erreur", message: "Problème de connexion : \(error.localizedDescription)")
                        return
                    }
                    
                    guard let httpResponse = response as? HTTPURLResponse else {
                        self.showAlert(title: "Erreur", message: "Réponse invalide du serveur")
                        return
                    }
                    
                    if httpResponse.statusCode == 200 {
                        self.showAlert(title: "Succès", message: "Tournée validée avec succès 🎉")
                    } else {
                        self.showAlert(title: "Erreur", message: "Erreur \(httpResponse.statusCode) : Impossible de valider la tournée")
                    }
                }
            }
            
            task.resume()
        }
        
        private func showAlert(title: String, message: String) {
            let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default))
            self.present(alert, animated: true)
        }
    }
