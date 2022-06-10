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
    private var cellViewModels: [Int: WishListViewCellModel] = [:]
    
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
            .map { $0.map { ($0.id, WishListViewCellModel(wish: $0)) } }
            .withUnretained(self)
            .do { model, viewModels in
                model.cellViewModels = viewModels.reduce(into: [Int: WishListViewCellModel]()) {
                    $0[$1.0] = $1.1
                }
            }
            .map { _, viewModels in
                viewModels.map { $0.1 }
            }
            .share()
        
        cellViewModels
            .bind(to: state.updateWishList)
            .disposed(by: disposeBag)
                
        let tappedWish = cellViewModels
            .flatMapLatest { viewModels -> Observable<(Bool, Wish)> in
                let tappedWish = viewModels.map {
                    $0.action.tappedWishButtonWithValue.asObservable()
                }
                return .merge(tappedWish)
            }
            .share()
        
        let requestSwitchWish = tappedWish
            .withUnretained(self)
            .flatMapLatest { model, wish in
                model.travalRepository.requestSwitchWish(wish: wish.0, id: wish.1.id)
            }
            .share()
        
        requestSwitchWish
            .compactMap { $0.value }
            .withUnretained(self)
            .compactMap { model, value in
                model.cellViewModels[value]
            }
            .bind(onNext: { viewModel in
                viewModel.action.switchWish.accept(())
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
