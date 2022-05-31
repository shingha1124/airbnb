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
    
    func state() -> InputSearchViewModelState { self }
    
    private let disposeBag = DisposeBag()
    
    let searchResultTravelViewModel: SearchResultViewModelProtocol = SearchResultViewModel()
    
    init() {
        inputSearchText
            .compactMap { $0 }
            .bind(to: searchResultTravelViewModel.action().inputSearchText)
            .disposed(by: disposeBag)
    }
}
