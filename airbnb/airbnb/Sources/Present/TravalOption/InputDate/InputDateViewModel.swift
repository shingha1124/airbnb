//
//  InputDateViewModel.swift
//  airbnb
//
//  Created by seongha shin on 2022/05/31.
//

import Foundation
import RxRelay
import RxSwift

final class InputDateViewModel: InputDateViewModelBinding, InputDateViewModelAction, InputDateViewModelState, InputDateViewModelProperty {
    func action() -> InputDateViewModelAction { self }
    
    let tappedSkipButton = PublishRelay<Void>()
    let tappedRemoveButton = PublishRelay<Void>()
    let tappedNextButton = PublishRelay<Void>()
    
    func state() -> InputDateViewModelState { self }
    
    let updateCheckInOut = PublishRelay<String>()
    let isHiddenSkipButton = PublishRelay<Bool>()
    let isHiddenRemoveButton = PublishRelay<Bool>()
    
    let checkInOutViewModel: CheckInOutViewModelProtocol = CheckInOutViewModel()
    
    private let disposeBag = DisposeBag()
    
    deinit {
        Log.info("deinit InputDateViewModel")
    }
    
    init() {
        checkInOutViewModel.state().selectedDates
            .map { checkIn, checkOut -> String in
                let checkInText = checkIn?.string("M월 d일 - ") ?? ""
                let checkOutText = checkOut?.string("M월 d일") ?? ""
                return "\(checkInText)\(checkOutText)"
            }
            .bind(to: updateCheckInOut)
            .disposed(by: disposeBag)
        
        checkInOutViewModel.state().selectedDates
            .map { checkIn, _ in
                checkIn != nil
            }
            .bind(to: isHiddenSkipButton)
            .disposed(by: disposeBag)
        
        checkInOutViewModel.state().selectedDates
            .map { checkIn, _ in
                checkIn == nil
            }
            .bind(to: isHiddenRemoveButton)
            .disposed(by: disposeBag)
        
        tappedRemoveButton
            .bind(to: checkInOutViewModel.action().tappedRemoveButton)
            .disposed(by: disposeBag)
    }
}
