//
//  CalenderViewModel.swift
//  airbnb
//
//  Created by seongha shin on 2022/05/25.
//

import Foundation
import RxRelay
import RxSwift

final class GuestViewModel: GuestViewModelBinding, GuestViewModelAction, GuestViewModelState {
    
    func action() -> GuestViewModelAction { self }
    
    let viewDidLoad = PublishRelay<Void>()
    let tappedRemoveButton = PublishRelay<Void>()
    
    func state() -> GuestViewModelState { self }
    
    let guestViewModels = PublishRelay<[GuestOptionItemViewModel]>()
    let guestCount = PublishRelay<[Int]>()
    
    private let disposeBag = DisposeBag()
    
    deinit {
        Log.info("deinit GuestViewModel")
    }
    
    init(guestMax: Int, babyMax: Int) {
        let makeGuestViewModels = viewDidLoad
            .map {
                GuestType.allCases.compactMap {
                    GuestOptionItemViewModel(type: $0)
                }
            }
            .share()
        
        makeGuestViewModels
            .bind(to: guestViewModels)
            .disposed(by: disposeBag)
        
        makeGuestViewModels
            .map { $0.map { _ in 0 } }
            .bind(to: guestCount)
            .disposed(by: disposeBag)
         
        let changeGuestCount = guestViewModels
            .flatMapLatest { viewModels -> Observable<ChangeGuestCount> in
                let changeGuest = viewModels.map {
                    $0.action().changeGuestCount.asObservable()
                }
                return .merge(changeGuest)
            }
            .share()

        let filterChangeCount = changeGuestCount
            .withLatestFrom(guestCount) { newGuest, prevGuests -> (GuestCount, Bool) in
                let adultCount = prevGuests[GuestType.adult.index]
                let childrenCount = prevGuests[GuestType.children.index]
                let babyCount = prevGuests[GuestType.baby.index]
                
                var totalCount = newGuest.type == .baby ? babyCount : adultCount + childrenCount
                let maxCount = newGuest.type == .baby ? babyMax : guestMax
                
                totalCount += newGuest.addValue
                
                if totalCount > maxCount {
                    return ((newGuest.type, newGuest.value), true)
                }
                
                let guestCount = newGuest.value + newGuest.addValue
                return ((newGuest.type, guestCount), totalCount >= maxCount)
            }
            .share()
        
        filterChangeCount
            .withLatestFrom(guestViewModels) { ($0, $1 ) }
            .bind(onNext: { result, viewModels in
                let (newGuest, isMax) = result
                viewModels[newGuest.type.index].state().updateCount.accept(newGuest.value)

                if newGuest.type != .baby {
                    viewModels[GuestType.adult.index].state().isMax.accept(isMax)
                    viewModels[GuestType.children.index].state().isMax.accept(isMax)
                } else {
                    viewModels[GuestType.baby.index].state().isMax.accept(isMax)
                }
            })
            .disposed(by: disposeBag)

        filterChangeCount
            .withLatestFrom(guestCount) { result, prevCount -> [Int] in
                let (newGuest, _) = result
                var newCount = prevCount
                newCount[newGuest.type.index] = newGuest.value
                return newCount
            }
            .withLatestFrom(guestViewModels) { guestCount, viewModels in
                var newGuestCount = guestCount
                let adultCount = guestCount[GuestType.adult.index]
                let childrenCount = guestCount[GuestType.children.index]
                let babyCount = guestCount[GuestType.baby.index]
                                
                if adultCount == 0, (childrenCount != 0 || babyCount != 0) {
                    newGuestCount[GuestType.adult.index] += 1
                    viewModels[GuestType.adult.index].state().updateCount.accept(1)
                }
                return newGuestCount
            }
            .bind(to: guestCount)
            .disposed(by: disposeBag)
        
        tappedRemoveButton
            .withLatestFrom(guestViewModels)
            .bind(onNext: { viewModels in
                viewModels.forEach {
                    $0.state().updateCount.accept(0)
                }
            })
            .disposed(by: disposeBag)
        
        tappedRemoveButton
            .withLatestFrom(guestCount)
            .map { $0.map { _ in 0 } }
            .bind(to: guestCount)
            .disposed(by: disposeBag)
    }
}
