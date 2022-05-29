//
//  CalenderViewModel.swift
//  airbnb
//
//  Created by seongha shin on 2022/05/25.
//

import Foundation
import RxDataSources
import RxRelay
import RxSwift

final class CheckInOutViewModel: CheckInOutViewModelBinding, CheckInOutViewModelAction, CheckInOutViewModelState {
    
    func action() -> CheckInOutViewModelAction { self }
    
    let viewDidLoad = PublishRelay<Void>()
    
    func state() -> CheckInOutViewModelState { self }
    
    let showCalender = PublishRelay<[SectionModel<String, CalenderCellViewModel>]>()
    let selectedDates = PublishRelay<CheckInOut>()
    let updateCheckInOutText = PublishRelay<String>()
    let updateToolbarButtons = PublishRelay<[TravalOptionToolBarButtons]>()
    
    private let disposeBag = DisposeBag()
    private var calenderViewModels: [String: [CalenderCellViewModel]] = [:]
    
    deinit {
        Log.info("deinit CheckInOutViewModel")
    }
    
    init() {
        viewDidLoad
            .map { _ in (checkIn: nil, checkOut: nil) }
            .bind(to: selectedDates)
            .disposed(by: disposeBag)
        
        let calenderCellViewModels = viewDidLoad
            .map { _ in
                (0..<12).compactMap { addMonth -> (String, [CalenderCellViewModel])? in
                    guard let date = Date().addMonth(addMonth) else {
                        return nil
                    }
                    let header = date.string("yyyy년 M월")
                    let viewModels = date.DaysOfMonth(withWeekDay: true).map { CalenderCellViewModel(date: $0) }
                    return (header, viewModels)
                }
            }
            .share()
 
        calenderCellViewModels
            .withUnretained(self)
            .bind(onNext: { model, models in
                model.calenderViewModels = models.reduce(into: [:]) { dictionary, viewModel in
                    dictionary[viewModel.0] = viewModel.1.filter { !$0.isNil }
                }
            })
            .disposed(by: disposeBag)

        calenderCellViewModels
            .map { models in
                models.map { SectionModel(model: $0.0, items: $0.1) }
            }
            .bind(to: showCalender)
            .disposed(by: disposeBag)
        
        let tappedCell = calenderCellViewModels
            .flatMapLatest { viewModels -> Observable<Date?> in
                let tappedCells = viewModels.map { _, models -> Observable<Date?> in
                    let dayCells = models.map {
                        $0.action().tappedCellWithDate.asObservable()
                    }
                    return .merge(dayCells)
                }
                return .merge(tappedCells)
            }
        
        tappedCell
            .compactMap { $0 }
            .withLatestFrom(selectedDates) { ($0, $1) }
            .withUnretained(self)
            .do { model, value in
                let (_, checkInOut) = value
                model.updateCellState(checkInOut, .none)
            }
            .map { model, value -> CheckInOut in
                let (date, checkInOut) = value
                return model.updateCheckInOut(checkInOut: checkInOut, date: date)
            }
            .withUnretained(self)
            .do { model, checkInOut in
                model.updateCellState(checkInOut, .inRange)
            }
            .map { $1 }
            .bind(to: selectedDates)
            .disposed(by: disposeBag)
        
        selectedDates
            .map { checkIn, checkOut -> String in
                let checkInText = checkIn?.string("M월 d일 - ") ?? ""
                let checkOutText = checkOut?.string("M월 d일") ?? ""
                return "\(checkInText)\(checkOutText)"
            }
            .bind(to: updateCheckInOutText)
            .disposed(by: disposeBag)
        
        selectedDates
            .map { checkInOut -> [TravalOptionToolBarButtons] in
                let (checkIn, checkOut) = checkInOut
                if checkIn == nil && checkOut == nil {
                    return [(.skip, true), (.flexible, true), (.next, false)]
                }
                if checkIn != nil && checkOut != nil {
                    return [(.reset, true), (.flexible, true), (.next, true)]
                }
                return [(.reset, true), (.flexible, true), (.next, false)]
            }
            .bind(to: updateToolbarButtons)
            .disposed(by: disposeBag)
    }
    
    private func updateCellState(_ checkInOut: CheckInOut, _ state: CalenderCellState) {
        let (checkIn, checkOut) = checkInOut

        updateCellState(state != .none ? .start : .none, to: checkIn)
        updateCellState(state != .none ? .end : .none, to: checkOut)

        guard let checkIn = checkIn, let checkOut = checkOut else {
            return
        }

        let days = checkIn.daysBetween(to: checkOut)
        (1..<days.count - 1).forEach { index in
            updateCellState(state != .none ? .inRange : .none, to: days[index])
        }
    }
    
    private func updateCellState(_ state: CalenderCellState, to date: Date?) {
        guard let date = date else { return }
        if let model = findCellViewModel(date: date) {
            model.state().updateState.accept(state)
        }
    }
    
    private func findCellViewModel(date: Date?) -> CalenderCellViewModelProtocol? {
        if let check = date, let day = check.day() {
            let checkInKey = check.string("yyyy년 M월")
            return calenderViewModels[checkInKey]?[day - 1]
        }
        return nil
    }
    
    private func updateCheckInOut(checkInOut: CheckInOut, date: Date) -> CheckInOut {
        let (checkIn, checkOut) = checkInOut
        
        if checkIn == nil, checkOut == nil {
            return (date, nil)
        } else if let checkIn = checkIn, checkOut == nil {
            if checkIn == date {
                return (nil, nil)
            } else if checkIn > date {
                return (date, checkIn)
            } else {
                return (checkIn, date)
            }
        } else {
            if checkIn == date {
                return (checkOut, nil)
            } else if let checkIn = checkIn, checkIn > date {
                return (date, checkOut)
            } else if checkOut == date {
                return (checkIn, nil)
            } else if let checkOut = checkOut, checkOut < date {
                return (checkIn, date)
            } else {
                guard let checkInBetween = checkIn?.numberOfDaysBetween(to: date),
                      let checkOutBetween = checkOut?.numberOfDaysBetween(to: date) else {
                    return (nil, nil)
                }
                
                if checkInBetween < checkOutBetween {
                   return (date, checkOut)
                } else {
                    return (checkIn, date)
                }
            }
        }
    }
}
