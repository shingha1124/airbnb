//
//  CalenderViewModelProtocol.swift
//  airbnb
//
//  Created by seongha shin on 2022/05/25.
//

import Foundation
import RxDataSources
import RxRelay

protocol CheckInOutViewModelAction {
    var viewDidLoad: PublishRelay<Void> { get }
}

protocol CheckInOutViewModelState {
    var showCalender: PublishRelay<[SectionModel<String, CalenderCellViewModel>]> { get }
    var updateCheckInOut: BehaviorRelay<(Date?, Date?)> { get }
}

protocol CheckInOutViewModelBinding {
    func action() -> CheckInOutViewModelAction
    func state() -> CheckInOutViewModelState
}

typealias CheckInOutViewModelProtocol = CheckInOutViewModelBinding
