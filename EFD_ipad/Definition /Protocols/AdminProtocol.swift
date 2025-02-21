//
//  AdminProtocol.swift
//  EFD_ipad
//
//  Created by Gil Rodrigues on 08/02/2025.
//

protocol AdminProtocol {
    func getDeliveryMans(completion: @escaping (Result<[User], Error>) -> Void)
    func createDeliveryMan(deliveryMan: CreateDeliveryManDTO, completion: @escaping (Result<Bool, Error>) -> Void)
    
}
