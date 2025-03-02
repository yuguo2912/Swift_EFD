//
//  UserWithLocationDTO.swift
//  EFD_ipad
//
//  Created by Gil Rodrigues on 01/03/2025.
//

class UserWithLocationDTO: Codable {
    var id: Int
    var name: String
    var lastName: String
    var location: UserLocationDTO
    
    
    init(id: Int, name: String, lastName: String, location: UserLocationDTO) {
        self.id = id
        self.name = name
        self.lastName = lastName
        self.location = location
    }
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case lastName = "lastname"
        case location
    }
}
