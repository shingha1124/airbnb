//
//  InputDateViewModelProtocol.swift
//  airbnb
//
//  Created by seongha shin on 2022/05/31.
//

import Foundation
import RxRelay

protocol InputDateViewModelAction {
}

protocol InputDateViewModelState {
}

protocol InputDateViewModelBinding {
    func action() -> InputDateViewModelAction
    func state() -> InputDateViewModelState
}

protocol InputDateViewModelProperty {
    var checkInOutViewModel: CheckInOutViewModelProtocol { get }
}

typealias InputDateViewModelProtocol = InputDateViewModelBinding & InputDateViewModelProperty
