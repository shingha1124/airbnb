//
//  SearchResultCellViewModel.swift
//  airbnb
//
//  Created by seongha shin on 2022/05/24.
//

import Foundation
import RxRelay
import RxSwift

final class SearchResultCellViewModel: SearchResultCellViewModelBinding, SearchResultCellViewModelAction, SearchResultCellViewModelState {
    
    func action() -> SearchResultCellViewModelAction { self }
    
    let loadCellData = PublishRelay<Void>()
    let tappedCell = PublishRelay<Void>()
    let selectedCell = PublishRelay<String>()
    
    func state() -> SearchResultCellViewModelState { self }
    
    let loadedCellData = PublishRelay<String>()
    
    private var disposeBag = DisposeBag()
    
    init(arround: String) {
        loadCellData
            .map { arround }
            .bind(to: loadedCellData)
            .disposed(by: disposeBag)
        
        tappedCell
            .map { arround }
            .bind(to: selectedCell)
            .disposed(by: disposeBag)
    }
}
