//
//  User.swift
//  TV Shows
//
//  Created by mbarosevic on 22.07.2021..
//

import Foundation

struct User: Codable {
    let email: String
    let imageUrl: String?
    let id: String
    
    enum CodingKeys: String, CodingKey {
        case email
        case imageUrl = "image_url"
        case id
    }
    
    init(email: String, imageUrl: String, id: String) throws {
        self.email = email
        self.imageUrl = imageUrl
        self.id = id
    }
}

struct LoginResponse: Codable {
    let user: User
}

struct AuthInfo: Codable {

    let accessToken: String
    let client: String
    let tokenType: String
    let expiry: String
    let uid: String

    enum CodingKeys: String, CodingKey {
        case accessToken = "access-token"
        case client = "client"
        case tokenType = "token-type"
        case expiry = "expiry"
        case uid = "uid"
    }

    // MARK: Helpers
    
    init(headers: [String: String]) throws {
        let data = try JSONSerialization.data(withJSONObject: headers, options: .prettyPrinted)
        let decoder = JSONDecoder()
        self = try decoder.decode(Self.self, from: data)
    }

    var headers: [String: String] {
        do {
            let data = try JSONEncoder().encode(self)
            let jsonObject = try JSONSerialization.jsonObject(with: data, options: [.allowFragments])
            return jsonObject as? [String: String] ?? [:]
        } catch {
            return [:]
        }
    }
}

