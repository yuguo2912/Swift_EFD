//
//  DependencyModule.swift
//  EFD_ipad
//
//  Created by Hugo Arnaudeau on 04/01/2025.
//

class DependencyModule{
    let livreurservice: EFDService
    
    private static var instance: DependencyModule!
    
    class func getInstance() -> DependencyModule {
        if self.instance == nil {
            self.instance = DependencyModule()
        }
        return self.instance
    }
    
    
    
    private init(){
        self.livreurservice = MockConnexionService()
    }
}
