//
//  MapRepositoryImpl.swift
//  airbnb
//
//  Created by 김동준 on 2022/05/25.
//

import Foundation
import RxSwift

class MapRepositoryImpl: NetworkRepository<MapTarget>, MapRepository {
    func requestLodging() -> Single<Result<[Lodging], APIError>> {
        Single.create { observer in
            guard let url = Bundle.main.url(forResource: "mapLodgingMock", withExtension: "json"),
                  let data = try? Data(contentsOf: url) else {
                observer(.success(.failure(.unowned)))
                return Disposables.create { }
            }
            let response = Response(statusCode: 200, data: data)
            do {
                let lodgings = try response.map(Lodgings.self)
                observer(.success(.success(lodgings.lodgings)))
            } catch {
                observer(.success(.failure(APIError.objectMapping(error: error, response: response))))
            }

            observer(.success(.failure(.unowned)))
            return Disposables.create {  }
        }
    }
    
    func requestUpdateWish(lodging: Lodging) -> Single<Result<Lodging, APIError>> {
        Single.create { observer in
            observer(.success(.success(lodging)))
            return Disposables.create { }
        }
    }
}
