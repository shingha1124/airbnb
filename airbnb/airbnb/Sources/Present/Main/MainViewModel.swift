//
//  MainViewModel.swift
//  airbnb
//
//  Created by seongha shin on 2022/05/23.
//

import Foundation
import RxRelay
import RxSwift

final class MainViewModel: ViewModel {
    
    struct Action {
        let test = PublishRelay<Void>()
    }
    
    struct State {
        
    }
    
    let action = Action()
    let state = State()
    
    let mapViewModel: MapViewModel = MapViewModel()
    
    private let disposeBag = DisposeBag()
    
    deinit {
#if DEBUG
        Log.info("deinit \(String(describing: type(of: self)))")
#endif
    }
    init() {
        action.test
            .bind(onNext: {
                print("asdfasdfsaf")
            })
            .disposed(by: disposeBag)
    }
}
