//
//  CalenderViewModelProtocol.swift
//  airbnb
//
//  Created by seongha shin on 2022/05/25.
//

import Foundation
import RxRelay

protocol PriceViewModelAction {
    var loadLodgment: PublishRelay<Void> { get }
    var changeSliderValue: PublishRelay<PriceSliderValue> { get }
}

protocol PriceViewModelState {
    var updatedGraphPoints: PublishRelay<[CGPoint]> { get }
    var updatedSliderValue: PublishRelay<PriceSliderValue> { get }
    var updatedPriceRange: PublishRelay<PriceRangeValue> { get }
    var updatedPriceAverage: PublishRelay<Int> { get }
    var updatedPriceRangeText: PublishRelay<String> { get }
}

protocol PriceViewModelBinding {
    func action() -> PriceViewModelAction
    func state() -> PriceViewModelState
}

typealias PriceViewModelProtocol = PriceViewModelBinding

typealias PriceSliderValue = (min: Double, max: Double)
typealias PriceRangeValue = (min: Int, max: Int)
