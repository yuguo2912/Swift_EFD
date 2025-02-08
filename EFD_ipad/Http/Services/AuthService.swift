import Foundation

class AuthService: AuthProtocol {
    
    private static var instance: AuthService?
    private let loginUrl: String = "http://localhost:8000/auth/login"
    private var token: String?
    
    class func getInstance() -> AuthService {
        if self.instance == nil {
            self.instance = AuthService()
        }
        return self.instance!
    }
    
    func login(loginDto loginDTO: LoginDTO, completion: @escaping (Result<String, Error>) -> Void) {
        
        let dataToSend: [String: Any] = [
            "mail": loginDTO.mail,
            "password": loginDTO.password
        ]
        
        guard let jsonData = try? JSONSerialization.data(withJSONObject: dataToSend) else {
            print("Erreur de sérialisation des données.")
            return
        }
        
        var request = URLRequest(url: URL(string: loginUrl)!)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = jsonData
        
        let dataTask = URLSession.shared.dataTask(with: request) { data, response, error in
            
            if let error = error {
                print("Erreur réseau : \(error.localizedDescription)")
                completion(.failure(error))
                return
            }
            
            if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode != 200 {
                    print("Erreur HTTP : \(httpResponse.statusCode)")
                        
                    if let data = data, let errorMessage = String(data: data, encoding: .utf8) {
                    
                        let httpError = NSError(domain: "", code: httpResponse.statusCode, userInfo: [NSLocalizedDescriptionKey: errorMessage])
                        completion(.failure(httpError))
                    } else {
                        let genericError = NSError(domain: "", code: httpResponse.statusCode, userInfo: [NSLocalizedDescriptionKey: "Erreur inconnue"])
                        completion(.failure(genericError))
                    }
                    return
            }
            
            guard let data = data else {
                print("Données vides reçues du serveur.")
                return
            }
            
            do {
                let authResponse = try JSONDecoder().decode(AuthDTO.self, from: data)
                self.token = authResponse.token  // Stockage du token
                completion(.success(authResponse.token))
            } catch {
                print("Erreur de décodage JSON : \(error.localizedDescription)")
                completion(.failure(error))
            }
        }
        dataTask.resume()
    }

    
    func getToken() -> String? {
        return token
    }
    
    func logout() {
        self.token = nil
    }
}
