//
//  AuthRepositoryImpl.swift
//  airbnb
//
//  Created by seongha shin on 2022/06/07.
//

import Foundation
import RxSwift

class AuthRepositoryImpl: NetworkRepository<AuthTarget>, AuthRepository {
    func requestGitLogin(code: String) -> Single<Swift.Result<Token, APIError>> {
        provider
            .request(.requestGitLogin(code: code))
            .map(Token.self)
    }
}
