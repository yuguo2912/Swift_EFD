//
//  HttpConnexionService.swift
//  EFD_ipad
//
//  Created by Hugo Arnaudeau on 22/01/2025.
//
import CoreLocation

class HttpConnexionService{
    private static var instance: HttpConnexionService!
    
    class func getInstance() -> HttpConnexionService {
        if self.instance == nil {
            self.instance = HttpConnexionService()
        }
        return self.instance
    }
    
    func getAll(completion: @escaping([Connexion]) -> Void) -> Void {
        let dataTask = URLSession.shared.dataTask(with: URLRequest (url:URL(string:"http://localhost:8000/auth")!)){
            data, res, err in
            guard let d = data,
                  let json =  try?JSONSerialization.jsonObject(with: d) as? [[String : Any]] else{
                DispatchQueue.main.async{
                    completion([])
                }
                return
            }
            let connexion = json.compactMap(HttpConnexion.newInstance(dict:))
            DispatchQueue.main.async{
                completion(connexion)
            }
        }
        dataTask.resume()
    }
    
}
