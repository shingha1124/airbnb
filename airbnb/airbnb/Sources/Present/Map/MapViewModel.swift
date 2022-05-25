//
//  NewMapViewModel.swift
//  airbnb
//
//  Created by seongha shin on 2022/05/25.
//

import Foundation
import MapKit
import RxRelay
import RxSwift

final class MapViewModel {
    let viewDidLoad = PublishRelay<Void>()
    let selectedCell = PublishRelay<IndexPath>()
    
    let updateRegion = PublishRelay<MKCoordinateRegion>()
    let updateLodging = PublishRelay<[Lodging]>()
    let updatePin = PublishRelay<[Lodging]>()
    
    @Inject(\.mapRepository) private var mapRepository: MapRepository
    
    private let disposeBag = DisposeBag()
    
    init() {
        viewDidLoad
            .map { _ -> MKCoordinateRegion in
                let center = CLLocationCoordinate2D(latitude: 37.4908205, longitude: 127.0334173)
                let span = MKCoordinateSpan(latitudeDelta: 0, longitudeDelta: 0.005)
                return MKCoordinateRegion(center: center, span: span)
            }
            .bind(to: updateRegion)
            .disposed(by: disposeBag)
        
        let requestLodging2 = viewDidLoad
            .withUnretained(self)
            .flatMapLatest { model, _ in
                model.mapRepository.requestLodging()
            }
            .compactMap { $0.value }
            .share()
        
        requestLodging2
            .bind(to: updatePin)
            .disposed(by: disposeBag)

        requestLodging2
            .bind(to: updateLodging)
            .disposed(by: disposeBag)
        
//        let requestLodging = viewDidLoad
//            .map { _ in
//                [
//                    Lodging(name: "1", coordX: 37.4908205, coordY: 127.0334173),
//                    Lodging(name: "2", coordX: 37.4908205, coordY: 127.0334173),
//                    Lodging(name: "3", coordX: 37.4908205, coordY: 127.0334173),
//                    Lodging(name: "4", coordX: 37.4908205, coordY: 127.0334173),
//                    Lodging(name: "5", coordX: 37.4908205, coordY: 127.0334173),
//                    Lodging(name: "6", coordX: 37.4908205, coordY: 127.0334173),
//                    Lodging(name: "7", coordX: 37.4908205, coordY: 127.0334173)
//                ]
//            }
//            .share()
//
//        requestLodging
//            .bind(to: updatePin)
//            .disposed(by: disposeBag)
//
//        requestLodging
//            .bind(to: updateLodging)
//            .disposed(by: disposeBag)
    }
}
