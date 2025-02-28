//
//  UpdateDeliveryStatusDTO.swift
//  EFD_ipad
//
//  Created by Gil Rodrigues on 26/02/2025.
//

class UpdateDeliveryStatusDTO: Codable {
    var packageId: Int
    var status: Bool
    
    init(packageId: Int, status: Bool) {
        self.packageId = packageId
        self.status = status
    }
}
