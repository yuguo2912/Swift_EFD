//
//  UpdateAssignedToDTO.swift
//  EFD_ipad
//
//  Created by Gil Rodrigues on 26/02/2025.
//

class UpdateAssignedToDTO: Codable {
    var tourId: Int
    var deliveryManId: Int
    
    init(tourId: Int, deliveryManId: Int) {
        self.tourId = tourId
        self.deliveryManId = deliveryManId
    }
}
