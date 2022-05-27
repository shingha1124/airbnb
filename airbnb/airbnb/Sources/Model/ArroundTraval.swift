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
    let imageUrl: URL
    let name: String
    let distance: String
}


struct TestTravals: Decodable{
    let data: [TestTraval]
}

struct TestTraval: Decodable{
    let time: String
}
