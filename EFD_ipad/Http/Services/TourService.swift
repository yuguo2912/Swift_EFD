import Foundation

class TourService {
    
    private static var instance: TourService?
    private let baseURL: String = "http://localhost:8000/package/getTours/"
    
    var tours: [TourByIDDTO] = []
    
    class func getInstance() -> TourService {
        if instance == nil {
            instance = TourService()
        }
        return instance!
    }
    
    func getToursForCurrentUser( completion: @escaping (Result<[TourByIDDTO], Error>) -> Void) {
        guard let userId = TokenManager.getInstance().getTokenClaims()?.id else {
            completion(.failure(NSError(domain: "", code: 400, userInfo: [NSLocalizedDescriptionKey: "❌ User ID non trouvé dans le contexte"])))
            return
        }
        
        let urlString = "\(baseURL)\(userId)"  // Ajout correct de l'ID dans l'URL
        guard let url = URL(string: urlString) else {  // Ici on utilise urlString et non baseURL
            completion(.failure(NSError(domain: "", code: 400, userInfo: [NSLocalizedDescriptionKey: "❌ URL invalide"])))
            return
        }

        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        let dataTask = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("❌ Erreur réseau :", error.localizedDescription)
                completion(.failure(error))
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 ||
                    httpResponse.statusCode == 202 else {
                let errorMessage = data.flatMap { String(data: $0, encoding: .utf8) } ?? "Erreur inconnue"
                completion(.failure(NSError(domain: "", code: 500, userInfo: [NSLocalizedDescriptionKey: errorMessage])))
                return
            }
            
            guard let data = data else {
                print("❌ Données vides reçues du serveur.")
                completion(.failure(NSError(domain: "", code: 500, userInfo: [NSLocalizedDescriptionKey: "Aucune donnée reçue"])))
                return
            }
            
            do {
                let tours = try JSONDecoder().decode([TourByIDDTO].self, from: data)
                self.tours = tours
                print("✅ Succès - Tours récupérés :", tours)
                completion(.success(tours))
            } catch {
                print("❌ Erreur de décodage JSON :", error.localizedDescription)
                completion(.failure(error))
            }
        }
        dataTask.resume()
    }
}
