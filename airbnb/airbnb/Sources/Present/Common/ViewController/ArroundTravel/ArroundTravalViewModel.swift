//
//  ArroundTravalViewModel.swift
//  airbnb
//
//  Created by seongha shin on 2022/05/24.
//

import Foundation
import RxRelay
import RxSwift

final class ArroundTravalViewModel: ViewModel {
    
    struct Action {
        let loadArroundTravel = PublishRelay<Void>()
        let selectedAddress = PublishRelay<ArroundTraval>()
    }
    
    struct State {
        let loadedAroundTraval = PublishRelay<[ArroundTravelCellViewModel]>()
    }
    
    let disposeBag = DisposeBag()
    let action = Action()
    let state = State()
    
    @Inject(\.travalRepository) private var travalRepository: TravalRepository
        
    init() {
        let requestAroundTraval = action.loadArroundTravel
            .withUnretained(self)
            .flatMapLatest { model, _ in
                model.travalRepository.requestAroundTraval()
            }
            .share()
        
        requestAroundTraval
            .compactMap { $0.value }
            .map { $0.map { ArroundTravelCellViewModel(arroundTraval: $0) } }
            .bind(to: state.loadedAroundTraval)
            .disposed(by: disposeBag)
        
        let tappedCells = state.loadedAroundTraval
            .flatMapLatest { viewModels -> Observable<ArroundTraval> in
                let tappedCells = viewModels.map {
                    $0.action.tappedCellWithDate.asObservable()
                }
                return .merge(tappedCells)
            }
            .share()
        
        tappedCells
            .bind(to: action.selectedAddress)
            .disposed(by: disposeBag)
    }
}
