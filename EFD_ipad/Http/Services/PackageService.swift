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
    
}
