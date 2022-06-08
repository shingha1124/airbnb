//
//  AuthRepository.swift
//  airbnb
//
//  Created by seongha shin on 2022/06/07.
//

import Foundation
import RxSwift

protocol AuthRepository {
    func requestGitLogin() -> Single<Swift.Result<[Lodging], APIError>>
}
