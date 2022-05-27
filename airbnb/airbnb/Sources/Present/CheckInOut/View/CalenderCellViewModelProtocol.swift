//
//  CalenderCellViewModelProtocol.swift
//  airbnb
//
//  Created by seongha shin on 2022/05/25.
//

import Foundation
import RxRelay

protocol CalenderCellViewModelAction {
    var viewLoad: PublishRelay<Void> { get }
    var tappedCell: PublishRelay<Void> { get }
    var tappedCellWithDate: PublishRelay<Date?> { get }
}

protocol CalenderCellViewModelState {
    var updateDate: PublishRelay<Date?> { get }
    var updateState: PublishRelay<CalenderCellState> { get }
}

protocol CalenderCellViewModelBinding {
    func action() -> CalenderCellViewModelAction
    func state() -> CalenderCellViewModelState
}

protocol CalenderCellViewModelProperty {
    var isNil: Bool { get }
}

typealias CalenderCellViewModelProtocol = CalenderCellViewModelBinding & CalenderCellViewModelProperty

enum CalenderCellState {
    case none
    case start
    case end
    case inRange
    case notSelect
}
