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
        
        requestLodgingList
            .compactMap { $0.value }
            .map { $0.map { LodgingListViewCellModel(lodging: $0) } }
            .bind(to: state.updatedLodgingList)
            .disposed(by: disposeBag)
    }
}
