//
//  SearchResultViewModel.swift
//  airbnb
//
//  Created by seongha shin on 2022/05/24.
//

import Foundation
import MapKit
import RxRelay
import RxSwift

final class SearchResultViewModel: NSObject, SearchResultViewModelBinding, SearchResultViewModelAction, SearchResultViewModelState {
    func action() -> SearchResultViewModelAction { self }
    
    let inputSearchText = PublishRelay<String>()
    
    func state() -> SearchResultViewModelState { self }
    
    let updatedSearchResult = PublishRelay<[SearchResultCellViewModel]>()
    let selectedAddress = PublishRelay<String>()
    
    private let disposeBag = DisposeBag()
    
    private lazy var searchCompleter: MKLocalSearchCompleter = {
        let completer = MKLocalSearchCompleter()
        completer.resultTypes = .address
        completer.region = MKCoordinateRegion(MKMapRect.world)
        completer.delegate = self
        return completer
    }()
    
    override init() {
        super.init()
        
        inputSearchText
            .withUnretained(self)
            .bind(onNext: { model, text in
                model.searchCompleter.queryFragment = text
            })
            .disposed(by: disposeBag)
        
        updatedSearchResult
            .flatMapLatest { viewModels -> Observable<String> in
                let tappedCells = viewModels.map {
                    $0.action().tappedCell.asObservable()
                }
                return .merge(tappedCells)
            }
            .bind(to: selectedAddress)
            .disposed(by: disposeBag)
    }
}

extension SearchResultViewModel: MKLocalSearchCompleterDelegate {
    func completerDidUpdateResults(_ completer: MKLocalSearchCompleter) {
        updatedSearchResult.accept(completer.results.map { SearchResultCellViewModel(arround: $0.title) })
    }
}
