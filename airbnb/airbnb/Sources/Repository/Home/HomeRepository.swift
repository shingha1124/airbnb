//
//  HomeRepository.swift
//  airbnb
//
//  Created by seongha shin on 2022/05/23.
//

import Foundation
import RxSwift

protocol HomeRepository {
    func requestAroundTraval() -> Single<Swift.Result<[AroundTraval], APIError>>
    func requestRecommandTraval() -> Single<Swift.Result<[RecommandTraval], APIError>>
}
