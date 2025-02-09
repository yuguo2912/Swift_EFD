//
//  AuthService.swift
//  EFD_ipad
//
//  Created by Gil Rodrigues on 06/02/2025.
//

protocol AuthProtocol {
    func login(loginDto loginDTO: LoginDTO, completion: @escaping (Result<String, Error>) -> Void)
    
}
