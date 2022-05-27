//
//  SearchOptionViewModelProtocol.swift
//  airbnb
//
//  Created by seongha shin on 2022/05/25.
//

import Foundation
import RxRelay

protocol TravalOptionViewModelAction {
    var viewDidLoad: PublishRelay<Void> { get }
}

protocol TravalOptionViewModelState {
    var usingCategorys: PublishRelay<[TravalOptionInfo.OptionType]> { get }
    var updateTitle: PublishRelay<String> { get }
    var updateValue: PublishRelay<(TravalOptionInfo.OptionType, String)> { get }
    var showCategoryPage: BehaviorRelay<TravalOptionInfo.OptionType> { get }
}

protocol TravalOptionViewModelBinding {
    func action() -> TravalOptionViewModelAction
    func state() -> TravalOptionViewModelState
}

protocol TravalOptionViewModelProperty {
    var priceViewModel: PriceViewModelProtocol { get }
    var checkInOutViewModel: CheckInOutViewModelProtocol { get }
    var personViewModel: GuestViewModelProtocol { get }
}

typealias TravalOptionViewModelProtocol = TravalOptionViewModelBinding & TravalOptionViewModelProperty
