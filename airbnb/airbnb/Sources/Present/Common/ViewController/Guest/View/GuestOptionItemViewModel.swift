//
//  GuestOptionItemViewModel.swift
//  airbnb
//
//  Created by seongha shin on 2022/05/31.
//

import Foundation
import RxRelay
import RxSwift

final class GuestOptionItemViewModel: GuestOptionItemViewModelBinding,
                                      GuestOptionItemViewModelAction, GuestOptionItemViewModelState {
    
    func action() -> GuestOptionItemViewModelAction { self }
    
    let loadGuestData = PublishRelay<Void>()
    let tappedChangeCount = PublishRelay<Int>()
    let changeGuestCount = PublishRelay<ChangeGuestCount>()
    
    func state() -> GuestOptionItemViewModelState { self }
    
    let updateTitle = PublishRelay<String>()
    let updateDescription = PublishRelay<String>()
    let updateCount = PublishRelay<Int>()
    let isMax = PublishRelay<Bool>()
    
    private let disposeBag = DisposeBag()
    
    init(type: GuestType) {
        loadGuestData
            .map { type.title }
            .bind(to: updateTitle)
            .disposed(by: disposeBag)
        
        loadGuestData
            .map { type.description }
            .bind(to: updateDescription)
            .disposed(by: disposeBag)
        
        loadGuestData
            .map { 0 }
            .bind(to: updateCount)
            .disposed(by: disposeBag)
        
        tappedChangeCount
            .withLatestFrom(updateCount) {
                ChangeGuestCount(type: type, value: $1, addValue: $0)
            }
            .bind(to: changeGuestCount)
            .disposed(by: disposeBag)
    }
}
