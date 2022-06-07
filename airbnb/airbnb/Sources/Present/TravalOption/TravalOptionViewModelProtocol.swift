//
//  TravalOptionViewModelProtocol.swift
//  airbnb
//
//  Created by seongha shin on 2022/05/30.
//

import Foundation
import RxRelay

struct TravalOption {
    let traval: String?
    let checkIn: Date?
    let checkOut: Date?
    let guest: [Int]
}

enum TravalOptionType: CaseIterable {
    case traval
    case date
    case guest
}

@objc protocol ViewAnimation {
    @objc
    optional func shouldAnimation(isAnimate: Bool) -> Bool
    
    @objc
    optional func didShowAnimation(safeAreaGuide: UILayoutGuide)
    
    func startShowAnimation(safeAreaGuide: UILayoutGuide)
    
    @objc
    optional func finishShowAnimation()
    
    @objc
    optional func didHiddenAnimation()
    
    func startHiddenAnimation()
    @objc
    optional func finishHiddenAnimation()
}
