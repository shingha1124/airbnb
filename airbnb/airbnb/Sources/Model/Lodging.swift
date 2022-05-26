//
//  Lodging.swift
//  airbnb
//
//  Created by seongha shin on 2022/05/25.
//

import Foundation

struct Lodgings: Decodable {
    let list: [Lodging]
}

struct Lodging: Decodable {
    let id: Int
    let name: String
    let rating: Double
    let review: Int
    let price: Int
    let totalPrice: Int
    let imageUrl: String
    let wish: Bool
    let latitude: Double
    let longitude: Double
}
