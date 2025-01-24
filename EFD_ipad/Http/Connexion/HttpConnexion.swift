//
//  HttpConnexion.swift
//  EFD_ipad
//
//  Created by Hugo Arnaudeau on 22/01/2025.
//

import Foundation
import CoreLocation

class  HttpConnexion{
    class func newInstance(dict: [String: Any])-> Connexion?{
        guard let n = dict["username"] as? String,
              let p = dict ["password"] as? String else{
            return nil
        }
        return Connexion(username: n, password: p)
    }
}
