//
//  APIProvider.swift
//  EFD_ipad
//
//  Created by Hugo Arnaudeau on 29/01/2025.
//

import Foundation

class APIProvider {
    static let shared = APIProvider()
    
    public let session: URLSession

    private init() {
        let config = URLSessionConfiguration.default
        config.protocolClasses = [AuthenthicatedURLProtocol.self] + (config.protocolClasses ?? [])
        self.session = URLSession(configuration: config)
    }

    func request(url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> Void) {
        let request = URLRequest(url: url)
        session.dataTask(with: request, completionHandler: completion).resume()
    }
}
