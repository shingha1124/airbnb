//
//  RxSwift+Extension.swift
//  airbnb
//
//  Created by seongha shin on 2022/05/24.
//

import Foundation
import RxSwift

extension ObservableType {
    public func mapVoid() -> Observable<Void> {
        self.map { _ in }
    }
}
