//
//  HomeRepository.swift
//  airbnb
//
//  Created by seongha shin on 2022/05/23.
//

import Foundation
import RxSwift

protocol TravalRepository {
    func requestAroundTraval() -> Single<Swift.Result<[ArroundTraval], APIError>>
    func requestRecommandTraval() -> Single<Swift.Result<[RecommandTraval], APIError>>
}
