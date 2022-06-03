//
//  InputTravalViewModelProtocol.swift
//  airbnb
//
//  Created by seongha shin on 2022/05/30.
//

import Foundation
import RxRelay

protocol InputTravalViewModelAction {
    var viewDidLoad: PublishRelay<Void> { get }
    var loadAroundTraval: PublishRelay<Void> { get }
    var tappedSearchBar: PublishRelay<Void> { get }
}

protocol InputTravalViewModelState {
    var loadedAroundTraval: PublishRelay<[ArroundTraval]> { get }
    var inputTravalResult: BehaviorRelay<String?> { get }
}

protocol InputTravalViewModelBinding {
    func action() -> InputTravalViewModelAction
    func state() -> InputTravalViewModelState
}

protocol InputTravalViewModelProperty {
    var arroundTravelViewModel: ArroundTravalViewModelProtocol { get }
}

typealias InputTravalViewModelProtocol = InputTravalViewModelBinding & InputTravalViewModelProperty
