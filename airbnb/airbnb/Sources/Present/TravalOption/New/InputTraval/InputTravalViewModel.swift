//
//  InputTravalViewModel.swift
//  airbnb
//
//  Created by seongha shin on 2022/05/30.
//

import Foundation
import RxRelay
import RxSwift

final class InputTravalViewModel: InputTravalViewModelProtocol, InputTravalViewModelAction, InputTravalViewModelState {
    func action() -> InputTravalViewModelAction { self }
    
    let loadAroundTraval = PublishRelay<Void>()
    let textDidBeginEditing = PublishRelay<Void>()
    let inputSearctText = PublishRelay<String>()
    
    func state() -> InputTravalViewModelState { self }
    
    let loadedAroundTraval = PublishRelay<[ArroundTraval]>()
    let resetHeight = PublishRelay<Void>()
    
    let arroundTravelViewModel: ArroundTravalViewModelProtocol = ArroundTravalViewModel()
    let searchResultTravelViewModel: SearchResultViewModelProtocol = SearchResultViewModel()
    
    @Inject(\.travalRepository) private var homeRepository: TravalRepository
    private let disposeBag = DisposeBag()
    
    init() {
        let requestAroundTraval = loadAroundTraval
            .withUnretained(self)
            .flatMapLatest { model, _ in
                model.homeRepository.requestAroundTraval()
            }
            .share()
        
        requestAroundTraval
            .compactMap { $0.value }
            .bind(to: loadedAroundTraval)
            .disposed(by: disposeBag)
        
        inputSearctText
            .bind(to: searchResultTravelViewModel.action().inputSearchText)
            .disposed(by: disposeBag)
    }
}
