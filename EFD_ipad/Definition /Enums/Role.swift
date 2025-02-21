//
//  Role.swift
//  EFD_ipad
//
//  Created by Gil Rodrigues on 06/02/2025.
//

enum Role: String, CaseIterable, Decodable, Encodable {
    case ADMIN        = "ADMIN"
    case USER         = "USER"
    case DELIVERY_MAN = "DELIVERY_MAN"
}
