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
    private var cellViewModels: [Int: LodgingListViewCellModel] = [:]

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
            .map { $0.lodgings.map { ($0.id, LodgingListViewCellModel(lodging: $0)) } }
            .withUnretained(self)
            .do { model, viewModels in
                model.cellViewModels = viewModels.reduce(into: [Int: LodgingListViewCellModel]()) {
                    $0[$1.0] = $1.1
                }
            }
            .map { _, viewModels in
                viewModels.map { $0.1 }
            }
            .share()
        
        cellViewModels
            .bind(to: state.updatedLodgingList)
            .disposed(by: disposeBag)
        
        let tappedWish = cellViewModels
            .flatMapLatest { viewModels -> Observable<(Bool, Lodging)> in
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
