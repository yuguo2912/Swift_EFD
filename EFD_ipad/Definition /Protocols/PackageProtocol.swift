//
//  PackageProtocol.swift
//  EFD_ipad
//
//  Created by Gil Rodrigues on 08/02/2025.
//

protocol PackageProtocol {
    func getAllTours(completion: @escaping (Result<[AllToursDTO], Error>) -> Void)
}
