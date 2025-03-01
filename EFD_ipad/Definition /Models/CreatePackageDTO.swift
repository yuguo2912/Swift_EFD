//
//  CreatePackageDTO.swift
//  EFD_ipad
//
//  Created by Gil Rodrigues on 01/03/2025.
//

class CreatePackageDTO: Codable {
    var tourId: Int
    var package: PackageDTO

    init(tourId: Int, package: PackageDTO) {
        self.tourId = tourId
        self.package = package
    }
    
    enum CodingKeys: String, CodingKey {
        case tourId
        case package
    }
}

