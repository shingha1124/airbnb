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

    let latitude: Double
    let longitude: Double
}
