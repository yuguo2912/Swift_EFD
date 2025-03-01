import Foundation

class PackageService: PackageProtocol {
    
    private static var instance: PackageService?
    private let baseURL: String = "http://localhost:8000/package/"
    
    var tours: [AllToursDTO] = []
    
    class func getInstance() -> PackageService {
        if instance == nil {
            instance = PackageService()
        }
        return instance!
    }
    
    // ✅ Récupérer tous les tours
    func getAllTours(completion: @escaping (Result<[AllToursDTO], Error>) -> Void) {
        let urlString = "\(baseURL)getAllTours"
        self.performRequest(urlString: urlString, decodingType: [AllToursDTO].self) { result in
            switch result {
            case .success(let tours):
                self.tours = tours
                completion(.success(tours))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    // ✅ Récupérer les tours de l'utilisateur actuel
    func getToursForCurrentUser(completion: @escaping (Result<[TourByIDDTO], Error>) -> Void) {
        guard let userId = TokenManager.getInstance().getTokenClaims()?.id else {
            completion(.failure(NSError(domain: "", code: 400, userInfo: [NSLocalizedDescriptionKey: "❌ User ID non trouvé"])))
            return
        }
        
        let urlString = "\(baseURL)getTours/\(userId)"
        self.performRequest(urlString: urlString, decodingType: [TourByIDDTO].self, completion: completion)
    }
    
    // ✅ Récupérer les livraisons pour le tour en cours
    func getDeliveriesForCurrentTour(completion: @escaping (Result<[PackageDeliveryDTO], Error>) -> Void) {
        guard let tourId = Context.shared.tourId else {
            completion(.failure(NSError(domain: "❌ Tour ID manquant", code: 400, userInfo: nil)))
            return
        }
        
        let urlString = "\(baseURL)byTour/\(tourId)"
        self.performRequest(urlString: urlString, decodingType: [PackageDeliveryDTO].self, completion: completion)
    }
    
    // ✅ Méthode générique pour effectuer les requêtes
    private func performRequest<T: Decodable>(urlString: String, decodingType: T.Type, completion: @escaping (Result<T, Error>) -> Void) {
        guard let url = URL(string: urlString) else {
            completion(.failure(NSError(domain: "", code: 400, userInfo: [NSLocalizedDescriptionKey: "❌ URL invalide"])))
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        let dataTask = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 || httpResponse.statusCode == 202 else {
                let errorMessage = data.flatMap { String(data: $0, encoding: .utf8) } ?? "Erreur inconnue"
                completion(.failure(NSError(domain: "", code: 500, userInfo: [NSLocalizedDescriptionKey: errorMessage])))
                return
            }
            
            guard let data = data else {
                completion(.failure(NSError(domain: "", code: 500, userInfo: [NSLocalizedDescriptionKey: "❌ Aucune donnée reçue"])))
                return
            }
            
            do {
                let decodedData = try JSONDecoder().decode(decodingType, from: data)
                completion(.success(decodedData))
            } catch {
                completion(.failure(error))
            }
        }
        
        dataTask.resume()
    }
}
