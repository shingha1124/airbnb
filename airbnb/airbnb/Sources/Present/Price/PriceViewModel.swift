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
    func action() -> PriceViewModelAction { self }
    
    func state() -> PriceViewModelState { self }
    
    private let disposeBag = DisposeBag()
    
    init() {
    }
}
