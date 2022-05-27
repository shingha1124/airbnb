//
//  SearchOptionViewModel.swift
//  airbnb
//
//  Created by seongha shin on 2022/05/25.
//

import Foundation
import RxRelay
import RxSwift

final class TravalOptionViewModel: TravalOptionViewModelBinding, TravalOptionViewModelAction, TravalOptionViewModelState, TravalOptionViewModelProperty {
    func action() -> TravalOptionViewModelAction { self }
    
    let viewDidLoad = PublishRelay<Void>()
    
    func state() -> TravalOptionViewModelState { self }
    
    let usingCategorys = PublishRelay<[TravalOptionInfo.OptionType]>()
    let updateTitle = PublishRelay<String>()
    let updateValue = PublishRelay<(TravalOptionInfo.OptionType, String)>()
    let showCategoryPage = BehaviorRelay<TravalOptionInfo.OptionType>(value: .checkInOut)
    
    let priceViewModel: PriceViewModelProtocol = PriceViewModel()
    let checkInOutViewModel: CheckInOutViewModelProtocol = CheckInOutViewModel()
    let personViewModel: GuestViewModelProtocol = GuestViewModel()
    
    private var travalOptionInfo = TravalOptionInfo()
    private let disposeBag = DisposeBag()
    
    deinit {
        Log.info("deinit TravalOptionViewModel")
    }
    
    init(type: TravalOptionInfo.ViewType) {
        var optionTypes: [TravalOptionInfo.OptionType]
        switch type {
        case .search:
            optionTypes = [.location, .checkInOut, .rangePrice, .person]
        case .reservation:
            optionTypes = [.checkInOut, .person]
        }
        
        viewDidLoad
            .map { _ in optionTypes }
            .bind(to: usingCategorys)
            .disposed(by: disposeBag)
        
        viewDidLoad
            .map { _ in type.title }
            .bind(to: updateTitle)
            .disposed(by: disposeBag)
        
        checkInOutViewModel.state().updateCheckInOut
            .bind(onNext: travalOptionInfo.setCheckInOut)
            .disposed(by: disposeBag)
        
        checkInOutViewModel.state().updateCheckInOut
            .map { checkIn, checkOut -> (TravalOptionInfo.OptionType, String) in
                let checkInText = checkIn?.string("M월 d일 - ") ?? ""
                let checkOutText = checkOut?.string("M월 d일") ?? ""
                return (.checkInOut, "\(checkInText)\(checkOutText)")
            }
            .bind(to: updateValue)
            .disposed(by: disposeBag)
        
        personViewModel.state().updatedTotalGuestCount
            .bind(onNext: travalOptionInfo.setperson)
            .disposed(by: disposeBag)
        
        personViewModel.state().updatedTotalGuestCount
            .map { count in (.person, "게스트 \(count)명") }
            .bind(to: updateValue)
            .disposed(by: disposeBag)
    }
    
    convenience init(location: String) {
        self.init(type: .search)
        travalOptionInfo.setLocation(location)
        
        viewDidLoad
            .map { _ in (.location, location) }
            .bind(to: updateValue)
            .disposed(by: disposeBag)
    }
}
