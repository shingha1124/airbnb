//
//  GuestOptionItemViewModelProtocol.swift
//  airbnb
//
//  Created by seongha shin on 2022/06/01.
//

import Foundation
import RxRelay

protocol GuestOptionItemViewModelAction {
    var loadGuestData: PublishRelay<Void> { get }
    var tappedChangeCount: PublishRelay<Int> { get }
    var changeGuestCount: PublishRelay<ChangeGuestCount> { get }
}

protocol GuestOptionItemViewModelState {
    var updateTitle: PublishRelay<String> { get }
    var updateDescription: PublishRelay<String> { get }
    var updateCount: PublishRelay<Int> { get }
    var isMax: PublishRelay<Bool> { get }
}

protocol GuestOptionItemViewModelBinding {
    func action() -> GuestOptionItemViewModelAction
    func state() -> GuestOptionItemViewModelState
}

typealias GuestOptionItemViewModelProtocol = GuestOptionItemViewModelBinding

typealias ChangeGuestCount = (type: GuestType, value: Int, addValue: Int)
typealias GuestCount = (type: GuestType, value: Int)
