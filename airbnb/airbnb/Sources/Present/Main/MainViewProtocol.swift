//
//  MainViewProtocol.swift
//  airbnb
//
//  Created by seongha shin on 2022/05/24.
//

import Foundation
import RxRelay

protocol MainViewModelAction {
    var loadHome: PublishRelay<Void> { get }
}

protocol MainViewModelState {
    var loadedHeroImage: PublishRelay<URL> { get }
}

protocol MainViewModelBinding {
    func action() -> MainViewModelAction
    func state() -> MainViewModelState
}

protocol MainViewModelProperty {
    var arroundTravelViewModel: ArroundTravalViewModelProtocol { get }
    var recommandTravelViewModel: RecommandTravelViewModelProtocol { get }
}

typealias MainViewModelProtocol = MainViewModelBinding & MainViewModelProperty & MainViewModelAction & MainViewModelState
