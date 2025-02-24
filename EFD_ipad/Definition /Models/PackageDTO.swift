//
//  PackageDTO.swift
//  EFD_ipad
//
//  Created by Gil Rodrigues on 23/02/2025.
//

class PackageDTO: Codable, CustomStringConvertible {
    var packageId: Int?
    var location: Coordinates?
    var deliveryDate: String?
    var isDelivered: Bool?
    var deliveryProof: String?
    
    var description: String {
        return "PackageDTO(packageId: \(packageId ?? 0), location: \(location ?? Coordinates(latitude: 0, longitude: 0)), deliveryDate: \(deliveryDate ?? ""), isDelivered: \(isDelivered ?? false), deliveryProof: \(deliveryProof ?? ""))"
    }
    
}
