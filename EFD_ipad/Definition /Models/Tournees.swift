//
//  Tournees.swift
//  EFD_ipad
//
//  Created by Hugo Arnaudeau on 24/12/2024.
//
import CoreLocation

class Tournees {
    var nbColis : Int
    var destination : CLLocationCoordinate2D
    var dateSpec : DateComponents
    var livreur : Livreur
    
    init(nbColis: Int, destination: CLLocationCoordinate2D, dateSpec: DateComponents, livreur: Livreur) {
        self.nbColis = nbColis
        self.destination = destination
        self.dateSpec = dateSpec
        self.livreur = livreur
    }
}
