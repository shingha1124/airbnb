//
//  MapViewModel.swift
//  airbnb
//
//  Created by 김동준 on 2022/05/23.
//

import RxSwift
import RxRelay
import RxAppState

struct MapDTO {
    let title: String = "aaaa"
}

protocol MapViewModelAction {
    var collectionSelected: PublishRelay<Int> { get }
    var loadCollectionData: PublishRelay<Void> { get }
    var loadPinData: PublishRelay<Void> { get }
}

protocol MapViewModelState {
    var collectionSelectedData: PublishRelay<MapDTO> { get }
    var loadedCollectionData: PublishRelay<[MapDTO]> { get }
    var loadedPin: PublishRelay<[CGPoint]> { get }
}

protocol MapViewModelBinding {
    func action() -> MapViewModelAction
    func state() -> MapViewModelState
}

typealias MapViewModelProtocol = MapViewModelBinding

final class MapViewModel: MapViewModelBinding, MapViewModelAction, MapViewModelState {
    var collectionSelected = PublishRelay<Int>()
    
    private let disposeBag = DisposeBag()
    
    func action() -> MapViewModelAction { self }
    
    var loadPinData = PublishRelay<Void>()
    var loadCollectionData = PublishRelay<Void>()
    
    func state() -> MapViewModelState { self }
    
    var loadedPin = PublishRelay<[CGPoint]>()
    var loadedCollectionData = PublishRelay<[MapDTO]>()
    var collectionSelectedData = PublishRelay<MapDTO>()
    
    init() {
        loadPinData
            .map { _ in
                [CGPoint(x: 37.4908205, y: 127.0334173)]
            }
            .bind(to: loadedPin)
            .disposed(by: disposeBag)
        
        loadCollectionData
            .map { _ in
                [MapDTO](repeating: MapDTO(), count: 5)
            }
            .bind(to: loadedCollectionData)
            .disposed(by: disposeBag)
        
        collectionSelected
            .map { _ in MapDTO() }
            .bind(to: collectionSelectedData)
            .disposed(by: disposeBag)
    }
}
