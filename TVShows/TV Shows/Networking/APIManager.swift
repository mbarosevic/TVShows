//
//  APIManager.swift
//  TV Shows
//
//  Created by mbarosevic on 21.07.2021..
//

import Alamofire
import SVProgressHUD

class APIManager {
    
    // MARK: - Variables declaration
    weak var delegate: APIManagerDelegate?
    private let sessionManager: Session
    private static var sharedApiManager: APIManager = {
        let apiManager = APIManager(sessionManager: Session())
        
        return apiManager
    }()
    
    // MARK: - Accessor to APIManager
    class func shared() -> APIManager {
        return sharedApiManager
    }
    
    // MARK: - Initialization
    private init(sessionManager: Session) {
        self.sessionManager = sessionManager
    }
    
    // MARK: - Get Session Manager function
    func getSessionManager() -> Session {
        return sessionManager
    }
    
    // MARK: - Login
    func loginUserWith(email: String, password: String) {
        let params: [String: String] = [
                    "email": email,
                    "password": password,
                    ]
        SVProgressHUD.show()
        self.sessionManager.request(
                "https://tv-shows.infinum.academy/users/sign_in",
                method: .post,
                parameters: params,
                encoder: JSONParameterEncoder.default)
            .validate()
            .responseDecodable(of: LoginResponse.self) { response in
                switch response.result {
                case .success(let response):
                    self.delegate?.setLoginDataFor(response.user)
                    SVProgressHUD.showSuccess(withStatus: "Success")
                case .failure(let error):
                    SVProgressHUD.showError(withStatus: "Error")
                    print("Error \(error)")
                }
            }
    }

    // MARK: - Register
    func registerUserWith(email: String, password: String) {
        let params: [String: String] = [
                    "email": email,
                    "password": password,
                    "password_confirmation": password
                    ]
        SVProgressHUD.show()
        self.sessionManager.request(
                "https://tv-shows.infinum.academy/users",
                method: .post,
                parameters: params,
                encoder: JSONParameterEncoder.default)
            .validate()
            .responseDecodable(of: LoginResponse.self) { response in
                switch response.result {
                case .success(let response):
                    SVProgressHUD.showSuccess(withStatus: "Success")
                    self.delegate?.setLoginDataFor(response.user)
                case .failure(let error):
                    SVProgressHUD.showError(withStatus: "Error")
                    print("Error \(error)")
                }
            }
        SVProgressHUD.dismiss()
    }
}

// MARK: - APIManager delegate
protocol APIManagerDelegate: AnyObject {
    func setLoginDataFor(_ user: User?)
}
