//
//  InputSearchViewModel.swift
//  airbnb
//
//  Created by seongha shin on 2022/05/31.
//

import Foundation
import RxRelay
import RxSwift

final class InputGuestViewModel: InputGuestViewModelProtocol, InputGuestViewModelAction, InputGuestViewModelState {
    
    private enum Contants {
        static let maxGuestCount = 16
        static let maxBabyCount = 5
    }
    
    func action() -> InputGuestViewModelAction { self }
    
    let viewDidLoad = PublishRelay<Void>()
    let tappedRemoveButton = PublishRelay<Void>()
    
    func state() -> InputGuestViewModelState { self }
    
    let updateGuestCount = BehaviorRelay<[Int]>(value: GuestType.allCases.map { _ in 0 })
    
    private let disposeBag = DisposeBag()
    
    let guestViewModel: GuestViewModelProtocol = GuestViewModel(guestMax: Contants.maxGuestCount, babyMax: Contants.maxBabyCount)
    
    deinit {
        Log.info("deinit InputGuestViewModel")
    }
    
    init() {
        
        guestViewModel.state().guestCount
            .bind(to: updateGuestCount)
            .disposed(by: disposeBag)
        
        tappedRemoveButton
            .bind(to: guestViewModel.action().tappedRemoveButton)
            .disposed(by: disposeBag)
    }
}
