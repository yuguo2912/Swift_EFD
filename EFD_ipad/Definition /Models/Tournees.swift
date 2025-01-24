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
    
    init(nbColis: Int, dateSpec: DateComponents, livreur: Livreur) {
        self.nbColis = nbColis
        self.dateSpec = dateSpec
        self.livreur = livreur
    }
}
