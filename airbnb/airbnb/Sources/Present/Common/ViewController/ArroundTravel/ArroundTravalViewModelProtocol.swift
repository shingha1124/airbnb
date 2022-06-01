//
//  ArroundTravalViewModelProtocol.swift
//  airbnb
//
//  Created by seongha shin on 2022/05/24.
//

import Foundation
import RxRelay

protocol ArroundTravalViewModelAction {
    var loadArroundTravel: PublishRelay<Void> { get }
    var selectedAddress: PublishRelay<ArroundTraval> { get }
}

protocol ArroundTravalViewModelState {
    var loadedAroundTraval: PublishRelay<[ArroundTravelCellViewModel]> { get }
}

protocol ArroundTravalViewModelBinding {
    func action() -> ArroundTravalViewModelAction
    func state() -> ArroundTravalViewModelState
}

typealias ArroundTravalViewModelProtocol = ArroundTravalViewModelBinding
