//
//  Lodging.swift
//  airbnb
//
//  Created by seongha shin on 2022/05/25.
//

import Foundation

struct Lodgings: Decodable {
    let total: Int
    let lodgings: [Lodging]
}

struct Lodging: Decodable {
    let id: Int
    let name: String
    let rating: Double
    let review: Int
    let price: Int
    let totalPrice: Int?
    let imageUrls: [URL]
    let wish: Bool
    let latitude: Double
    let longitude: Double
}
