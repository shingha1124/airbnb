//
//  RecommandTravelViewController.swift
//  airbnb
//
//  Created by seongha shin on 2022/05/24.
//

import Foundation
import RxRelay
import RxSwift

final class RecommandTravelViewModel: RecommandTravelViewModelBinding, RecommandTravelViewModelAction, RecommandTravelViewModelState {
    func action() -> RecommandTravelViewModelAction { self }
    
    let loadRecommandTravel = PublishRelay<Void>()
    
    func state() -> RecommandTravelViewModelState { self }
    
    let loadedRecommandTraval = PublishRelay<[RecommandTraval]>()
    
    @Inject(\.travalRepository) private var travalRepository: TravalRepository
    private let disposeBag = DisposeBag()
    
    init() {
        let requestRecommandTraval = loadRecommandTravel
            .withUnretained(self)
            .flatMapLatest { model, _ in
                model.travalRepository.requestRecommandTraval()
            }
            .share()
        
        requestRecommandTraval
            .compactMap { $0.value }
            .bind(to: loadedRecommandTraval)
            .disposed(by: disposeBag)
    }
}
