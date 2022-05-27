//
//  ArroundTravalViewModel.swift
//  airbnb
//
//  Created by seongha shin on 2022/05/24.
//

import Foundation
import RxRelay
import RxSwift

final class ArroundTravalViewModel: ArroundTravalViewModelBinding, ArroundTravalViewModelAction, ArroundTravalViewModelState {
    func action() -> ArroundTravalViewModelAction { self }
    
    let loadArroundTravel = PublishRelay<Void>()
    
    func state() -> ArroundTravalViewModelState { self }
    
    let loadedAroundTraval = PublishRelay<[ArroundTravelCellViewModel]>()
    let selectedAddress = PublishRelay<ArroundTraval>()
    
    @Inject(\.travalRepository) private var travalRepository: TravalRepository
    private let disposeBag = DisposeBag()
    
    init() {
        let requestAroundTraval = loadArroundTravel
            .withUnretained(self)
            .flatMapLatest { model, _ in
                model.travalRepository.requestAroundTraval()
            }
            .share()
        
        requestAroundTraval
            .compactMap { $0.value }
            .map { $0.map { ArroundTravelCellViewModel(arroundTraval: $0) } }
            .bind(to: loadedAroundTraval)
            .disposed(by: disposeBag)
        
        let tappedCells = loadedAroundTraval
            .flatMapLatest { viewModels -> Observable<ArroundTraval> in
                let tappedCells = viewModels.map {
                    $0.action().tappedCellWithDate.asObservable()
                }
                return .merge(tappedCells)
            }
            .share()
        
        tappedCells
            .bind(to: selectedAddress)
            .disposed(by: disposeBag)
    }
}
