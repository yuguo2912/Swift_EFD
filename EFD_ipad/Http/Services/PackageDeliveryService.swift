//
//

import Foundation

protocol PackageDeliveryServiceProtocol {
    func getAllDeliveries(completion: @escaping (Result<[PackageDeliveryDTO], Error>) -> Void)
}

class PackageDeliveryService: PackageDeliveryServiceProtocol {
    
    func getAllDeliveries(completion: @escaping (Result<[PackageDeliveryDTO], Error>) -> Void) {
        let urlString = "http://192.168.246.237:8000/package/byTour/1"  // 🔗 Remplace avec ton URL réelle
        guard let url = URL(string: urlString) else {
            completion(.failure(NSError(domain: "Invalid URL", code: 400, userInfo: nil)))
            return
        } 
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let data = data else {
                completion(.failure(NSError(domain: "No Data", code: 404, userInfo: nil)))
                return
            }
            
            if let jsonString = String(data: data, encoding: .utf8) {
                print(" Raw JSON Response: \(jsonString)")
            }
            
            do {
                let decoder = JSONDecoder()
                decoder.dateDecodingStrategy = .iso8601  // Pour gérer les dates en ISO 8601
                
                let deliveries = try decoder.decode([PackageDeliveryDTO].self, from: data)
                completion(.success(deliveries))
            } catch {
                completion(.failure(error))
            }
        }
        
        task.resume()
    }
}

