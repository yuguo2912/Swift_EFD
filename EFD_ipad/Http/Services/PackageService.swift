//
//  PackageService.swift
//  EFD_ipad
//
//  Created by Gil Rodrigues on 08/02/2025.
//

import Foundation

class PackageService: PackageProtocol {

    private static var instance: PackageService?
    
    private let packageURL: String = "http://localhost:8000/package/"
    private let tourURL: String = "http://localhost:8000/package/tour/"
    
    var tours: [AllToursDTO] = []
    var packages: [PackageDTO] = []
    
    class func getInstance() -> PackageService {
        if instance == nil {
            instance = PackageService()
        }
        return instance!
    }
    
    func getAllTours(completion: @escaping (Result<[AllToursDTO], any Error>) -> Void) {
        var request = URLRequest(url: URL(string: self.packageURL + "getAllTours")!)
        request.httpMethod = "GET"
        
        let dataTask = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("error")
                completion(.failure(error))
                return
            }
            if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode != 202 {
                if let data = data, let errorMessage = String(data: data, encoding: .utf8) {
                    print(data)
                    let httpError = NSError(domain: "", code: httpResponse.statusCode, userInfo: [NSLocalizedDescriptionKey: errorMessage])
                    completion(.failure(httpError))
                } else {
                    let genericError = NSError(domain: "", code: httpResponse.statusCode, userInfo: [NSLocalizedDescriptionKey: "Erreur inconnue"])
                    completion(.failure(genericError))
                }
            }
            
