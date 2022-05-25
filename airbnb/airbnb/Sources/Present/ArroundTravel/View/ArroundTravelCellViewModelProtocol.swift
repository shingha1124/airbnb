//
//  AroundTravelCellViewModelProtocol.swift
//  airbnb
//
//  Created by seongha shin on 2022/05/24.
//

import Foundation
import RxRelay

protocol ArroundTravelCellViewModelAction {
    var tappedCell: PublishRelay<ArroundTraval> { get }
}

protocol ArroundTravelCellViewModelState {
    var arroundTraval: ArroundTraval { get }
}

protocol ArroundTravelCellViewModelBinding {
    func action() -> ArroundTravelCellViewModelAction
    func state() -> ArroundTravelCellViewModelState
}

typealias ArroundTravelCellViewModelProtocol = ArroundTravelCellViewModelBinding
