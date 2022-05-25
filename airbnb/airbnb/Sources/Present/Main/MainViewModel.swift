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
    
    let loadHome = PublishRelay<Void>()
    
    func state() -> MainViewModelState { self }
    
    let loadedHeroImage = PublishRelay<URL>()
    
    let arroundTravelViewModel: ArroundTravalViewModelProtocol = ArroundTravalViewModel()
    let recommandTravelViewModel: RecommandTravelViewModelProtocol = RecommandTravelViewModel()
    
    @Inject(\.travalRepository) private var travalRepository: TravalRepository
    private let disposeBag = DisposeBag()
    
    init() {
        loadHome
            .compactMap { URL(string: "https://user-images.githubusercontent.com/5019378/169792466-371c2b29-2869-4335-8c07-d20488fc9035.png") }
            .bind(to: loadedHeroImage)
            .disposed(by: disposeBag)
    }
}
