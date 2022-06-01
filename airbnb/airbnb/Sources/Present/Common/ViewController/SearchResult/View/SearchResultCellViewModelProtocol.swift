//
//  SearchResultCellViewModelProtocol.swift
//  airbnb
//
//  Created by seongha shin on 2022/05/24.
//

import Foundation
import RxRelay

protocol SearchResultCellViewModelAction {
    var loadCellData: PublishRelay<Void> { get }
    var tappedCell: PublishRelay<Void> { get }
    var selectedCell: PublishRelay<String> { get }
}

protocol SearchResultCellViewModelState {
    var loadCellData: PublishRelay<Void> { get }
    var loadedCellData: PublishRelay<String> { get }
}

protocol SearchResultCellViewModelBinding {
    func action() -> SearchResultCellViewModelAction
    func state() -> SearchResultCellViewModelState
}

typealias SearchResultCellViewModelProtocol = SearchResultCellViewModelBinding
