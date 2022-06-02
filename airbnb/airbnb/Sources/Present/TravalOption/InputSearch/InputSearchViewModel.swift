//
//  InputSearchViewModel.swift
//  airbnb
//
//  Created by seongha shin on 2022/05/31.
//

import Foundation
import RxRelay
import RxSwift

final class InputSearchViewModel: InputSearchViewModelProtocol, InputSearchViewModelAction, InputSearchViewModelState {
    func action() -> InputSearchViewModelAction { self }
    
    let inputSearchText = PublishRelay<String?>()
    let editingDidEndOnExit = PublishRelay<String?>()
    let selectedAddress = PublishRelay<String?>()
    
    func state() -> InputSearchViewModelState { self }
    
    private let disposeBag = DisposeBag()
    
    let searchResultTravelViewModel: SearchResultViewModelProtocol = SearchResultViewModel()
    
    deinit {
        Log.info("deinit InputSearchViewModel")
    }
    
    init() {
        inputSearchText
            .compactMap { $0 }
            .bind(to: searchResultTravelViewModel.action().inputSearchText)
            .disposed(by: disposeBag)
        
        searchResultTravelViewModel.action().selectedAddress
            .bind(to: selectedAddress)
            .disposed(by: disposeBag)
    }
}
