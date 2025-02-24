//
//  PackageProtocol.swift
//  EFD_ipad
//
//  Created by Gil Rodrigues on 08/02/2025.
//

protocol PackageProtocol {
    func getAllTours(completion: @escaping (Result<[AllToursDTO], Error>) -> Void)
    func deleteTour(tourId: Int, completion: @escaping (Result<Bool, Error>) -> Void)
    func deletePackage(packageId: Int, completion: @escaping (Result<Bool, Error>) -> Void)
    func editPackage(package: PackageDTO, completion: @escaping (Result<PackageDTO, Error>) -> Void)
}
