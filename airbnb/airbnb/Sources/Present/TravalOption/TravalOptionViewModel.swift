//
//  TravalOptionViewModel.swift
//  airbnb
//
//  Created by seongha shin on 2022/05/30.
//

import Foundation
import RxRelay
import RxSwift

final class TravalOptionViewModel: ViewModel {
    
    struct Action {
        let startShowAnimation = PublishRelay<Void>()
        let selectTravalOption = PublishRelay<TravalOptionType>()
        let tappedAllRemoveButton = PublishRelay<Void>()
        let tappedSearchButton = PublishRelay<Void>()
        let tappedCloseButton = PublishRelay<Void>()
    }
    
    struct State {
        let showTravalOptionPage = PublishRelay<TravalOptionType>()
        let hiddenTravalOptionPage = PublishRelay<TravalOptionType>()
        let enabledSearchView = PublishRelay<Bool>()
        let closedViewController = PublishRelay<Void>()
    }
    
    let searchViewModel = InputSearchViewModel()
    let travalViewModel: InputTravalViewModel
    let dateViewModel = InputDateViewModel()
    let guestViewModel = InputGuestViewModel()
    
    let action = Action()
    let state = State()
    
    private let disposeBag = DisposeBag()
    
    deinit {
#if DEBUG
        Log.info("deinit \(String(describing: type(of: self)))")
#endif
    }
    
    init(inputTraval: String? = nil, searchAction: @escaping (TravalSearchData) -> Void) {
        travalViewModel = InputTravalViewModel(inputTraval: inputTraval)
        
        action.startShowAnimation
            .map { _ -> TravalOptionType in
                if let inputTraval = inputTraval,
                   inputTraval.isEmpty {
                    return .traval
                }
                return .date
            }
            .bind(to: state.showTravalOptionPage)
            .disposed(by: disposeBag)
        
        action.selectTravalOption
            .withLatestFrom(state.showTravalOptionPage) { (show: $0, hidden: $1) }
            .withUnretained(self)
            .do { model, viewSwitch in
                model.state.hiddenTravalOptionPage.accept(viewSwitch.hidden)
            }
            .map { _, viewSwitch in viewSwitch.show }
            .bind(to: state.showTravalOptionPage)
            .disposed(by: disposeBag)
        
        Observable
            .merge(
                travalViewModel.action.tappedSearchBar.map { _ in true },
                searchViewModel.action.editingDidEndOnExit.map { _ in false },
                searchViewModel.action.selectedAddress.map { _ in false }
            )
            .bind(to: state.enabledSearchView)
            .disposed(by: disposeBag)
        
        Observable
            .merge(
                searchViewModel.action.editingDidEndOnExit.asObservable(),
                searchViewModel.action.selectedAddress.asObservable()
            )
            .bind(to: travalViewModel.state.inputTravalResult)
            .disposed(by: disposeBag)
        
        Observable
            .merge(
                searchViewModel.action.editingDidEndOnExit.map { _ in .date },
                searchViewModel.action.selectedAddress.map { _ in .date },
                dateViewModel.action.tappedSkipButton.map { _ in .guest },
                dateViewModel.action.tappedNextButton.map { _ in .guest }
            )
            .bind(to: action.selectTravalOption)
            .disposed(by: disposeBag)
        
        action.tappedAllRemoveButton
            .map { "" }
            .bind(to: travalViewModel.state.inputTravalResult)
            .disposed(by: disposeBag)
        
        action.tappedAllRemoveButton
            .bind(to: dateViewModel.action.tappedRemoveButton)
            .disposed(by: disposeBag)
        
        action.tappedAllRemoveButton
            .bind(to: guestViewModel.action.tappedRemoveButton)
            .disposed(by: disposeBag)
        
        action.tappedCloseButton
//            .withUnretained(self)
//            .do { model, _  in
//                let traval = model.inputTravalViewModel.state().inputTravalResult.value
//                let checkInOut = model.inputDateViewModel.state().updateCheckInOut.value
//                let guest = model.guestViewModel.state().updateGuestCount.value
//            }
//            .mapVoid()
            .bind(to: state.closedViewController)
            .disposed(by: disposeBag)
        
        action.tappedSearchButton
            .withUnretained(self)
            .map { model, _ -> TravalSearchData in
                let region = model.travalViewModel.state.inputTravalResult.value
                let checkInOut = model.dateViewModel.state.updateCheckInOut.value
                let guests = model.guestViewModel.state.updateGuestCount.value
                return TravalSearchData(region: region, checkInOut: checkInOut, guests: guests)
            }
            .do {
                searchAction($0)
            }
            .mapVoid()
            .bind(to: state.closedViewController)
            .disposed(by: disposeBag)
    }
}

struct TravalSearchData {
    let region: String?
    let checkInOut: CheckInOut
    let guests: [Int]
}
