//
//  HomeTarget.swift
//  airbnb
//
//  Created by seongha shin on 2022/05/23.
//

import Foundation

enum HomeTarget {
    case requestAroundTraval
}

extension HomeTarget: BaseTarget {
    var baseURL: URL? {
        switch self {
        case .requestAroundTraval:
            return URL(string: "https://api.codesquad.kr/starbuckst")
        }
    }
    
    var path: String? {
        switch self {
        case .requestAroundTraval:
            return nil
        }
    }
    
    var parameter: [String: Any]? {
        switch self {
        case .requestAroundTraval:
            return nil
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .requestAroundTraval:
            return .get
        }
    }
    
    var content: HTTPContentType {
        switch self {
        case .requestAroundTraval:
            return .json
        }
    }
}
