//
//  AuthTarget.swift
//  airbnb
//
//  Created by seongha shin on 2022/06/07.
//

import Foundation

enum AuthTarget {
    case requestGitLogin(code: String)
}

extension AuthTarget: BaseTarget {
    var baseURL: URL? {
        URL(string: "http://3.39.96.36:8080")
    }
    
    var path: String? {
        switch self {
        case .requestGitLogin:
            return "/login/oauth/github"
        }
    }
    
    var parameter: [String: Any]? {
        switch self {
        case .requestGitLogin(let code):
            return ["code": code]
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .requestGitLogin:
            return .get
        }
    }
    
    var content: HTTPContentType {
        switch self {
        case .requestGitLogin:
            return .query
        }
    }
}
