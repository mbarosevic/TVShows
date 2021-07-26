//
//  APIManager.swift
//  TV Shows
//
//  Created by mbarosevic on 21.07.2021..
//

import Alamofire

struct UserParameters {
    let password: String
    let email: String
    var registerData: [String: String] {
        return [
            "email": email,
            "password": password,
            "password_confirmation": password
        ]
    }
    
    var loginData: [String: String] {
        return [
            "email": email,
            "password": password
        ]
    }
}

class APIManager {
    
    // MARK: - Variables declaration
    private let sessionManager: Session
    private static var sharedApiManager: APIManager = {
        let apiManager = APIManager(sessionManager: Session())
        
        return apiManager
    }()
    
    // MARK: - Accessor to APIManager
    class var shared: APIManager {
        return sharedApiManager
    }
    
    // MARK: - Initialization
    private init(sessionManager: Session) {
        self.sessionManager = sessionManager
    }
    
    // MARK: - Login
    func loginUser(
        with parameters: UserParameters,
        completion: @escaping (AFDataResponse<LoginResponse>) -> Void
    ){
        sessionManager.request(
                "https://tv-shows.infinum.academy/users/sign_in",
                method: .post,
                parameters: parameters.loginData,
                encoder: JSONParameterEncoder.default
            )
            .validate()
            .responseDecodable(of: LoginResponse.self, completionHandler: completion)
    }
    
    // MARK: - Register
    func registerUser(
        with parameters: UserParameters,
        completion: @escaping (AFDataResponse<LoginResponse>) -> Void
    ) {
        sessionManager.request(
            "https://tv-shows.infinum.academy/users",
            method: .post,
            parameters: parameters.registerData,
            encoder: JSONParameterEncoder.default
        )
        .validate()
        .responseDecodable(of: LoginResponse.self, completionHandler: completion)
    }
}
