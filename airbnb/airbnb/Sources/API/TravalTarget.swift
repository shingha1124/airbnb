//
//  HomeTarget.swift
//  airbnb
//
//  Created by seongha shin on 2022/05/23.
//

import Foundation

enum TravalTarget {
    case requestAroundTraval
    case requestSearch(searchData: TravalSearchData)
    case requestWishList
}

extension TravalTarget: BaseTarget {
    var baseURL: URL? {
        URL(string: "http://3.39.96.36:8080")
    }
    
    var path: String? {
        switch self {
        case .requestAroundTraval:
            return "/nearby"
        case .requestSearch:
            return "/lodgings"
        case .requestWishList:
            return "/wish"
        }
    }
    
    var parameter: [String: Any]? {
        switch self {
        case .requestAroundTraval, .requestWishList:
            return nil
        case .requestSearch(let searchData):
            var param: [String: Any] = [:]
            if let region = searchData.region { param["region"] = region }
            if let checkIn = searchData.checkInOut.checkIn { param["checkIn"] = checkIn.string("yyyy-MM-dd") }
            if let checkOut = searchData.checkInOut.checkOut { param["checkOut"] = checkOut.string("yyyy-MM-dd") }
//            if let guests = searchData.guests.reduce(0){ } { param["guests"] = guests }
//            if let maxPrice = maxPrice { param["maxPrice"] = maxPrice }
//            if let minPrice = minPrice { param["minPrice"] = minPrice }
            return param
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .requestAroundTraval, .requestSearch, .requestWishList:
            return .get
        }
    }
    
    var content: HTTPContentType {
        switch self {
        case .requestAroundTraval:
            return .json
        case .requestSearch, .requestWishList:
            return .query
        }
    }
}
