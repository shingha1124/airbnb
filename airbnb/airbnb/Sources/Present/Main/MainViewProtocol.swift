//
//  MainViewProtocol.swift
//  airbnb
//
//  Created by seongha shin on 2022/05/24.
//

import Foundation
import RxRelay

protocol MainViewModelAction {
//    var loadHome: PublishRelay<Void> { get }
}

protocol MainViewModelState {
//    var loadedHeroImage: PublishRelay<URL> { get }
//    var presentSearchOption: PublishRelay<String> { get }
}

protocol MainViewModelBinding {
    func action() -> MainViewModelAction
    func state() -> MainViewModelState
}

protocol MainViewModelProperty {
    var mapViewModel: MapViewModel { get }
//    var recommandTravelViewModel: RecommandTravelViewModelProtocol { get }
}

typealias MainViewModelProtocol = MainViewModelBinding & MainViewModelProperty & MainViewModelAction & MainViewModelState
