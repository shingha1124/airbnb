//
//  TravalOptionViewModelProtocol.swift
//  airbnb
//
//  Created by seongha shin on 2022/05/30.
//

import Foundation
import RxRelay

protocol TravalOptionViewModelAction {
    var viewDidAppear: PublishRelay<Void> { get }
    var selectTravalOption: PublishRelay<NewTravalOptionType> { get }
    var tappedAllRemoveButton: PublishRelay<Void> { get }
    var tappedSearchButton: PublishRelay<Void> { get }
}

protocol TravalOptionViewModelState {
    var showTravalOptionPage: PublishRelay<NewTravalOptionType> { get }
    var hiddenTravalOptionPage: PublishRelay<NewTravalOptionType> { get }
    var enabledSearchView: PublishRelay<Bool> { get }
}

protocol TravalOptionViewModelBinding {
    func action() -> TravalOptionViewModelAction
    func state() -> TravalOptionViewModelState
}

protocol TravalOptionViewModelProperty {
    var inputTravalViewModel: InputTravalViewModelProtocol { get }
    var inputDateViewModel: InputDateViewModelProtocol { get }
    var searchViewModel: InputSearchViewModelProtocol { get }
    var guestViewModel: InputGuestViewModelProtocol { get }
}

typealias TravalOptionViewModelProtocol = TravalOptionViewModelBinding & TravalOptionViewModelProperty

enum NewTravalOptionType: CaseIterable {
    case traval
    case date
    case guest
}

@objc protocol ViewAnimation {
    @objc
    optional func shouldAnimation(isAnimate: Bool) -> Bool
    
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
