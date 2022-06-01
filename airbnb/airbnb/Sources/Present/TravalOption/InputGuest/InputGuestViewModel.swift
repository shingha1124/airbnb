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
    
    let updateGuestCount = PublishRelay<String>()
    
    private let disposeBag = DisposeBag()
    
    let guestViewModel: GuestViewModelProtocol = GuestViewModel(guestMax: Contants.maxGuestCount, babyMax: Contants.maxBabyCount)
    
    deinit {
        Log.info("deinit InputGuestViewModel")
    }
    
    init() {
        
        guestViewModel.state().guestCount
            .map { guests -> String in
                let totalCount = guests[GuestType.adult.index] + guests[GuestType.children.index]
                let babyCount = guests[GuestType.baby.index]
                
                let totalText = totalCount != 0 ? "게스트\(totalCount)명" : ""
                let babyText = babyCount != 0 ? ", 유아\(babyCount)명" : ""
                return "\(totalText)\(babyText)"
            }
            .bind(to: updateGuestCount)
            .disposed(by: disposeBag)
        
        tappedRemoveButton
            .bind(to: guestViewModel.action().tappedRemoveButton)
            .disposed(by: disposeBag)
    }
}
