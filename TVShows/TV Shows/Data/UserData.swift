//
//  UserData.swift
//  TV Shows
//
//  Created by FOI on 26.07.2021..
//

import Foundation

final class UserData {
    static let sharedInstance = UserData()
    var user: User?
    var authInfo: AuthInfo?
    
    private init () {
    }
}
