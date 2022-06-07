//
//  InputTravalViewModel.swift
//  airbnb
//
//  Created by seongha shin on 2022/05/30.
//

import Foundation
import RxRelay
import RxSwift

final class InputTravalViewModel: ViewModel {
    
    struct Action {
        let viewDidLoad = PublishRelay<Void>()
        let loadAroundTraval = PublishRelay<Void>()
        let tappedSearchBar = PublishRelay<Void>()
    }
    
    struct State {
        let inputTravalResult = BehaviorRelay<String?>(value: nil)
        let loadedAroundTraval = PublishRelay<[ArroundTraval]>()
    }
    
    let disposeBag = DisposeBag()
    let action = Action()
    let state = State()
    
    let arroundTravelViewModel = ArroundTravalViewModel()
    
    @Inject(\.travalRepository) private var homeRepository: TravalRepository
    
    deinit {
#if DEBUG
        Log.info("deinit \(String(describing: type(of: self)))")
#endif
    }
    
    init(inputTraval: String? = nil) {
        action.viewDidLoad
            .filter { inputTraval != nil }
            .map { inputTraval }
            .bind(to: state.inputTravalResult)
            .disposed(by: disposeBag)
        
        let requestAroundTraval = action.viewDidLoad
            .withUnretained(self)
            .flatMapLatest { model, _ in
                model.homeRepository.requestAroundTraval()
            }
            .share()
        
        requestAroundTraval
            .compactMap { $0.value }
            .bind(to: state.loadedAroundTraval)
            .disposed(by: disposeBag)
        
        arroundTravelViewModel.action.selectedAddress
            .map { $0.name }
            .bind(to: state.inputTravalResult)
            .disposed(by: disposeBag)
    }
}
