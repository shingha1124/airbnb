//
//  CalenderViewModelProtocol.swift
//  airbnb
//
//  Created by seongha shin on 2022/05/25.
//

import Foundation
import RxRelay

protocol GuestViewModelAction {
    var viewDidLoad: PublishRelay<Void> { get }
    var tappedRemoveButton: PublishRelay<Void> { get }
}

protocol GuestViewModelState {
    var guestViewModels: PublishRelay<[GuestOptionItemViewModel]> { get }
    var guestCount: PublishRelay<[Int]> { get }
}

protocol GuestViewModelBinding {
    func action() -> GuestViewModelAction
    func state() -> GuestViewModelState
}

typealias GuestViewModelProtocol = GuestViewModelBinding

enum GuestType: Int, CaseIterable {
    case adult = 0
    case children
    case baby
    
    var index: Int {
        switch self {
        case .adult: return 0
        case .children: return 1
        case .baby: return 2
        }
    }
    
    var title: String {
        switch self {
        case .adult: return "성인"
        case .children: return "어린이"
        case .baby: return "유아"
        }
    }
    
    var description: String {
        switch self {
        case .adult: return "만 13세 이상"
        case .children: return "만 2~12세"
        case .baby: return "만 2세 미만"
        }
    }
}
