//
//  UserAnnotation.swift
//  EFD_ipad
//
//  Created by Gil Rodrigues on 02/03/2025.
//

import MapKit

class UserAnnotation: MKPointAnnotation {
    let user : UserWithLocationDTO
    
    init(user: UserWithLocationDTO) {
        self.user = user
        super.init()
        self.title = user.name + " " + user.lastName
        self.subtitle = "Dernière mise à jour le : " + user.location.lastUpdated!
        self.coordinate = CLLocationCoordinate2D(latitude: user.location.location.getLatitude(), longitude: user.location.location.getLongitude())
    }
}
