//
//  DeliveryTourDTO.swift
//  EFD_ipad
//
//  Created by Gil Rodrigues on 23/02/2025.
//

class DeliveryTourDTO: Codable, CustomStringConvertible {
    var deliveryTourId: Int?
    var tourId: Int?
    var packages: [PackageDTO]?
    
    var description: String {
        return "DeliveryTourDTO(deliveryTourId: \(String(describing: deliveryTourId ?? 0)), tourId: \(String(describing: tourId ?? 0)), packages: \(String(describing: packages ?? [])))"
    }
    
    enum CodingKeys: String, CodingKey {
        case deliveryTourId = "deliveryTourId"
        case tourId = "tourId"
        case packages = "Packages"
    }
}
