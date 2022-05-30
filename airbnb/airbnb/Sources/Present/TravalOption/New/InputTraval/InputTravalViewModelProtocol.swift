//
//  InputTravalViewModelProtocol.swift
//  airbnb
//
//  Created by seongha shin on 2022/05/30.
//

import Foundation
import RxRelay

protocol InputTravalViewModelAction {
    var loadAroundTraval: PublishRelay<Void> { get }
    var textDidBeginEditing: PublishRelay<Void> { get }
    var inputSearctText: PublishRelay<String> { get }
}

protocol InputTravalViewModelState {
    var loadedAroundTraval: PublishRelay<[ArroundTraval]> { get }
    var resetHeight: PublishRelay<Void> { get }
}

protocol InputTravalViewModelBinding {
    func action() -> InputTravalViewModelAction
    func state() -> InputTravalViewModelState
}

protocol InputTravalViewModelProperty {
    var arroundTravelViewModel: ArroundTravalViewModelProtocol { get }
    var searchResultTravelViewModel: SearchResultViewModelProtocol { get }
}

typealias InputTravalViewModelProtocol = InputTravalViewModelBinding & InputTravalViewModelProperty
