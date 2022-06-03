//
//  InputSearchViewModelProtocol.swift
//  airbnb
//
//  Created by seongha shin on 2022/05/31.
//

import Foundation
import RxRelay

protocol InputGuestViewModelAction {
    var viewDidLoad: PublishRelay<Void> { get }
    var tappedRemoveButton: PublishRelay<Void> { get }
}

protocol InputGuestViewModelState {
    var updateGuestCount: BehaviorRelay<[Int]> { get }
}

protocol InputGuestViewModelBinding {
    func action() -> InputGuestViewModelAction
    func state() -> InputGuestViewModelState
}

protocol InputGuestViewModelProperty {
    var guestViewModel: GuestViewModelProtocol { get }
}

typealias InputGuestViewModelProtocol = InputGuestViewModelBinding & InputGuestViewModelProperty
