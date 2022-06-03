//
//  TravalOptionViewModel.swift
//  airbnb
//
//  Created by seongha shin on 2022/05/30.
//

import Foundation
import RxRelay
import RxSwift

final class TravalOptionViewModel: TravalOptionViewModelBinding, TravalOptionViewModelAction, TravalOptionViewModelState, TravalOptionViewModelProperty {
    func action() -> TravalOptionViewModelAction { self }
    
    let viewDidAppear = PublishRelay<Void>()
    let selectTravalOption = PublishRelay<TravalOptionType>()
    let tappedAllRemoveButton = PublishRelay<Void>()
    let tappedSearchButton = PublishRelay<Void>()
    let tappedCloseButton = PublishRelay<Void>()
    
    func state() -> TravalOptionViewModelState { self }
    
    let showTravalOptionPage = PublishRelay<TravalOptionType>()
    let hiddenTravalOptionPage = PublishRelay<TravalOptionType>()
    let enabledSearchView = PublishRelay<Bool>()
    let closedViewController = PublishRelay<Void>()
    
    let inputTravalViewModel: InputTravalViewModelProtocol
    let inputDateViewModel: InputDateViewModelProtocol = InputDateViewModel()
    let searchViewModel: InputSearchViewModelProtocol = InputSearchViewModel()
    let guestViewModel: InputGuestViewModelProtocol = InputGuestViewModel()
    
    private let disposeBag = DisposeBag()
    
    deinit {
        Log.info("deinit TravalOptionViewModel")
    }
    
    init(inputTraval: String? = nil) {
        
        inputTravalViewModel = InputTravalViewModel(inputTraval: inputTraval)
        
        viewDidAppear
            .map { _ -> TravalOptionType in
                if let inputTraval = inputTraval,
                   inputTraval.isEmpty {
                    return .traval
                }
                return .date
            }
            .bind(to: showTravalOptionPage)
            .disposed(by: disposeBag)
        
        selectTravalOption
            .withLatestFrom(showTravalOptionPage) { (show: $0, hidden: $1) }
            .withUnretained(self)
            .do { model, viewSwitch in
                model.hiddenTravalOptionPage.accept(viewSwitch.hidden)
            }
            .map { _, viewSwitch in viewSwitch.show }
            .bind(to: showTravalOptionPage)
            .disposed(by: disposeBag)
        
        Observable
            .merge(
                inputTravalViewModel.action().tappedSearchBar.map { _ in true },
                searchViewModel.action().editingDidEndOnExit.map { _ in false },
                searchViewModel.action().selectedAddress.map { _ in false }
            )
            .bind(to: enabledSearchView)
            .disposed(by: disposeBag)
        
        Observable
            .merge(
                searchViewModel.action().editingDidEndOnExit.asObservable(),
                searchViewModel.action().selectedAddress.asObservable()
            )
            .bind(to: inputTravalViewModel.state().inputTravalResult)
            .disposed(by: disposeBag)
        
        Observable
            .merge(
                searchViewModel.action().editingDidEndOnExit.map { _ in .date },
                searchViewModel.action().selectedAddress.map { _ in .date },
                inputDateViewModel.action().tappedSkipButton.map { _ in .guest },
                inputDateViewModel.action().tappedNextButton.map { _ in .guest }
            )
            .bind(to: selectTravalOption)
            .disposed(by: disposeBag)
        
        tappedAllRemoveButton
            .map { "" }
            .bind(to: inputTravalViewModel.state().inputTravalResult)
            .disposed(by: disposeBag)
        
        tappedAllRemoveButton
            .bind(to: inputDateViewModel.action().tappedRemoveButton)
            .disposed(by: disposeBag)
        
        tappedAllRemoveButton
            .bind(to: guestViewModel.action().tappedRemoveButton)
            .disposed(by: disposeBag)
        
        tappedCloseButton
//            .withUnretained(self)
//            .do { model, _  in
//                let traval = model.inputTravalViewModel.state().inputTravalResult.value
//                let checkInOut = model.inputDateViewModel.state().updateCheckInOut.value
//                let guest = model.guestViewModel.state().updateGuestCount.value
//            }
//            .mapVoid()
            .bind(to: closedViewController)
            .disposed(by: disposeBag)
    }
}
