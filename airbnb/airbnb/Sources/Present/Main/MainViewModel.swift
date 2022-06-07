//
//  MainViewModel.swift
//  airbnb
//
//  Created by seongha shin on 2022/05/23.
//

import Foundation
import RxRelay
import RxSwift

final class MainViewModel: ViewModel {
    
    struct Action {
        let searchLodgingList = PublishRelay<TravalSearchData>()
    }
    
    struct State {
    }
    
    let action = Action()
    let state = State()
    private let disposeBag = DisposeBag()
    
    let mapViewModel = MapViewModel()
    let lodgingListViewModel = LodgingListViewModel()
    
    deinit {
#if DEBUG
        Log.info("deinit \(String(describing: type(of: self)))")
#endif
    }
    init() {
        action.searchLodgingList
            .bind(to: lodgingListViewModel.action.searchLodgingList)
            .disposed(by: disposeBag)
    }
}
