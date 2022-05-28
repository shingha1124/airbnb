//
//  CalenderViewModel.swift
//  airbnb
//
//  Created by seongha shin on 2022/05/25.
//

import Foundation
import RxRelay
import RxSwift

final class PriceViewModel: PriceViewModelBinding, PriceViewModelAction, PriceViewModelState {
    
    private enum Contants {
        static let sliderCount = 100
    }
    
    func action() -> PriceViewModelAction { self }
    
    let loadLodgment = PublishRelay<Void>()
    let changeSliderValue = PublishRelay<PriceSliderValue>()
    
    func state() -> PriceViewModelState { self }
    
    let updatedGraphPoints = PublishRelay<[CGPoint]>()
    let updatedSliderValue = PublishRelay<PriceSliderValue>()
    let updatedPriceRange = PublishRelay<PriceRangeValue>()
    
    private let disposeBag = DisposeBag()
    
    private let prices: [Int] = (0..<100000).map { _ -> Int in
        Int.random(in: 10000..<1000000)
    }
    
    deinit {
        Log.info("deinit PriceViewModel")
    }
    
    init() {
        
        let requestLodgment = loadLodgment
            .withUnretained(self)
            .map { model, _ in
                model.prices.sorted()
            }
            .share()
        
        let updateSliderValue = changeSliderValue
            .withLatestFrom(updatedSliderValue) { change, prevValue -> PriceSliderValue in
                if (change.max - change.min) < 0.1 {
                    return prevValue
                }
                return change
            }
            .share()
        
        let updatePriceRange = updateSliderValue
            .withLatestFrom(requestLodgment) { sliderValue, lodgments -> (min: Int, max: Int) in
                let range = lodgments[lodgments.count - 1] - lodgments[0]
                let minPrice = (sliderValue.0 * Double(range)) + Double(lodgments[0])
                let maxPrice = (sliderValue.1 * Double(range)) + Double(lodgments[0])
                return (Int(minPrice), Int(maxPrice))
            }
            .share()
        
        Observable
            .merge(
                requestLodgment.map { _ in (min: 0, max: 1) },
                updateSliderValue
            )
            .bind(to: updatedSliderValue)
            .disposed(by: disposeBag)
        
        Observable
            .merge(
                requestLodgment.map { ($0[0], $0[$0.count - 1]) },
                updatePriceRange
            )
            .bind(to: updatedPriceRange)
            .disposed(by: disposeBag)
        
        requestLodgment
            .filter { $0.count > 20 }
            .map { lodgments -> [CGPoint] in
                let range = lodgments[lodgments.count - 1] - lodgments[0]
                let tickValue: Int = range / Contants.sliderCount
                
                var countByLodgments = [Int]()
                var checkPrice = lodgments[0] + tickValue
                var count = 0
                var maxCount = 0
                lodgments.forEach { price in
                    if price < checkPrice {
                        count += 1
                    } else {
                        countByLodgments.append(count)
                        maxCount = max(count, maxCount)
                        count = 1
                        checkPrice += tickValue
                    }
                }
                
                let points = countByLodgments.enumerated().map { index, count -> CGPoint in
                    let pointX = Double(index) / Double(Contants.sliderCount - 1)
                    let pointY = Double(count) / Double(maxCount)
                    return CGPoint(x: pointX, y: pointY)
                }
                return points
            }
            .bind(to: updatedGraphPoints)
            .disposed(by: disposeBag)
    }
}
