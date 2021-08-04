//
//  KeychainManager.swift
//  TV Shows
//
//  Created by FOI on 02.08.2021..
//

import Foundation
import KeychainAccess

//let accessToken: String
//let client: String
//let tokenType: String
//let expiry: String
//let uid: String

class KeychainManager {

    static let shared = KeychainManager()
    
    private let keychain = Keychain(service: "mbarosevic.TV-Shows")
    
    func deleteKeychainValues() {
        keychain["accessToken"] = nil
        keychain["client"] = nil
        keychain["tokenType"] = nil
        keychain["expiry"] = nil
        keychain["uid"] = nil
    }
    
    func storeAuthInfo(_ authInfo: AuthInfo?) {
        guard let authInfo = authInfo else {
            try? keychain.remove("authInfo")
            return
        }
        
        let encoder = PropertyListEncoder()
        let data = try! encoder.encode(authInfo)
        try? keychain.set(data, key: "authInfo")
    }
    
    func fetchAuthInfo() -> AuthInfo? {
        // fetch
        
        return nil
    }
    
    public var accessToken: String {
        get {
            do {
                return try keychain.get("accessToken") ?? ""
            } catch let error {
                print("error: \(error)")
            }
            return ""
        }
        
        set(value) {
            do {
                try keychain.set(value, key: "accessToken")
            } catch let error {
                print("error: \(error)")
            }
        }
    }
    
    public var client: String {
        get {
            do {
                return try keychain.get("client") ?? ""
            } catch let error {
                print("error: \(error)")
            }
            return ""
        }
        
        set(value) {
            do {
                try keychain.set(value, key: "client")
            } catch let error {
                print("error: \(error)")
            }
        }
    }
    
    public var tokenType: String {
        get {
            do {
                return try keychain.get("tokenType") ?? ""
            } catch let error {
                print("error: \(error)")
            }
            return ""
        }
        
        set(value) {
            do {
                try keychain.set(value, key: "tokenType")
            } catch let error {
                print("error: \(error)")
            }
        }
    }
    
    public var expiry: String {
        get {
            do {
                return try keychain.get("expiry") ?? ""
            } catch let error {
                print("error: \(error)")
            }
            return ""
        }
        
        set(value) {
            do {
                try keychain.set(value, key: "expiry")
            } catch let error {
                print("error: \(error)")
            }
        }
    }
    
    public var uid: String {
        get {
            do {
                return try keychain.get("uid") ?? ""
            } catch let error {
                print("error: \(error)")
            }
            return ""
        }
        
        set(value) {
            do {
                try keychain.set(value, key: "uid")
            } catch let error {
                print("error: \(error)")
            }
        }
    }
}
