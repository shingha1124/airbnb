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
    let selectTravalOption = PublishRelay<NewTravalOptionType>()
    let tappedAllRemoveButton = PublishRelay<Void>()
    let tappedSearchButton = PublishRelay<Void>()
    
    func state() -> TravalOptionViewModelState { self }
    
    let showTravalOptionPage = PublishRelay<NewTravalOptionType>()
    let hiddenTravalOptionPage = PublishRelay<NewTravalOptionType>()
    let enabledSearchView = PublishRelay<Bool>()
    
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
            .map { inputTraval != nil ? .date : .traval }
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
    }
}
