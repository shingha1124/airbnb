//
//  SearchViewProtocol.swift
//  airbnb
//
//  Created by seongha shin on 2022/05/24.
//

import Foundation
import RxRelay

protocol SearchViewModelAction {
    var loadAroundTraval: PublishRelay<Void> { get }
    var inputSearchText: PublishRelay<String?> { get }
    var clearSearchText: PublishRelay<Void> { get }
}

protocol SearchViewModelState {
    var loadedAroundTraval: PublishRelay<[ArroundTraval]> { get }
    var presentSearchOption: PublishRelay<String> { get }
    var showArroundTravalView: PublishRelay<Bool> { get }
    var showSearchResultView: PublishRelay<Bool> { get }
    var enabledClearButton: PublishRelay<Bool> { get }
    var clearedSearchText: PublishRelay<Void> { get }
}

protocol SearchViewModelBinding {
    func action() -> SearchViewModelAction
    func state() -> SearchViewModelState
}

protocol SearchViewModelProperty {
    var arroundTravelViewModel: ArroundTravalViewModelProtocol { get }
    var searchResultTravelViewModel: SearchResultViewModelProtocol { get }
}

typealias SearchViewModelProtocol = SearchViewModelBinding & SearchViewModelProperty
