//
//  HomeRepositoryImpl.swift
//  airbnb
//
//  Created by seongha shin on 2022/05/23.
//

import Foundation
import RxSwift

class TravalRepositoryImpl: NetworkRepository<HomeTarget>, TravalRepository {
    func requestAroundTraval() -> Single<Result<[ArroundTraval], APIError>> {
        Single.create { observer in
            guard let url = Bundle.main.url(forResource: "mock", withExtension: "json"),
                  let data = try? Data(contentsOf: url) else {
                observer(.success(.failure(.unowned)))
                return Disposables.create { }
            }
            
            let response = Response(statusCode: 200, data: data)
            do {
                let travals = try response.map(AroundTravals.self)
                observer(.success(.success(travals.list)))
            } catch {
                observer(.success(.failure(APIError.objectMapping(error: error, response: response))))
            }
            
            observer(.success(.failure(.unowned)))
            return Disposables.create {  }
        }
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
