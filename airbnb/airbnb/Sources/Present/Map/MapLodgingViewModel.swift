//
//  MapLodgingViewModel.swift
//  airbnb
//
//  Created by 김동준 on 2022/06/07.
//

import MapKit
import RxRelay
import RxSwift

final class MapLodgingViewModel: ViewModel {
    let action = Action()
    let state = State()
    
    struct Action {
        let viewDidLoad = PublishRelay<Void>()
        let presentDetailView = PublishRelay<Int>()
    }
    
    struct State {
        let childViewControllers = PublishRelay<Void>()
    }

    private let disposeBag = DisposeBag()
    let mapViewModel = MapViewModel()
    let collectionViewModel = LodgingCollectionViewModel()
    
    init() {
        action.viewDidLoad
            .bind(to: state.childViewControllers)
            .disposed(by: disposeBag)
        
        Observable.merge(mapViewModel.state.presentDetail.asObservable(), collectionViewModel.state.presentDetail.asObservable())
            .bind(to: action.presentDetailView)
            .disposed(by: disposeBag)
    }
}
