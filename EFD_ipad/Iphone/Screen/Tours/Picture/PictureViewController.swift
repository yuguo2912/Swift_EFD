//
//  CameraViewController.swift
//  MultimediaDiscovery
//
//  Created by Benoit Briatte on 04/02/2025.
//

import UIKit
import CoreLocation
class PictureViewController: UIViewController, CLLocationManagerDelegate {
    
    @IBOutlet weak var selectedImageView: UIImageView!
    
    var package: PackageDeliveryDTO? // L'objet du colis à livrer
    let locationManager = CLLocationManager()
    var userLocation: CLLocation?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Camera"
        self.navigationItem.rightBarButtonItems = [
            UIBarButtonItem(barButtonSystemItem: .camera, target: self, action: #selector(handleCamera)),
            UIBarButtonItem(barButtonSystemItem: .bookmarks, target: self, action: #selector(handleLibrary))
        ]
        
        setupLocationManager()
    }
    
    func setupLocationManager() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        userLocation = locations.last
    }
    
    @objc func handleCamera() {
        guard UIImagePickerController.isSourceTypeAvailable(.camera) else { return }
        
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

extension PictureViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true)
        guard let image = info[.editedImage] as? UIImage else {
            return
        }
        
        self.selectedImageView.image = image
        validateDelivery(with: image) // 🔥 Validation après la prise de photo
    }
    
    private func validateDelivery(with image: UIImage) {
        guard let package = package else {
            showAlert(title: "Erreur", message: "Aucun colis sélectionné")
            return
        }
        
        guard let userLocation = userLocation else {
            showAlert(title: "Erreur", message: "Impossible d'obtenir votre position GPS")
            return
        }
        
        guard let deliveryLat = package.location?.getLatitude(),
              let deliveryLon = package.location?.getLongitude() else {
            showAlert(title: "Erreur", message: "Coordonnées du colis introuvables")
            return
        }
        
        let deliveryLocation = CLLocation(latitude: deliveryLat, longitude: deliveryLon)
        let distance = userLocation.distance(from: deliveryLocation) // Distance en mètres
        
        if distance > 200 {
            showAlert(title: "Erreur", message: "Vous devez être à moins de 200m du point de livraison.")
            return
        }
        
        sendDeliveryProof(image, package: package)
    }
    
    private func sendDeliveryProof(_ image: UIImage, package: PackageDeliveryDTO) {
        let urlString = "http://localhost:8000/package/setDeliveryProof/\(package.packageId)"
        guard let url = URL(string: urlString) else {
            showAlert(title: "Erreur", message: "URL invalide")
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        
        let boundary = UUID().uuidString
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        
        guard let imageData = image.jpegData(compressionQuality: 0.8) else {
            showAlert(title: "Erreur", message: "Impossible de compresser l'image")
            return
        }
        
        var body = Data()
        body.append("--\(boundary)\r\n".data(using: .utf8)!)
        body.append("Content-Disposition: form-data; name=\"image\"; filename=\"proof.jpg\"\r\n".data(using: .utf8)!)
        body.append("Content-Type: image/jpeg\r\n\r\n".data(using: .utf8)!)
        body.append(imageData)
        body.append("\r\n--\(boundary)--\r\n".data(using: .utf8)!)
        
        request.httpBody = body
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            DispatchQueue.main.async {
                if let error = error {
                    self.showAlert(title: "Erreur", message: "Problème d'upload : \(error.localizedDescription)")
                    return
                }
                
                guard let httpResponse = response as? HTTPURLResponse else {
                    self.showAlert(title: "Erreur", message: "Réponse serveur invalide")
                    return
                }
                
                if httpResponse.statusCode == 200 {
                    self.updateDeliveryStatus(package: package)
                } else {
                    self.showAlert(title: "Erreur", message: "Upload échoué avec code \(httpResponse.statusCode)")
                }
            }
        }
        
        task.resume()
    }
    
    private func updateDeliveryStatus(package: PackageDeliveryDTO) {
        let urlString = "http://localhost:8000/package/setDeliveryStatus"
        guard let url = URL(string: urlString) else {
            showAlert(title: "Erreur", message: "URL invalide pour la mise à jour du statut")
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let jsonBody: [String: Any] = [
            "packageId": package.packageId,
            "status": "delivered"
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
                    self.showAlert(title: "Erreur", message: "Problème lors de la mise à jour du statut : \(error.localizedDescription)")
                    return
                }
                
                guard let httpResponse = response as? HTTPURLResponse else {
                    self.showAlert(title: "Erreur", message: "Réponse invalide du serveur")
                    return
                }
                
                if httpResponse.statusCode == 200 {
                    self.showAlert(title: "Succès", message: "Colis livré avec succès !")
                    NotificationCenter.default.post(name: NSNotification.Name("PackageDelivered"), object: package.packageId)
                } else {
                    self.showAlert(title: "Erreur", message: "Erreur \(httpResponse.statusCode) : Échec de mise à jour")
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
