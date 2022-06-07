//
//  InputDateViewModel.swift
//  airbnb
//
//  Created by seongha shin on 2022/05/31.
//

import Foundation
import RxRelay
import RxSwift

final class InputDateViewModel: ViewModel {
    struct Action {
        let tappedSkipButton = PublishRelay<Void>()
        let tappedRemoveButton = PublishRelay<Void>()
        let tappedNextButton = PublishRelay<Void>()
    }
    
    struct State {
        let updateCheckInOut = BehaviorRelay<CheckInOut>(value: (checkIn: nil, checkOut: nil))
        let isHiddenSkipButton = PublishRelay<Bool>()
        let isHiddenRemoveButton = PublishRelay<Bool>()
    }
    
    let disposeBag = DisposeBag()
    let action = Action()
    let state = State()
    
    let checkInOutViewModel = CheckInOutViewModel()
    
    deinit {
        Log.info("deinit InputDateViewModel")
    }
    
    init() {
        checkInOutViewModel.state.selectedDates
            .bind(to: state.updateCheckInOut)
            .disposed(by: disposeBag)
        
        checkInOutViewModel.state.selectedDates
            .map { checkIn, _ in
                checkIn != nil
            }
            .bind(to: state.isHiddenSkipButton)
            .disposed(by: disposeBag)
        
        checkInOutViewModel.state.selectedDates
            .map { checkIn, _ in
                checkIn == nil
            }
            .bind(to: state.isHiddenRemoveButton)
            .disposed(by: disposeBag)
        
        action.tappedRemoveButton
            .bind(to: checkInOutViewModel.action.tappedRemoveButton)
            .disposed(by: disposeBag)
    }
}
