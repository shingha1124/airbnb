//
//  InputSearchViewModel.swift
//  airbnb
//
//  Created by seongha shin on 2022/05/31.
//

import Foundation
import RxRelay
import RxSwift

final class InputGuestViewModel: ViewModel{
    
    private enum Constants {
        static let maxGuestCount = 16
        static let maxBabyCount = 5
    }
    
    struct Action {
        let viewDidLoad = PublishRelay<Void>()
        let tappedRemoveButton = PublishRelay<Void>()
    }
    
    struct State {
        let updateGuestCount = BehaviorRelay<[Int]>(value: GuestType.allCases.map { _ in 0 })
    }
    
    private let disposeBag = DisposeBag()
    let action = Action()
    let state = State()
    
    let guestViewModel = GuestViewModel(guestMax: Constants.maxGuestCount, babyMax: Constants.maxBabyCount)
    
    deinit {
#if DEBUG
        Log.info("deinit \(String(describing: type(of: self)))")
#endif
    }
    
    init() {
        
        guestViewModel.state.guestCount
            .bind(to: state.updateGuestCount)
            .disposed(by: disposeBag)
        
        action.tappedRemoveButton
            .bind(to: guestViewModel.action.tappedRemoveButton)
            .disposed(by: disposeBag)
    }
}
