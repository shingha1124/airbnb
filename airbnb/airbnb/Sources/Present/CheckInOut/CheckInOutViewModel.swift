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
    let updateCheckInOut = BehaviorRelay<(Date?, Date?)>(value: (nil, nil))

    private let disposeBag = DisposeBag()
    private var calenderViewModels: [String: [CalenderCellViewModel]] = [:]
    
    deinit {
        Log.info("deinit CheckInOutViewModel")
    }
    
    init() {
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

        let tappedCells = calenderCellViewModels
            .flatMapLatest { viewModels -> Observable<Date?> in
                let tappedCells = viewModels.map { _, models -> Observable<Date?> in
                    let dayCells = models.map {
                        $0.action().tappedCellWithDate.asObservable()
                    }
                    return .merge(dayCells)
                }
                return .merge(tappedCells)
            }
            .compactMap { $0 }
            .withUnretained(self)
            .map { model, date -> (Date?, Date?) in
                model.checkInOutDateProcess(date: date)
            }
            .share()

        tappedCells
            .withUnretained(self)
            .do { arg in
                let (model, (checkIn, checkOut)) = arg
                model.updateInRangeCellState(.none)
                model.updateCheckInOut.accept((checkIn, checkOut))
            }
            .map { _ in .inRange }
            .withUnretained(self)
            .bind(onNext: { model, state in
                model.updateInRangeCellState(state)
            })
            .disposed(by: disposeBag)
    }
    
    private func updateInRangeCellState(_ state: CalenderCellState) {
        let checkIn = updateCheckInOut.value.0
        let checkOut = updateCheckInOut.value.1

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
    
    private func checkInOutDateProcess(date: Date) -> (Date?, Date?) {
        let (checkIn, checkOut) = updateCheckInOut.value
        
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
