//
//  MapLodgingViewModel.swift
//  airbnb
//
//  Created by 김동준 on 2022/06/07.
//

import MapKit
import RxRelay
import RxSwift

protocol MapLodgingModelAction {
}

final class MapLodgingViewModel {
    let viewDidLoad = PublishRelay<Void>()
    let presentDetailView = PublishRelay<Int>()
    
    private let disposeBag = DisposeBag()
    
    let childViewControllers = PublishRelay<[String: UIViewController]>()
    
    let mapViewModel = MapViewModel()
    let collectionViewModel = LodgingCollectionViewModel()
    
    init() {
        viewDidLoad
            .withUnretained(self)
            .map { model, _ in
                [MapViewController.id: MapViewController(viewModel: model.mapViewModel),
                 LodgingCollectionViewController.id: LodgingCollectionViewController(viewModel: model.collectionViewModel)]
            }
            .bind(to: childViewControllers)
            .disposed(by: disposeBag)
        
        Observable.merge(mapViewModel.presentDetail.asObservable(), collectionViewModel.presentDetail.asObservable())
            .bind(to: presentDetailView)
            .disposed(by: disposeBag)
    }
}
