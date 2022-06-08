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
        let checkLogin = PublishRelay<Void>()
        let searchLodgingList = PublishRelay<TravalSearchData>()
    }
    
    struct State {
        let presentLoginView = PublishRelay<Void>()
    }
    
    let action = Action()
    let state = State()
    private let disposeBag = DisposeBag()
    
    let mapViewModel = MapViewModel()
    let lodgingListViewModel = LodgingListViewModel()
    
    @Inject(\.tokenStore) private var tokenStore: TokenStore
    
    deinit {
#if DEBUG
        Log.info("deinit \(String(describing: type(of: self)))")
#endif
    }
    init() {
        action.checkLogin
            .delay(.seconds(1), scheduler: MainScheduler.asyncInstance)
            .withUnretained(self)
            .filter { model, _ in
                model.tokenStore.getToken() == nil
            }
            .mapVoid()
            .bind(to: state.presentLoginView)
            .disposed(by: disposeBag)
        
        action.searchLodgingList
            .bind(to: lodgingListViewModel.action.searchLodgingList)
            .disposed(by: disposeBag)
    }
}
