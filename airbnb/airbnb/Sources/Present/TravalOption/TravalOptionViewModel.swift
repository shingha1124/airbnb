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
    let viewDidAppear = PublishRelay<Void>()
    let tappedCategory = PublishRelay<TravalOptionInfoType>()
    
    func state() -> TravalOptionViewModelState { self }
    
    let showCategorys = PublishRelay<[TravalOptionInfoType]>()
    let showCategoryPage = BehaviorRelay<TravalOptionInfoType>(value: .checkInOut)
    let updateTitle = PublishRelay<String>()
    let updateCategoryValue = PublishRelay<(TravalOptionInfoType, String)>()
    let updateToolbarButtons = PublishRelay<[TravalOptionToolBarButtons]>()
    
    let checkInOutViewModel: CheckInOutViewModelProtocol = CheckInOutViewModel()
    let priceViewModel: PriceViewModelProtocol = PriceViewModel()
    let personViewModel: GuestViewModelProtocol = GuestViewModel()
    
    private var travalOptionInfo = TravalOptionInfo()
    private let disposeBag = DisposeBag()
    
    deinit {
        Log.info("deinit TravalOptionViewModel")
    }
    
    init(type: TravalOptionViewType) {
        var optionTypes: [TravalOptionInfoType]
        switch type {
        case .search:
            optionTypes = [.location, .checkInOut, .rangePrice, .guest]
        case .reservation:
            optionTypes = [.checkInOut, .guest]
        }
        
        viewDidLoad
            .map { _ in optionTypes }
            .bind(to: showCategorys)
            .disposed(by: disposeBag)
        
        viewDidLoad
            .map { _ in type.title }
            .bind(to: updateTitle)
            .disposed(by: disposeBag)
        
        viewDidLoad
            .map { _ in .checkInOut }
            .bind(to: showCategoryPage)
            .disposed(by: disposeBag)
        
        tappedCategory
            .bind(to: showCategoryPage)
            .disposed(by: disposeBag)
        
        Observable
            .merge(
                checkInOutViewModel.state().updateCheckInOutText.map { (.checkInOut, $0) },
                personViewModel.state().updatedTotalCountText.map { (.guest, $0) },
                priceViewModel.state().updatedPriceRangeText.map { (.rangePrice, $0) }
            )
            .bind(to: updateCategoryValue)
            .disposed(by: disposeBag)

        Observable
            .merge(
                checkInOutViewModel.state().updateToolbarButtons
                    .map { (TravalOptionInfoType.checkInOut, $0) },
                personViewModel.state().updateToolbarButtons
                    .map { (TravalOptionInfoType.guest, $0) }
            )
            .withLatestFrom(showCategoryPage) { ($0, $1) }
            .filter { toolbar, currentPage in
                currentPage == toolbar.0
            }
            .map { toolbar, _ in toolbar.1.map { (type: $0.type, isEnable: $0.isEnable) } }
            .bind(to: updateToolbarButtons)
            .disposed(by: disposeBag)
    }
    
    convenience init(location: String) {
        self.init(type: .search)
        travalOptionInfo.setLocation(location)
        
        viewDidLoad
            .map { _ in (.location, location) }
            .bind(to: updateCategoryValue)
            .disposed(by: disposeBag)
    }
}
