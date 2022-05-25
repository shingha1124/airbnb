//
//  RecommandTraval.swift
//  airbnb
//
//  Created by seongha shin on 2022/05/23.
//

import Foundation

struct RecommandTravals: Decodable {
    let list: [RecommandTraval]
}

struct RecommandTraval: Decodable {
    let imageUrl: URL
    let title: String
}
