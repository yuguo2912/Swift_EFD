//
//  GetDeliveryProofDTO.swift
//  EFD_ipad
//
//  Created by Gil Rodrigues on 28/02/2025.
//

class GetDeliveryProofDTO: Codable {
    var deliveryProof: String
    
    init(deliveryProof: String) {
        self.deliveryProof = deliveryProof
    }
}
