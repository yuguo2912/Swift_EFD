//
//  Context.swift
//  EFD_ipad
//
//  Created by Hugo Arnaudeau on 24/02/2025.
//

class Context {
    var userId : Int?
    var tourId : Int?
    
    init(userId: Int?, tourId: Int?) {
        self.userId = userId
        self.tourId = tourId
    }
    
    
    static let shared : Context = {
        let instance = Context(userId: 0, tourId: 0)
        return instance
    }()
}
