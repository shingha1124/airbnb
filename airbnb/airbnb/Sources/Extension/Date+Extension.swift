//
//  Calender+Extension.swift
//  airbnb
//
//  Created by seongha shin on 2022/05/26.
//

import Foundation

extension Date {
    func string(_ format: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        return dateFormatter.string(from: self)
    }
    
    func day() -> Int? {
        Calendar.current.dateComponents([.day], from: self).day
    }
    
    func addDay(_ addDay: Int) -> Date? {
        var dateComponent = DateComponents()
        dateComponent.day = addDay
        return Calendar.current.date(byAdding: dateComponent, to: self)
    }
    
    func addMonth(_ addMonth: Int) -> Date? {
        var dateComponent = DateComponents()
        dateComponent.month = addMonth
        return Calendar.current.date(byAdding: dateComponent, to: self)
    }
    
    func firstDayOfMonth() -> Date? {
        let components = Calendar.current.dateComponents([.year, .month], from: self)
        return Calendar.current.date(from: components)
    }
    
    func lastDayOfMonth() -> Date? {
        guard let firstDay = firstDayOfMonth() else { return nil }
        
        guard let nextMonth = Calendar.current.date(byAdding: .month, value: +1, to: firstDay) else {
            return nil
        }
        
        return Calendar.current.date(byAdding: .day, value: -1, to: nextMonth)
    }
    
    func numberOfDaysBetween(to date: Date) -> Int {
        let fromDate = self > date ? date : self
        let toDate = self > date ? self : date
        
        let numberOfDays = Calendar.current.dateComponents([.day], from: fromDate, to: toDate)
        
        guard let days = numberOfDays.day else { return 0 }
        return days
    }
    
    func daysBetween(to date: Date) -> [Date] {
        let numberOfDaysBetween = self.numberOfDaysBetween(to: date)
        return (0...numberOfDaysBetween).compactMap { addDay in
            self.addDay(addDay)
        }
    }
    
    func DaysOfMonth(withWeekDay: Bool = false) -> [Date?] {
        guard let firstDayDate = firstDayOfMonth(),
              let lastDayDate = lastDayOfMonth() else {
            return []
        }

        let startComponents = Calendar.current.dateComponents([.day, .weekday], from: firstDayDate)
        let lastComponents = Calendar.current.dateComponents([.day, .weekday], from: lastDayDate)
        
        guard let startWeekDay = startComponents.weekday,
              let lastDay = lastComponents.day,
              let lastWeekDay = lastComponents.weekday else {
            return []
        }
        
        var days = (0..<lastDay).map { firstDayDate.addDay($0) }
        
        if withWeekDay == false {
            return days
        }
        
        (0..<startWeekDay - 1).forEach { _ in days.insert(nil, at: 0) }
        (lastWeekDay - 1..<6).forEach { _ in days.append(nil) }
        
        return days
    }
}
