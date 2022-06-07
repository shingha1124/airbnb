//
//  Int+Extension.swift
//  airbnb
//
//  Created by seongha shin on 2022/06/07.
//

import Foundation

extension Int {
    func convertToKRW() -> String? {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .currency
        numberFormatter.locale = Locale(identifier: "ko_KR")
        return numberFormatter.string(for: self)
    }
}
