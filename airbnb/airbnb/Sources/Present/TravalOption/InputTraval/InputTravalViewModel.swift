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
    
    let viewDidLoad = PublishRelay<Void>()
    let loadAroundTraval = PublishRelay<Void>()
    let tappedSearchBar = PublishRelay<Void>()
    
    func state() -> InputTravalViewModelState { self }
    
    let inputTravalResult = BehaviorRelay<String?>(value: nil)
    let loadedAroundTraval = PublishRelay<[ArroundTraval]>()
    
    let arroundTravelViewModel: ArroundTravalViewModelProtocol = ArroundTravalViewModel()
    
    @Inject(\.travalRepository) private var homeRepository: TravalRepository
    private let disposeBag = DisposeBag()
    
    deinit {
        Log.info("deinit InputTravalViewModel")
    }
    
    init(inputTraval: String? = nil) {
        
        viewDidLoad
            .filter { inputTraval != nil }
            .map { inputTraval }
            .bind(to: inputTravalResult)
            .disposed(by: disposeBag)
        
        let requestAroundTraval = viewDidLoad
            .withUnretained(self)
            .flatMapLatest { model, _ in
                model.homeRepository.requestAroundTraval()
            }
            .share()
        
        requestAroundTraval
            .compactMap { $0.value }
            .bind(to: loadedAroundTraval)
            .disposed(by: disposeBag)
        
        arroundTravelViewModel.action().selectedAddress
            .map { $0.name }
            .bind(to: inputTravalResult)
            .disposed(by: disposeBag)
    }
}
