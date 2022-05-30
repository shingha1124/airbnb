//
//  NewTravalOptionViewModelProtocol.swift
//  airbnb
//
//  Created by seongha shin on 2022/05/30.
//

import Foundation
import RxRelay

protocol NewTravalOptionViewModelAction {
    var viewDidLoad: PublishRelay<Void> { get }
    var selectTravalOption: PublishRelay<NewTravalOptionType> { get }
    var tappedCloseSearch: PublishRelay<Void> { get }
}

protocol NewTravalOptionViewModelState {
    var showTravalOptionPage: PublishRelay<NewTravalOptionType> { get }
    var hiddenTravalOptionPage: PublishRelay<NewTravalOptionType> { get }
    var fillToTravalView: PublishRelay<Void> { get }
}

protocol NewTravalOptionViewModelBinding {
    func action() -> NewTravalOptionViewModelAction
    func state() -> NewTravalOptionViewModelState
}

protocol NewTravalOptionViewModelProperty {
    var inputTravalViewModel: InputTravalViewModelProtocol { get }
}

typealias NewTravalOptionViewModelProtocol = NewTravalOptionViewModelBinding & NewTravalOptionViewModelProperty

enum NewTravalOptionType {
    case traval
    case date
    case guest
}
