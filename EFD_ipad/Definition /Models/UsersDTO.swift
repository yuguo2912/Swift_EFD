//
//  UsersDTO.swift
//  EFD_ipad
//
//  Created by Gil Rodrigues on 08/02/2025.
//

struct UsersDTO: Decodable {
    let users: [User]
    
    init(users: [User] = []) {
        self.users = users
    }
    
    enum CodingKeys: String, CodingKey {
        case users = "Users"
    }
    
}
