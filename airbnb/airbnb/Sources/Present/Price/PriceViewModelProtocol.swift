//
//  CalenderViewModelProtocol.swift
//  airbnb
//
//  Created by seongha shin on 2022/05/25.
//

import Foundation
import RxRelay

protocol PriceViewModelAction {
}

protocol PriceViewModelState {
}

protocol PriceViewModelBinding {
    func action() -> PriceViewModelAction
    func state() -> PriceViewModelState
}

typealias PriceViewModelProtocol = PriceViewModelBinding
