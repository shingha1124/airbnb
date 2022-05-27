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
    
    private enum Constant {
        static let guestLimited = 8
    }
    
    func action() -> GuestViewModelAction { self }
    
    let viewDidLoad = PublishRelay<Void>()
    let changeGuestCount = PublishRelay<GuestChangeCount>()
    
    func state() -> GuestViewModelState { self }
    
    let updatedTitle = PublishRelay<GuestType>()
    let updatedDescription = PublishRelay<GuestType>()
    let updatedCount = PublishRelay<GuestCount>()
    let updatedButtonState = PublishRelay<GuestButtonState>()
    let updatedTotalGuestCount = PublishRelay<Int>()
    
    private let disposeBag = DisposeBag()
    private var guestCounts: [GuestType: Int] = [:]
    
    deinit {
        Log.info("deinit GuestViewModel")
    }
    
    init() {
        let initData = viewDidLoad
            .flatMapLatest { _ -> Observable<GuestType> in
                    .merge(Observable.from(GuestType.allCases))
            }
            .share()
        
        let changedGuestCount = changeGuestCount
            .withUnretained(self)
            .filter { model, changeCount in
                let currentCount = model.guestCounts[changeCount.type] ?? 0
                if changeCount.value > 0 && currentCount == Constant.guestLimited,
                   changeCount.value < 0 && currentCount == 0 {
                    return false
                }
                return true
            }
            .do { model, changeCount in
                let currentCount = model.guestCounts[changeCount.type] ?? 0
                model.guestCounts[changeCount.type] = currentCount + changeCount.value
            }
            .map { model, changeCount -> GuestCount in
                (type: changeCount.type, count: model.guestCounts[changeCount.type] ?? 0)
            }
            .share()
        
        Observable
            .merge(
                initData.map { ($0, 0) },
                changedGuestCount
            )
            .bind(to: updatedCount)
            .disposed(by: disposeBag)
        
        Observable
            .merge(
                viewDidLoad.map { _ in },
                changedGuestCount.map { _ in }
            )
            .withUnretained(self)
            .map { model, _ in
                model.guestCounts.reduce(0, { result, value -> Int in
                    result + value.value
                })
            }
            .bind(to: updatedTotalGuestCount)
            .disposed(by: disposeBag)
        
        Observable
            .merge(
                initData.map { ($0, false, true) },
                changedGuestCount.map { ($0, $1 != 0, $1 != Constant.guestLimited) }
            )
            .bind(to: updatedButtonState)
            .disposed(by: disposeBag)
      
        initData
            .map { ($0, false, true) }
            .bind(to: updatedButtonState)
            .disposed(by: disposeBag)
        
        initData
            .bind(to: updatedTitle)
            .disposed(by: disposeBag)
        
        initData
            .bind(to: updatedDescription)
            .disposed(by: disposeBag)
    }
}
