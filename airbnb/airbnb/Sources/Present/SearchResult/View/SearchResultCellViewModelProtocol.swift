//
//  SearchResultCellViewModelProtocol.swift
//  airbnb
//
//  Created by seongha shin on 2022/05/24.
//

import Foundation
import RxRelay

protocol SearchResultCellViewModelAction {
    var tappedCell: PublishRelay<String> { get }
}

protocol SearchResultCellViewModelState {
    var arround: String { get }
}

protocol SearchResultCellViewModelBinding {
    func action() -> SearchResultCellViewModelAction
    func state() -> SearchResultCellViewModelState
}

typealias SearchResultCellViewModelProtocol = SearchResultCellViewModelBinding
