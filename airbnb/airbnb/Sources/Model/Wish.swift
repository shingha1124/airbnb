//
//  Wish.swift
//  airbnb
//
//  Created by seongha shin on 2022/06/09.
//

import Foundation

struct Wish: Decodable {
    let id: Int
    let name: String
    let rating: Double
    let review: Int
    let price: Int
    let imageUrl: URL?
    
    enum CodingKeys: String, CodingKey {
        case name, rating, review, price, imageUrl
        case id = "lodgingId"
    }
}
