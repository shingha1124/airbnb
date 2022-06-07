//
//  MainViewModel.swift
//  airbnb
//
//  Created by seongha shin on 2022/05/23.
//

import Foundation
import RxRelay
import RxSwift

final class MainViewModel: MainViewModelProtocol {
    func action() -> MainViewModelAction { self }
    
    func state() -> MainViewModelState { self }
    
    let mapViewModel: MapViewModel = MapViewModel()
    
    @Inject(\.travalRepository) private var travalRepository: TravalRepository
    private let disposeBag = DisposeBag()
    
    deinit {
        Log.info("deinit MainViewModel")
    }
    
    init() {
    }
}
