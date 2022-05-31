//
//  AroundTravelCellViewModelProtocol.swift
//  airbnb
//
//  Created by seongha shin on 2022/05/24.
//

import Foundation
import RxRelay

protocol ArroundTravelCellViewModelAction {
    var viewLoad: PublishRelay<Void> { get }
    var tappedCell: PublishRelay<Void> { get }
    var tappedCellWithDate: PublishRelay<ArroundTraval> { get }
}

protocol ArroundTravelCellViewModelState {
    var updateName: PublishRelay<String> { get }
    var updatedistance: PublishRelay<String> { get }
    var updateThumbnail: PublishRelay<URL> { get }
}

protocol ArroundTravelCellViewModelBinding {
    func action() -> ArroundTravelCellViewModelAction
    func state() -> ArroundTravelCellViewModelState
}

typealias ArroundTravelCellViewModelProtocol = ArroundTravelCellViewModelBinding
