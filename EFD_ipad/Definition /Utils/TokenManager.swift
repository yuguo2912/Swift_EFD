//
//  TokenManager.swift
//  EFD_ipad
//
//  Created by Gil Rodrigues on 07/02/2025.
//

import Foundation
import Security
import SwiftJWT

struct MyClaims: Claims {
    let id: Int
    let role: String
}

class TokenManager {
    private static var instance: TokenManager?
    private let keychainKey = "authToken"
    private let secret = "superSecretKey"  // La clé secrète de ton API Go
    
    class func getInstance() -> TokenManager {
        if self.instance == nil {
            self.instance = TokenManager()
        }
        return self.instance!
    }
    
    func saveToken(_ token: String) {
        let data = Data(token.utf8)
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: keychainKey,
            kSecValueData as String: data
        ]
        
        SecItemDelete(query as CFDictionary)  // Supprime l'ancien token
        SecItemAdd(query as CFDictionary, nil)
    }
    
    func getToken() -> String? {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: keychainKey,
            kSecReturnData as String: kCFBooleanTrue!,
            kSecMatchLimit as String: kSecMatchLimitOne
        ]
        
        var dataTypeRef: AnyObject?
        if SecItemCopyMatching(query as CFDictionary, &dataTypeRef) == noErr,
           let data = dataTypeRef as? Data,
           let token = String(data: data, encoding: .utf8) {
            return token
        }
        return nil
    }
    
    func deleteToken() {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: keychainKey
        ]
        SecItemDelete(query as CFDictionary)
    }
    
    func getTokenClaims() -> MyClaims? {
        guard let token = getToken() else { return nil }
        
        do {
            let jwt = try JWT<MyClaims>(jwtString: token, verifier: .hs256(key: Data(secret.utf8)))
            return jwt.claims
        } catch {
            print("❌ Erreur lors du décodage du token :", error)
            return nil
        }
    }
}
