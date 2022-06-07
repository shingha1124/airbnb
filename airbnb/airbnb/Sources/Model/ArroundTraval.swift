//
//  AroundTraval.swift
//  airbnb
//
//  Created by seongha shin on 2022/05/23.
//

import Foundation

struct AroundTravals: Decodable {
    let list: [ArroundTraval]
}

struct ArroundTraval: Decodable {
    let id: Int
    let name: String
    let imageUrl: URL
    let description: String
}
