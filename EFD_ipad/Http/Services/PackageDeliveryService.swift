import Foundation

/*protocol PackageDeliveryServiceProtocol {
    func getDeliveriesForCurrentTour(completion: @escaping (Result<[PackageDeliveryDTO], Error>) -> Void)
}*/

class PackageDeliveryService {
    
    private let baseURL: String = "http://localhost:8000/package/byTour/"
    
    func getDeliveriesForCurrentTour(completion: @escaping (Result<[PackageDeliveryDTO], Error>) -> Void) {
        guard let tourId = Context.shared.tourId else {
            completion(.failure(NSError(domain: "❌ Tour ID manquant", code: 400, userInfo: nil)))
            return
        }
        
        let urlString = "\(baseURL)\(tourId)"  // 🔹 Utilisation dynamique de l'ID du tour
        guard let url = URL(string: urlString) else {
            completion(.failure(NSError(domain: "❌ URL invalide", code: 400, userInfo: nil)))
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 || httpResponse.statusCode == 202 else {
                let errorMessage = data.flatMap { String(data: $0, encoding: .utf8) } ?? "Erreur inconnue"
                completion(.failure(NSError(domain: "❌ Erreur serveur", code: 500, userInfo: [NSLocalizedDescriptionKey: errorMessage])))
                return
            }
            
            guard let data = data else {
                completion(.failure(NSError(domain: "❌ Aucune donnée reçue", code: 404, userInfo: nil)))
                return
            }
            
            if let jsonString = String(data: data, encoding: .utf8) {
                print("Raw JSON Response: \(jsonString)")
            }
            
            do {
                let decoder = JSONDecoder()
                decoder.dateDecodingStrategy = .iso8601
                
                let deliveries = try decoder.decode([PackageDeliveryDTO].self, from: data)
                completion(.success(deliveries))
            } catch {
                completion(.failure(error))
            }
        }
        
        task.resume()
    }
}