            guard let data = data else {
                print("Données vides reçues du serveur.")
                return
            }
            do {
                let tours: [AllToursDTO] = try JSONDecoder().decode([AllToursDTO].self, from: data)
                self.tours = tours
                print("success")
                completion(.success(tours))
            }catch {
                print("Erreur de décodage JSON : \(error.localizedDescription)")
                completion(.failure(error))
            }
        }
        dataTask.resume()
    }
    
    
    
    func deleteTour(tourId: Int, completion: @escaping (Result<Bool, any Error>) -> Void) {
        var request = URLRequest(url: URL(string: self.tourURL + tourId.description)!)
        request.httpMethod = "DELETE"
        
        let dataTask = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("error")
                completion(.failure(error))
                return
            }
            if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode != 202 {
                if let data = data, let errorMessage = String(data: data, encoding: .utf8) {
                    print(data)
                    let httpError = NSError(domain: "", code: httpResponse.statusCode, userInfo: [NSLocalizedDescriptionKey: errorMessage])
                    completion(.failure(httpError))
                } else {
                    let genericError = NSError(domain: "", code: httpResponse.statusCode, userInfo: [NSLocalizedDescriptionKey: "Erreur inconnue"])
                    completion(.failure(genericError))
                }
            }
            
            guard let data = data else {
                print("Données vides reçues du serveur.")
                return
            }
            do {
                let _: CommonSuccessResponse = try JSONDecoder().decode(CommonSuccessResponse.self, from: data)
                completion(.success(true))
            }catch {
                print("Erreur de décodage JSON : \(error.localizedDescription)")
                completion(.failure(error))
            }
        }
        dataTask.resume()
    }
    
    func deletePackage(packageId: Int, completion: @escaping (Result<Bool, any Error>) -> Void) {
        var request = URLRequest(url: URL(string: self.packageURL + packageId.description)!)
        request.httpMethod = "DELETE"
        
        let dataTask = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("error")
                completion(.failure(error))
                return
            }
            if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode != 202 {
                if let data = data, let errorMessage = String(data: data, encoding: .utf8) {
                    print(data)
                    let httpError = NSError(domain: "", code: httpResponse.statusCode, userInfo: [NSLocalizedDescriptionKey: errorMessage])
                    completion(.failure(httpError))
                } else {
                    let genericError = NSError(domain: "", code: httpResponse.statusCode, userInfo: [NSLocalizedDescriptionKey: "Erreur inconnue"])
                    completion(.failure(genericError))
                }
            }
            
            guard let data = data else {
                print("Données vides reçues du serveur.")
                return
            }
            do {
                let _: CommonSuccessResponse = try JSONDecoder().decode(CommonSuccessResponse.self, from: data)
                completion(.success(true))
            }catch {
                print("Erreur de décodage JSON : \(error.localizedDescription)")
                completion(.failure(error))
            }
        }
        dataTask.resume()
    }
    
    func editPackage(package: PackageDTO, completion: @escaping (Result<PackageDTO, any Error>) -> Void) {
        var request = URLRequest(url: URL(string: self.packageURL + package.packageId!.description)!)
        request.httpMethod = "PATCH"
        print(package)
        let isoFormatter = ISO8601DateFormatter()
        
        if let storedDate = isoFormatter.date(from: package.deliveryDate!) {
            let calendar = Calendar.current
            let storedComponents = calendar.dateComponents([.year, .month, .day], from: storedDate)
            
            if let finalDate = calendar.date(from: DateComponents(
                year: storedComponents.year,
                month: storedComponents.month,
                day: storedComponents.day,
                hour: 23,
                minute: 59
            )) {
                package.deliveryDate = isoFormatter.string(from: finalDate)
            }
        }
        
        let jsonData = try? JSONEncoder().encode(package)
        request.httpBody = jsonData
        
        let dataTask = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("error")
                completion(.failure(error))
                return
            }
            if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode != 202 {
                if let data = data, let errorMessage = String(data: data, encoding: .utf8) {
                    print(data)
                    let httpError = NSError(domain: "", code: httpResponse.statusCode, userInfo: [NSLocalizedDescriptionKey: errorMessage])
                    completion(.failure(httpError))
                } else {
                    let genericError = NSError(domain: "", code: httpResponse.statusCode, userInfo: [NSLocalizedDescriptionKey: "Erreur inconnue"])
                    completion(.failure(genericError))
                }
            }
            
            guard let data = data else {
                print("Données vides reçues du serveur.")
                return
            }
            do {
                let pack: PackageDTO = try JSONDecoder().decode(PackageDTO.self, from: data)
                print(pack)
                completion(.success(pack))
            } catch {
                print("Erreur de décodage JSON : \(error.localizedDescription)")
                completion(.failure(error))
            }
        }
        dataTask.resume()
    }

    
    func updateDeliveryStatus(deliveryStatus: UpdateDeliveryStatusDTO, completion: @escaping (Result<Bool, any Error>) -> Void) {
        var request: URLRequest = URLRequest(url: URL(string: self.packageURL + "setDeliveryStatus")!)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let jsonData = try? JSONEncoder().encode(deliveryStatus)
        request.httpBody = jsonData
        
            let task = URLSession.shared.dataTask(with: request) { data, response, error in
                
                if let error = error {
                    completion(.failure(error))
                    return
                }
                guard let httpResponse = response as? HTTPURLResponse, let data = data else {
                    completion(.failure(NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "Réponse invalide"])))
                    return
                }
                
                
                if let responseString = String(data: data, encoding: .utf8) {
                    print("Réponse brute du serveur: \(responseString)")
                }
                

                if httpResponse.statusCode == 400 {
                    let errorMessage = String(data: data, encoding: .utf8) ?? "Erreur inconnue"
                    print("Erreur API : \(errorMessage)")
                    completion(.failure(NSError(domain: "", code: 400, userInfo: [NSLocalizedDescriptionKey: errorMessage])))
                    return
                }
                
                
                do {
                    let successResponse = try JSONDecoder().decode(CommonSuccessResponse.self, from: data)
                    print("JSON décodé avec succès : \(successResponse.status ?? "null")")
                    completion(.success(true))
                } catch {
                    print(" Erreur de décodage JSON : \(error.localizedDescription)")
                    completion(.failure(error))
                }
                
            }
            task.resume()
    }
    
    func getPackagesByTourId(tourId: Int, completion: @escaping (Result<[PackageDTO], any Error>) -> Void) {
        var request = URLRequest(url: URL(string: self.packageURL + "byTour/" + tourId.description)!)
        request.httpMethod = "GET"
        print(tourId)
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("error")
                completion(.failure(error))
                return
            }
            if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode != 202 {
                if let data = data, let errorMessage = String(data: data, encoding: .utf8) {
                    print(data)
                    let httpError = NSError(domain: "", code: httpResponse.statusCode, userInfo: [NSLocalizedDescriptionKey: errorMessage])
                    completion(.failure(httpError))
                } else {
                    let genericError = NSError(domain: "", code: httpResponse.statusCode, userInfo: [NSLocalizedDescriptionKey: "Erreur inconnue"])
                    completion(.failure(genericError))
                }
            }
            
            guard let data = data else {
                print("Données vides reçues du serveur.")
                return
            }
            do {
                let packages: [PackageDTO] = try JSONDecoder().decode([PackageDTO].self, from: data)
                self.packages = packages
                completion(.success(packages))
            }catch {
                print("Erreur de décodage JSON : \(error.localizedDescription)")
                completion(.failure(error))
            }
        }
        task.resume()
    }
    
    func updateDeliveryManAssigned(updateAssignedToDTO: UpdateAssignedToDTO, completion: @escaping (Result<Bool, any Error>) -> Void) {
        var request = URLRequest(url: URL(string: self.packageURL + "assignTo")!)
        request.httpMethod = "PATCH"
        
        let jsonData = try? JSONEncoder().encode(updateAssignedToDTO)
        request.httpBody = jsonData
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            
            if let error = error {
                completion(.failure(error))
                return
            }
            guard let httpResponse = response as? HTTPURLResponse, let data = data else {
                completion(.failure(NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "Réponse invalide"])))
                return
            }
            
            
            if let responseString = String(data: data, encoding: .utf8) {
                print("Réponse brute du serveur: \(responseString)")
            }
            

            if httpResponse.statusCode == 400 {
                let errorMessage = String(data: data, encoding: .utf8) ?? "Erreur inconnue"
                print("Erreur API : \(errorMessage)")
                completion(.failure(NSError(domain: "", code: 400, userInfo: [NSLocalizedDescriptionKey: errorMessage])))
                return
            }
            
            
            do {
                let _ = try JSONDecoder().decode(CommonSuccessResponse.self, from: data)
                completion(.success(true))
            } catch {
                print(" Erreur de décodage JSON : \(error.localizedDescription)")
                completion(.failure(error))
            }
            
        }
        task.resume()
        
    }
}
