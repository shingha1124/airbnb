//
//  MapTarget.swift
//  airbnb
//
//  Created by 김동준 on 2022/05/25.
//

import Foundation

enum MapTarget {
    case requestLodging
}

extension MapTarget: BaseTarget {
    var baseURL: URL? {
        switch self {
        case .requestLodging:
            return URL(string: "https://api.codesquad.kr/starbuckst")
        }
    }
    
    var path: String? {
        switch self {
        case .requestLodging:
            return nil
        }
    }
    
    var parameter: [String: Any]? {
        switch self {
        case .requestLodging:
            return nil
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .requestLodging:
            return .get
        }
    }
    
    var content: HTTPContentType {
        switch self {
        case .requestLodging:
            return .json
        }
    }
}
