//
//  UserProtocol.swift
//  EFD_ipad
//
//  Created by Gil Rodrigues on 07/02/2025.
//

protocol UserProtocol {
    func getUserById(id: Int, completion: @escaping (Result<User, Error>) -> Void)
    func editUserById(id: Int, user: User, completion: @escaping (Result<Bool, Error>) -> Void)
    func deleteUserById(id: Int, completion: @escaping (Result<Bool, Error>) -> Void)
    func getUserLocationById(id: Int, completion: @escaping (Result<Coordinates, Error>) -> Void)
    func setUserLocationById(id: Int, coordinates: Coordinates, completion: @escaping (Result<Bool, Error>) -> Void)
}
