//
//  AdminService.swift
//  EFD_ipad
//
//  Created by Gil Rodrigues on 08/02/2025.
//

import Foundation

class AdminService: AdminProtocol {
    
    private static var instance: AdminService?
    
    private let adminURL: String = "http://localhost:8000/admin/"
    
    private var deliveryMans: [User] = []
    
    var admin: User?
    
    class func getInstance() -> AdminService {
        if instance == nil {
            instance = AdminService()
        }
        return instance!
    }
    
    func getDeliveryMans(completion: @escaping (Result<[User], any Error>) -> Void) {
        var request: URLRequest = URLRequest(url: URL(string: self.adminURL)!)
        request.httpMethod = "GET"
        request.setValue("Bearer \(TokenManager.getInstance().getToken() ?? UserDefaults.standard.string(forKey: "token") ?? "")", forHTTPHeaderField: "Authorization")
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            
            if let error = error {
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
                let users: UsersDTO = try JSONDecoder().decode(UsersDTO.self, from: data)
                self.deliveryMans = users.users
                completion(.success(users.users))
            }catch {
                print("Erreur de décodage JSON : \(error.localizedDescription)")
                completion(.failure(error))
            }
        }
        task.resume()
    }
    
    func createDeliveryMan(user: User, completion: @escaping (Result<Bool, any Error>) -> Void) {
        return completion(.success(true))
    }
    
    
}
