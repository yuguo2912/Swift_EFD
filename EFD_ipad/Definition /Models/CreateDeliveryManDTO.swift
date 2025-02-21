//
//  CreateDeliveryManDTO.swift
//  EFD_ipad
//
//  Created by Gil Rodrigues on 21/02/2025.
//

class CreateDeliveryManDTO: Codable {
    var name: String
    var lastname: String
    var mail: String
    
    init(name: String, lastname: String, mail: String) {
        self.name = name
        self.lastname = lastname
        self.mail = mail
    }

}
