//
//  Show.swift
//  TV Shows
//
//  Created by FOI on 27.07.2021..
//

import Foundation

struct Show: Decodable {
    let id: String
    let title: String
    let averageRating: Double?
    let description: String?
    let imageUrl: String
    let numOfReviews: Int
    
    enum CodingKeys: String, CodingKey {
        case id
        case title
        case averageRating = "average_rating"
        case description
        case imageUrl = "image_url"
        case numOfReviews = "no_of_reviews"
    }
}

struct Pagination: Decodable {
    let count: Int
    let page: Int
    let items: Int
    let pages: Int
}

struct ShowsResponse: Decodable {
    let shows: [Show]
    //let pagination: [Pagination]
}

struct ShowResponse: Decodable {
    let show: Show
}

