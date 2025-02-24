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
    
        let isoFormatter = ISO8601DateFormatter()
        let now = Date()
        let calendar = Calendar.current
            
        if let storedDate = isoFormatter.date(from: package.deliveryDate!) {
            let storedComponents = calendar.dateComponents([.year, .month, .day], from: storedDate)
            let nowComponents = calendar.dateComponents([.hour, .minute], from: calendar.date(byAdding: .minute, value: 10, to: now)!)
                  
            if let finalDate = calendar.date(from: DateComponents(
                year: storedComponents.year,
                month: storedComponents.month,
                day: storedComponents.day,
                hour: nowComponents.hour,
                minute: nowComponents.minute
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
                completion(.success(pack))
            }catch {
                print("Erreur de décodage JSON : \(error.localizedDescription)")
                completion(.failure(error))
            }
        }
        dataTask.resume()
    }
}
