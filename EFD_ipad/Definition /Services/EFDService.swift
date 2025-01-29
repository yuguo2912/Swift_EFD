//
//  EFDServices.swift
//  EFD_ipad
//
//  Created by Hugo Arnaudeau on 23/12/2024.
//
protocol EFDService{
    func getAllConnexion(completion:
        @escaping([Connexion])->Void)->Void
    func getAllLivreur(completion: @escaping([Livreur])->Void)->Void
}
