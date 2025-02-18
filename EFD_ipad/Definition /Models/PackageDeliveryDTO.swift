//
//  PackageDeliveryDTO.swift
//  EFD_ipad
//
//  Created by Hugo Arnaudeau on 13/02/2025.
//


import Foundation

class PackageDeliveryDTO: Decodable, CustomStringConvertible {
    
    var description: String {
        return """
        Package ID: \(packageId)
        Location: \(location?.description ?? "No Location")
        Delivery Date: \(deliveryDate)
        Delivered: \(isDelivered ? "Yes" : "No")
        Delivery Proof: \(deliveryProof ?? "None")
        """
    }
    
    var packageId: Int
    var location: Coordinates?
    var deliveryDate: String
    var isDelivered: Bool
    var deliveryProof: String?

    enum CodingKeys: String, CodingKey {
        case packageId
        case location
        case deliveryDate
        case isDelivered
        case deliveryProof
    }
    
    init(packageId: Int, location: Coordinates?, deliveryDate: String, isDelivered: Bool, deliveryProof: String?) {
        self.packageId = packageId
        self.location = location
        self.deliveryDate = deliveryDate
        self.isDelivered = isDelivered
        self.deliveryProof = deliveryProof
    }
}
