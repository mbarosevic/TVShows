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

struct ReviewParameters {
    let comment: String
    let rating: String
    let show_id: String
    var reviewData: [String: String] {
        return [
            "comment": comment,
            "rating": rating,
            "show_id": show_id
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
    
    // MARK: - Shows
    func fetchShows(
        completion: @escaping (AFDataResponse<ShowsResponse>) -> Void
    ) {
        sessionManager.request(
            "https://tv-shows.infinum.academy/shows",
            method: .get,
            parameters: ["page": "1", "items": "100"],
            headers: HTTPHeaders((UserData.sharedInstance.authInfo?.headers)!)
        )
        .validate()
        .responseDecodable(of: ShowsResponse.self, completionHandler: completion)
    }
    
    func fetchShow(
        for showId: String,
        completion: @escaping (AFDataResponse<ShowResponse>) -> Void
    ) {
        print("Fetching for: \(showId)")
        sessionManager.request(
            "https://tv-shows.infinum.academy/shows/\(showId)",
            method: .get,
            headers: HTTPHeaders((UserData.sharedInstance.authInfo?.headers)!)
        )
        .validate()
        .responseDecodable(of: ShowResponse.self, completionHandler: completion)
    }
    
    // MARK: - Fetch Reviews
    func fetchReviews(
        for showId: String,
        completion: @escaping (AFDataResponse<ReviewResponse>) -> Void
    ) {
        sessionManager.request(
            "https://tv-shows.infinum.academy/shows/\(showId)/reviews",
            method: .get,
            headers: HTTPHeaders((UserData.sharedInstance.authInfo?.headers)!)
        )
        .validate()
        .responseDecodable(of: ReviewResponse.self, completionHandler: completion)
    }
    
    // MARK: - Submit Reviews
    func submitReview(
        comment: String, rating: String, showId: String,
        completion: @escaping (AFDataResponse<SubmitReviewResponse>) -> Void
    ){
        
        let params: [String: String] = [
                    "comment": comment,
                    "rating": rating,
                    "show_id": showId
                ]
        
        sessionManager.request(
            "https://tv-shows.infinum.academy/reviews",
            method: .post,
            parameters: params,
            encoder: JSONParameterEncoder.default,
            headers: HTTPHeaders((UserData.sharedInstance.authInfo?.headers)!)
        )
        .validate().responseDecodable(
            of: SubmitReviewResponse.self,
            completionHandler: completion)
                    
    }
}
