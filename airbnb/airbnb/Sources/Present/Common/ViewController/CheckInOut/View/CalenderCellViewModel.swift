//
//  NewCalenderCellViewModel.swift
//  airbnb
//
//  Created by seongha shin on 2022/05/26.
//

import Foundation
import RxRelay
import RxSwift

final class CalenderCellViewModel: ViewModel {
    
    struct Action {
        let tappedCell = PublishRelay<Void>()
        let tappedCellWithDate = PublishRelay<Date?>()
    }
    
    struct State {
        let updateState = PublishRelay<CalenderCellState>()
        let date: Date?
    }
    
    let action = Action()
    let state: State
    let disposeBag = DisposeBag()
    
    init(date: Date?) {
        state = State(date: date)
        
        action.tappedCell
            .map { _ in date }
            .bind(to: action.tappedCellWithDate)
            .disposed(by: disposeBag)
    }
}

enum CalenderCellState {
    case none
    case start
    case end
    case inRange
    case notSelect
}
