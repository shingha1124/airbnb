//
//  LodgingListViewModel.swift
//  airbnb
//
//  Created by seongha shin on 2022/06/07.
//

import Foundation
import RxRelay
import RxSwift

final class LodgingListViewModel: ViewModel {
    
    struct Action {
        let searchLodgingList = PublishRelay<TravalSearchData>()
    }
    
    struct State {
        let updatedLodgingList = PublishRelay<[LodgingListViewCellModel]>()
        let presentDetailView = PublishRelay<Int>()
    }
    
    let action = Action()
    let state = State()
    private let disposeBag = DisposeBag()

    @Inject(\.travalRepository) private var travalRepository: TravalRepository
    
    init() {
        let requestLodgingList = action.searchLodgingList
            .withUnretained(self)
            .flatMapLatest { model, searchData in
                model.travalRepository.requestSearch(searchData: searchData)
            }
            .share()
        
        let cellViewModels = requestLodgingList
            .compactMap { $0.value }
            .map { $0.lodgings.map { LodgingListViewCellModel(lodging: $0) } }
            .share()
        
        cellViewModels
            .bind(to: state.updatedLodgingList)
            .disposed(by: disposeBag)
        
        let tappedWish = cellViewModels
            .flatMapLatest { viewModels -> Observable<Lodging> in
                let tappedWish = viewModels.map {
                    $0.action.tappedWishButtonWithValue.asObservable()
                }
                return .merge(tappedWish)
            }
            .share()
        
        let requestAddWish = tappedWish
            .withUnretained(self)
            .flatMapLatest { model, lodging in
                model.travalRepository.requestWishAdd(id: lodging.id)
            }
            .share()
        
        requestAddWish
            .compactMap { $0.value }
            .bind(onNext: {
                print("tapped Wish: 1231231232")
                print("tapped Wish: \($0)")
            })
            .disposed(by: disposeBag)
        
        let tappedCell = cellViewModels
            .flatMapLatest { viewModels -> Observable<Lodging> in
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
