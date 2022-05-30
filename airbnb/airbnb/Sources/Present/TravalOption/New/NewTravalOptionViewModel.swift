//
//  NewTravalOptionViewModel.swift
//  airbnb
//
//  Created by seongha shin on 2022/05/30.
//

import Foundation
import RxRelay
import RxSwift

final class NewTravalOptionViewModel: NewTravalOptionViewModelBinding, NewTravalOptionViewModelAction, NewTravalOptionViewModelState {
    func action() -> NewTravalOptionViewModelAction { self }
    
    let viewDidLoad = PublishRelay<Void>()
    let selectTravalOption = PublishRelay<NewTravalOptionType>()
    let tappedCloseSearch = PublishRelay<Void>()
    
    func state() -> NewTravalOptionViewModelState { self }
    
    let showTravalOptionPage = PublishRelay<NewTravalOptionType>()
    let hiddenTravalOptionPage = PublishRelay<NewTravalOptionType>()
    let fillToTravalView = PublishRelay<Void>()
    
    let inputTravalViewModel: InputTravalViewModelProtocol = InputTravalViewModel()
    
    private let disposeBag = DisposeBag()
    
    init() {
        viewDidLoad
            .map { .traval }
            .bind(to: showTravalOptionPage)
            .disposed(by: disposeBag)
        
        selectTravalOption
            .withLatestFrom(showTravalOptionPage) { (show: $0, hidden: $1) }
            .withUnretained(self)
            .do { model, viewSwitch in
                model.hiddenTravalOptionPage.accept(viewSwitch.hidden)
            }
            .map { _, viewSwitch in viewSwitch.show }
            .bind(to: showTravalOptionPage)
            .disposed(by: disposeBag)
        
        
        
//        inputTravalViewModel.action().textDidBeginEditing
//            .bind(to: fillToTravalView)
//            .disposed(by: disposeBag)
//
//        tappedCloseSearch
//            .bind(to: inputTravalViewModel.state().resetHeight)
//            .disposed(by: disposeBag)
    }
}
