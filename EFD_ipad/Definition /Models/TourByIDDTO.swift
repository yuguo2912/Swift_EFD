import Foundation

struct TourByIDDTO: Codable {
    var deliveryTourId: Int?
    var tourId: Int?
    var Packages: Int?  // Renommé en `packages` pour respecter Swift
    
    var description: String {
        return "\(deliveryTourId ?? 0) | \(tourId ?? 0) | \(Packages ?? 0)"
    }
}
