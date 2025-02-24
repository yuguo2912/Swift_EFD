//
//  Coordinates.swift
//  EFD_ipad
//
//  Created by Gil Rodrigues on 06/02/2025.
//

class Coordinates: Decodable, CustomStringConvertible, Encodable {
    var description: String {
        return "Coordinates(latitude: \(latitude), longitude: \(longitude))"
    }
    
    private var latitude: Double
    private var longitude: Double
    
    init(latitude: Double, longitude: Double) {
        self.latitude = latitude
        self.longitude = longitude
    }
    
    init?(from dictionary: [String: Any]?) {
        guard let dict = dictionary,
                let latitude = dict["latitude"] as? Double,
                let longitude = dict["longitude"] as? Double else {
            return nil
        }
           
        self.latitude = latitude
        self.longitude = longitude
    }
    
    func getLatitude() -> Double {
        return latitude
    }
        
    func getLongitude() -> Double {
        return longitude
    }
    
    func setLatitude(_ latitude: Double) {
        self.latitude = latitude
    }
    
    func setLongitude(_ longitude: Double) {
        self.longitude = longitude
    }
}
