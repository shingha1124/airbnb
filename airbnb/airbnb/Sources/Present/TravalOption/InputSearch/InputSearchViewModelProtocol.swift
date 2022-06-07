//
//  InputSearchViewModelProtocol.swift
//  airbnb
//
//  Created by seongha shin on 2022/05/31.
//

import Foundation
import RxRelay

protocol InputSearchViewModelAction {
    var inputSearchText: PublishRelay<String?> { get }
    var editingDidEndOnExit: PublishRelay<String?> { get }
    var selectedAddress: PublishRelay<String?> { get }
}

protocol InputSearchViewModelState {
}

protocol InputSearchViewModelBinding {
    func action() -> InputSearchViewModelAction
    func state() -> InputSearchViewModelState
}

protocol InputSearchViewModelProperty {
    var searchResultTravelViewModel: SearchResultViewModelProtocol { get }
}

typealias InputSearchViewModelProtocol = InputSearchViewModelBinding & InputSearchViewModelProperty
