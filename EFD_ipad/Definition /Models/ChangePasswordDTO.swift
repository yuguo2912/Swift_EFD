//
//  ChangePasswordDTO.swift
//  EFD_ipad
//
//  Created by Gil Rodrigues on 02/03/2025.
//

class ChangePasswordDTO: Codable {
    var userId: Int
    var password: String
    
    init(userId: Int, password: String) {
        self.userId = userId
        self.password = password
    }
}
