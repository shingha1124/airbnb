//
//  Environment.swift
//  airbnb
//
//  Created by seongha shin on 2022/06/07.
//

import Foundation

enum Constants {
    enum Login {
        static let gitHubClientId = Bundle.main.object(forInfoDictionaryKey: "GitHubClientId") as? String ?? ""
        static let gitHubScheme = Bundle.main.object(forInfoDictionaryKey: "GitHubScheme") as? String ?? ""
    }
}
