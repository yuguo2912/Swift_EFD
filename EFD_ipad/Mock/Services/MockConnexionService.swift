//
//  MockEFDServices.swift
//  EFD_ipad
//
//  Created by Hugo Arnaudeau on 23/12/2024.
//


import CoreLocation

class MockConnexionService: EFDService {
    
    private static var instance: MockConnexionService!
    
    private var livreurList = [
        Livreur(nom: "Hugo", prenom: "Arnaudeau", age: 21, location: CLLocationCoordinate2D(latitude: 90.2122, longitude: 2.3113121)),
        Livreur(nom: "Matthieu", prenom: "D", age: 48, location: CLLocationCoordinate2D(latitude: 21.2212132, longitude: 2.23232312))
    ]
    private var tourneeList = [
        Tournees(nbColis: 20, destination: CLLocationCoordinate2D(latitude: 21.21231232, longitude: 0.12342322), dateSpec: DateComponents(year: 2024, month: 12, day: 26, hour: 14, minute: 30), livreur: (Livreur(nom: "Hugo", prenom: "Arnau", age: 22))),
        Tournees(nbColis: 20, destination: CLLocationCoordinate2D(latitude: 0.2231313, longitude: 23.241231), dateSpec: DateComponents(year: 2022, month: 10, day: 1, hour: 00, minute: 10), livreur: Livreur(nom: "oui", prenom: "test2", age: 23)),
    ]
    class func getInstance() -> MockConnexionService {
        if self.instance == nil {
            self.instance = MockConnexionService()
        }
        return self.instance
    }
    
    func getAllConnexion(completion: @escaping([Connexion]) -> Void) -> Void {
        completion([
            Connexion(username: "username", password: "password"),
            
            Connexion(username: "hugo", password: "EFD"),
            Connexion(username: " ", password: " "),
        ])
    }
    func getAllLivreur(completion: @escaping([Livreur])->Void)->Void{
        completion(livreurList)
    }
    func addLivreur(_ livreur: Livreur){
        livreurList.append(livreur)
    }
    func getAllTournees(completion:@escaping([Tournees])->Void)->Void{
        completion(tourneeList)
    }
    func addTournee(_ tournee: Tournees){
        tourneeList.append(tournee)
    }
}
