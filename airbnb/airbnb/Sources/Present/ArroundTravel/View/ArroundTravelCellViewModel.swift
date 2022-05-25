//
//  AroundTravelCellViewModel.swift
//  airbnb
//
//  Created by seongha shin on 2022/05/24.
//

import Foundation
import RxRelay

final class ArroundTravelCellViewModel: ArroundTravelCellViewModelBinding, ArroundTravelCellViewModelAction, ArroundTravelCellViewModelState {
    
    func action() -> ArroundTravelCellViewModelAction { self }
    
    let tappedCell = PublishRelay<ArroundTraval>()
    
    func state() -> ArroundTravelCellViewModelState { self }
    
    let arroundTraval: ArroundTraval
    
    init(arroundTraval: ArroundTraval) {
        self.arroundTraval = arroundTraval
    }
}
