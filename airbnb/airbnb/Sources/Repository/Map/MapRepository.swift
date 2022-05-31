//
//  MapRepository.swift
//  airbnb
//
//  Created by 김동준 on 2022/05/25.
//

import Foundation
import RxSwift

protocol MapRepository {
    func requestLodging() -> Single<Swift.Result<[Lodging], APIError>>
    func requestUpdateWish(lodging: Lodging) -> Single<Swift.Result<Lodging, APIError>>
}
