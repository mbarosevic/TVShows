//
//  Review.swift
//  TV Shows
//
//  Created by FOI on 28.07.2021..
//

import Foundation
struct Review: Codable {
    let id: String
    let comment: String
    let rating: Int
    let showId: Int
    let user: User
    
    enum CodingKeys: String, CodingKey {
        case id
        case rating
        case comment
        case showId = "show_id"
        case user
    }
}

struct ReviewResponse: Codable {
    let reviews: [Review]
}

struct SubmitReviewResponse: Codable {
    let review: Review
}

