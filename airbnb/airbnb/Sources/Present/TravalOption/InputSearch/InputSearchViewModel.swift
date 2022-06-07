//
//  InputSearchViewModel.swift
//  airbnb
//
//  Created by seongha shin on 2022/05/31.
//

import Foundation
import RxRelay
import RxSwift

final class InputSearchViewModel: ViewModel {
    
    struct Action {
        let inputSearchText = PublishRelay<String?>()
        let editingDidEndOnExit = PublishRelay<String?>()
        let selectedAddress = PublishRelay<String?>()
    }
    
    struct State {
    }
    
    let action = Action()
    let state = State()
    
    private let disposeBag = DisposeBag()
    
    let searchResultViewModel = SearchResultViewModel()
    
    deinit {
#if DEBUG
        Log.info("deinit \(String(describing: type(of: self)))")
#endif
    }
    
    init() {
        action.inputSearchText
            .compactMap { $0 }
            .bind(to: searchResultViewModel.action.inputSearchText)
            .disposed(by: disposeBag)
        
        searchResultViewModel.action.selectedAddress
            .bind(to: action.selectedAddress)
            .disposed(by: disposeBag)
    }
}
