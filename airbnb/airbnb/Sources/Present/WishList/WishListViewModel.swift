//
//  WishListViewModel.swift
//  airbnb
//
//  Created by seongha shin on 2022/06/08.
//

import Foundation
import RxRelay
import RxSwift

final class WishListViewModel: ViewModel {
    struct Action {
        let checkLogin = PublishRelay<Void>()
    }
    
    struct State {
        let isLogin = PublishRelay<Bool>()
        let updateWishList = PublishRelay<[WishListViewCellModel]>()
        let presentDetailView = PublishRelay<Int>()
    }
    
    let action = Action()
    let state = State()
    let disposeBag = DisposeBag()
    
    let lodgingListViewModel = LodgingListViewModel()
    
    @Inject(\.tokenStore) private var tokenStore: TokenStore
    @Inject(\.travalRepository) private var travalRepository: TravalRepository
    
    init() {
        let checkLogin = action.checkLogin
            .withUnretained(self)
            .map { model, _ in
                model.tokenStore.hasToken()
            }
            .share()
        
        checkLogin
            .bind(to: state.isLogin)
            .disposed(by: disposeBag)
        
        let requestWishList = checkLogin
            .filter { $0 }
            .withUnretained(self)
            .flatMapLatest { model, _ in
                model.travalRepository.requestWishList()
            }
            .share()
        
        let cellViewModels = requestWishList
            .compactMap { $0.value }
            .map { $0.map { WishListViewCellModel(wish: $0) } }
            .share()
        
        cellViewModels
            .bind(to: state.updateWishList)
            .disposed(by: disposeBag)
                
        let tappedWish = cellViewModels
            .flatMapLatest { viewModels -> Observable<Wish> in
                let tappedWish = viewModels.map {
                    $0.action.tappedWishButtonWithValue.asObservable()
                }
                return .merge(tappedWish)
            }
            .share()
        
        tappedWish
            .bind(onNext: {
                print("tapped Wish: \($0)")
            })
            .disposed(by: disposeBag)
        
        let tappedCell = cellViewModels
            .flatMapLatest { viewModels -> Observable<Wish> in
                let tappedCell = viewModels.map {
                    $0.action.tappedCellWithValue.asObservable()
                }
                return .merge(tappedCell)
            }
            .share()
        
        tappedCell
            .map { $0.id }
            .bind(to: state.presentDetailView)
            .disposed(by: disposeBag)
    }
}
