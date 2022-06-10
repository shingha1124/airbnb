//
//  HomeRepositoryImpl.swift
//  airbnb
//
//  Created by seongha shin on 2022/05/23.
//

import Foundation
import RxSwift

class TravalRepositoryImpl: NetworkRepository<TravalTarget>, TravalRepository {
    
    func requestAroundTraval() -> Single<Result<[ArroundTraval], APIError>> {
        provider
            .request(.requestAroundTraval)
            .map([ArroundTraval].self)
    }
    
    func requestSearch(searchData: TravalSearchData) -> Single<Swift.Result<Lodgings, APIError>> {
        provider
            .request(.requestSearch(searchData: searchData))
            .map(Lodgings.self)
    }
    
    func requestWishList() -> Single<Swift.Result<[Wish], APIError>> {
        provider
            .request(.requestWishList)
            .map([Wish].self)
    }
    
    func requestWishAdd(id: Int) -> Single<Swift.Result<Void, APIError>> {
        provider
            .request(.requestAddWish(id: id))
            .mapVoid()
    }
    
    func requestRecommandTraval() -> Single<Result<[RecommandTraval], APIError>> {
        Single.create { observer in
            guard let url = Bundle.main.url(forResource: "recommandTravalMock", withExtension: "json"),
                  let data = try? Data(contentsOf: url) else {
                observer(.success(.failure(.unowned)))
                return Disposables.create { }
            }
            
            let response = Response(statusCode: 200, data: data)
            do {
                let travals = try response.map(RecommandTravals.self)
                observer(.success(.success(travals.list)))
            } catch {
                observer(.success(.failure(APIError.objectMapping(error: error, response: response))))
            }
            
            observer(.success(.failure(.unowned)))
            return Disposables.create {  }
        }
    }
}
