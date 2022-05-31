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
    let tappedCloseSearch = PublishRelay<Void>()
    
    func state() -> TravalOptionViewModelState { self }
    
    let showTravalOptionPage = PublishRelay<NewTravalOptionType>()
    let hiddenTravalOptionPage = PublishRelay<NewTravalOptionType>()
    let enabledSearchView = PublishRelay<Bool>()
    
    let inputTravalViewModel: InputTravalViewModelProtocol = InputTravalViewModel()
    let inputDateViewModel: InputDateViewModelProtocol = InputDateViewModel()
    let searchViewModel: InputSearchViewModelProtocol = InputSearchViewModel()
    
    private let disposeBag = DisposeBag()
    
    deinit {
        Log.info("deinit TravalOptionViewModel")
    }
    
    init() {
        viewDidAppear
            .map { .traval }
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
        
        inputTravalViewModel.action().tappedSearchBar
            .map { _ in true }
            .bind(to: enabledSearchView)
            .disposed(by: disposeBag)
    }
}
