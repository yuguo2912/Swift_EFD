//
//  UserLocationDTO.swift
//  EFD_ipad
//
//  Created by Gil Rodrigues on 01/03/2025.
//

class UserLocationDTO: Codable {
    var location: Coordinates
    var lastUpdated: String?
    
    init(location: Coordinates, lastUpdated: String) {
        self.location = location
        self.lastUpdated = lastUpdated
    }
    
    enum CodingKeys: String, CodingKey {
        case location = "location"
        case lastUpdated = "lastUpdatedAt"
    }
}
