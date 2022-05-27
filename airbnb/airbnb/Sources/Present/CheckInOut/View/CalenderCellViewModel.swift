//
//  NewCalenderCellViewModel.swift
//  airbnb
//
//  Created by seongha shin on 2022/05/26.
//

import Foundation
import RxRelay
import RxSwift

final class CalenderCellViewModel: CalenderCellViewModelBinding, CalenderCellViewModelProperty, CalenderCellViewModelAction, CalenderCellViewModelState {
    func action() -> CalenderCellViewModelAction { self }
    
    let viewLoad = PublishRelay<Void>()
    let tappedCell = PublishRelay<Void>()
    let tappedCellWithDate = PublishRelay<Date?>()
    
    func state() -> CalenderCellViewModelState { self }
    
    let updateDate = PublishRelay<Date?>()
    let updateState = PublishRelay<CalenderCellState>()
    
    let isNil: Bool
    
    private var disposeBag = DisposeBag()
    
    init(date: Date?) {
        isNil = date == nil
        
        viewLoad
            .map { _ in date }
            .bind(to: updateDate)
            .disposed(by: disposeBag)
        
        viewLoad
            .take(1)
            .compactMap { date }
            .map { Date() > $0 ? .notSelect: .none }
            .bind(to: updateState)
            .disposed(by: disposeBag)
        
        viewLoad
            .skip(1)
            .withLatestFrom(updateState)
            .bind(to: updateState)
            .disposed(by: disposeBag)
        
        tappedCell
            .withLatestFrom(updateState)
            .filter { $0 != .notSelect }
            .withLatestFrom(updateDate)
            .bind(to: tappedCellWithDate)
            .disposed(by: disposeBag)
    }
}
