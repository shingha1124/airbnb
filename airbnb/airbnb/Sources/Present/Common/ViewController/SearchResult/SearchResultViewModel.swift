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

final class SearchResultViewModel: NSObject, ViewModel {
    
    struct Action {
        let inputSearchText = PublishRelay<String>()
        let selectedAddress = PublishRelay<String>()
    }
    
    struct State {
        let updatedSearchResult = PublishRelay<[SearchResultCellViewModel]>()
    }
    
    let action = Action()
    let state = State()
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
        
        action.inputSearchText
            .bind(to: searchCompleter.rx.queryFragment)
            .disposed(by: disposeBag)
        
        state.updatedSearchResult
            .flatMapLatest { viewModels -> Observable<String> in
                let tappedCells = viewModels.map {
                    $0.action.selectedCell.asObservable()
                }
                return .merge(tappedCells)
            }
            .bind(to: action.selectedAddress)
            .disposed(by: disposeBag)
    }
}

extension SearchResultViewModel: MKLocalSearchCompleterDelegate {
    func completerDidUpdateResults(_ completer: MKLocalSearchCompleter) {
        state.updatedSearchResult.accept(completer.results.map { SearchResultCellViewModel(arround: $0.title) })
    }
}
