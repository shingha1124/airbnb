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
    
    let tappedCell = PublishRelay<String>()
    
    func state() -> SearchResultCellViewModelState { self }
    
    let arround: String
    
    init(arround: String) {
        self.arround = arround
    }
}
