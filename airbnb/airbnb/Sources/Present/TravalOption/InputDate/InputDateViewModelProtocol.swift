//
//  InputDateViewModelProtocol.swift
//  airbnb
//
//  Created by seongha shin on 2022/05/31.
//

import Foundation
import RxRelay

protocol InputDateViewModelAction {
    var tappedSkipButton: PublishRelay<Void> { get }
    var tappedRemoveButton: PublishRelay<Void> { get }
    var tappedNextButton: PublishRelay<Void> { get }
}

protocol InputDateViewModelState {
    var updateCheckInOut: PublishRelay<String> { get }
    var isHiddenSkipButton: PublishRelay<Bool> { get }
    var isHiddenRemoveButton: PublishRelay<Bool> { get }
}

protocol InputDateViewModelBinding {
    func action() -> InputDateViewModelAction
    func state() -> InputDateViewModelState
}

protocol InputDateViewModelProperty {
    var checkInOutViewModel: CheckInOutViewModelProtocol { get }
}

typealias InputDateViewModelProtocol = InputDateViewModelBinding & InputDateViewModelProperty
