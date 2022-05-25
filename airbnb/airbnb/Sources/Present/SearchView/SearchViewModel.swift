//
//  SearchViewModel.swift
//  airbnb
//
//  Created by seongha shin on 2022/05/23.
//

import Foundation
import RxRelay
import RxSwift

final class SearchViewModel: SearchViewModelBinding, SearchViewModelProperty, SearchViewModelAction, SearchViewModelState {
    func action() -> SearchViewModelAction { self }
    
    let loadAroundTraval = PublishRelay<Void>()
    let inputSearchText = PublishRelay<String?>()
    let clearSearchText = PublishRelay<Void>()
    
    func state() -> SearchViewModelState { self }
    
    let loadedAroundTraval = PublishRelay<[ArroundTraval]>()
    let presentSearchOption = PublishRelay<String>()
    let showArroundTravalView = PublishRelay<Bool>()
    let showSearchResultView = PublishRelay<Bool>()
    let enabledClearButton = PublishRelay<Bool>()
    let clearedSearchText = PublishRelay<Void>()
    
    let arroundTravelViewModel: ArroundTravalViewModelProtocol = ArroundTravalViewModel()
    let searchResultTravelViewModel: SearchResultViewModelProtocol = SearchResultViewModel()
    
    @Inject(\.travalRepository) private var homeRepository: TravalRepository
    private let disposeBag = DisposeBag()
    
    init() {
        let requestAroundTraval = loadAroundTraval
            .withUnretained(self)
            .flatMapLatest { model, _ in
                model.homeRepository.requestAroundTraval()
            }
            .share()
        
        requestAroundTraval
            .compactMap { $0.value }
            .bind(to: loadedAroundTraval)
            .disposed(by: disposeBag)
        
        inputSearchText
            .compactMap { $0 }
            .bind(to: searchResultTravelViewModel.action().inputSearchText)
            .disposed(by: disposeBag)
        
        inputSearchText
            .map { !$0.isNilOrEmpty }
            .bind(to: showArroundTravalView)
            .disposed(by: disposeBag)
        
        inputSearchText
            .map { $0.isNilOrEmpty }
            .bind(to: showSearchResultView)
            .disposed(by: disposeBag)
        
        inputSearchText
            .map { !$0.isNilOrEmpty }
            .bind(to: enabledClearButton)
            .disposed(by: disposeBag)
        
        clearSearchText
            .map { "" }
            .bind(to: inputSearchText)
            .disposed(by: disposeBag)
        
        clearSearchText
            .bind(to: clearedSearchText)
            .disposed(by: disposeBag)
        
        Observable
            .merge(
                arroundTravelViewModel.state().selectedAddress.map { $0.name }.asObservable(),
                searchResultTravelViewModel.state().selectedAddress.asObservable()
            )
            .bind(to: presentSearchOption)
            .disposed(by: disposeBag)
    }
}
