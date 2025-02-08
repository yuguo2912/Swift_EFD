class User: Decodable, CustomStringConvertible {
    
    var description: String {
        return """
            User: \(id)
            \(name) \(lastname)
            Email: \(email)
            Role: \(role.rawValue)
            Token: \(token ?? "")
            Coordinates: \(coordinates?.description ?? Coordinates(latitude: 0, longitude: 0).description)
            """
    }
    
    var id: Int
    var name: String
    var lastname: String
    var email: String
    var role: Role
    var token: String?
    var coordinates: Coordinates?
    
    init(id: Int = -1, name: String = "", lastname: String = "", email: String = "", role: Role = .USER, token: String = "", coordinates: Coordinates? = nil) {
        self.id = id
        self.name = name
        self.lastname = lastname
        self.email = email
        self.role = role
        self.token = token
        self.coordinates = coordinates
    }
    
    // Initialisation à partir d'un dictionnaire JSON
    init?(from dictionary: [String: Any]) {
        guard let id = dictionary["id"] as? Int,
              let name = dictionary["name"] as? String,
              let lastname = dictionary["lastname"] as? String,
              let email = dictionary["email"] as? String,
              let roleRawValue = dictionary["role"] as? String,
              let role = Role(rawValue: roleRawValue),
              let token = dictionary["token"] as? String else {
            return nil
        }
        
        self.id = id
        self.name = name
        self.lastname = lastname
        self.email = email
        self.role = role
        self.token = token
        self.coordinates = Coordinates(from: dictionary["coordinates"] as? [String: Any])
    }
    
}
