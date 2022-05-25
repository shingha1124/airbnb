//
//  RecommandTravelViewModelProtocol.swift
//  airbnb
//
//  Created by seongha shin on 2022/05/24.
//

import Foundation
import RxRelay

protocol RecommandTravelViewModelAction {
    var loadRecommandTravel: PublishRelay<Void> { get }
}

protocol RecommandTravelViewModelState {
    var loadedRecommandTraval: PublishRelay<[RecommandTraval]> { get }
}

protocol RecommandTravelViewModelBinding {
    func action() -> RecommandTravelViewModelAction
    func state() -> RecommandTravelViewModelState
}

typealias RecommandTravelViewModelProtocol = RecommandTravelViewModelBinding
