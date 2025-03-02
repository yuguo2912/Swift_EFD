//
//  UserService.swift
//  EFD_ipad
//
//  Created by Gil Rodrigues on 07/02/2025.
//

import Foundation

class UserService: UserProtocol {
        
    private static var instance: UserService?
    
    private let userURL: String = "http://localhost:8000/user/"
    private let getUserLocationURL: String = "http://localhost:8000/user/getLocation/"
    private let setUserLocationURL: String = "http://localhost:8000/user/setLocation/"
    private let getAllDeliveryManLocationsURL: String = "http://localhost:8000/user/getAllLocations/"
    
    var user: User?
    private var checkedUser: User?
    
    class func getInstance() -> UserService {
        if self.instance == nil {
            self.instance = UserService()
        }
        return self.instance!
    }
    
    func getUserById(id: Int, completion: @escaping (Result<User, Error>) -> Void) {
        var request: URLRequest = URLRequest(url: URL(string: self.userURL + id.description)!)
        request.httpMethod = "GET"
        let dataTask = URLSession.shared.dataTask(with: request) { data, response, error in
            
            if let error = error {
                print("Erreur réseau : \(error.localizedDescription)")
                completion(.failure(error))
                return
            }
            
            if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode != 202 {
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
        var request: URLRequest = URLRequest(url: URL(string: self.userURL + id.description)!)
        guard let jsonData = try? JSONSerialization.data(withJSONObject: user.toDictionary()) else {
            print("Erreur de sérialisation des données.")
            return
        }
        
        request.httpMethod = "PATCH"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = jsonData
        
        let dataTask = URLSession.shared.dataTask(with: request) { (data, response, error) in
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
            
            guard data != nil else {
                print("Données vides reçues du serveur.")
                return
            }
            
            do {
                completion(.success(true))
            }
        }
        dataTask.resume()
    }
    
    func deleteUserById(id: Int, completion: @escaping (Result<Bool, any Error>) -> Void) {
        return
    }
    
    func getUserLocationById(id: Int, completion: @escaping (Result<UserLocationDTO, any Error>) -> Void) {
        var request = URLRequest(url: URL(string: self.getUserLocationURL + id.description)!)
        request.httpMethod = "GET"
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
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
                let userLocation: UserLocationDTO = try JSONDecoder().decode(UserLocationDTO.self, from: data)
                print("success")
                completion(.success(userLocation))
            }catch {
                completion(.failure(error))
            }
        }
        task.resume()
    }
    
    func setUserLocationById(id: Int, coordinates: Coordinates, completion: @escaping (Result<Bool, any Error>) -> Void) {
        return
    }
    
    func getAllDeliveryManLocations(completion: @escaping (Result<UserWithLocationListDTO, any Error>) -> Void) {
        var request = URLRequest(url: URL(string: self.getAllDeliveryManLocationsURL)!)
        request.httpMethod = "GET"
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
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
                let usersLocations: UserWithLocationListDTO = try JSONDecoder().decode(UserWithLocationListDTO.self, from: data)
                print("success")
                completion(.success(usersLocations))
            }catch {
                completion(.failure(error))
            }
        }
        task.resume()
    }
    
    func changePassword(changePasswordDTO: ChangePasswordDTO, completion: @escaping (Result<Bool, any Error>) -> Void) {
        var request = URLRequest(url: URL(string: self.userURL + "changePassword")!)
        request.httpMethod = "POST"
        
        let jsonData = try? JSONEncoder().encode(changePasswordDTO)
        request.httpBody = jsonData
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            guard let httpResponse = response as? HTTPURLResponse, let data = data else {
                completion(.failure(NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "Réponse invalide"])))
                return
            }
            
            
            if let responseString = String(data: data, encoding: .utf8) {
                print("Réponse brute du serveur: \(responseString)")
            }
            

            if httpResponse.statusCode == 400 {
                let errorMessage = String(data: data, encoding: .utf8) ?? "Erreur inconnue"
                print("Erreur API : \(errorMessage)")
                completion(.failure(NSError(domain: "", code: 400, userInfo: [NSLocalizedDescriptionKey: errorMessage])))
                return
            }
            
            
            do {
                let successResponse = try JSONDecoder().decode(CommonSuccessResponse.self, from: data)
                completion(.success(true))
            } catch {
                completion(.failure(error))
            }
        }
        task.resume()
    }
}
