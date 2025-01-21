//
//  EFD_ipad.swift
//  EFD_ipad
//
//  Created by Hugo Arnaudeau on 23/12/2024.
//

//ici mettre les valeurs que nous sommes censés recevoir de l'API s'il y'a plusieurs jeux de données créer des classes différentes
import CoreLocation

class Livreur {
    var nom: String
    var prenom: String
    var age: Int
    var location : CLLocationCoordinate2D?
    
    init(nom: String, prenom: String, age: Int, location: CLLocationCoordinate2D? = nil) {
        self.nom = nom
        self.prenom = prenom
        self.age = age
        self.location = location
    }
    /*convenience init?(dictionnary: [String: Any]){
        guard let n = dictionnary["nom"] as? String,
              let p = dictionnary["prenom"] as? String,
              let a = dictionnary["age"] as? Int else{
            return nil
        }
        self.init(nom: n, prenom: p, age: a)
    }
    func toDictionnary () -> [String: Any]{
        return [
            "nom": self.nom,
            "prenom" : self.prenom,
            "age" : self.age,
        ]
    }*/
}
