//
//  AuthRepositoryImpl.swift
//  airbnb
//
//  Created by seongha shin on 2022/06/07.
//

import Foundation
import RxSwift

class AuthRepositoryImpl: NetworkRepository<AuthTarget>, AuthRepository {
    func requestGitLogin() -> Single<Swift.Result<[Lodging], APIError>> {
        Single.create { observer in
            return Disposables.create {  }
        }
    }
}
