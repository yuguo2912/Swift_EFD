//
//  AllToursDTO.swift
//  EFD_ipad
//
//  Created by Gil Rodrigues on 08/02/2025.
//

class AllToursDTO: Decodable, CustomStringConvertible {
    
    var description: String {
        return "\(tourId ?? 0) | \(userId ?? 0) | \(firstName ?? "") | \(lastName ?? "") | \(deliveryDate ?? "") | \(String(describing: packages)) | \(status ?? "")"
    }
    
    var tourId: Int?
    var userId: Int?
    var firstName: String?
    var lastName: String?
    var deliveryDate: String?
    var packages: Int?
    var status: String?
    
    enum CodingKeys: String, CodingKey {
        case tourId = "tourId"
        case userId = "userId"
        case firstName = "name"
        case lastName = "lastname"
        case deliveryDate = "deliveryDate"
        case packages = "packages"
        case status = "status"
    }
}
