//
//  NewTravalOptionViewModelProtocol.swift
//  airbnb
//
//  Created by seongha shin on 2022/05/30.
//

import Foundation
import RxRelay

protocol NewTravalOptionViewModelAction {
    var viewDidAppear: PublishRelay<Void> { get }
    var selectTravalOption: PublishRelay<NewTravalOptionType> { get }
    var tappedCloseSearch: PublishRelay<Void> { get }
}

protocol NewTravalOptionViewModelState {
    var showTravalOptionPage: PublishRelay<NewTravalOptionType> { get }
    var hiddenTravalOptionPage: PublishRelay<NewTravalOptionType> { get }
    var enabledSearchView: PublishRelay<Bool> { get }
}

protocol NewTravalOptionViewModelBinding {
    func action() -> NewTravalOptionViewModelAction
    func state() -> NewTravalOptionViewModelState
}

protocol NewTravalOptionViewModelProperty {
    var inputTravalViewModel: InputTravalViewModelProtocol { get }
    var inputDateViewModel: InputDateViewModelProtocol { get }
    var searchViewModel: InputSearchViewModelProtocol { get }
}

typealias NewTravalOptionViewModelProtocol = NewTravalOptionViewModelBinding & NewTravalOptionViewModelProperty

enum NewTravalOptionType: CaseIterable {
    case search
    case traval
    case date
    case guest
}

@objc protocol TravalOptionAnimation {
    @objc
    optional func didShowAnimation(safeAreaGuide: UILayoutGuide)
    
    func startShowAnimation(safeAreaGuide: UILayoutGuide)
    
    @objc
    optional func finishShowAnimation()
    
    @objc
    optional func didHiddenAnimation()
    
    func startHiddenAnimation()
    @objc
    optional func finishHiddenAnimation()
}
