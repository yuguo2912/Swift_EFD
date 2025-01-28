//
//  Tournees.swift
//  EFD_ipad
//
//  Created by Hugo Arnaudeau on 24/12/2024.
//
import CoreLocation

class Tournees {
    var nbColis : Int
    var dateSpec : DateComponents
    var livreur : Livreur
    var isDelivered: Bool
    
    init(nbColis: Int, dateSpec: DateComponents, livreur: Livreur, isDelivered: Bool) {
        self.nbColis = nbColis
        self.dateSpec = dateSpec
        self.livreur = livreur
        self.isDelivered = isDelivered
    }
}
