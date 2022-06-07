//
//  SearchResultCellViewModel.swift
//  airbnb
//
//  Created by seongha shin on 2022/05/24.
//

import Foundation
import RxRelay
import RxSwift

final class SearchResultCellViewModel: ViewModel {
    
    struct Action {
        let loadCellData = PublishRelay<Void>()
        let tappedCell = PublishRelay<Void>()
        let selectedCell = PublishRelay<String>()
    }
    
    struct State {
        let loadedCellData = PublishRelay<String>()
    }
    
    let action = Action()
    let state = State()
    let disposeBag = DisposeBag()
    
    init(arround: String) {
        action.loadCellData
            .map { arround }
            .bind(to: state.loadedCellData)
            .disposed(by: disposeBag)
        
        action.tappedCell
            .map { arround }
            .bind(to: action.selectedCell)
            .disposed(by: disposeBag)
    }
}
