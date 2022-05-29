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
    var viewDidAppear: PublishRelay<Void> { get }
    var tappedCategory: PublishRelay<TravalOptionInfoType> { get }
}

protocol TravalOptionViewModelState {
    var showCategorys: PublishRelay<[TravalOptionInfoType]> { get }
    var showCategoryPage: BehaviorRelay<TravalOptionInfoType> { get }
    var updateTitle: PublishRelay<String> { get }
    var updateCategoryValue: PublishRelay<(TravalOptionInfoType, String)> { get }
    var updateToolbarButtons: PublishRelay<[TravalOptionToolBarButtons]> { get }
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
typealias TravalOptionToolBarButtons = (type: TravalOptionToolBarType, isEnable: Bool)

enum TravalOptionToolBarType: CaseIterable {
    case skip
    case reset
    case next
    case search
    case flexible
}

enum TravalOptionViewType {
    case search
    case reservation
    
    var title: String {
        switch self {
        case .search: return "숙소 찾기"
        case .reservation: return "숙소 예약"
        }
    }
}
