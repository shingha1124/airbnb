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
        let viewDidLoad = PublishRelay<Void>()
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
    @Inject(\.travalRepository) private var travalRepository: TravalRepository
    
    deinit {
#if DEBUG
        Log.info("deinit \(String(describing: type(of: self)))")
#endif
    }
    init() {
        action.viewDidLoad
            .delay(.seconds(1), scheduler: MainScheduler.asyncInstance)
            .withUnretained(self)
            .filter { model, _ in
                model.tokenStore.getToken() == nil
            }
            .mapVoid()
            .bind(to: state.presentLoginView)
            .disposed(by: disposeBag)
        
        Observable
            .merge(
                action.viewDidLoad
                    .map {
                        TravalSearchData(region: "서울", checkInOut: CheckInOut(checkIn: nil, checkOut: nil), guests: [])
                    },
                action.searchLodgingList.asObservable()
            )
            .bind(to: lodgingListViewModel.action.searchLodgingList)
            .disposed(by: disposeBag)
    }
}
