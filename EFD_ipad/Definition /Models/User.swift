class User: Decodable, CustomStringConvertible {
    
    var description: String {
        return """
            User: \(id)
            \(firstname) \(lastname)
            Email: \(email)
            Role: \(role.rawValue)
            Token: \(token)
            Coordinates: \(coordinates?.description ?? Coordinates(latitude: 0, longitude: 0).description)
            """
    }
    
    private var id: Int
    private var firstname: String
    private var lastname: String
    private var email: String
    private var role: Role
    private var token: String
    private var coordinates: Coordinates?
    
    init(id: Int = -1, firstname: String = "", lastname: String = "", email: String = "", role: Role = .USER, token: String = "", coordinates: Coordinates? = nil) {
        self.id = id
        self.firstname = firstname
        self.lastname = lastname
        self.email = email
        self.role = role
        self.token = token
        self.coordinates = coordinates
    }
    
    // Initialisation à partir d'un dictionnaire JSON
    init?(from dictionary: [String: Any]) {
        guard let id = dictionary["id"] as? Int,
              let firstname = dictionary["firstname"] as? String,
              let lastname = dictionary["lastname"] as? String,
              let email = dictionary["email"] as? String,
              let roleRawValue = dictionary["role"] as? String,
              let role = Role(rawValue: roleRawValue),
              let token = dictionary["token"] as? String else {
            return nil
        }
        
        self.id = id
        self.firstname = firstname
        self.lastname = lastname
        self.email = email
        self.role = role
        self.token = token
        self.coordinates = Coordinates(from: dictionary["coordinates"] as? [String: Any])
    }
    
    // Accesseurs (getters)
    func getId() -> Int { return id }
    func getFirstname() -> String { return firstname }
    func getLastname() -> String { return lastname }
    func getEmail() -> String { return email }
    func getRole() -> Role { return role }
    func getToken() -> String { return token }
    func getCoordinates() -> Coordinates? { return coordinates }

    // Mutateurs (setters)
    func setFirstname(_ firstname: String) { self.firstname = firstname }
    func setLastname(_ lastname: String) { self.lastname = lastname }
    func setEmail(_ email: String) { self.email = email }
    func setRole(_ role: Role) { self.role = role }
    func setToken(_ token: String) { self.token = token }
    func setCoordinates(_ coordinates: Coordinates?) { self.coordinates = coordinates }
}
