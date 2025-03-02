//
//  UserWithLocationListDTO.swift
//  EFD_ipad
//
//  Created by Gil Rodrigues on 02/03/2025.
//

class UserWithLocationListDTO: Codable {
    var users: [UserWithLocationDTO]
    
    init(users: [UserWithLocationDTO]) {
        self.users = users
    }
    
    enum CodingKeys: String, CodingKey {
        case users = "users"
    }
}
