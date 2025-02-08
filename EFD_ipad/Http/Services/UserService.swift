//
//  UserService.swift
//  EFD_ipad
//
//  Created by Gil Rodrigues on 07/02/2025.
//

import Foundation

class UserService: UserProtocol {
        
    private static var instance: UserService?
    
    private static let userURL: String = "http://localhost:8000/user/"
    private static let getUserLocationURL: String = "http://localhost:8000/user/getLocation/"
    private static let setUserLocationURL: String = "http://localhost:8000/user/setLocation/"
    
    private var user: User?
    private var checkedUser: User?
    
    class func getInstance() -> UserService {
        if self.instance == nil {
            self.instance = UserService()
        }
        return self.instance!
    }
    
    
    
    func getUserById(id: Int, completion: @escaping (Result<User, Error>) -> Void) {
        var request: URLRequest = URLRequest(url: URL(string: UserService.userURL + String(id))!)
        request.httpMethod = "GET"
        let dataTask = URLSession.shared.dataTask(with: request) { data, response, error in
            
            if let error = error {
                print("Erreur réseau : \(error.localizedDescription)")
                completion(.failure(error))
                return
            }
            
            if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode != 200 {
                print("Erreur HTTP : \(httpResponse.statusCode)")
                return
            }
            
            guard let data = data else {
                print("Données vides reçues du serveur.")
                return
            }
            
            do {
                let response = try JSONDecoder().decode(User.self, from: data)
                self.user = response
                completion(.success(self.user!))
            } catch {
                print("Erreur de décodage JSON : \(error.localizedDescription)")
                completion(.failure(error))
            }
        }
        dataTask.resume()
    }
    
    func editUserById(id: Int, user: User, completion: @escaping (Result<Bool, any Error>) -> Void) {
        return
    }
    
    func deleteUserById(id: Int, completion: @escaping (Result<Bool, any Error>) -> Void) {
        return
    }
    
    func getUserLocationById(id: Int, completion: @escaping (Result<Coordinates, any Error>) -> Void) {
        return
    }
    
    func setUserLocationById(id: Int, coordinates: Coordinates, completion: @escaping (Result<Bool, any Error>) -> Void) {
        return
    }
}
