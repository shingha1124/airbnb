//
//  TravalOption.swift
//  airbnb
//
//  Created by seongha shin on 2022/05/25.
//

import Foundation

public class TravalOptionInfo {
    public private(set) var location: String?
    public private(set) var checkIn: Date?
    public private(set) var checkOut: Date?
    public private(set) var minPrice: Int?
    public private(set) var maxPrice: Int?
    public private(set) var guestCount: Int = 0
    
    func setLocation(_ value: String?) {
        location = value
    }
    
    func setCheckInOut(checkIn: Date?, checkOut: Date?) {
        self.checkIn = checkIn
        self.checkOut = checkOut
    }
    
    func setRangePrice(min: Int, max: Int) {
        self.minPrice = min
        self.maxPrice = max
    }
    
    func setGuest(_ value: Int) {
        guestCount = value
    }
}

enum TravalOptionInfoType: Int, CaseIterable {
    case location
    case checkInOut
    case rangePrice
    case guest
    
    var index: Int {
        switch self {
        case .location: return 0
        case .checkInOut: return 1
        case .rangePrice: return 2
        case .guest: return 3
        }
    }
    
    var name: String {
        switch self {
        case .location: return "위치"
        case .checkInOut: return "체크인/체크아웃"
        case .rangePrice: return "요금"
        case .guest: return "인원"
        }
    }
}
