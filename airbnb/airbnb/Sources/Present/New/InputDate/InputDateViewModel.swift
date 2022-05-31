//
//  InputDateViewModel.swift
//  airbnb
//
//  Created by seongha shin on 2022/05/31.
//

import Foundation

final class InputDateViewModel: InputDateViewModelBinding, InputDateViewModelAction, InputDateViewModelState, InputDateViewModelProperty {
    func action() -> InputDateViewModelAction { self }
    
    func state() -> InputDateViewModelState { self }
    
    let checkInOutViewModel: CheckInOutViewModelProtocol = CheckInOutViewModel()
    
    deinit {
        Log.info("deinit InputDateViewModel")
    }
    
    init() {
        
    }
}
