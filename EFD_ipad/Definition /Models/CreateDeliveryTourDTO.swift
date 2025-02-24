//
//  CreateDeliveryTourDTO.swift
//  EFD_ipad
//
//  Created by Gil Rodrigues on 23/02/2025.
//

class CreateDeliveryTourDTO: Codable {
    let deliveryManId: Int
    let deliveryDate: String
    let numberOfPackages: Int
    
    init(deliveryManId: Int, deliveryDate: String, numberOfPackages: Int) {
        self.deliveryManId = deliveryManId
        self.deliveryDate = deliveryDate
        self.numberOfPackages = numberOfPackages
    }
}
