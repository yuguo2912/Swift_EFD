import Foundation

class AuthenthicatedURLProtocol: URLProtocol {
    static var tokenProvider: (() -> String?)?

    override class func canInit(with request: URLRequest) -> Bool {
        return true // Intercepte toutes les requêtes
    }

    override class func canonicalRequest(for request: URLRequest) -> URLRequest {
        return request
    }

    override func startLoading() {
        guard let token = AuthenthicatedURLProtocol.tokenProvider?() else {
            client?.urlProtocol(self, didFailWithError: NSError(domain: "AuthError", code: 401, userInfo: nil))
            return
        }

        var newRequest = request
        newRequest.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")

        let task = URLSession.shared.dataTask(with: newRequest) { data, response, error in
            if let data = data {
                self.client?.urlProtocol(self, didLoad: data)
            }
            if let response = response {
                self.client?.urlProtocol(self, didReceive: response, cacheStoragePolicy: .notAllowed)
            }
            if let error = error {
                self.client?.urlProtocol(self, didFailWithError: error)
            }
            self.client?.urlProtocolDidFinishLoading(self)
        }
        task.resume()
    }

    override func stopLoading() {}
}
