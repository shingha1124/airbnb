//
//  SearchResultViewModelProtocol.swift
//  airbnb
//
//  Created by seongha shin on 2022/05/24.
//

import Foundation
import RxRelay

protocol SearchResultViewModelAction {
    var inputSearchText: PublishRelay<String> { get }
}

protocol SearchResultViewModelState {
    var updatedSearchResult: PublishRelay<[SearchResultCellViewModel]> { get }
    var selectedAddress: PublishRelay<String> { get }
}

protocol SearchResultViewModelBinding {
    func action() -> SearchResultViewModelAction
    func state() -> SearchResultViewModelState
}

typealias SearchResultViewModelProtocol = SearchResultViewModelBinding
