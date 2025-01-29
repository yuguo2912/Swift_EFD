import Foundation

class HttpConnexionService {
    private static var instance: HttpConnexionService!
    private let apiProvider = APIProvider.shared // Injection du provider

    class func getInstance() -> HttpConnexionService {
        if self.instance == nil {
            self.instance = HttpConnexionService()
        }
        return self.instance
    }

    // 🔥 Authentification & récupération du token
    func login(mail: String, password: String, completion: @escaping (Bool) -> Void) {
        guard let url = URL(string: "http://localhost:8000/auth/login") else {
            completion(false)
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        let body: [String: Any] = ["mail": mail, "password": password]
        request.httpBody = try? JSONSerialization.data(withJSONObject: body)

        apiProvider.session.dataTask(with: request) { data, response, error in
            guard let data = data else {
                DispatchQueue.main.async { completion(false) }
                return
            }

            do {
                if let json = try JSONSerialization.jsonObject(with: data) as? [String: Any],
                   let token = json["token"] as? String {

                    // 🔥 Stocker le token et le fournir à l'intercepteur
                    UserDefaults.standard.setValue(token, forKey: "auth_token")
                    AuthenthicatedURLProtocol.tokenProvider = { token }

                    DispatchQueue.main.async { completion(true) }
                } else {
                    DispatchQueue.main.async { completion(false) }
                }
            } catch {
                DispatchQueue.main.async { completion(false) }
            }
        }.resume()
    }
}
