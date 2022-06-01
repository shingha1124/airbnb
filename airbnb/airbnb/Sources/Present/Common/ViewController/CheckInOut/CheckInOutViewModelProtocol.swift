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
    var tappedRemoveButton: PublishRelay<Void> { get }
}

protocol CheckInOutViewModelState {
    var showCalender: PublishRelay<[SectionModel<String, CalenderCellViewModel>]> { get }
    var selectedDates: PublishRelay<CheckInOut> { get }
}

protocol CheckInOutViewModelBinding {
    func action() -> CheckInOutViewModelAction
    func state() -> CheckInOutViewModelState
}

typealias CheckInOutViewModelProtocol = CheckInOutViewModelBinding
typealias CheckInOut = (checkIn: Date?, checkOut: Date?)
